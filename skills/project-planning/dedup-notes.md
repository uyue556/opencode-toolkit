# Dedup Notes — project-planning

Consolidation of 28 source skills (21 from `project-management/`, 7 from `planning/`) into one `project-planning` skill.

## Output layout

```
project-planning/
├── SKILL.md                  # routing hub + core workflow + best practices (< 500 lines)
├── references/
│   ├── plan-writing.md       # plan-writing, writing-plans, blueprint, concise-planning
│   ├── planning-with-files.md# planning-with-files (+ reference.md, templates/)
│   ├── feature-tracking.md   # feature-tracking, track-management (+ implementation-playbook)
│   ├── estimation.md         # progressive-estimation
│   ├── prd-and-issues.md     # to-prd, to-issues, github-issue-creator
│   ├── decision-navigator.md # decision-navigator
│   ├── collaboration.md      # team-collaboration-issue, team-collaboration-standup-notes
│   ├── sred-reporting.md     # sred-work-summary, sred-project-organizer
│   └── tool-automation.md    # 11 Rube MCP automation skills + linear-claude-skill
├── scripts/
│   └── generate-standup.sh   # extracted from standup implementation-playbook.md
└── dedup-notes.md
```

## Sources scanned (28 SKILL.md)

planning (7): blueprint, concise-planning, decision-navigator, plan-writing, planning-with-files, track-management, writing-plans.
project-management (21): asana, basecamp, confluence, feature-tracking, freshservice, github-issue-creator, jira, linear-automation, linear-claude-skill, miro, monday, progressive-estimation, sred-project-organizer, sred-work-summary, team-collaboration-issue, team-collaboration-standup-notes, to-issues, to-prd, todoist, trello, wrike.

## Notable duplicates merged

- **5 plan-writing skills → `references/plan-writing.md`.** `concise-planning` (atomic checklist template), `plan-writing` (goal/tasks/verify), `writing-plans` (TDD bite-sized steps, exact paths), and `blueprint` (cold-start multi-agent steps) all cover task breakdown. Kept the best of each: concise template, plan-writing structure, writing-plans header/TDD task format + execution handoff, blueprint's cold-start/adversarial-review distinctives. Dropped repeated "keep it short/specific/verifiable" advice across all four.
- **11 Rube MCP automation skills → `references/tool-automation.md`.** Asana/Basecamp/Confluence/Freshservice/Jira/Linear/Miro/Monday/Todoist/Trello/Wrike shared ~70% identical text: identical Prerequisites, Setup (Rube MCP endpoint, RUBE_MANAGE_CONNECTIONS, ACTIVE check), Common Patterns (ID resolution, pagination), and Known Pitfalls structure. Merged the shared pattern once and kept each tool's unique quick-reference table + tool-specific pitfalls. Dropped all duplicated setup/limitations boilerplate (11 copies → 1).
- **`linear-automation` (Rube MCP) + `linear-claude-skill` (CLI/MCP/SDK) → `tool-automation.md`.** Overlapping "manage Linear issues/projects" content; kept Rube MCP quick-ref plus the CLI skill's security (Varlock, never expose API keys), project-planning workflow (project→initiative→issues), status/label conventions, and tool-selection table.
- **`feature-tracking` + `track-management` → `references/feature-tracking.md`.** Both are durable feature/work-unit memory with lifecycle management; feature-tracking is repo-native docs/features/, track-management is Conductor spec.md/plan.md/tracks.md. Kept both structures (they complement) under one routing doc.
- **`to-issues` + `to-prd` + `github-issue-creator` → `references/prd-and-issues.md`.** All three produce tracker artifacts (PRD, issues, GitHub issues) from conversation/plans. Kept the PRD template, vertical-slice issue process + issue template, and the messy-input→issue template with severity mapping.
- **`sred-work-summary` + `sred-project-organizer` → `references/sred-reporting.md`.** Upstream/downstream of the same SR&ED pipeline; merged into one workflow doc.
- **`team-collaboration-issue` + `team-collaboration-standup-notes` → `references/collaboration.md`.** Both had thin SKILL.md wrappers pointing at `resources/implementation-playbook.md`; merged the playbook substance (issue triage→RCA→branch→TDD→PR→verify; standup data sources + generation prompt + async patterns) into one reference.
- **`planning-with-files` + its `reference.md`/`templates/` → `references/planning-with-files.md`.** Inlined condensed templates (task_plan/findings/progress skeletons) and the Manus context-engineering background; dropped full template boilerplate.

## Notable skills dropped / reduced

- **`decision-navigator`** — kept nearly intact in `references/decision-navigator.md` (unique: branching-question technique, no other source covers it).
- **`progressive-estimation`** — kept in `references/estimation.md`; dropped references to an external repo/installation guide and "Related Skills" cross-links to skills outside this domain.
- **`blueprint`** — reduced to the portable technique (cold-start steps, adversarial review, mutation protocol); dropped installation/clone instructions and repo-specific examples (the skill was essentially an installer for an external repo).
- **`linear-claude-skill`** — trimmed CLI/GraphQL deep-dive (api.md/sdk.md/sync.md references to files that don't exist here) but kept all security + project-planning conventions.
- **Dropped across all sources**: "When to Use / Limitations" boilerplate that appeared verbatim in every SKILL.md; self-congratulatory preamble; "Related Skills" cross-references pointing to other consolidated skills; per-tool duplication of the identical Rube MCP setup section.

## Scripts

- Carried 1 script: `scripts/generate-standup.sh` (extracted verbatim from `team-collaboration-standup-notes/resources/implementation-playbook.md`; made optional-integration checks safer).
- No other standalone scripts existed in the 28 sources (only embedded command snippets, which are inlined in the references where useful).

## Gaps / doubts

- `blueprint` was an installer for an external GitHub repo (antbotlab/blueprint); I kept only the pattern, not the pin/install. If the user wants the exact blueprint workflow, re-fetch the pinned revision.
- Conductor `track-management` playbook (spec.md/plan.md/tracks.md/metadata.json, status-marker conventions) was skimmed by headings, not fully read; the condensed lifecycle in `feature-tracking.md` may omit edge-case details of the full playbook.
- `team-collaboration-*` implementation playbooks were large (628 + 768 lines) and read by heading structure + key sections; PR/standup example code beyond what's captured lives in the originals.
- Rube MCP tool slugs are copied from source quick-reference tables; schemas drift — the skill correctly instructs `RUBE_SEARCH_TOOLS` first, so tables are hints, not ground truth.
- SR&ED workflow assumes GitHub/Notion/Linear access and Notion templates that live in the original skill's references (`SRED.md`, `project-template.md`) — not shipped here; treat as external requirements.
- No scripts dir content in sources beyond the one extracted; the `planning-with-files` SKILL mentioned `scripts/init-session.sh` / `check-complete.sh` but no such files exist in the source directory.
