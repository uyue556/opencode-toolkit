# Orchestration & Multi-Agent Operations

How to coordinate agents productively: orchestrator patterns, task registries, quality gates, parallel dispatch, goal loops, scheduling, and hosted/background agents. Consolidated from `multi-agent-task-orchestrator`, `orchestrate`, `dispatching-parallel-agents`, `parallel-agents`, `open-dynamic-workflows`, `goal-loop`, `agent-self-scheduling`, `hosted-agents`, `agent-manager-skill`, `llm-council`, `multi-advisor`.

## Table of contents

1. [Orchestrator pattern](#orchestrator-pattern)
2. [Anti-duplication & quality gates](#anti-duplication--quality-gates)
3. [Parallel dispatch](#parallel-dispatch)
4. [Orchestration patterns for specialists](#orchestration-patterns-for-specialists)
5. [Multi-perspective advisory (councils)](#multi-perspective-advisory-councils)
6. [Goal loops (bounded autonomy)](#goal-loops-bounded-autonomy)
7. [Scheduling recurring runs](#scheduling-recurring-runs)
8. [Hosted / background agents](#hosted--background-agents)

---

## Orchestrator pattern

The orchestrator decomposes tasks, routes to specialists, prevents duplicate/conflicting work, and verifies results. It never does the specialized work itself.

**Define what it is NOT** (the NOT-block reduces task drift ~35%):

```
You are the Task Orchestrator. You NEVER do specialized work yourself.
You decompose tasks, delegate to the right agent, prevent conflicts,
and verify quality before marking anything done.

WHAT YOU ARE NOT:
- NOT a code writer — delegate to code agents
- NOT a researcher — delegate to research agents
- NOT a tester — delegate to test agents
```

**Workflow:**

1. Decompose into distinct, bounded assignments with explicit outputs.
2. Run narrow read-only scouts in parallel (low reasoning effort, no inherited conversation) when the runtime supports it.
3. Use medium reasoning effort for routine implementation, high for difficult work.
4. Give each subagent distinct ownership; prevent overlapping assignments; instruct leaf workers not to delegate.
5. Integrate outputs, resolve conflicts, and verify the combined result.
6. Keep approvals and externally consequential decisions with the user.

Keep trivial work with the coordinator; parallel agents cost tokens and coordination time, so use them only when the task is substantial.

### Task routing (keyword scoring)

```python
AGENTS = {
    "code-architect": ["code", "implement", "function", "bug", "fix", "refactor", "api"],
    "security-reviewer": ["security", "vulnerability", "audit", "cve", "injection"],
    "researcher": ["research", "compare", "analyze", "benchmark", "evaluate"],
    "doc-writer": ["document", "readme", "explain", "tutorial", "guide"],
    "test-engineer": ["test", "coverage", "unittest", "pytest", "spec"],
}
def route_task(description):
    scores = {a: sum(1 for kw in kws if kw in description.lower())
              for a, kws in AGENTS.items()}
    return max(scores, key=scores.get) if max(scores.values()) > 0 else "code-architect"
```

---

## Anti-duplication & quality gates

### Task registry (SQLite)

Before assigning work, check whether someone already owns it. Store tasks with `description`, `agent`, `status`, and compare new descriptions to pending/in-progress tasks (e.g., difflib `SequenceMatcher` ratio ≥ 0.55). Skip duplicates; notify the user instead of double-assigning.

### Quality gates — output is a CLAIM, evidence decides

After an agent reports completion, verify:

1. Were files actually modified? (`git diff --stat`)
2. Do tests pass? (`npm test` / `pytest`)
3. Were secrets introduced? (grep for API keys/tokens)
4. Did the build succeed? (`npm run build`)
5. Were only intended files touched? (scope check)

Mark done only after ALL checks pass. Log every delegation: task ID, agent, scope, deadline, verification command.

### 30-minute heartbeat

Periodically (e.g., every 30 min) ask: "What have I delegated recently?" If nothing, open the backlog; check for idle agents (>30 min without a message on an assigned task); relaunch or reassign them.

---

## Parallel dispatch

Use when 2+ independent tasks can run without shared state or sequential dependencies (e.g., 3 test files failing with unrelated root causes).

- **Identify independent domains** by what's broken, not by file count.
- **One agent per problem domain**, each with: specific scope, clear goal, constraints (don't touch other code), and a required summary of findings.
- **Review and integrate:** read each summary, check for conflicts, run the full suite, spot-check (agents make systematic errors).

Don't parallelize: related failures (fixing one may fix others), tasks needing full-system understanding, exploratory debugging, or anything with shared state (agents editing the same files).

**Prompt structure:** focused (one domain), self-contained (all context needed), specific about output. Never "fix all the tests" — always "fix agent-tool-abort.test.ts"; paste error messages; give constraints; demand a summary.

For CLI agents, use one git worktree per run so results merge cleanly. For dynamic workflow engines, plan a subtask graph, declare dependencies, and keep an adversarial verification pass on before merging.

---

## Orchestration patterns for specialists

- **Comprehensive analysis:** explorer-agent → domain-agents → synthesis.
- **Feature review:** affected-domain-agents → test-engineer → synthesis (always verify code changes with a test pass).
- **Security audit:** security-auditor → penetration-tester → prioritized remediation.
- **Synthesis protocol:** one unified report — task summary, agent contributions table, consolidated recommendations ranked Critical/Important/Nice-to-have, action items.

Share context between sequential agents; pass relevant findings to the next agent; keep ownership non-overlapping.

---

## Multi-perspective advisory (councils)

**LLM council (Karpathy pattern):** multiple models respond in parallel (Phase 1), rank each other's anonymized responses (Phase 2), then a chairman synthesizes (Phase 3). Save raw responses to files; never truncate API output; always display full transparency. Implement with any provider (e.g., Fireworks open-weight models). Critical rules: let the user pick models; never skip the ranking phase.

**Persona boards (multi-advisor):** activate multiple expert personas in parallel, each from its own angle, then synthesize consensuses, key divergences, and a decision. Rules: authenticity of voice, healthy tension (if everyone agrees, dig deeper), no forced consensus, every consultation ends with concrete next actions.

Both are best used for high-stakes decisions where a single perspective is a blind spot.

---

## Goal loops (bounded autonomy)

Turn a prompt into a persistent agent that loops `plan → act → test → review → iterate` until a verifiable stop condition, user pause, or budget limit. (Implemented as e.g. `/goal` in Codex, Claude Code, Hermes; generalizable to any auto-continue agent.)

Use only when all three hold: (1) > ~30 min of mechanical work; (2) a **verifiable stop condition**; (3) an agent-ready repo.

**The 5-part contract (every goal needs this):**

1. **Objective** — one sentence, one concrete outcome.
2. **Constraints** — what must NOT change (public API, files, libs, conventions).
3. **Validation command** — exact command proving progress (`pytest -q`).
4. **Stop condition** — verifiable: "Stop when X passes" OR "when further changes need human/product input."
5. **Documentation** — one sentence committing the agent to concise docs for every change.

Plus: what to read first, work in checkpoints, log progress briefly, forbid reward-hacking explicitly ("do not delete, skip, weaken, or narrow tests to make the goal pass"), forbid scope creep, and say when to pause and ask.

**Writing rules:**

- One objective, one stop condition. Never a backlog.
- Use literal strings for paths/commands/issue numbers.
- Keep the contract compact (≈4,000-char cap); put detail in a `PLAN.md` and point to it.
- **Meta-prompting trick:** have a second AI session inspect the codebase and emit the structured contract — hand-written goals under-specify.

**When a goal drifts:** minor drift → type a correction; loose objective → pause, tighten the contract; bad mess → clear it, `git status`/`stash`, rewrite via meta-prompting, restart. Always review the diff before merging — long autonomy means more code to validate, not less. Keep approvals/sandboxing tight.

---

## Scheduling recurring runs

First question: does the agent have a built-in scheduler, or do you own the clock?

**Camp A — one-shot agents, you own the clock** (Claude Code `-p`, Codex `exec`, Pi `run`): wrap in cron (1-min floor), systemd timers, or a `while ...; sleep N; done` loop for sub-minute. Never put an LLM on a tight autonomous timer. Gotchas: pass permission flags or the run hangs on a prompt (the #1 silent failure); use JSON output so the wrapper parses deterministically; one-shot runs are amnesiac — resume or persist state to a file.

**Camp B — built-in scheduler** (e.g., Hermes): gateway ticks run due jobs in fresh isolated sessions. Supports one-shot delays, cron expressions, zero-token script mode, job chaining, and loop safety (scheduled sessions cannot create more cron jobs).

**Heartbeat pattern:** one fast recurring tick gates many slower per-task checks — read a task list + per-task `last_run` timestamps, act only on due tasks, stay silent when nothing is due. Define active hours.

**Verify it fires before reporting success:** log file grows after one interval, or run the wrapped command once by hand → clean JSON/exit 0; for built-in schedulers, list jobs and confirm `next_run`.

---

## Hosted / background agents

For agents that run in remote sandboxed environments (Modal, VMs, server-first frameworks like OpenCode). Session speed should be limited only by model time-to-first-token — do all infrastructure work before the user starts.

- **Image registry pattern:** pre-build environment images on a cadence (~30 min) containing repo at a known commit, deps, build/cache warm. Spin sandboxes from the most recent image.
- **Snapshots:** base, post-change, and pre-exit snapshots enable instant restore for follow-ups.
- **Warm pool + predictive warm-up:** start warming when the user begins typing; allow file reads before git sync completes, block only writes.
- **Self-spawning agents:** expose tools to spawn sessions, read status, and continue main work while sub-sessions run.
- **Per-session state isolation:** one SQLite DB (or Durable Object) per session; real-time streaming via WebSocket; single state system synced across clients (chat, Slack, web, VS Code).
- **Multiplayer:** don't tie the data model to a single author; attribute commits to the prompting user; auth via user tokens so PRs open on the user's behalf.
- **Metrics that matter:** sessions resulting in merged PRs (primary), time-to-first-response, PR approval rate, % agent-written code.
- **Azure hosted agents (Python):** `azure-ai-projects>=2.0.0b3` with `ImageBasedHostedAgentDefinition` — container image, `container_protocol_versions=[ProtocolVersionRecord(protocol=AgentProtocol.RESPONSES, version="v1")]`, cpu/memory, tools (`code_interpreter`, `mcp`, `file_search`), env vars. Prereqs: image in ACR, `AcrPull` on the project identity, capability host. Errors: `ImagePullBackOff` → ACR pull perms; `CapabilityHostNotFound` → create capability host. Use `DefaultAzureCredential`; version image tags in production.

Local CLI fleet management (alternative): run several CLI agents in separate tmux sessions with a manager script (`doctor`, `list`, `start`, `monitor --follow`, `assign`) — cron-friendly for scheduled local agent work.
