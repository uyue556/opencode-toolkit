---
name: data-database
description: >-
  Consolidated skill for all data & database work: SQL and PostgreSQL (schema design, psql, indexes, query tuning,
  warehouse credit audit), database architecture & tech selection (Relational/NoSQL/Vector/serverless), ORMs and
  safe migrations, data engineering (Spark, dbt, Snowflake, ETL/ELT pipelines, data quality), data science &
  analytics (polars, pandas, plots, storytelling), data AI (RAG, embeddings, vector search), product analytics
  (tracking plans, Segment/PostHog/Mixpanel, Monte Carlo), data acquisition (scraping, financial APIs), and
  spreadsheet/document data processing (xlsx, Google Sheets, PDF, DOCX). Use whenever the user mentions: SQL,
  PostgreSQL, psql, 数据库, 数据, 数据仓库, data warehouse, schema 设计, index 索引, migration 迁移, ETL/ELT,
  data pipeline, 数据管道, Spark, dbt, Snowflake, BigQuery, data quality 数据质量, polars, pandas, RAG, 向量检索,
  vector search, embedding, 向量数据库, NoSQL, DynamoDB, Cassandra, analytics 数据分析, cohort 留存, tracking plan,
  埋点, spreadsheet 表格, xlsx, Google Sheets, PDF parsing, pdf, docx, scraping, 爬虫, or any data pipeline, database,
  or analytics task. Route task-specific detail to references/ as shown in the selection table.
---

# Data & Database

One consolidated skill for the data/database domain. Pick the reference file for your task, apply the
recurring workflows below, and read the relevant reference for detail instead of improvising.

## When to use this skill

- Designing, migrating, or tuning databases (SQL, NoSQL, vector, serverless).
- Writing or reviewing SQL, warehouse queries, schema, or ORM models.
- Building data pipelines, transformations, or dashboards.
- Analyzing data, building analytics instrumentation, or doing data science / ML feature work.
- Working with spreadsheets, PDFs, DOCX, or scraping data into databases.

Do NOT use for: pure application/UI code, infra that is unrelated to data, or when no data access exists.

## Core workflow (apply for most tasks)

1. Clarify the data domain, access patterns, scale targets, and consistency needs before choosing tech.
2. Select the database/storage/processing approach — context decides, never default blindly.
3. Design schema/model/query-first; validate with `EXPLAIN (ANALYZE)` before optimizing.
4. Add data quality checks, monitoring, and rollback plans early.
5. Document assumptions, lineage, and migration/rollback steps.

## Selection routing

| If the task is about… | Read this reference |
|---|---|
| Writing/tuning SQL, EXPLAIN, indexes, warehouse credit anti-patterns, psql, read-only PG access | `references/sql-postgres.md` |
| Schema design, DB & ORM selection, indexing strategy, multi-tenant RLS, amazon/aurora/cost | `references/database-design.md` |
| Schema & data migrations, zero-downtime, ORM migrations, migration conflicts | `references/migrations.md` |
| NoSQL (Cassandra/DynamoDB), vector DBs (Weaviate, pgvector), similarity search tuning | `references/nosql-vector.md` |
| ETL/ELT pipelines, Spark, dbt, Snowflake, warehouse/lakehouse, data quality, streaming | `references/data-engineering.md` |
| Data science: polars, pandas, plots, experiments, storytelling, feature dev | `references/data-science.md` |
| RAG, embeddings, vector retrieval, LLM app patterns | `references/data-ai.md` |
| Product analytics: tracking plans, Segment/PostHog, cohort analysis, monitoring | `references/analytics.md` |
| Scraping, crawling, API data sources (financial, X, search) | `references/data-acquisition.md` |
| Excel/xlsx or Google Sheets operations | `references/spreadsheets.md` |
| PDF or DOCX processing | `references/documents.md` |

## Recurring best practices

- SQL: avoid `SELECT *`; keep predicates sargable; filter before join; `LIMIT` after `ORDER BY`; prefer
  `UNION ALL` over `UNION`; never commit mass `DELETE`/`UPDATE` without a `WHERE` and a transaction.
- Indexes: index real query paths only; composite with equality columns first; cover FK columns
  (Postgres does not auto-index them); use function/partial/covering indexes deliberately.
- Data model: normalize to ~3NF first; denormalize only for proven read hotspots. Prefer `TIMESTAMPTZ`,
  `NUMERIC` for money, `TEXT` over `VARCHAR(n)`, `BIGINT IDENTITY` over `SERIAL`. UUID only when you need
  global uniqueness or opacity.
- Migrations: every `up()` needs a tested `down()`; expand→migrate→contract (add nullable column, backfill,
  add NOT NULL, deploy, drop old); use `CREATE INDEX CONCURRENTLY`; run in transactions where supported.
- Warehouse/BI: centralize transformations in a staging→intermediate→marts layer; test aggressively;
  track freshness; audit queries for credit-burning anti-patterns before production.
- Performance: measure with `EXPLAIN ANALYZE`/`pg_stat_statements`/`spark.ui` first; tune only what is
  measured; cache deliberately; right-size parallelism/partitions (128–256 MB per partition for Spark).
- Data engineering: enforce a data contract (sources, SLAs, schemas); validate before writing to sinks;
  give every pipeline observability and a dead-letter queue; protect PII with least-privilege access.
- Data AI/RAG: retrieval quality drives answer quality — evaluate retrieval (MRR/Recall@K/NDCG) separately
  from generation; prefer hybrid search + metadata pre-filtering + reranking; refresh embeddings on change.
- Analytics: track for decisions, not curiosity; events represent meaningful state changes; agree a
  naming taxonomy (Object + Action) and an identity strategy before instrumenting.
- Spreadsheets/Excel: write formulas, not hardcoded computed values; recalculate after editing and scan
  for `#REF!`/`#DIV/0!` errors; preserve existing template conventions over imposed formatting.

## Do

- Match tool to task: pandas for analysis, openpyxl for Excel formulas/formatting, polars for larger
  in-RAM data, Spark for distributed.
- Keep DB connections secure: use `~/.pgpass` over `PGPASSWORD`, `chmod 600` connection config files,
  parameterized queries (`\bind`) instead of string interpolation.
- Scope multi-tenant queries to `tenant_id` at both app and DB layer (RLS policy as the safety net).
- Build read-only query tooling with validation, timeouts, and row caps for exploration.
- Route deep, model-specific detail to the references listed above.

## Don't

- Don't slap indexes on every column — each index slows writes.
- Don't model a distributed NoSQL store like SQL; model queries first (partition key cardinality matters).
- Don't use one embedding model/strategy for everything; match content type and query pattern.
- Don't hardcode computed values into spreadsheets — keep formulas so the sheet stays updateable.
- Don't dump raw data in presentations — front-load the insight, then the data.
- Don't run destructive DDL/DML on production without a rollback plan and backup.

## Examples

- "Query is slow on Postgres" → read `sql-postgres.md`: `EXPLAIN (ANALYZE)`, check for Seq Scans,
  missing index, non-sargable predicate; apply index/rewrite pattern; verify with the plan.
- "Build a data pipeline" → read `data-engineering.md`: choose batch vs streaming, staging→marts,
  quality gates, incremental loading with watermark, monitoring + DLQ.
- "RAG search keeps returning irrelevant docs" → read `data-ai.md`: fix chunking, add metadata filter +
  hybrid search + reranking, then evaluate retrieval metrics separately.
- "Design schema for multi-tenant SaaS" → read `database-design.md` + `migrations.md`: shared-schema +
  RLS, `tenant_id` on every table, tenant-aware migrations, UUID keys.

## Common pitfalls

- Premature denormalization or premature vertical/horizontal scaling.
- Treating SQL optimization as guesswork instead of plan-driven (`EXPLAIN`).
- Skipping data-quality gates "just for now" — they become tomorrow's incidents.
- Sending everything to the LLM context — relevance-threshold retrieved chunks.
- Web/tracking data without identity strategy → cohort/retention analyses are unusable.

## Reference inventory

See `references/README.md` for the table of contents across all sub-topics.