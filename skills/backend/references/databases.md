# Databases: Access, Connection, Performance, Serverless Postgres

Most backend performance problems are database problems. The top three by
impact: N+1 queries, unbounded querysets, and missing indexes.

## N+1 queries (the #1 bug)

A list of 100 rows where each iteration triggers its own query = 101 queries;
10,000 rows = timeouts. Fix by prefetching/batching.

- ORM eager loading: `select_related` (FK joins) / `prefetch_related`
  (reverse relations, many-to-many) in Django; `Include/ThenInclude` in EF Core;
  Prisma nested `include`; SQLAlchemy `selectinload`.
- **Prefetch where the data is accessed**: in views AND in serializers —
  `SerializerMethodField` that runs `obj.orders.count()` per object is an N+1.
  Annotate instead (`User.objects.annotate(order_count=Count('orders'))`).
- Model properties that query are dangerous inside loops — use `Prefetch` with
  a custom queryset or annotate.
- GraphQL: use DataLoader (see `graphql.md`).
- Validate: trace view → queryset → template/serializer loop; confirm the field
  is accessed inside a loop and the table is large (1000+ rows).

## Unbounded queries

- Always paginate list endpoints (see `api-design.md`).
- For batch processing over large tables, stream instead of loading all:
  Django `queryset.iterator()`; cursors; paged chunks.
- Add indexes on columns used in filters/joins/order-by. Missing indexes cause
  full-table scans on large tables.

## Connection management

- **Pool connections** (pgbouncer, PgBond, Django `django-db-pool`, EF Core
  pooling). Size pools conservatively; too large exhausts the DB.
- Close connections properly; reuse a single client in long-running workers.
- Use async drivers in async apps (asyncpg, aiomysql, Drizzle serverless
  driver) and connection per request-scoped session pattern.

## Transactions

- Wrap critical multi-step operations in a transaction; use `SELECT ... FOR
  UPDATE` where contention is expected.
- Distributed transactions across services → sagas (see `api-integration.md`),
  not global 2PC.

## Serverless Postgres (Neon)

Neon is a serverless Postgres that separates compute and storage: autoscaling,
branching, instant restore, scale-to-zero, read replicas. Fully compatible with
Postgres — works with any language/ORM that supports Postgres.

### Setup flow

1. Inspect existing setup: `.env`/`DATABASE_URL`, ORM (Prisma/Drizzle/TypeORM),
   existing Neon config.
2. Provision a project (Neon CLI or MCP server):
   `npx -y neon@latest init --agent <agent-name>`.
3. Get the connection string; store in `.env` as `DATABASE_URL` (read the file
   before writing to avoid clobbering).
4. Pick the driver for your runtime (see Neon "choose a connection" guide):
   serverless driver for edge/workers, pooled connection string for many
   concurrent clients.
5. Set up schema via migrations, not sync.

### Neon-specific features

- **Branching**: create dev branches for PRs; instant restore from any point.
- **Scale-to-zero / autoscaling**: compute pauses when idle, resumes on demand;
  set warm-up rules for latency-sensitive workloads.
- **Connection pooling**: use the pooled endpoint (`-pooler`) to avoid exhausting
  connections under concurrency.
- **Neon Auth**: adds sign-in with no custom auth server; then query the DB with
  the user's session.
- **Neon Functions**: long-running serverless Node HTTP functions on your
  branch with `DATABASE_URL` injected; supports WebSockets, SSE, MCP servers.
  Design for fan-out across isolates and client reconnection.
- Docs are the source of truth; fetch current docs (append `.md` to a Neon doc
  URL, or use `https://neon.com/docs/llms.txt` as the index). Don't guess URLs.

### Security reminders

Use environment variables for credentials, never commit connection strings, and
use least-privilege database roles.

## Raw SQL rules

- Prefer the ORM; use raw SQL only when needed for performance.
- Always parameterize — never string-concatenate user input.
- Keep migrations under version control; test them on a staging copy.

## Sources

- `neon-postgres`, `neon-functions`, `django-perf-review`,
  `backend-dev-guidelines` (repository rules), `dotnet-backend` (EF Core),
  `django-pro`, `nestjs-expert` (TypeORM), `api-sdk-generator` (models).