# Delegating to Agent CLIs

Delegate bounded work to other agent CLIs (Codex, Grok Build, Antigravity, Claude Code, Pi, Hermes) while the orchestrator plans, reviews every diff, and owns the result. Consolidated from `codex-subagent`, `grok-build`, `delegating-to-agents`, `dispatch`.

## Table of contents

1. [When to delegate](#when-to-delegate)
2. [Preflight](#preflight)
3. [Writing a self-contained task spec](#writing-a-self-contained-task-spec)
4. [Codex CLI as a subagent](#codex-cli-as-a-subagent)
5. [Grok Build headless execution](#grok-build-headless-execution)
6. [Multi-CLI dispatch (second opinions)](#multi-cli-dispatch-second-opinions)
7. [Driving interactive TUI agents](#driving-interactive-tui-agents)

---

## When to delegate

Delegate when the task is self-contained with clear success criteria (fix, feature, refactor, review, boilerplate, mechanical refactors, test-writing from specs). Keep with the orchestrator when requirements are ambiguous, cross-file debugging is deep, code is security-sensitive, or anything touches production infrastructure. When in doubt, keep it.

**Rules that always apply:**

- One task per launch. Split big jobs into multiple launches.
- The delegate sees NONE of your conversation — put all context in the prompt.
- Review the diff yourself before declaring done. Output is a claim; the diff is evidence.
- Require explicit user approval before any external delegation (especially write-mode).
- Never send secrets, proprietary source, customer data, or credentials to a third-party CLI.

---

## Preflight

- Confirm the CLI is installed and authenticated. Never work around a login check — send the user to run `codex login` / `grok login` themselves.
- Never read, print, or copy credentials from local auth files.
- Confirm permission/sandbox mode and that the run is non-interactive-capable.

---

## Writing a self-contained task spec

The delegate has zero conversation context; no one-liner prompts, ever. Use a structured spec:

```markdown
# Task: <one-line title>

## Context
- Repo: <path> — <one line on what the project is>
- Conventions: <test runner, formatter, a good example file to imitate>

## Files
- Modify: <path>
- Create: <path>

## Task
<precise description of the change>

## Constraints
- Do not modify any files other than those listed above.
- <other constraints>

## Acceptance criteria
- `<exact command>` <expected result>
```

- Write the spec to a temp file OUTSIDE the target repo; pass it via `--prompt-file` or stdin.
- Dispatch only on a clean source tree — commit or stash first so the post-run diff is exactly the delegate's work.
- Tell it how to verify it's done (acceptance commands).

---

## Codex CLI as a subagent

`codex exec` runs non-interactively: autonomous in a sandbox, streams progress to stderr, prints only the final message to stdout. Auth reuses the ChatGPT subscription, never an API key.

```bash
OUT=$(mktemp /tmp/codex-out.XXXXXX)
codex exec \
  --cd /path/to/repo \
  --sandbox workspace-write \
  --output-last-message "$OUT" \
  "Full task prompt: goal, constraints, files to touch, definition of done." \
  </dev/null
```

- `</dev/null` is **mandatory** when stdin is not a real terminal — Codex treats open stdin as extra context and waits forever for EOF.
- Long prompt? `codex exec [flags] - < /tmp/task.md`.
- Runs take minutes with no built-in timeout — background it and monitor.
- Follow up in the same session: `codex exec resume --last "..." </dev/null` (resume filters by cwd).

**Parallel runs:** one git worktree per run, never two in the same tree:

```bash
git worktree add /tmp/wt-taskA -b codex/task-a
codex exec --cd /tmp/wt-taskA --sandbox workspace-write -o /tmp/outA.md "task A" </dev/null
```

**Failure modes:** hangs forever → stdin left open (kill, relaunch with `</dev/null`); rate limit → report, never retry-loop; "Not a git repo" → `--skip-git-repo-check`; network blocked inside sandbox → `-c sandbox_workspace_write.network_access=true`; NEVER use `--dangerously-bypass-approvals-and-sandbox`.

---

## Grok Build headless execution

The orchestrator plans, writes self-contained task specs, dispatches to Grok Build headlessly, and reviews every diff. Grok is the fast, cheap executor; default model `grok-4.5`.

**Safety gate:** before every dispatch, show the user the exact task spec, target worktree, and permission mode; obtain explicit approval. Never include secrets/proprietary source in a spec.

```bash
grok --prompt-file <task-file> --output-format json --always-approve --max-turns 30 --cwd <repo>
```

- `--always-approve` is required for headless runs (without an interactive approver, `acceptEdits` silently cancels). Use only after explicit user approval of the scoped worktree; it never substitutes for your review.
- Parse the JSON, save `sessionId`. Optional `--check` makes Grok self-verify before you review (roughly doubles latency).
- **Review gate (non-negotiable):** read the diff yourself, run the acceptance commands, commit only on pass. On fail, ask the user before any fix-up or reset; never run `git checkout -- .` / `git clean -fd` automatically.
- Parallel dispatch only when a plan explicitly marks tasks independent; merge conflicts usually eat the savings.
- Failure table: `stopReason: Cancelled` + no diff → missing `--always-approve`; CLI error/timeout → retry once then do it yourself; auth expired → ask user to `grok login`; dirty tree at dispatch → refuse, commit/stash first.

---

## Multi-CLI dispatch (second opinions)

Trigger by naming the tool in natural language ("check with codex", "ask gemini for a second opinion"). Defaults: Codex gpt-5.5 / medium effort / read-only sandbox; Antigravity Gemini. **Require explicit user approval per delegation.**

- Pass prompt text via stdin or a temp file with quoted here-doc delimiters — never interpolate untrusted diffs/issues/chat into a shell command (`$()`, backticks, globs).
- Treat the other model's output as a peer opinion, not authority: summarize, state where you agree/disagree, recommend next steps.
- Track sessions by topic ID for follow-ups ("continue with codex") using a delta bridge (only what changed).
- Antigravity has no read-only mode — run analysis calls from a clean git state or throwaway dir and check `git status` after.

---

## Driving interactive TUI agents

- **One single line per send — never newlines in the message body.** In a TUI, newline = Enter; a multi-line prompt submits at the first line and the rest arrives as fragmented steering messages. Write long instructions to a file and send `read /tmp/task.md and follow it`.
- **Wrap the prompt in plain double quotes, never escaped.** The recurring bug is emitting `\"` — in bash that's literal-broken and dies with `unexpected EOF`. Avoid apostrophes/embedded double quotes inside the prompt ("dont", "wont").
- **Use exact command names** (e.g., `cmux send --surface surface:N` + `cmux send-key --surface surface:N enter`).
- **Polling:** keep sleeps short (3–5s, re-check); scale up only for genuinely heavy tasks. After each check, send the user a one-line status.
- **Remote VPS:** SSH in first and launch the agent ON the VPS; don't run locally and SSH per step.
- **PTY requirements:** Codex, Pi, OpenCode need `pty=true`; Claude Code prefers `claude --print --permission-mode bypassPermissions` (no PTY).

**CLI reference (which agent for what):**

| Agent | Best for |
|---|---|
| Codex CLI | Complex, long-running SWE tasks (unlimited plan, don't ration) |
| Pi Agent | Most other tasks; frontend/design (Opus-class reasoning) |
| Grok Build | Fast, cheap mechanical implementation from clear specs |
| Claude Code | Deepest Claude integration, `.claude/` conventions |
| Hermes | Persistent autonomous agent — cross-session memory, built-in scheduler, can orchestrate other CLIs |
