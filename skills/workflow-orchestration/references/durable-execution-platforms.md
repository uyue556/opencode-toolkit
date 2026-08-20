# Durable Execution Platforms

Selection and sharp edges for durable workflow platforms. Read `SKILL.md`
first; this file holds per-platform detail and the failure modes that actually
hurt in production.

## Platform selection

| Platform | Best for | Caveats |
|----------|----------|---------|
| **Temporal** | Mission-critical, long-running (hours–years), distributed transactions, saga/compensation, entity workflows | Steeper learning curve; determinism rules are non-negotiable |
| **Inngest** | Event-driven serverless, TypeScript, AI workflows | Steps are HTTP handlers; no workers to manage |
| **Trigger.dev** | AI background jobs, integration-rich TS (OpenAI/Stripe/Slack) | Version-lock SDK + CLI; env vars must be synced to cloud |
| **Upstash QStash** | Reliable HTTP delivery, serverless cron, fan-out | Endpoints must be public HTTPS; ~500KB body limit |
| **AWS Step Functions** | AWS-native stacks, existing Lambdas | JSON (ASL) definition, 256KB payload limits |
| **Azure Durable Functions** | Azure stacks, .NET/TS | Checkpoint + replay, good AI agent support |
| **n8n** | Low-code visual workflows, non-engineers | Must add Error Trigger + retries manually |
| **Airflow/Dagster/Prefect/Kubeflow** | Data/batch/DAG pipelines, ML | Batch-oriented; not for interactive/long-lived entities |

Tradeoffs in one line: n8n optimizes accessibility, Temporal correctness,
Inngest developer experience. Pick by need, not hype.

## Universal durable-execution rules

These apply to *every* durable platform. Best practice is roughly the same
regardless of surface.

1. **Non-idempotent external steps → CRITICAL.** Durable execution replays from
   the beginning on restart. If step 3 crashes, steps 1–2 rerun. External
   services don't know these are retries. Always:
   - Payment: `idempotency_key: order-${orderId}-payment` (Stripe et al).
   - Email: check `alreadySent(orderId)` before send, return `{skipped:true}`.
   - DB: `INSERT ... ON CONFLICT (id) DO NOTHING` / upsert.
   - Derive keys from stable inputs, never from random values.

2. **Long workflows need checkpoints.** A 24h workflow with one step/hour holds
   state in memory between checkpoints. WRONG: one `step.run("process-all")`
   looping 1000 items. CORRECT: per-item `step.run` calls (checkpoint each).
   Use `step.sleep`/durable sleep for waits; use child workflows / `invoke` for
   long processes; use `ContinueAsNew` before history grows unbounded (Temporal
   default ~50K events / 50MB).

3. **Always set activity timeouts.** External APIs can hang forever. Temporal:
   `startToCloseTimeout` (required), `scheduleToCloseTimeout`,
   `heartbeatTimeout` for long activities. Inngest: `step.run(id, {timeout},
   fn)`. Step Functions: `TimeoutSeconds` + `HeartbeatSeconds`. Rule: activity
   timeout < workflow timeout.

4. **Retries with exponential backoff + jitter.** Immediate retries hit a dying
   service 100× simultaneously. Temporal:
   `initialInterval:1s, backoffCoefficient:2, maximumInterval:1min,
   maximumAttempts:5`. Inngest retries use exponential backoff by default. Add
   jitter to prevent thundering herd. Mark **non-retryable** error types
   (validation, card declined, resource-not-found) so you don't retry them.

5. **Dead-letter handling.** After retries are exhausted, workflows must not
   vanish silently. Inngest: `onFailure` handler → log + Slack alert + queue for
   manual review. n8n: Error Trigger node → log → Slack → Jira. Temporal:
   `workflow.failed` / signals.

6. **Large data out of workflow state.** Workflow state is persisted and replayed
   on every step. Store large payloads (S3/DB) and return only the reference key.
   Step Functions hard-limit ~256KB; Temporal ~2MB per argument.

7. **Side effects outside step boundaries → CRITICAL.** Code that runs on replay
   must be deterministic. Wrong: `uuid()` or `new Date()` in workflow function.
   Right: generate IDs / read time inside activities (recorded), or use
   `workflow.now()`, `workflow.random()`, `sideEffect()`.

Checklist: idempotency keys ✓, timeouts on all activities ✓, backoff+jitter ✓,
dead-letter path ✓, payloads as references ✓, determinism ✓.

## Temporal specifics (Python + Go SDKs)

### Workflow vs Activity design rule
- **Workflow = orchestration/decision logic.** Deterministic. No external calls.
  State auto-preserved. Can run for years.
- **Activity = external interaction** (API, DB, network). Non-deterministic OK.
  Idempotent. Short-lived. Has timeouts + retry.

Decision: "does it touch external systems?" → Activity. "Is it orchestration or
decision logic?" → Workflow.

### Python SDK (`temporal-python-pro`)
- Worker: configure task queue, register workflow + activities, graceful shutdown,
  connection pooling.
- Decorators: `@workflow.defn` + `@workflow.run` (entry, async/await);
  `@activity.defn`; signal handlers `@workflow.signal`; query handlers
  `@workflow.query`.
- Three execution models for activities:
  1. **Async (asyncio)** — non-blocking I/O (APIs, async DB).
  2. **Sync multithreaded** (`ThreadPoolExecutor`) — blocking I/O (sync clients,
     file ops, legacy libs).
  3. **Sync multiprocess** (`ProcessPoolExecutor`) — CPU-heavy (ML inference,
     heavy calc).
  Anti-pattern: blocking the async event loop turns async programs into serial
  execution.
- Determinism: `workflow.now()`, `workflow.random()`, no threading/locks/global
  state, no direct external calls.
- Errors: `ApplicationError(non_retryable=True)` for permanent failures;
  `next_retry_delay` for dynamic delay; catch `ActivityError` in workflows for
  compensation.
- Timeouts: `schedule_to_close` (total), `start_to_close` (per attempt),
  `heartbeat_timeout`, `schedule_to_start` (queue time).
- Testing: `WorkflowEnvironment` time-skipping test env (instant `workflow.sleep`,
  fast month-long workflows), mock activities, `ActivityEnvironment` for unit
  tests, replay testing against production histories in CI.
- Serialization: JSON default; custom data converters; Protobuf; ~2MB/arg limit.

### Go SDK (`temporal-golang-pro`)
- **Five determinism rules:** no native goroutines; no `time.Now`/`time.Sleep`;
  no non-deterministic map iteration (sort keys); no direct external I/O; no
  non-deterministic random.
- Durable concurrency via `workflow.Go`, `workflow.Channel`, `workflow.Selector`
  (not native primitives). Example: `workflow.NewSelector` waits on both a signal
  channel and a 72h timer for approvals.
- Versioning: `workflow.GetVersion(ctx, "billing_logic", workflow.DefaultVersion,
  2)` for safe logic evolution; `workflow.GetReplaySafeLogger`.
- `ContinueAsNew` to manage history size; child workflows with lifecycle +
  cancellation + parent/child signal propagation.
- mTLS worker: load client cert+key, CA pool, `client.Dial` with TLS options
  (`Certificates`, `RootCAs`).
- Heartbeat long activities (`activity.RecordHeartbeat`) — must beat before
  `heartbeatTimeout` or be considered stuck.
- Testing: `WorkflowTestSuite` with deterministic time; activity/child mocking;
  `replayer.ReplayWorkflowHistoryFromJSON` for compatibility on code change.
- Troubleshooting: determinism panic → missing `workflow.GetVersion`; history
  too large → add `ContinueAsNew`; worker hang → check `WorkerStopTimeout`.

## Inngest specifics

- **Events are the primitive.** Typed events (`EventSchemas().fromRecord`),
  triggers on `event: "user/signed.up"`, send anywhere via
  `await inngest.send({name, data})`.
- **Steps are durable checkpoints.** `step.run("validate-order", fn)` — results
  stored; retries survive crashes. `step.sleep("wait", "1h")` is real durable
  sleep (not a blocked thread). `step.waitForEvent` must have `{timeout:'24h'}`.
- Concurrency is first-class: `concurrency: { limit: 10 }` protects downstream
  services. Retries: `retries: 5` config; `NonRetriableError` for permanent
  failures.
- Fan-out built-in: one event triggers many functions; `step.sendEvent` to fan
  out child events.
- `idempotency: 'event.data.stripeEventId'` dedups webhook processing.
- Every function needs a unique `id`; registered in `serve()` handler.
  Validation checks live in the source skill: serve handler present; functions
  registered; descriptive kebab-case step names; waitForEvent timeout; concurrency
  limit; typed events; unique ids; duration strings ("1h") not ms; retry policy
  configured; idempotency key for payment functions.

## Trigger.dev specifics

- **Tasks are the building blocks**, each independently retryable; runs are
  durable. `task({id, run})`; trigger with `task.trigger(payload)` (fire-and-forget)
  or `handle.wait()` (await result). `triggerAndWait` for sequential sub-steps.
- **Built-in integrations** (`@trigger.dev/openai`, `/anthropic`, `/resend`,
  `/stripe`, `/slack`) add automatic retries + rate-limit handling — prefer them
  to raw SDKs.
- **Timeouts are real**: long tasks get killed silently at the execution-timeout
  limit (dashboard: "Task timed out"). Use `machine: { preset: 'large-2x' }` and
  **log progress at each step**. Break very long jobs into subtasks,
  each with its own timeout.
- **Payloads serialize to JSON**: Date → string (use `.toISOString()`), class
  instances lose methods (use plain objects), circular refs throw.
- **Env vars don't auto-sync** to Trigger.dev cloud — push via
  `npx trigger.dev@latest env push`; configure staging too.
- **SDK + CLI must be version-matched**; pin both in CI.
- **Idempotency** for retry-safe side effects:
  `idempotencyKeys.create(`email-${orderId}`)` → skip if `!isNew`.
- Concurrency: `queue: { concurrencyLimit: 5 }`; conservative starts: 5–10 for
  external APIs, 20–50 for DBs. Avoid `wait.for` inside giant loops (each creates
  checkpoint state — batch instead; chunk into subtasks).
- `trigger.config.ts` must sit at the package/project root (monorepos: run from
  package dir or pass `--config`). Keep the dev server running in dev
  (`npx trigger.dev dev`), else triggers silently vanish.

## QStash specifics

- **HTTP is the interface** — QStash calls your public URLs from the cloud.
  Endpoints MUST be publicly accessible HTTPS; localhost/private IPs unreachable
  (use ngrok/dev-mode bypass locally).
- **Always verify signatures**: `new Receiver({currentSigningKey,
  nextSigningKey})` + `receiver.verify({signature, body, url})` on RAW body
  (`req.text()`, not parsed JSON). Both keys for rotation. Verify callbacks too.
- **Fast-acknowledge endpoints.** QStash times out ~30s; heavy inline processing
  → mark failed → retry → duplicates. Acknowledge fast, then queue/publish the
  heavy work.
- **Deduplicate**: `deduplicationId: 'charge-order-123'` (custom) or
  `contentBasedDeduplication: true` (body hash). Default window ~60s. Make
  endpoints idempotent regardless.
- **Configure retries per message**: critical ops → `retries: 5` + long backoff;
  notifications → `retries: 1` fail fast. Use `failureCallback` as dead-letter.
- **Callbacks close the loop**: `callback` gets delivery status
  (`sourceMessageId`, `status`), `failureCallback` for failures/alerts.
- **Batch publishes** (`batchJSON`) instead of 100 individual calls; watch plan
  rate limits (free ~500 msgs/day).
- **URL groups fan out** to multiple endpoints — audit them regularly, remove
  dead endpoints.
- **Cron runs in UTC** — convert local time, document the timezone.
- Small bodies: send references (`{documentId}`) and fetch in handler, not 5MB
  payloads.

## n8n specifics

- Every production workflow needs an **Error Trigger** node → extract details →
  log → Slack/email alert → optional dead-letter (Redis/Postgres) + recovery
  sub-workflow. Also use node retry, node timeout, and workflow timeout settings.
- Build sequential steps with retry-on-failure configured per node; use Switch
  node for event-type routing; sub-workflows for reuse.

## Additional sharp edges (cross-platform)

- **Scaling rule** (Temporal): don't scale an individual workflow. 1M tasks →
  ~1K child workflows × ~1K tasks each. Keep each workflow bounded.
- **Retry classification** — retryable vs permanent: never retry validation
  errors, business-rule violations, or permanent failures.
- **Versioning strategies** — `workflow.get_version()` for in-flight-change
  safety; new workflow type + route new executions; keep old event replay
  compatible.
- **Monitoring** — duration, activity failure rates, retry/backoff counts, pending
  workflow counts. Distributed tracing in production.