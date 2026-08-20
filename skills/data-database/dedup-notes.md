# Deduplication Notes — data-database

Consolidated 74 source SKILL.md files from 9 libraries into one skill + 11 references.

## Source libraries scanned

| Library | # SKILL.md | Notes |
|---|---|---|
| data | 22 | SQL, pipelines, warehouse, scraping, analytics |
| data-ai | 14 | RAG, embeddings, vector, LLM patterns |
| data-science | 8 | analysis, polars/plotly, storytelling, quality |
| data-engineering | 1 | Snowflake |
| database | 16 | Postgres, ORMs, migrations, NoSQL, psql, sqlmap |
| databases | 2 | Weaviate, Drizzle conflict |
| database-processing | 5 | architect, design, optimizer, admin, Neon |
| spreadsheet-processing | 3 | xlsx, Google Sheets (x2) |
| document-processing | 3 | PDF, DOCX, co-authoring |
| **Total** | **74** | |

## Notable duplicates merged

- **Postgres best practices duplicated 3×**: `postgres-best-practices` and `supabase-postgres-best-practices`
  are the same Supabase ruleset; `postgresql` (schema focus) overlaps both. Kept the 8-category
  prioritized ruleset once (in `sql-postgres.md`) and merged Supabase rule references into it.
- **Vector stack duplicated 5×**: `embedding-strategies`, `vector-database-engineer`,
  `similarity-search-patterns`, `vector-index-tuning`, and parts of `rag-engineer` overlap heavily.
  Merged into `data-ai.md` (embeddings/chunking/RAG) + `nosql-vector.md` (vector DB ops/index tuning).
- **SQL tuning duplicated 3×**: `sql-pro`, `sql-optimization-patterns`, and `sql-sentinel` overlap on
  index/EXPLAIN guidance. Kept one EXPLAIN-driven workflow; `sql-sentinel`'s 20-rule table preserved
  as the unique cost-audit asset.
- **Migrations duplicated 4×**: `database-migration`, `database-migrations-sql-migrations`,
  `prisma-expert` (migration chapter), `drizzle-orm-expert` (migration chapter). Merged into one
  `migrations.md` with per-ORM command notes.
- **Database "persona" skills are near-identical boilerplate**: `database-architect`,
  `database-admin`, `database-optimizer`, `database-design`, `data-engineer`, `sql-pro`,
  `data-scientist` all follow the same "capabilities/response approach" template. Condensed to one
  workflow each inside the relevant reference; marketing-style capability lists dropped.
- **Analytics automations share the same Rube-MCP pattern**: `segment-automation`,
  `posthog-automation`, `mixpanel-automation`, `amplitude-automation`, `googlesheets-automation` are
  the same composio wrapper with different tools. Collapsed into one "platform automation" section
  (`analytics.md`/`spreadsheets.md`) instead of 5 near-identical files.
- **Google Sheets duplicated 2×**: `google-sheets-automation` (standalone OAuth) vs
  `googlesheets-automation` (Rube MCP) — kept both as two short subsections since the access paths differ.
- **RAG/LLM guidance duplicated across `rag-engineer`, `llm-app-patterns`, `ai-engineering-toolkit`**:
  retrieval/eval discipline unified in `data-ai.md`.
- **Scraping duplicated**: `web-scraper`, `firecrawl-scraper`, `exa-search`, `tavily-web`,
  `x-twitter-scraper` all cover "fetch data" — unified into the strategy-selection workflow in
  `data-acquisition.md`.

## Notable skills dropped (or heavily condensed) and why

- **`clarity-gate`** (713 lines): a specialized HITL/data-verification spec for a specific agentskills
  ecosystem; only the "evaluate claims/metrics separately" discipline was carried into `data-ai.md`.
- **`data-structure-protocol`**: codebase-graph navigation protocol, only tangentially a data skill;
  one paragraph retained in `data-science.md`.
- **`monte-carlo-validation-notebook`** (694 lines): a very detailed YAML-notebook spec; distilled to
  the reusable "SQL validation query patterns for PRs" in `sql-postgres.md`.
- **`sqlmap-database-pentesting`**: offensive security; out of scope for a general data skill — only
  referenced implicitly (not carried; do not reproduce attack tooling here).
- **`seek-and-analyze-video` / `notebooklm` / `local-llm-expert`**: niche tools (video memory model,
  NotebookLM wrapper, local LLM VRAM) — not core to data/database; local-LLM got a one-liner in
  `data-ai.md`.
- **`doc-coauthoring`**: general writing workflow, not data processing; condensed to a short workflow
  in `documents.md`.
- **`arrowspace`**: proprietary spectral-search library; pattern noted in `data-acquisition.md`.
- **`optim-agent`**: parameter optimization for ML systems — adjacent to data science but distinct;
  dropped (covered by data-science workflow generally).
- **`data-engineering-data-driven-feature`** and `data-engineering-data-pipeline` (data-science lib)
  overlap `data-engineer` + `data-quality-frameworks`; merged into `data-engineering.md`/`data-science.md`.
- **`drizzle-migration-conflict`**: kept as a focused "repair principles" section in `migrations.md`.
- **`postgres-readonly-queries`**: kept the defense-in-depth approach + config template
  (`scripts/connections.example.json` carried over).
- **`neon-postgres-branches` / `neon-postgres-egress-optimizer`**: egress optimizer folded into
  `sql-postgres.md` monitoring/`database-design.md` cost; branches → `migrations.md`.
- **`database-migrations-migration-observability`**: observability/CDC points merged into
  `migrations.md`.
- **`monte-carlo-monitor-creation`**: monitor-as-code workflow merged into `analytics.md`.
- **`alpha-vantage`**: API usage kept (financial data acquisition) in `data-acquisition.md`.

## Scripts carried over

- `scripts/connections.example.json` — read-only Postgres connection config template from
  `postgres-readonly-queries` (the referenced `query.py`/`recalc.py`/sheets/weaviate scripts are NOT
  present in the installed source libraries — they live in upstream repos only).

## Gaps & doubts

- Several skills reference external scripts (`recalc.py`, `query.py`, Weaviate `scripts/*`, sheets
  `auth.py`) that are not shipped in the library directories; users must obtain them from the upstream
  repos. Verified by `ls` — no `scripts/` dirs existed in the source trees.
- `postgresql-cli` ships extensive `references/` (meta-commands etc.); I captured the essential tables
  but not every psql command — deep links to official psql docs are preserved for the rest.
- `segment-cdp` (854 lines) and `analytics-tracking` (410) were deep-read in key sections, not fully;
  the full tracking-plan YAML/TypeScript detail is condensed, not reproduced verbatim.
- `supabase-postgres-best-practices` ships ~30 rule files; only the category priorities + key rules
  were merged (rule files remain in the upstream repo).
- The Rube-MCP automation skills depend on external MCP servers; exact invocation details were not
  reproduced — refer to each platform's docs.
