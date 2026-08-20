# Database Design & Architecture

Synthesized from: `database-architect`, `database-design` (+ 6 sub-guides), `saas-multi-tenant`,
`sql-pro`, `database-optimizer`, `database-admin`, `database-cloud-optimization-cost-optimize`,
`nosql-expert` (mental-model overlap), `using-neon`.

## ToC

1. [Technology selection](#technology-selection)
2. [Schema design](#schema-design)
3. [Multi-tenancy & RLS](#multi-tenancy--rls)
4. [Performance-first architecture](#performance-first-architecture)
5. [Cost optimization](#cost-optimization)

## Technology selection

Choose from context, never by default. Decision tree:

- Full relational features, self-hosted → **PostgreSQL**; serverless PG → **Neon/Supabase**.
- Edge / ultra-low latency → **Turso** (edge SQLite); simple/embedded/local → **SQLite**.
- AI / vector search → **PostgreSQL + pgvector** (or dedicated vector DBs — see `nosql-vector.md`).
- Global distribution → PlanetScale, CockroachDB, TiDB, Turso.
- Massive write scale + wide-column reads → Cassandra/ScyllaDB/DynamoDB (query-first modeling).
- Analytics/OLAP → columnar warehouse (Snowflake, BigQuery, Redshift, ClickHouse).

Consider per workload: consistency vs availability (CAP), query patterns, write/read ratio,
operational complexity, cost, compliance, and deployment target. Prefer the simplest store that meets
the requirements; add specialty stores (search, timeseries, vector, graph) only when there is a real
need (polyglot persistence, not polyglot because you can).

ORM selection: **Drizzle** (edge/TS, small), **Prisma** (best DX, schema-first, migrations + Studio),
**Kysely** (type-safe SQL builder), **SQLAlchemy 2.0** (Python, async). Raw SQL for complex control.

## Schema design

- Normalize to ~3NF first; denormalize only for measured, high-ROI reads.
- Primary keys: `BIGINT IDENTITY` for simple single-DB apps; UUID/ULID for distributed systems or
  security (avoid sequential IDs on tenant-scoped or publicly exposed resources); natural keys rarely.
- Every table: `created_at`, `updated_at` (`TIMESTAMPTZ`), `deleted_at` if soft delete.
- Relationships: 1:1 (FK on child), 1:N (FK on child), M:N (junction table). Decide `ON DELETE`
  (`CASCADE`/`SET NULL`/`RESTRICT`/`SET DEFAULT`) deliberately.
- Anti-patterns: defaulting to Postgres for trivial apps; skipping indexes; `SELECT *` in prod; storing
  JSON when structured columns are better; ignoring N+1.
- Index strategy: WHERE/JOIN/ORDER BY/FK columns + unique constraints; don't over-index write-heavy or
  low-cardinality columns. Composite: equality columns first, range last, most selective first.

## Multi-tenancy & RLS

Default for most SaaS (<~1000 tenants): **shared schema + `tenant_id`** on every tenant-scoped table.

- `tenant_id` NOT NULL (UUID preferred), first column in every composite index.
- Enable `ALTER TABLE ... ENABLE ROW LEVEL SECURITY; FORCE ROW LEVEL SECURITY;` and a policy comparing
  `tenant_id` to `current_setting('app.current_tenant_id')` (USING for SELECT, WITH CHECK for INSERT).
- Middleware sets `SELECT set_config('app.current_tenant_id', $1, true)` inside a transaction per
  request; always `RESET` in cleanup (stale tenant context leaks between pooled connections).
- ORM-level scoping is a complement, not a replacement: inject `tenantId` into every query via Prisma
  middleware or a Drizzle base builder. RLS is the safety net.
- Cross-tenant admin routes bypass RLS via a dedicated role with a **separate** admin auth flow.
- Migrations must run on a `bypassrls`/superuser connection.
- Never auto-increment IDs for tenant resources; soft-delete tenants + batch cleanup; per-tenant rate
  limiting and quotas; tenant-aware background jobs (payload carries `tenant_id`); test with ≥3 tenants.
- Schema-per-tenant: N migration runs + N pools (PgBouncer in transaction mode); database-per-tenant
  only for regulatory data-residency requirements.

## Performance-first architecture

- Measure first: slow-query logs, `EXPLAIN ANALYZE`, `pg_stat_statements`, APM. Tune only what's measured.
- Caching tiers (app → Redis/Memcached → buffer pool) with explicit invalidation (TTL, event-driven,
  stampede protection); materialized views for expensive aggregations.
- Scaling ladder: right-size + connection pooling → read replicas → partitioning → sharding.
  Read/write splitting, workload isolation. Design for failure: backups (RPO/RTO), HA, multi-region.
- Transactions: choose isolation levels deliberately; prefer short transactions; idempotent retries;
  sagas for distributed flows; optimistic locking to avoid hot-row contention.
- Monitoring: latency, throughput, connections, cache hit, bloat; alert on thresholds + anomalies.

## Cost optimization

- Sizing: start small, scale up; autoscale/`AUTO_SUSPEND`, `AUTO_RESUME`; separate warehouses per workload.
- Storage: compression, tiering hot→warm→cold, lifecycle policies, prune old partitions.
- Compute: spot instances for batch, on-demand for streaming, serverless for ad-hoc; right-size
  reserved capacity for stable baselines.
- Query-level: kill expensive/credit-burning queries (see `sql-postgres.md` audit rules); cache hot
  results; review `pg_stat_statements` for top-cost statements.
- Reserved instances for steady loads; review idle resources and unused indexes regularly.
