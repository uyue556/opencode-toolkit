---
name: project-planning
description: "Plan, break down, estimate, track, and execute software projects end-to-end. Turn a vague objective or conversation into a PRD, implementation plan, and independently-grabbable issues; break work into verifiable 2-5 minute tasks; estimate with PERT/confidence bands; keep durable feature memory with markdown files; run standups, kickoffs, and SR&ED reporting; automate Asana/Jira/Linear/Trello/Monday/Todoist/Wrike/Basecamp/Confluence/Freshservice/Miro via Rube MCP (Composio). Use whenever the user mentions 项目规划, 计划, 排期, 冲刺, sprint, 任务拆分, 需求拆解, 功能开发计划, PRD, 问题单, issue, 估算, 工时, 排程, roadmap, 里程碑, 敏捷, agile, kanban, standup, 站会, feature track, 功能跟踪, estimation, backlog, tracking, roadmap, kickoff."
risk: critical
source: consolidated
---

# Project Planning

Consolidated skill for turning objectives into executed, tracked, reported projects. It spans the full lifecycle: clarify the ask, write a PRD or plan, break it into verifiable tasks and issues, estimate, persist the plan as durable memory, publish to an issue tracker, track execution, and report progress.

## When to Use

- User asks to **plan** a coding task, feature, refactor, or project (计划/规划/排期).
- User has a **spec, PRD, or requirements** and needs an implementation plan before touching code.
- User wants a plan **broken into issues/tickets** for an issue tracker, or a **PRD synthesized** from a conversation.
- User wants to **estimate** work (single task, backlog, or sprint) with statistical confidence.
- User is working on a **long-lived feature** across sessions/agents and needs durable memory.
- User asks for **standup notes, progress reports, or SR&ED (Canadian R&D tax) project documentation**.
- User wants to **automate** a project-management tool (Asana, Basecamp, Confluence, Freshservice, Jira, Linear, Miro, Monday, Todoist, Trello, Wrike).
- User is **stuck or overwhelmed** ("I don't know where to start") — use decision-navigator to find concrete next steps.

Do **not** use for: quick single-file edits, simple lookups, or when the user says "just do it" and the task fits in one PR.

## Core Workflow

For a typical multi-step project, move through these phases. Skip phases the situation doesn't need; each has a reference file with the full playbook.

### 1. Clarify & orient (brief)
- If the user is stuck or the request is broad/open-ended, branch them down to a concrete scope with **decision-navigator** (`references/decision-navigator.md`).
- Otherwise ask **at most 1-2 blocking questions**; make reasonable assumptions for the rest. Extract anything the user already told you before asking.

### 2. Capture intent as a PRD (if this is a feature)
- Synthesize the conversation into a PRD without interviewing the user: Problem Statement, Solution, extensive User Stories, Implementation Decisions, Testing Decisions, Out of Scope. Use project domain vocabulary and respect ADRs. See `references/prd-and-issues.md`.

### 3. Write the plan
- Pick a granularity: **concise-planning** (atomic checklist) for quick plans, **plan-writing** (max 5-10 verifiable tasks) for feature work, **writing-plans** (TDD bite-sized steps with exact file paths) for implementation plans, **blueprint** (cold-start steps with self-contained context briefs) for multi-session/multi-agent projects. See `references/plan-writing.md`.
- Save the plan in the **project root** (e.g., `{task-slug}.md` or `docs/plans/YYYY-MM-DD-<feature>.md`), never in `.claude/` or temp folders.

### 4. Persist as durable memory
- Before starting any complex task, create working-memory files: `task_plan.md`, `findings.md`, `progress.md` in the project root. Re-read the plan before major decisions; update after each phase; log all errors. See `references/planning-with-files.md`.
- For long-lived features, maintain a feature track under `docs/features/` with status, source-of-truth links, current behavior, decisions, risks, and a dated changelog. See `references/feature-tracking.md`.

### 5. Break into issues & estimate
- Break the plan into **tracer-bullet vertical slices** (thin end-to-end paths through schema, API, UI, tests), each demoable on its own; publish to the tracker in dependency order with acceptance criteria. See `references/prd-and-issues.md`.
- Estimate with **three-point PERT** and publish P75/P90 (not P50) for commitments; calibrate against actuals. See `references/estimation.md`.

### 6. Publish & track
- Create issues/projects/sprints in the chosen tool (Linear, Jira, GitHub, Asana, Monday, Todoist, Trello, Wrike, Basecamp) via its automation reference. Create issues in the **correct project from the start** — a project per phase, linked to its initiative/roadmap, with issues attached to projects. See `references/tool-automation.md`.
- Track execution with status markers and reconcile the track before declaring completion. See `references/feature-tracking.md`.

### 7. Report
- Generate standup notes from commits/tickets; produce progress summaries; for Canadian tax purposes, group a year of PRs/docs/tickets into SR&ED projects. See `references/collaboration.md` and `references/sred-reporting.md`.

## Selection Routing

| If the task is... | Open this reference |
|---|---|
| Writing an implementation plan / breaking work into tasks / blueprint for multi-agent | `references/plan-writing.md` |
| Keeping working memory across a long task (task_plan/findings/progress) | `references/planning-with-files.md` |
| Durable feature memory, Conductor tracks, spec.md/plan.md lifecycle | `references/feature-tracking.md` |
| Estimating effort, sprint sizing, PERT, confidence bands | `references/estimation.md` |
| PRD synthesis, vertical-slice issues, GitHub issue creation | `references/prd-and-issues.md` |
| User is stuck/overwhelmed, scope is unclear | `references/decision-navigator.md` |
| Standups, async updates, issue-resolution workflow, PRs | `references/collaboration.md` |
| SR&ED (Canadian R&D tax) work summary & project descriptions | `references/sred-reporting.md` |
| Automating a PM tool via Rube MCP / Composio (11 tools) | `references/tool-automation.md` |

## Best Practices

- **Plan first.** Never start a complex task without a written plan. Files are memory: context is RAM (volatile), the filesystem is disk (persistent). Anything important gets written to disk.
- **Tasks are small and verifiable.** Each task is 2-5 minutes of work, one clear outcome, independently verifiable. Max ~10 tasks per plan; if more, split into multiple plans. Verb-first, concrete, name real files.
- **Specific over generic.** "Run `npx create-next-app`" beats "Set up project". Verification is concrete: "curl returns 200", "click the button and see the toast".
- **Verification is always last** in a phase. Every plan has a Done-When block.
- **Commit frequently, TDD-first** for implementation plans: write failing test → see it fail → minimal implementation → see it pass → commit.
- **Link, don't duplicate.** Feature tracks link to the PRD/code/tests rather than copying specs; index stays a compact status surface.
- **Make the change easy, then make the easy change.** Prefactor before implementing; look for the highest test seam possible (ideally one).
- **Use the right estimate for the commitment.** P50 for expectation, P75/P90 for commitments. Re-calibrate when team composition or agent usage changes.
- **Use a fresh agent/session per task** for long plans (subagent-driven), or open a parallel session with the plan on disk.

## Do & Don't

| Do | Don't |
|---|---|
| Create `task_plan.md`/`findings.md`/`progress.md` in the project root before complex work | Start executing without a plan |
| Save plan files in the project root as `{slug}.md` | Save plans inside `.claude/`, `docs/`, or temp folders |
| Write findings to disk after every ~2 view/browser/search operations | Rely on chat context for multimodal findings |
| Log every error + resolution; never repeat the same failed action | Hide errors and silently retry identically |
| Keep each plan to one page / max 10 tasks | Produce 50 sub-sub-task checklists |
| Create issues in the correct project from the start | Create issues in a "holding" project and move them later |
| Use P75/P90 for commitments | Promise P50 estimates as deadlines |
| Reconcile the track (status, links, changelog) before declaring done | Treat a detailed plan as if the behavior already exists |
| Respect secrets: never put credentials/tokens in tracks or commits | Expose API keys in shell output or context |

## Common Pitfalls

- **Stale plans treated as truth.** Current code/tests beat old plans; update current-behavior sections only after verification.
- **Overconfidence in estimates.** Always widen for commitments; missing context (team size, agent usage %) inflates error.
- **Drift in long tasks.** After ~50 tool calls the goal fades; re-read the plan before decisions (recitation).
- **Tool-ID confusion.** Most trackers require IDs/GIDs, not display names — resolve names to IDs first (see `references/tool-automation.md`).
- **Vertical slices cut horizontally.** A slice touching only one layer isn't demoable; cut thin end-to-end paths.
- **PRD/issue duplication.** Keep one authoritative doc; issues reference it rather than restating it fully.
- **Over-branching a stuck user.** Once the user says "just tell me what to do", stop branching and give concrete steps.

## Examples

**Example 1 — Feature from conversation (Linear workflow):**
1. Synthesize the conversation into a PRD (Problem/Solution/User Stories/Decisions/Testing/Out of Scope).
2. Create the phase project linked to its initiative; set state to `planned`.
3. Break into vertical slices; create issues in that project with acceptance criteria + "Blocked by" refs.
4. Write `docs/plans/YYYY-MM-DD-<feature>.md` with bite-sized TDD steps; save `task_plan.md`.
5. Estimate each slice (three-point PERT); commit to P75.
6. When work starts, set project to `in-progress`; mark issues done as shipped; set project `completed`; update the feature track.

**Example 2 — Messy bug report → GitHub issue:**
1. Extract structure from the raw input (voice note/error paste).
2. Produce: Summary, Environment, Repro Steps, Expected vs Actual, Error Details, Impact (severity matched to effect), Additional Context.
3. Save as `issues/YYYY-MM-DD-short-description.md`; placeholder any sensitive values.

**Example 3 — Stuck user ("I want to start a business but don't know where"):**
1. Branch: "What's the main thing drawing you to it?" → specific idea / freedom / money / not sure.
2. Branch deeper 2-3 levels (idea stage, biggest blocker).
3. At the leaf, give 3-6 ordered concrete steps, not vague advice.

## Limitations

- This skill structures and guides planning; it does not replace environment-specific validation, testing, expert review, or professional legal/financial advice (including SR&ED eligibility — CRA decides).
- Automation references require the corresponding tool connection (Rube MCP or CLI) to be configured and ACTIVE.
- Do not treat generated artifacts as final until validated against the user's real sources.
- Stop and ask for clarification if required inputs, permissions, safety boundaries, or success criteria are missing.
