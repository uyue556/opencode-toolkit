# Planning With Files (Working Memory on Disk)

How to use persistent markdown files as "working memory on disk" across long, multi-step tasks. Merged from: `planning-with-files` (incl. its `reference.md` and `templates/`).

## The Core Model

```
Context Window = RAM (volatile, limited)
Filesystem     = Disk (persistent, unlimited)
→ Anything important gets written to disk.
```

## The Three Planning Files

Create these **in your project directory** (NOT in the skill installation folder), before any complex task:

| File | Purpose | When to Update |
|---|---|---|
| `task_plan.md` | Goal, current phase, phases, decisions, errors | After each phase |
| `findings.md` | Research/discoveries, requirements, technical decisions | After ANY discovery |
| `progress.md` | Session log, test results, what was done | Throughout session |

### `task_plan.md` skeleton

```markdown
# Task Plan: [Brief Description]

## Goal
[One sentence describing the end state]

## Current Phase
Phase 1

## Phases
### Phase 1: Requirements & Discovery
- [ ] Understand user intent
- [ ] Identify constraints
- **Status:** in_progress    <!-- pending | in_progress | complete -->

## Key Questions
1. [Question to answer]

## Decisions Made
| Decision | Rationale |
|----------|-----------|

## Errors Encountered
| Error | Attempt | Resolution |
|-------|---------|------------|
```

### `findings.md` skeleton

```markdown
# Findings & Decisions

## Requirements
- [captured from user request]

## Research Findings
- [key discoveries from searches/docs/exploration]

## Technical Decisions
| Decision | Rationale |
|----------|-----------|

## Visual/Browser Findings
- [CRITICAL: capture multimodal content as text immediately]
```

### `progress.md` skeleton

```markdown
# Progress Log

## Session: [DATE]
### Phase 1: [Title]
- **Status:** in_progress
- Actions taken:
- Files created/modified:

## Test Results
| Test | Input | Expected | Actual | Status |

## Error Log
| Timestamp | Error | Attempt | Resolution |

## 5-Question Reboot Check
| Question | Answer |
|----------|--------|
| Where am I? | Phase X |
| Where am I going? | Remaining phases |
| What's the goal? | [goal] |
| What have I learned? | See findings.md |
| What have I done? | See above |
```

## Critical Rules

1. **Create the plan first.** Never start a complex task without `task_plan.md`. Non-negotiable.
2. **The 2-Action Rule.** After every 2 view/browser/search operations, immediately save key findings to text files. Multimodal content (images, PDFs, browser output) doesn't persist otherwise.
3. **Read before decide.** Before major decisions, re-read the plan file so goals stay in the attention window (recitation; counteracts "lost in the middle").
4. **Update after act.** After completing a phase: mark status `in_progress` → `complete`, log errors, note files created/modified.
5. **Log ALL errors** with attempt + resolution. This builds knowledge and prevents repetition.
6. **Never repeat failures.** `if action_failed: next_action != same_action`. Track what you tried; mutate the approach.

## The 3-Strike Error Protocol

```
ATTEMPT 1: Diagnose & Fix      → read error, identify root cause, targeted fix
ATTEMPT 2: Alternative Approach → different method/tool/library; NEVER repeat the same failing action
ATTEMPT 3: Broader Rethink     → question assumptions, search solutions, consider updating the plan
AFTER 3 FAILURES: Escalate to User → explain what you tried, share the error, ask for guidance
```

## Read vs Write Decision Matrix

| Situation | Action | Reason |
|---|---|---|
| Just wrote a file | Don't read | Content still in context |
| Viewed image/PDF | Write findings NOW | Multimodal → text before lost |
| Browser returned data | Write to file | Screenshots don't persist |
| Starting new phase | Read plan/findings | Re-orient if context stale |
| Error occurred | Read relevant file | Need current state to fix |
| Resuming after gap | Read all planning files | Recover state |

## The 5-Question Reboot Test

If you can answer these, your context management is solid:
1. Where am I? → current phase in `task_plan.md`
2. Where am I going? → remaining phases
3. What's the goal? → goal statement in plan
4. What have I learned? → `findings.md`
5. What have I done? → `progress.md`

## Context Engineering Background (from `reference.md`)

Adapted from Manus principles:
- **Design around KV-cache:** keep prompt prefixes stable, no timestamps in system prompts, append-only deterministic context.
- **Filesystem as external memory:** keep URLs and file paths even when content is dropped — never lose the pointer to full data.
- **Manipulate attention through recitation:** re-read the plan before each decision.
- **Keep the wrong stuff in:** failed actions with stack traces let the model update beliefs and reduce repetition.
- **Don't get few-shotted:** introduce controlled variation; uniform repetitive pairs cause drift.
- **Compaction:** store full tool results on disk, keep only references/compacts for stale results.

## When to Use / Skip

**Use for:** multi-step tasks (3+ steps), research tasks, building projects, tasks spanning many tool calls, anything requiring organization.

**Skip for:** simple questions, single-file edits, quick lookups.

## Anti-Patterns

| Don't | Do Instead |
|---|---|
| Use TodoWrite for persistence | Create `task_plan.md` |
| State goals once and forget | Re-read plan before decisions |
| Hide errors and retry silently | Log errors to plan file |
| Stuff everything in context | Store large content in files |
| Start executing immediately | Create plan file FIRST |
| Repeat failed actions | Track attempts, mutate approach |
| Create files in skill directory | Create files in project root |
