# Collaboration: Standups & Issue Resolution

Async-first team communication (standup notes from commits/tickets) and systematic GitHub issue resolution workflows. Merged from: `team-collaboration-standup-notes`, `team-collaboration-issue` (incl. their `implementation-playbook.md` files).

## 1. Standup Notes Generator

Async standups maintain visibility, coordinate work, and surface blockers without synchronous meetings.

### Data sources to orchestrate
- Git commit history (last 24h, by author): `git log --author="$USER" --since="24 hours ago" --pretty=format:"%h|%s|%cr" --no-merges`
- Jira ticket updates (completed / in-progress)
- Obsidian daily notes / calendar events
- Fall back gracefully when a source (e.g., Jira MCP) is unavailable.

### Standup note structure
```markdown
# Standup - YYYY-MM-DD

## Yesterday / Last Update
- Group related commits into single accomplishment bullets
- Link commits to tickets (extract ticket IDs from messages)
- Transform technical commits into business value ("Implemented X to enable Y")

## Today / Next
- In-progress tickets with current status
- Planned meetings
- Prioritize by ticket priority and sprint goals

## Blockers / Notes
- Flag blockers from patterns: multiple commits retrying the same fix,
  no commits on a high-priority ticket, "TODO"/"FIXME" in code,
  dependencies mentioned in ticket comments
```

### AI-assisted generation prompt
Provide the model with commit/ticket/calendar context and instruct it to:
1. Group related commits into single accomplishment statements; link to tickets; express business value.
2. List in-progress tickets with status; estimate completion from commit history; prioritize.
3. Identify potential blockers from commit/ticket patterns.
Format: markdown with clear headers, 1-2 line bullets, hyperlinks to PRs/tickets/docs.

### Async standup patterns
- Post daily to the team channel (e.g., Slack `#standup`) as: ✅ Yesterday / 🎯 Today / 🚧 Blockers / 📎 Links.
- Draft in Obsidian, adjust formatting for the target platform, present for human review before posting.
- Track follow-ups: auto-generate follow-up tasks from standups.

## 2. GitHub Issue Resolution Workflow

Systematic path from issue to merged, tested PR.

### 1. Issue analysis & triage
- Get complete issue details, metadata, linked PRs/related issues.
- Search for similar resolved issues; check recent commits in the affected area; review PR history for regressions.

### 2. Root cause analysis
- Find when the issue was introduced: `git bisect` with an automated test script; `git blame` on specific files.
- Search all occurrences/imports/usages of the problematic function; analyze the call hierarchy.

### 3. Branch strategy
- Feature branches for features, bug-fix branches for fixes, hotfix branches for production, experimental/spike branches for spikes.
- Set upstream tracking; link branch to issue; configure branch protection locally.

### 4. Implementation planning & task breakdown
Break into phases with verifiable outputs, e.g.:
```markdown
## Implementation Plan for Issue #<N>
### Phase 1: Foundation
### Phase 2: Core Logic
### Phase 3: Integration
### Phase 4: Testing & Polish
```
Update after each subtask completion.

### 5. Test-driven development
Write failing tests first, verify they fail, implement minimally, verify they pass, commit. Test external behavior, not implementation details. Use integration tests where the seams demand them.

### 6. Pull request creation
Before PR: run all tests, check for console logs/debug code, verify no sensitive data, update documentation. Write a comprehensive PR description: Summary, Changes Made, Testing, Performance Impact, Screenshots/Demo, Checklist. Reference the related issue; choose the correct type of change; include the review checklist.

### 7. Post-implementation verification
- Check deployment status; monitor for errors; verify the fix in production; check error rates.
- Add a resolution comment and close with a reference to the PR/commit.

## Do & Don't

| Do | Don't |
|---|---|
| Group commits into business-value bullets | Dump raw commit hashes in standups |
| Flag blockers explicitly with context | Hide stalled work |
| Use `git bisect` + tests for regressions | Guess the culprit commit |
| Run tests + check for debug code before PR | Open PRs with console logs or secrets |
| Reference the issue in the PR | Merge without post-deploy verification |
