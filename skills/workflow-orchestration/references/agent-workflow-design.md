# Agent Workflow Design

Structuring agentic work so it is bounded, verifiable, and acceptance-gated.
Read `../SKILL.md` first.

## Core discipline: verification before completion

**Iron law:** no completion claims without fresh verification evidence. If you
haven't run the verification command in this message, you cannot claim it passes.

Gate function before any status claim:
1. IDENTIFY — what command proves this claim?
2. RUN — execute the full command, fresh and complete.
3. READ — full output, exit code, failure counts.
4. VERIFY — does the output confirm the claim? If no, state the actual status
   with evidence. If yes, state the claim WITH evidence.
5. ONLY THEN — make the claim.

Common failures (claim → requires): tests pass → test output 0 failures (not a
previous run, not "should pass"); linter clean → linter output 0 errors; build
succeeds → build exit 0 (linter ≠ compiler); bug fixed → original symptom
passes; agent completed → VCS diff shows changes (never trust an agent's success
report); requirements met → line-by-line checklist.

Red flags — STOP: "should/probably/seems to"; expressing satisfaction before
verification ("Great!", "Done!"); about to commit/push/PR without verification;
trusting agent success reports; partial verification; "just this once".
Rationalizations to reject: "I'm confident" (confidence ≠ evidence), "linter
passed" (≠ compiler), "agent said success" (verify independently), "different
words so rule doesn't apply" (spirit over letter).

## Ask questions if underspecified

Before implementing, decide whether the request is underspecified: multiple
plausible interpretations, or unclear objective / "done" / scope / constraints /
environment / safety.

- Ask 1–5 must-have questions in the first pass, numbered with lettered options;
  prefer questions that eliminate whole branches of work.
- Offer multiple-choice options, suggest defaults (bold the recommended choice),
  and include a fast-path ("reply `defaults`") plus a "Not sure – use default"
  option.
- Pause before acting until must-have answers arrive (or user approves stated
  assumptions). Restate chosen options in plain language to confirm.
- Do NOT ask questions you can answer with a quick low-risk discovery read
  (configs, existing patterns, docs).

## Spec → Build → Review loop (bounded)

Structure a bounded development cycle for scoped features:

- **Phase 1 — Spec:** interview one focused question at a time; write
  `specs/<feature-name>.md` with objective, exact requirements, edge cases, a
  concrete definition of done, iteration budget, verification commands, and
  approval gates. Do NOT start building yet.
- **Phase 2 — Build:** read the spec, build exactly what it describes. No extra
  features, no unrelated refactors, no invented requirements. List which spec
  requirements you covered.
- **Phase 3 — Review:** compare implementation to the spec requirement by
  requirement; list every gap naming the exact spec item it fails; loop back to
  Build if budget remains; stop for human input when the next fix would change
  the spec, exceed the budget, require risky operations, or depend on product
  decisions. Pass only when every requirement is met with declared evidence.

Keep scope small and modular; split large systems into multiple independent
loops.

## Executing a written implementation plan

For executing a plan in a separate session with review checkpoints:

1. **Load and review** the plan critically; raise concerns before starting;
   create a TodoWrite.
2. **Execute batches** (default first 3 tasks); follow steps exactly; run
   verifications as specified.
3. **Report** what was implemented + verification output; wait for feedback.
4. **Continue** in batches until complete.
5. Stop immediately on blockers (missing dependency, test failure, unclear
   instruction, repeated verification failure) — ask rather than guess.

## Subagent-driven development (same session)

Dispatch a fresh subagent per task, then run a two-stage review after each task:
**spec compliance review first, then code quality review.**

Process per task:
1. Controller reads the plan once, extracts all tasks with full text + context,
   creates TodoWrite.
2. Dispatch implementer subagent with full task text + context (do NOT make the
   subagent read the plan file). Answer its questions before it proceeds.
3. Implementer implements, tests, commits, self-reviews.
4. Dispatch spec-reviewer subagent — confirms code matches spec, nothing extra.
5. If gaps: implementer (same subagent) fixes; spec reviewer re-reviews.
6. Dispatch code-quality reviewer subagent; fix and re-review until approved.
7. Mark task complete; proceed to next; then one final whole-implementation
   review.

Red flags — never:
- Skip reviews (spec compliance OR code quality); start quality review before
  spec compliance is ✅; move on while either review has open issues.
- Dispatch multiple implementation subagents in parallel (conflicts).
- Let implementer self-review replace actual review (both are needed).
- Accept "close enough" on spec compliance.

Advantages: no context pollution, subagents follow TDD, questions surface before
work begins. Cost: more invocations + controller prep, but catches issues early.

## Acceptance-gated end-to-end delivery (state machine)

Treat each task as incomplete until acceptance criteria are verified with
evidence, not until code changed. States: `intake → issue-gated → executing →
review-loop → deploy-verify → accepted | escalated`.

Rules:
- **DoD first:** convert the request into testable acceptance criteria. Invalid:
  "fix checkout"; valid: "checkout endpoint returns an openable third-party
  payment URL in dev".
- **Issue gate:** if the tracking issue is not `ready` / gate not `allowed`, do
  not implement; never execute while `draft`. Acceptance criteria must be
  testable and pass/fail checkable.
- **Review loop:** batch PR polling windows (wait 3m → 6m → 10m, then process
  all visible comments together) instead of noisy rapid polling.
- **Deploy-verify:** deploy to `dev` by default; verify via real API/log
  evidence against DoD.
- **Completion gate:** report "done" only when all DoD checks pass; otherwise
  keep looping or escalate with a blocker report (what passed, what failed,
  evidence, smallest decision needed).
- **Human gates (always ask):** production/staging deploys beyond scope,
  destructive ops, billing/security posture changes, missing secrets, ambiguous
  DoD.
- Stop conditions → escalate: DoD fails after max rounds (default 2), external
  blocker, conflicting review instructions.
- Output contract: status, acceptance criteria pass/fail checklist, evidence
  (commands/logs/API results), open risks, need-human-input.

## Pre-task briefing (task intelligence)

Before execution, classify the task (simple / moderate / complex / critical) and
scale the briefing accordingly:

- **Simple**: execute directly.
- **Moderate/Complex**: parallel-scan relevant skills/agents, then produce a
  pre-execution briefing: context collected, execution plan with time estimates
  per stage, pre-resolved likely problems, verification checkpoints per stage,
  and a rollback plan.
- **Critical** (irreversible/deploy/delete/infra): maximal briefing + explicit
  user confirmation.

Problem anticipation in three layers:
- **Probable (80%+):** resolve BEFORE starting (invalid YAML → validate first;
  expired API key → check auth first; missing deps → read requirements first;
  git state → `git status` first).
- **Possible (30–70%):** verify state before assuming OK; define a warning
  signal and a response action.
- **Unlikely but critical (<10%, high impact):** irreversible actions, data
  loss, credential exposure → preventive backup, explicit confirmation, rollback
  plan.

Always add a 20–30% time buffer; never under-estimate to please.

## Full-stack / multi-agent feature orchestration

For full-stack features across layers, follow API-first, contract-driven phases:

1. **Architecture & design foundation:** database schema → backend service
   architecture with API contracts (OpenAPI/GraphQL) → frontend component
   architecture (against those contracts).
2. **Parallel implementation:** backend, frontend, database each from the
   contracts.
3. **Integration & testing:** API contract testing, E2E testing, security audit.
4. **Deployment & operations:** infra/CI-CD, observability, performance.

Each phase builds on prior outputs; keep separation of concerns; use feature
flags and progressive rollout.
