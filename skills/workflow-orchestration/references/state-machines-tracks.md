# State Machines & Track-Based Delivery (Conductor)

Phased, spec-gated, track-based delivery where every artifact is versioned and
every revert is by logical work unit. Read `../SKILL.md` first.

## The track model

A **track** = a unit of work (feature / bug / chore / refactor) with a
specification and a phased implementation plan.

```
conductor/
├── product.md            # product context
├── tech-stack.md         # technical constraints
├── workflow.md           # TDD/commit/verification preferences
├── tracks.md             # registry (status markers)
├── index.md
└── tracks/{trackId}/
    ├── spec.md           # requirements
    ├── plan.md           # phased tasks + verification
    ├── metadata.json     # progress state
    └── index.md          # navigation
```

Track ID: `{shortname}_{YYYYMMDD}` (e.g., `user-auth_20250115`); append a
counter on collision.

## Creating a track (spec → plan → create)

1. **Pre-flight:** verify product/tech-stack/workflow context files exist.
2. **Classify:** feature / bug / chore / refactor; ask ONE question per turn,
   max ~6.
   - Feature: summary, user story, 3–5 acceptance criteria, dependencies, scope
     boundaries (out of scope!), technical notes.
   - Bug: summary, steps to reproduce, expected vs actual, affected areas, root
     cause hypothesis.
3. **Write `spec.md`:** summary, context, user story / problem, acceptance
   criteria, dependencies, out-of-scope, technical notes. Status: Draft.
4. **User reviews the spec** (approve / edit / restart).
5. **Write `plan.md`:** phases, each with objective, rationale, tasks, and a
   verification task. Typical structure: Setup/Foundation → Core Implementation
   → Integration → Polish. For TDD tracks, write test tasks before
   implementation tasks. Each phase is independently verifiable.
6. **User reviews the plan** (approve / edit / add phases / restart).
7. **Create** directory structure, `metadata.json` (id/title/type/status,
   phases.total/completed, tasks.total/completed), register in `tracks.md`.

## Implementing a track (TDD red-green-refactor)

For each incomplete task (`- [ ] Task X.Y`):
1. Mark `[~]` in progress; announce.
2. **Red:** write a failing test; run to confirm it fails. If tests pass
   unexpectedly, HALT and investigate.
3. **Green:** write minimum code to pass; run to confirm.
4. **Refactor:** clean up while keeping tests green.
5. **Commit** (`git add -A; git commit -m "{prefix}: {task} ({trackId})"`);
   mark task `[x]`; commit the plan update; bump `metadata.json`.
6. **Phase completion:** when a phase is fully `[x]`, run the phase
   verification + full test suite, then report and **wait for explicit user
   approval** before the next phase. Never skip verification checkpoints.
7. Record commit hashes in `metadata.json` for revertability.

Critical rules:
- STOP on any failure; present options (retry / skip / pause / revert).
- Do not attempt to continue past errors.
- Follow workflow.md strictly; keep plan.md current; commit frequently.

On resume: load `metadata.json`, find the current task, ask user how to proceed
(continue / restart task / show progress).

## Status, validation, and management

- **Status:** parse `tracks.md` (`[ ]` pending / `[~]` in progress / `[x]`
  complete) and per-track `plan.md` task counts; detect blockers (`BLOCKED:`
  markers, incomplete-track dependencies, failed verification); report
  overall project progress.
- **Validator:** verify `conductor/` artifacts exist and are consistent
  (index/product/tech-stack/workflow/tracks.md + required track files); status
  markers and task markers must follow the `[ ]/[~]/[x]` convention.
- **Manage:** archive / restore / delete / rename tracks and clean orphaned
  artifacts; confirm destructive actions before applying; keep `tracks.md` and
  metadata consistent.

## Reverting by work unit (git-aware undo)

Revert entire tracks, phases, or individual tasks using recorded commit
history — never by blind `git reset`.

1. Verify Conductor + git repo state; check for uncommitted changes first.
2. Select target (track / phase / task).
3. Discover the recorded commits for that unit from `metadata.json` / git log.
4. Revert the exact commits for the logical unit; leave other work intact.
5. Update plan.md + metadata to reflect the revert.

## Feature development pipeline (research → implementation → progress → phase)

A lighter-weight track workflow (the `build` skill):

```
/build research <name>        → docs/{name}/RESEARCH.md (problem, options,
                                recommended approach, tech, data, risks, open Qs)
/build implementation <name>  → docs/{name}/IMPLEMENTATION.md (phases with
                                objective/rationale/tasks/success criteria)
/build progress <name>        → docs/{name}/PROGRESS.md (phase status, decisions,
                                blockers, session log, files changed)
/build phase N <name>         → execute phase N, update PROGRESS.md in real time
/build status <name>          → which docs exist → next step
```

Guidelines: use AskUserQuestion liberally; deep research before building; keep
PROGRESS.md updated in real time; prevent scope creep (note emergent
requirements for future phases, don't expand current phase); "always works"
philosophy — test as you go, fix before moving on.
