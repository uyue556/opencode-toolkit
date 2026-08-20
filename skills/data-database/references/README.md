# Data & Database — Reference Library

Table of contents for the consolidated `data-database` skill. Read `SKILL.md` first for routing.

| Reference | Covers |
|---|---|
| `sql-postgres.md` | SQL authoring & tuning, EXPLAIN, index design, warehouse credit audit (sql-sentinel 20 rules), psql client, read-only Postgres access, warehouse analysis workflow |
| `database-design.md` | DB & ORM selection, schema design, indexing, multi-tenant RLS, database architect workflow, cost optimization |
| `migrations.md` | ORM migrations (Sequelize/TypeORM/Prisma/Drizzle), zero-downtime, rollback, migration conflict repair, observability/CDC, Neon branching |
| `nosql-vector.md` | NoSQL mental models (Cassandra/DynamoDB), single-table design, Weaviate ops, vector index & similarity search tuning, pgvector |
| `data-engineering.md` | Pipelines (batch/streaming), Spark optimization, dbt, Snowflake, warehouse/lakehouse, data quality frameworks, orchestration, cost patterns |
| `data-science.md` | Polars, pandas, visualization (plotly), data-scientist workflow, experiments, data storytelling, quality frameworks |
| `data-ai.md` | RAG pipelines, embedding selection, chunking, vector DB engineering, hybrid search, LLM app patterns, recsys |
| `analytics.md` | Tracking plans & event taxonomy, product analytics (Segment/PostHog/Mixpanel/Amplitude), cohort/retention, Monte Carlo monitoring |
| `data-acquisition.md` | Web scraping strategies, Firecrawl, X/Twitter scraper, financial APIs (Alpha Vantage), search APIs |
| `spreadsheets.md` | xlsx (openpyxl/pandas, formulas, recalc), Google Sheets (standalone OAuth + Rube MCP) |
| `documents.md` | PDF processing (pypdf/pdfplumber/reportlab, OCR, forms), DOCX (pandoc, OOXML, redlining, docx-js) |

Most references are organized as: decision tree / core workflow / patterns / gotchas.
