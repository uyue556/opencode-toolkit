# SQL & PostgreSQL

Synthesized from: `sql-pro`, `sql-sentinel`, `postgresql`, `postgresql-cli`, `sql-optimization-patterns`
(+ playbook), `supabase-postgres-best-practices` (+ rules), `postgres-readonly-queries`, `warehouse`,
`monte-carlo-validation-notebook`.

## ToC

1. [Writing high-performance SQL](#writing-high-performance-sql)
2. [EXPLAIN-driven optimization](#explain-driven-optimization)
3. [Index design](#index-design)
4. [Warehouse credit audit — 20 anti-patterns](#warehouse-credit-audit)
5. [PostgreSQL schema gotchas](#postgresql-schema-gotchas)
6. [psql client quick reference](#psql-client-quick-reference)
7. [Read-only Postgres access](#read-only-postgres-access)
8. [Warehouse analysis workflow](#warehouse-analysis-workflow)

## Writing high-performance SQL

Core rules (apply everywhere; these also drive the warehouse cost audit below):

- Never `SELECT *`; list columns explicitly. Columnar warehouses scan only referenced columns.
- Keep predicates **sargable**: no `LOWER(col) = ...`, `col LIKE '%x'`, or `col + 1 = ...` — create an
  expression/functional index instead or compare a range.
- `NOT IN (SELECT ...)` has NULL semantics traps — use `NOT EXISTS` or an anti-join.
- Prefer `UNION ALL` unless you genuinely need dedup.
- Filter before joining; join filtered subsets rather than cartesian-then-filter. A comma-join without a
  `WHERE` on the join key is a Cartesian product.
- `ORDER BY` only with `LIMIT`, otherwise the full result is sorted.
- Batch: multi-row `INSERT`, `COPY`, or temp-table-based bulk `UPDATE ... FROM` instead of row-by-row loops.
- Use CTEs for readability; beware correlated subqueries in `SELECT` — rewrite with JOIN + aggregate or a
  window function.
- `COUNT(DISTINCT)` at scale → use `approx_count_distinct` / HLL where the engine supports it.

## EXPLAIN-driven optimization

Optimize only what you measure. For PostgreSQL:

```sql
EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT ...;
```

Watch for: `Seq Scan` (full table scan — usually the first thing to fix), `Index Only Scan` (best),
`Nested Loop` vs `Hash Join` vs `Merge Join`, estimated vs actual rows (staleness → run `ANALYZE`),
and cost. Fix order: missing index → wrong column list → join shape → pagination → caching.

Useful maintenance: `ANALYZE` after big loads; `VACUUM (ANALYZE)` on Postgres; keep statistics fresh.

### Pagination

- Bad: `OFFSET` on large tables (deep offsets rescans).
- Good: keyset/cursor pagination — `WHERE (created_at, id) < (last_ts, last_id) ORDER BY created_at DESC, id DESC LIMIT n`
  with a matching `(created_at DESC, id DESC)` index.

### Monitoring queries (Postgres)

```sql
-- Slow queries
SELECT query, calls, total_time, mean_time FROM pg_stat_statements ORDER BY mean_time DESC LIMIT 10;
-- Tables scanned without index
SELECT schemaname, tablename, seq_scan, seq_tup_read FROM pg_stat_user_tables WHERE seq_scan > 0 ORDER BY seq_tup_read DESC;
-- Unused indexes (bloat + slow writes)
SELECT schemaname, tablename, indexname, idx_scan FROM pg_stat_user_indexes WHERE idx_scan = 0 ORDER BY pg_relation_size(indexrelid) DESC;
```

Also monitor deadlocks, long transactions, and `pg_stat_activity` state. Supabase ruleset priorities:
query performance → connection management → security/RLS → schema → locking → data access → monitoring → advanced.

### N+1 resolution

Batch related lookups: one `JOIN`/`IN (...)` query, eager loading in ORMs, or a DataLoader. Never loop
a query per parent row.

## Index design

- B-tree default for equality + range; GIN for JSONB/arrays/full-text; GiST for ranges/geometry;
  BRIN for huge naturally-ordered time-series; HNSW/IVFFlat for pgvector.
- Composite index: put equality columns first, range columns last, most-selective first.
- Covering index: `INCLUDE (col, ...)` enables index-only scans.
- Partial index: `WHERE status = 'active'` for hot subsets.
- Expression index: `ON users (LOWER(email))` — the WHERE must match the expression exactly.
- Postgres does **not** auto-index FK columns — add them (`REFERENCES` + `CREATE INDEX`).
- Too many indexes slow writes; keep only what query patterns need.

## Warehouse credit audit

Static-analysis anti-patterns that dominate warehouse bills (BigQuery/Snowflake/Redshift/Postgres). Severity:
critical = Cartesian joins, mass `DELETE`/`UPDATE` without `WHERE`, no `WHERE` at all; high = `SELECT *`,
leading-wildcard `LIKE`, function-on-column, `NOT IN (SELECT ...)`, fact-table without partition filter;
medium = `SELECT DISTINCT`, `ORDER BY` without `LIMIT`, implicit casts, `COUNT(DISTINCT)` at scale,
scalar subqueries in SELECT, 5+ joins (broadcast/spill), window `OVER ()` without `PARTITION`,
`UNION` vs `UNION ALL`; low = string concat in SELECT, `LIMIT` without `ORDER BY`, `SELECT *` in EXISTS/IN.

Fix each finding with a concrete rewrite; quantify savings. Note: static analysis only — pair with
`EXPLAIN`, row counts, and billing data for real impact. Run an analyzer over `.sql` files before
promoting a dbt model or dashboard query to production.

## PostgreSQL schema gotchas

- Unquoted identifiers are lowercased; use `snake_case`, avoid quoted mixed-case names.
- `UNIQUE` allows multiple NULLs unless `UNIQUE (...) NULLS NOT DISTINCT` (PG15+).
- Identity columns have gaps (rollbacks/crashes) — don't "fix" them.
- No silent truncation: `NUMERIC(2,0)` insertion of 999 errors.
- MVCC leaves dead tuples — avoid hot wide-row churn; `fillfactor=90` helps HOT updates.
- Type choices: `TIMESTAMPTZ` (never `timestamp`/`timetz`), `NUMERIC` for money (never `money`),
  `TEXT` over `VARCHAR(n)`/`CHAR(n)`, `BIGINT GENERATED ALWAYS AS IDENTITY` over `SERIAL`; `UUID`
  only for global uniqueness/opacity (prefer `uuidv7()`); enums only for small stable sets.
- JSONB over JSON; GIN index for containment (`@>`); extract hot scalar fields into indexed columns.
- Partitions: declarative partitioning (RANGE/LIST/HASH) or TimescaleDB hypertables — not inheritance.
  Global UNIQUE constraints are unsupported; include partition key in PK/UNIQUE.
- Safe evolution: `CREATE INDEX CONCURRENTLY` (not in transaction); adding `NOT NULL` with volatile
  default rewrites the table; drop constraints before columns; transactional DDL for testing.

## psql client quick reference

- Connect: `psql -h host -p port -U user -d db`; or `~/.pgpass` (`chmod 600`), or `PG*` env vars.
  Precedence: flags > env > `pg_service.conf` > defaults. Avoid `PGPASSWORD` in prod (visible in `ps aux`).
- Inspect: `\d name` (table detail), `\dt`, `\dv`, `\di`, `\dn`, `\du`, `\l`, `\dx` (extensions),
  `\d+`, `\dtS` modifiers; patterns `*`/`?`/schema.`table`.
- Execute: `;`, `\g file`, `\gx` (expanded), `\crosstabview`, `\watch [interval=n] [count=n]`,
  `\gexec` (runs generated SQL — inspect first!), pipeline mode `\startpipeline ... \endpipeline` (PG14+).
- Import/export: `\copy table FROM/TO 'file.csv' WITH (FORMAT csv, HEADER)` (client-side, no superuser);
  `COPY ... TO STDOUT \g file` for multi-line/variable queries. `program` option = command injection risk.
- Scripting: `\i file`, `\if/\else/\endif`, `\set var`, `:'var'` (quoted) vs `:var` (unquoted — unsafe),
  `\bind` for parameterized values, `\timing`, `\errverbose`, `ON_ERROR_STOP`.
- Safety: preview destructive ops with `BEGIN; DELETE ... RETURNING *; ROLLBACK;`; check `\d` "Referenced
  by" before `DROP TABLE`; confirm the right DB with `\conninfo`. Exit codes: 0 ok, 1 fatal, 2 conn, 3 ON_ERROR_STOP.

## Read-only Postgres access

Defense-in-depth for exploration: use a database role with read-only privileges as primary control, plus
a client that: only allows `SELECT`/`SHOW`/`EXPLAIN`/`WITH`, rejects multi-statement input, enforces a
30s timeout, caps rows (e.g. 10k) and column width, supports `sslmode`, and never leaks credentials in
errors. Manage multiple connections via a config file (see `scripts/connections.example.json`, keep
`chmod 600`). Workflow: list connections → match user intent to DB description → inspect `--tables` /
`--schema` → query with `LIMIT`.

## Warehouse analysis workflow

For governed, read-only warehouse analysis: (1) define the analytical contract (question, scope, output);
(2) find governed/provenance-tracked sources; (3) draft a read-only query with explicit filters;
(4) review scope/privacy before execution; (5) execute only with authorization; (6) validate the result
(row counts, edge cases, against a known value); (7) report with provenance and caveats. Validate PR
changes with before/after comparison queries (row counts, NULL rates, distribution of changed fields,
time-axis continuity) rather than trusting the diff blindly.

### SQL validation query patterns (PR-time)

For new models: total row count, sample preview, core segmentation counts, uniqueness, NULL-rate per
column, time-axis continuity. For modified models, add before/after comparisons on changed fields and
row counts. Turn these into a reusable validation notebook/YAML so every change is checked identically.
