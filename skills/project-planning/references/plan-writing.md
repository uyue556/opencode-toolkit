# Plan Writing & Task Breakdown

How to turn a request, spec, or objective into a clear, actionable, atomic plan. Merged from: `plan-writing`, `writing-plans`, `blueprint`, `concise-planning`.

## Choose the Right Plan Style

| Source skill | Best for | Output |
|---|---|---|
| `concise-planning` | Quick coding-task plans | One-page atomic checklist: Approach, Scope (In/Out), Action Items, Validation |
| `plan-writing` | Feature/bug/refactor plans | Goal + Tasks (max 10, verifiable) + Done-When |
| `writing-plans` | Implementation plans assuming zero codebase context | Bite-sized TDD steps with exact file paths and code |
| `blueprint` | Multi-session, multi-agent, multi-PR projects | One-PR-sized steps, each with a self-contained context brief |

## Core Principles (Shared Across All)

- **Keep it SHORT.** If a plan is longer than one page it's too long. 5-10 clear tasks max; no sub-sub-tasks. One line per task.
- **Be SPECIFIC.** Name real commands, files, and APIs. "Run `npx create-next-app`" beats "Set up project"; "curl localhost:3000/api/users returns 200" beats "Verify the API".
- **Atomic tasks.** Each step is one logical unit (2-5 minutes), verb-first ("Add...", "Refactor...", "Verify..."), with a clear verifiable outcome.
- **Verification is LAST** in every phase and every task. If you can't say how to check it, you haven't defined the task.
- **Dynamic, not templated.** Plans are unique to the task; adjust for project type (new project vs feature vs bug fix). Don't copy-paste script commands blindly — pick only scripts relevant to THIS task.

## Concise Plan Template (from `concise-planning`)

```markdown
# Plan
<High-level approach: 1-3 sentences on what and why>

## Scope
- In:
- Out:

## Action Items
[ ] <Step 1: Discovery>
[ ] <Step 2: Implementation>
[ ] <Step 3: Implementation>
[ ] <Step 4: Validation/Testing>
[ ] <Step 5: Rollout/Commit>

## Open Questions
- <Question 1 (max 3)>
```

## Plan Structure (from `plan-writing`)

```markdown
# [Task Name]

## Goal
One sentence: What are we building/fixing?

## Tasks
- [ ] Task 1: [Specific action] → Verify: [How to check]
- [ ] Task 2: [Specific action] → Verify: [How to check]

## Done When
- [ ] [Main success criteria]
```

That's it — no phases or sub-sections unless truly needed. Mark `[x]` as you complete.

## Implementation Plan Structure (from `writing-plans`)

Assumes a skilled developer who knows nothing about the toolset or domain. Save to `docs/plans/YYYY-MM-DD-<feature-name>.md`. Announce at start: "I'm using the writing-plans skill to create the implementation plan."

**Header:**
```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Goal:** [One sentence describing what this builds]
**Architecture:** [2-3 sentences about approach]
**Tech Stack:** [Key technologies/libraries]
```

**Each task** follows TDD with exact file paths and code:
```markdown
### Task N: [Component Name]
**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Step 1: Write the failing test** (code block)
**Step 2: Run test to verify it fails** — Run: `pytest ...` Expected: FAIL with "<error>"
**Step 3: Write minimal implementation** (code block)
**Step 4: Run test to verify it passes** — Expected: PASS
**Step 5: Commit** — `git add ...` / `git commit -m "feat: ..."`
```

### Execution Handoff

After saving the plan, offer two options:
1. **Subagent-Driven (this session)** — dispatch a fresh subagent per task, review between tasks, fast iteration.
2. **Parallel Session (separate)** — new session executes the plan on disk with checkpoints.

## Blueprint (from `blueprint`)

For multi-session/multi-agent engineering projects (3+ PRs). Turn a one-line objective into a construction plan any fresh agent can execute cold.

- **Cold-start execution:** every step has a self-contained context brief — a fresh agent in a new session can pick up any step without reading prior steps.
- **Adversarial review gate:** delegate plan review to a strongest-model sub-agent before execution.
- **Plan mutation protocol:** steps can be split, inserted, or skipped with an audit trail.
- **Research first:** scan the codebase, read project memory, run pre-flight checks; then design (one-PR-sized steps, parallel paths, dependency graph); draft; review; register the plan and update project memory.

Best practices:
- ✅ Use for 3+ PRs or multiple sessions/agents.
- ❌ Don't invoke for tasks completable in a single PR or when the user says "just do it".

## Do & Don't

| Don't | Do |
|---|---|
| 50 tasks with sub-sub-tasks | 5-10 clear tasks max |
| "Set up project" | "Run `npx create-next-app`" |
| "Verify the component works" | "Run `npm run dev`, click button, see toast" |
| Copy-paste all scripts into every plan | Only scripts relevant to THIS task |
| Save plans in `.claude/` or temp dirs | Save in project root as `{task-slug}.md` (or `docs/plans/`) |
