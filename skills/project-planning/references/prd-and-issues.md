# PRD, Issues & GitHub Issue Creation

Turn conversations into PRDs, break plans into independently-grabbable issues, and turn messy bug reports into crisp GitHub issues. Merged from: `to-prd`, `to-issues`, `github-issue-creator`.

## 1. PRD From Conversation (`to-prd`)

Turn the current conversation into a PRD — **no interview**, just synthesis of what's already discussed.

**Process:**
1. Explore the repo to understand current state (if not already done). Use the project's domain glossary vocabulary; respect ADRs in the area you're touching.
2. Sketch the **seams** at which you'll test the feature. Prefer existing seams, at the highest point possible. Fewer seams = better (ideal: one). Confirm with the user.
3. Write the PRD with the template below and publish it to the issue tracker with a `ready-for-agent` triage label.

**PRD template:**
```markdown
## Problem Statement
The problem the user faces, from the user's perspective.

## Solution
The solution, from the user's perspective.

## User Stories
1. As an <actor>, I want a <feature>, so that <benefit>
   (extensive numbered list covering all aspects)

## Implementation Decisions
- Modules built/modified, interfaces, technical clarifications, architecture, schema changes,
  API contracts, specific interactions.
- Do NOT include specific file paths or code snippets (they go stale).
  Exception: inline decision-rich snippets from a prototype (state machine, reducer, schema, type shape),
  noting they came from a prototype.

## Testing Decisions
- What makes a good test (external behavior, not implementation details)
- Which modules will be tested
- Prior art (similar tests in the codebase)

## Out of Scope

## Further Notes
```

## 2. Break Plans Into Issues (`to-issues`)

Break a plan/spec/PRD into **tracer-bullet vertical slices**: each issue is a thin vertical slice that cuts through ALL integration layers end-to-end (schema, API, UI, tests) — NOT a horizontal slice of one layer.

**Process:**
1. **Gather context** — work from conversation; if an issue reference is passed, fetch its full body and comments.
2. **Explore the codebase** — use domain glossary vocabulary; respect ADRs; look for opportunities to prefactor ("make the change easy, then make the easy change").
3. **Draft vertical slices** — each delivers a narrow but COMPLETE path through every layer; a completed slice is demoable/verifiable on its own; prefactoring done first.
4. **Quiz the user** — present as a numbered list: Title, Blocked by, User stories covered. Ask: granularity right? dependencies correct? merge/split needed? Iterate until approved.
5. **Publish in dependency order** (blockers first, so real issue IDs can be referenced). Apply the triage label (ready for AFK agents). Do NOT close or modify the parent issue.

**Issue body template:**
```markdown
## Parent
A reference to the parent issue (omit if the source wasn't an existing issue).

## What to build
End-to-end behavior of this vertical slice, not layer-by-layer implementation.
Avoid file paths/code snippets (they go stale) — except decision-rich prototype snippets.

## Acceptance criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Blocked by
- Reference to the blocking ticket (or "None - can start immediately")
```

## 3. GitHub Issue From Messy Input (`github-issue-creator`)

Turn error logs, screenshots, voice notes, and rough bug reports into crisp, developer-ready issues.

**Template:**
```markdown
## Summary
[One-line description]

## Environment
- **Product/Service**:
- **Region/Version**:
- **Browser/OS**: (if relevant)

## Reproduction Steps
1. [Step]
2. [Step]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Error Details
```[error message/code]```

## Visual Evidence
[Reference to attached screenshots/GIFs — format `!Description`]

## Impact
[Severity: Critical/High/Medium/Low + brief explanation]

## Additional Context
```

**Guidelines:**
- **Crisp:** no fluff; every word adds value.
- **Extract structure from chaos:** voice dictation/raw notes contain facts buried in casual language.
- **Infer missing context:** fill in specifics from conversation/memory ("the dashboard").
- **Placeholder sensitive data:** use `[PROJECT_NAME]`, `[USER_ID]`, etc.
- **Match severity to impact:** Critical = service down/data loss/security; High = major feature broken, no workaround; Medium = feature impaired, workaround exists; Low = minor/cosmetic.
- **Output location:** `issues/YYYY-MM-DD-short-description.md` in the repo root.

## Do & Don't

| Do | Don't |
|---|---|
| Cut vertical (end-to-end) slices | Cut horizontal (single-layer) slices |
| Publish blockers before dependents | Reference issue IDs that don't exist yet |
| Describe end-to-end behavior in issues | Embed file paths/code that go stale fast |
| Quiz the user on granularity & deps | Publish a breakdown without approval |
| Separate current behavior from planned | Record plans as if the behavior exists |
