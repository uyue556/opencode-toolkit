# Migrations

Synthesized from: `database-migration` (+ playbook refs), `database-migrations-sql-migrations`,
`database-migrations-migration-observability`, `drizzle-orm-expert`, `drizzle-migration-conflict`,
`prisma-expert`, `neon-postgres-branches`.

## ToC

1. [Safe migration workflow](#safe-migration-workflow)
2. [Zero-downtime patterns](#zero-downtime-patterns)
3. [Rollback strategies](#rollback-strategies)
4. [ORM migration notes](#orm-migration-notes)
5. [Drizzle migration conflict repair](#drizzle-migration-conflict-repair)
6. [Observability & CDC](#observability--cdc)
7. [Neon branching for migration testing](#neon-branching-for-migration-testing)

## Safe migration workflow

- Never make breaking changes in one step. Expand → migrate → contract:
  - **Add column**: add nullable → backfill → add `NOT NULL`/default.
  - **Remove column**: stop using → deploy → drop.
  - **Add index**: `CREATE INDEX CONCURRENTLY` (non-blocking, cannot run inside a transaction).
  - **Rename/retarget**: add new → migrate data → deploy code → drop old.
- Every migration has a tested `down()`; test on staging first; run in transactions when supported;
  back up before migrating; keep changes small and incremental; migrations should be idempotent/re-runnable.
- Commit as a unit: schema change + data backfill + code change reviewed together.

## Zero-downtime patterns

Blue-green (backward-compatible) phases: (1) add new column (both old+new code work);
(2) deploy code writing both columns; (3) backfill; (4) deploy code reading new column;
(5) drop old column. Large-table operations: chunked/batched updates, do not lock the whole table.

Cross-database/engine switches: dialect-aware DDL (e.g. MySQL `JSON` vs Postgres `JSONB`), data
transformation scripts with `down()` reconstruction, and parallel-run/strangler migration before cutover.

## Rollback strategies

- Transaction-based: wrap DDL+DML in one transaction; rollback on failure.
- Checkpoint-based: `CREATE TABLE users_backup AS SELECT * FROM users` → migrate → verify → drop backup;
  restore from backup on failure.
- Prisma: `prisma migrate resolve --applied|--rolled-back <name>` to reconcile a failed prod migration;
  never `migrate dev` in production (`migrate deploy` only).

## ORM migration notes

- **Sequelize**: `queryInterface` with up/down; `npx sequelize-cli db:migrate[ :undo]`.
- **TypeORM**: `MigrationInterface` with up/down; `npm run typeorm migration:run[ :revert]`.
- **Prisma**: `prisma migrate dev --name x` (dev), `prisma migrate deploy` (prod); validate with
  `prisma validate`, check drift with `prisma migrate diff`.
- **Drizzle Kit**: `drizzle-kit generate` → SQL migration files; `drizzle-kit push` (dev only, skips
  migration files); `drizzle-kit migrate` (prod). Review generated SQL before applying.

## Drizzle migration conflict repair

Common when multiple devs/agents generate migrations concurrently (snapshots, journals, and migration
SQL diverge). Repair principles:

- Diagnose the conflict mode first (missing snapshot vs journal drift vs differing SQL) before touching files.
- Prefer the safest operation that restores the intended schema state; keep migrations reproducible.
- Never hand-edit snapshots without understanding the journal chain; regenerate only the affected leaf.
- Verify by diffing schema against the database and re-running the migration flow in a fresh environment.
- Add CI guards to prevent concurrent generation (lock/ownership rules, review gates).

## Observability & CDC

- Make migrations observable: log each step, record schema version, alert on failures, wire into CI/CD.
- Change Data Capture (e.g. Debezium) streams DB changes for downstream sync — monitor lag, schema
  evolution, and restart/replay safety.
- Instrument: metrics (execution time, records changed), Grafana dashboards, alerting on drift/failure.

## Neon branching for migration testing

- **Normal branch**: copy of data — preferred for real-data migration testing (schema + data).
- **Schema-only branch** (Beta): for sensitive data — structure without PII payloads.
- Workflow: create branch → run migrations → validate → promote/reset. Reset from parent when a clean
  slate is needed (note hard constraints/blockers). Use branches in CI/CD per PR; treat branch config as
  code (`neon.ts`/CLI/MCP). Branches give safe, throwaway environments for destructive testing.
