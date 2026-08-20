# Event Sourcing, CQRS, Projections, Sagas

Sources: `event-sourcing-architect`, `event-store-design`, `cqrs-implementation` (+
`resources/implementation-playbook.md`), `projection-patterns` (+ playbook), `saga-orchestration`,
and distributed-pattern notes from `monopoly/patterns`.

## 1. When to use

- Full audit trail / regulatory requirement (fintech, healthcare).
- Temporal queries ("what was the state at time X"), replay, time-travel debugging, undo/redo.
- Read and write loads differ significantly (read:write > ~10:1) → CQRS.
- Complex domain with many state transitions; multiple read projections from one source.
- Distributed transactions / long-running workflows across services → sagas.

Do NOT use when: domain is simple CRUD, you cannot operate an event store/projections, or strong
immediate consistency is required everywhere. (Cheap alternative to event sourcing: append-only
audit log.)

## 2. Event sourcing principles

- Events are **immutable facts** — never mutate or delete committed events in production.
- Keep events small and focused; don't store large payloads.
- Version events from day one (schema evolution).
- Use **correlation IDs** (and causation IDs) for tracing across aggregates/services.
- Make event handlers **idempotent** (dedupe by event ID).
- Plan for projection rebuilding; rebuild in staging before production.
- Use **snapshots** for long-lived aggregates to speed up state rebuild.
- Design for eventual consistency.

Workflow: identify aggregate boundaries and event streams → design events as immutable facts →
implement command handlers + event application → build projections for query requirements →
design sagas/process managers for cross-aggregate workflows → snapshot long-lived aggregates →
set event versioning strategy.

## 3. Event store design

Requirements:

| Requirement | Description |
|---|---|
| Append-only | Events are immutable, only appends |
| Ordered | Per-stream and global ordering |
| Versioned | Optimistic concurrency control |
| Subscriptions | Real-time event notifications |
| Idempotent | Handle duplicate writes safely |

Technology comparison:

| Technology | Best for | Limitations |
|---|---|---|
| EventStoreDB | Pure event sourcing | Single-purpose |
| PostgreSQL | Existing Postgres stack | Manual implementation |
| Kafka | High-throughput streaming | Not ideal for per-stream queries |
| DynamoDB | Serverless, AWS-native | Query limitations |
| Marten | .NET ecosystems | .NET specific |

Best practices: stream IDs that include aggregate type (`Order-{uuid}`); correlation/causation IDs;
version from day one; idempotency via event IDs; index for your query patterns. Don't update/delete
events, don't store large payloads, don't skip optimistic concurrency, don't ignore backpressure.

### PostgreSQL event store schema

```sql
CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    stream_id VARCHAR(255) NOT NULL,
    stream_type VARCHAR(255) NOT NULL,
    event_type VARCHAR(255) NOT NULL,
    event_data JSONB NOT NULL,
    metadata JSONB DEFAULT '{}',
    version BIGINT NOT NULL,
    global_position BIGSERIAL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT unique_stream_version UNIQUE (stream_id, version)
);
CREATE INDEX idx_events_stream_id ON events(stream_id, version);
CREATE INDEX idx_events_global_position ON events(global_position);
CREATE INDEX idx_events_event_type ON events(event_type);
CREATE INDEX idx_events_created_at ON events(created_at);

CREATE TABLE snapshots (
    stream_id VARCHAR(255) PRIMARY KEY,
    stream_type VARCHAR(255) NOT NULL,
    snapshot_data JSONB NOT NULL,
    version BIGINT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE subscription_checkpoints (
    subscription_id VARCHAR(255) PRIMARY KEY,
    last_position BIGINT NOT NULL DEFAULT 0,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### EventStoreDB usage (Python)

```python
from esdbclient import EventStoreDBClient, NewEvent, StreamState
client = EventStoreDBClient(uri="esdb://localhost:2113?tls=false")

# Append with optimistic concurrency via expected_revision (-1 = NO_STREAM, None = ANY)
client.append_to_stream("order-abc", events=new_events, current_version=state)
# Read stream from revision
client.get_stream("order-abc", stream_position=0)
# Subscribe to all from commit position
client.subscribe_to_all(commit_position=pos)
# Category projection
read_stream(f"$ce-{category}")
```

### DynamoDB event store shape

- PK: `STREAM#{stream_id}`, SK: `VERSION#{version:020d}` (zero-padded for sort order).
- GSI1PK: `EVENTS`, GSI1SK: timestamp ISO — for global ordering.
- Conditional write for concurrency; batch_writer for appends.

## 4. CQRS

Separate read model (Query) from write model (Command) into distinct paths/databases.

- **Write path:** Client → Command API → Write DB (normalized, PostgreSQL).
- **Read path:** Client → Query API → Read DB (denormalized, Redis/Elasticsearch).
- **Sync:** Write DB → CDC (Debezium) → Message Queue → Read DB updater.

Workflow: identify read/write workloads and consistency needs → define command and query models
with clear boundaries → implement read-model projections and synchronization → validate
performance, recovery, failure modes.

Trade-offs: independent scaling and optimized schemas per side; but eventual consistency between
models and two models to maintain. Real users: Amazon (orders), LinkedIn (feed).

Key components: Command object + CommandHandler + CommandBus; Query object + QueryHandler +
QueryBus; read model updaters.

## 5. Projections / read models

- Projections consume events and build materialized views for querying.
- Types: current-state projection, history/audit timeline, aggregation (metrics/dashboards),
  search index, multi-table joins.
- Each projection keeps a **checkpoint** (subscription_checkpoints) so it resumes from the last
  position; idempotent handlers survive redelivery.
- Rebuild projections from the event stream when the projection logic changes.

Example shapes: `CurrentOrderState` (materialized view for queries), `OrderHistory` (audit
timeline), `DailyOrderMetrics` (analytics aggregation).

Best practices: keep projections simple and single-purpose; test replay; monitor lag.

## 6. Sagas

Manage distributed transactions via sequences of local transactions; compensate on failure.

Two styles:

- **Choreography:** services react to events autonomously (decentralized; good for simple chains).
- **Orchestration:** a central orchestrator coordinates steps (centralized; easier to trace and
  reason about).

Saga execution states: `Started → Pending → Compensating → Completed | Failed`.

Best practices (Do): make steps idempotent; design compensations carefully (they must work); use
correlation IDs; implement timeouts; log everything. Don't: assume instant completion; skip
compensation testing; couple services synchronously; ignore partial failures.

### Orchestrator base (concept)

- `Saga` has `saga_id`, `saga_type`, `state`, `data`, ordered `steps`, `current_step`.
- Each step: name, action, compensation, status, result/error, timestamps.
- `start()` → save saga → execute next step (publish action command).
- On step completion → advance; on completion → publish `{type}Completed`.
- On step failure → mark `COMPENSATING`, run completed steps in **reverse** publishing their
  compensation commands; when all compensated → `FAILED`.
- Timeout per step: schedule a timeout check; if still `executing`, fail the step.

Example steps for an order saga:
`reserve_inventory (comp: release_reservation) → process_payment (comp: refund) →
create_shipment (comp: cancel_shipment) → send_confirmation (comp: cancellation notice)`.

**Alternative:** durable-execution frameworks (DBOS) persist workflow state, retry failed steps,
and resume from checkpoint after crashes — removes the need to hand-build saga stores and
compensation tracking. Consider when you want saga reliability without the coordination
infrastructure.

## 7. Related distributed patterns (summary)

- **Outbox pattern:** solve dual-write (DB write + queue publish) by inserting the event into an
  outbox table in the same DB transaction; a relay process publishes it. Guarantees at-least-once
  delivery — consumers must be idempotent. Relay options: Debezium (CDC), polling relay.
- **Circuit breaker:** monitor downstream failure rate; CLOSED → OPEN (fail fast) → HALF-OPEN
  (probe) → CLOSED. Starting thresholds: open after 50% failure over 10 requests, stay open 30s.
- **Bulkhead:** separate thread pools/semaphores per service call so one slow service can't starve
  others.
- **Consistent hashing:** only K/N keys remap when nodes change; use virtual nodes for even
  distribution.
- **Backpressure:** consumers signal producers to slow (drop / buffer / block / rate limit).
- **2PC:** avoid in microservices (coordinator SPOF, blocks, low throughput) — prefer sagas.
- **Read-through / write-through / write-behind cache:** pick by consistency vs latency needs.