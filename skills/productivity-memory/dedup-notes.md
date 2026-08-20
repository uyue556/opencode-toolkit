# Dedup Notes — productivity-memory

Consolidated **44 SKILL.md files** from 6 source libraries into one skill
(`productivity-memory`) with 8 sub-topic references + reusable wiki templates.

## Topics merged (by reference)

- **memory-systems.md** — merged `memory/agent-memory-systems` (CoALA types, vector-store
  selection, chunking, decay, validation), `memory/memory-systems` (spectrum, graph/temporal
  architectures, benchmarks), `memory/conversation-memory` (tiered + entity memory, importance
  scoring, user isolation, GDPR), `memory/hierarchical-agent-memory` (scoped CLAUDE.md, routing,
  dashboard), `memory/recallmax` (dedup injection, tone/intent-preserving summarization,
  compression).
- **context-optimization.md** — merged `memory/context-window-management` (tiers, serial
  position, intelligent summarization, token budgets), `context-optimization/geminiignore-finops`
  (7 ignore categories + baseline template), `productivity/context-kit` (personal context
  artifacts + safety), `productivity/faf-wizard` (project.faf portable context),
  `productivity/codex-profiles` (CODEX_HOME isolation).
- **knowledge-management.md** — merged `knowledge-management/wiki-builder` (layout, flavors,
  provenance, operating loop) and `knowledge-management/maintain-codex-wiki` (review-first
  contract, statuses, source classes, Confinement, promotion table), plus `productivity/anywrite`
  (Anytype CLI).
- **workflow-productivity.md** — merged `productivity/rich-elicitation`, `productivity/grilling`,
  `productivity/grill-me`, `productivity/grill-with-docs`, `productivity/interview-style-doc-building`,
  `productivity/brain-to-docs`, `productivity/read-all-adrs`, `productivity/handoff`,
  `productivity/setup-help`, `productivity/markdown-rendering`, `productivity/interview-coach`
  (brief mention), `productivity/ask-matt` (router logic).
- **time-and-journaling.md** — merged `productivity/time-ledger` and `productivity/trading-ledger`
  (shared parse→To-confirm→batch-ask pattern, per-ledger schema/rules).
- **file-organization.md** — `productivity/file-organizer` alone.
- **office-productivity.md** — merged `productivity/office-productivity` (workflow bundle) and
  `office-productivity/pptx-deck-creation` (narrative frameworks, coordinate spec, audit),
  plus `productivity/mdpr-skill` (brief).
- **external-automation.md** — merged the Rube MCP/Composio suite
  (`box-automation`, `dropbox-automation`, `one-drive-automation`, `cal-com-automation`,
  `calendly-automation`, `docusign-automation`) into one common-pattern reference +
  per-service table; standalone `gmail-automation`, `google-calendar-automation`; and
  `telegram-bot-messaging`.

## Notable duplicates dropped / compressed

- **The 6 Rube MCP SaaS skills** (Box/Dropbox/OneDrive/Cal.com/Calendly/DocuSign) are ~80%
  identical scaffolding (prerequisites, ID resolution, pagination, rate limits, quick reference).
  Kept the single shared pattern + a per-service table; dropped the ~200-line near-identical
  bodies. Their specific quirks are preserved in the table and text.
- **grilling / grill-me / grill-with-docs** — three variants of the same interview; merged into
  one section, keeping the distinguishing rule (with-docs = stateful + ADRs, me = stateless).
- **conversation-memory ↔ agent-memory-systems ↔ memory-systems** — heavy overlap on
  tiered/semantic/episodic/procedural memory, importance scoring, consolidation, decay, and
  user isolation; kept the single best explanation of each and merged unique sharp edges
  (embedding-model mismatch, token budgeting, GDPR) into memory-systems.md.
- **context-window-management ↔ agent-memory-systems token-budget section** — both describe
  token budgeting; kept in context-optimization.md (primary home) and summarized the
  retrieval-side budget in memory-systems.md.
- **context-kit ↔ faf-wizard ↔ codex-profiles** — all are "give the agent portable context"
  tools; kept distinct (personal artifacts / project.faf / CODEX_HOME) but merged the shared
  safety rules (inspect before install, no secrets in context).
- **Dropped as out-of-scope fluff or tool-specific**: `workorai` (job marketplace, unrelated to
  productivity-memory), `daily-gift` (creative gift pipeline, marketing content), `quit-sponsor`
  and `satori` (personal-development health/coaching — adjacent but not memory/productivity;
  not merged, only noted). `interview-coach` reduced to a one-line route (large dedicated
  coaching system). `ask-matt` used only as router logic. `anywrite`/`telegram` kept as tool
  summaries since they are genuinely reusable productivity automation.
- **faf-wizard marketing copy** (performance claims, success stories, Discord links) dropped;
  kept the workflow, format, and migration commands.

## Scripts carried

- **None carried.** No `scripts/` subdirectories exist in any of the 44 source skills.
  `telegram-bot-messaging` references a `scripts/telegram.sh`, but the script itself is NOT
  present in the source library (only SKILL.md + README), so it was not fabricated or copied —
  the reference documents the commands/config and points at the upstream repo.
- **Templates carried** (not scripts, but directly reusable): the wiki-builder scaffold
  (`wiki.config.md`, `sources.md`, `maintenance-log.md`, `index.md`) copied verbatim to
  `references/wiki-templates/`. The `.geminiignore` baseline block is embedded in
  `context-optimization.md`.

## Gaps / doubts

- **Rube MCP services not deep-read beyond headings** — the per-service skill bodies were
  skimmed via headings; specific argument shapes live in the tools' live schemas (which the
  reference itself instructs to search first), so loss is acceptable.
- **`interview-coach`'s 23-command system** was only skimmed; if the user wants full job-search
  coaching, the source skill (`dbhat93/job-search-os`) should be consulted directly.
- **`quit-sponsor` / `satori`** (personal-development) were not merged into this domain — they
  fit a health/coaching domain better; noted here so they aren't lost.
- **`daily-gift`** creative pipeline and **`workorai`** marketplace flow were judged out of scope
  for productivity-memory and dropped.
- Reference files `ooxml-parsing.md`, `design-profiles.md`, `reference-deck-analysis*.md`,
  `audit-checklist.md`, `visual-asset-adapters.md` (pptx-deck-creation) exist upstream and are
  summarized into office-productivity.md rather than copied wholesale.
