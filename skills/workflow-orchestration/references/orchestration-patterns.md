# Orchestration Patterns

Recipes for the core patterns behind every workflow platform, plus the
workflow/activity design rule. Read `../SKILL.md` first.

## The workflow/activity split (Temporal vocabulary, universal idea)

- **Workflow** = orchestration and decision logic. Must be **deterministic**
  (same inputs → same outputs on every replay). Cannot do direct external calls,
  threading, locks, global/static state, `random()`, or `datetime.now()`. State
  is preserved automatically across crashes; workflows can run for years.
  Allowed: `workflow.now()` (deterministic time), `workflow.random()`
  (deterministic random), pure functions, calling activities.
- **Activity** = external interaction (API, DB, network). Can be
  non-deterministic. Must be **idempotent** (calling N times = calling once).
  Short-lived (seconds to minutes typically). Has built-in timeouts + retries.

Decision rule:
```
Does it touch external systems? → Activity
Is it orchestration/decision logic? → Workflow
```

## 1. Saga pattern with compensation

Distributed transactions with rollback capability.

```
For each step:
  1. Register compensation BEFORE executing
  2. Execute the step (via activity)
  3. On failure, run all compensations in reverse order (LIFO)
```

Example (payment workflow):
1. Reserve inventory (compensation: release inventory)
2. Charge payment (compensation: refund payment)
3. Fulfill order (compensation: cancel fulfillment)

Critical requirements:
- Compensations must be idempotent.
- Register compensation BEFORE executing the step.
- Run compensations in reverse order.
- Handle partial failures gracefully.

## 2. Entity workflows (actor model)

One workflow execution = one entity (cart, account, inventory item), persisted
for the entity lifetime. Receives **signals** for state changes; supports
**queries** for current state.

Use cases: shopping cart (add/checkout/expiration), bank account
(deposit/withdraw/balance), inventory (stock updates, reservations).

Benefits: encapsulates entity behavior, guarantees consistency per entity,
natural event sourcing.

## 3. Fan-out / fan-in (parallel execution)

Spawn child workflows or parallel activities, wait for all, aggregate, handle
partial failures.

```
        ┌→ Step A ─┐
Input ──┼→ Step B ─┼→ Aggregate → Output
        └→ Step C ─┘
```

Scaling rule (Temporal): don't scale individual workflows. For 1M tasks: spawn
~1K child workflows × ~1K tasks each. Keep each workflow bounded.

## 4. Async callback pattern

Wait for an external event or human approval.

```
Workflow sends request → external system processes async → sends signal →
workflow continues with response
```

Use cases: human approval workflows, webhook callbacks, long-running external
processes. In Go: `workflow.NewSelector` waits on both a signal channel and a
timeout timer (e.g., 72h approval window).

## 5. Sequential workflow

Steps execute in order, each output becomes the next input. Content pipelines,
data processing, ordered operations. Checkpoint at each step.

## 6. Orchestrator-worker pattern

Central coordinator analyzes a task, creates subtasks, dispatches to
specialized workers, aggregates results. Works with dynamic subtask creation and
AI planning (LLM produces the subtask plan, each subtask runs as a durable
step).

```
ORCHESTRATOR (analyze → create subtasks → dispatch → aggregate)
  │
  ├── Worker1 (create)
  ├── Worker2 (modify)
  └── Worker3 (delete)
```

## State management & determinism

- Complete program state is preserved automatically (event history records every
  command and event); recovery resumes from last successful step.
- Workflows execute as state machines: replay behavior must be consistent.
- Prohibited in workflow code: threading/locks/sync primitives, `random()`,
  global/static variables, system time (`datetime.now()`), direct file/network
  I/O, non-deterministic libraries.
- `sideEffect()` / `MutableSideEffect()` (Temporal) capture a single
  non-deterministic value once and replay it identically — do NOT use them as a
  workaround to call external APIs inside workflows.

## Versioning strategies

Challenge: changing workflow code while old executions still run.

1. `workflow.get_version()` for safe changes (pin minimum version; only remove
   the old branch after zero running instances on the old version).
2. New workflow type; route new executions to it.
3. Keep old events replay-compatible (backward compatibility).

## Resilience & error handling

- **Retry policies**: initial interval, backoff coefficient (exponential), max
  interval (cap), max attempts (eventual failure). Non-retryable: validation
  failures, business-rule violations, permanent failures (resource not found).
- **Idempotency strategies**: idempotency keys (dedup), check-then-act with
  unique constraints, upserts instead of inserts, track processed request IDs.
- **Heartbeats**: activity sends periodic heartbeat with progress; timeout if no
  heartbeat; enables progress-based retry and cancellation of long activities.
- **Activity timeouts**: `schedule_to_close` (total duration), `start_to_close`
  (per attempt), `heartbeat_timeout` (stall detection), `schedule_to_start`
  (queue time). Rule: activity timeout < workflow timeout.

## Common pitfalls

- Using `datetime.now()` instead of `workflow.now()`.
- Threading/async ops in workflow code.
- Direct external API calls from workflow code.
- Non-idempotent activities (can't handle retries).
- Missing timeouts (activities run forever).
- No error classification (retrying validation errors).
- Ignoring payload limits (Temporal ~2MB per argument).
- Generating random IDs / reading clock inside workflow code (breaks replay).

## Operational considerations

- **Monitoring**: workflow duration, activity failure rates, retry/backoff
  counts, pending workflow counts.
- **Scalability**: horizontal scaling with workers, task-queue partitioning,
  child-workflow decomposition, activity batching when appropriate.
- **Testing**: use time-skipping test environments (instant sleep, fast
  month-long workflows); mock activities; replay testing against production
  histories in CI; test error paths and compensation.

## When NOT to use orchestration

- Simple CRUD (use direct API calls).
- Pure data processing pipelines (use Airflow/batch).
- Stateless request/response (use standard APIs).
- Real-time streaming (use Kafka, event processors).
