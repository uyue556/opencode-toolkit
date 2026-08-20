# Queues & Background Jobs

Offload anything slow or long-running from the request path. This file covers
BullMQ (Node/Redis) with notes on Celery (Python) and generic worker patterns.

## Principles

- Jobs are fire-and-forget from the producer — let the queue handle delivery.
- Always set explicit job options — defaults rarely match your use case.
- Idempotency is your responsibility — jobs may run more than once.
- Exponential backoff beats linear (avoids thundering herds).
- Failed jobs need a home — dead-letter/handling is not optional.
- Concurrency limits protect downstream services — start conservative.
- Job data should be small — pass IDs, not payloads.
- Graceful shutdown prevents orphaned jobs — handle SIGTERM properly.

## BullMQ basics

```javascript
import { Queue, Worker } from 'bullmq';
import IORedis from 'ioredis';

const connection = new IORedis(process.env.REDIS_URL, {
  maxRetriesPerRequest: null,   // Required for BullMQ
  enableReadyCheck: false,
});

const emailQueue = new Queue('emails', {
  connection,
  defaultJobOptions: {
    attempts: 3,
    backoff: { type: 'exponential', delay: 1000 },
    removeOnComplete: { count: 1000 },
    removeOnFail: { count: 5000 },
  },
});

const worker = new Worker('emails', async (job) => {
  await sendEmail(job.data);
}, {
  connection,
  concurrency: 5,
  limiter: { max: 100, duration: 60000 }, // 100 jobs/min
});

worker.on('failed', (job, err) => console.error(`Job ${job?.id} failed:`, err));
```

## Delayed & scheduled jobs

```javascript
// Run once after a delay
await queue.add('reminder', { userId: 123 }, { delay: 24 * 60 * 60 * 1000 });

// Repeatable (cron) — always specify a timezone to avoid DST drift
await queue.add('daily-digest', { type: 'summary' }, {
  repeat: { pattern: '0 9 * * *', tz: 'America/New_York' },
});

// Remove a repeatable job (must match the exact repeat options)
await queue.removeRepeatable('daily-digest', { pattern: '0 9 * * *', tz: 'America/New_York' });
```

## Job flows / dependencies

Use `FlowProducer` when a job depends on children completing first (parent waits
for all children). Useful for multi-stage pipelines (validate inventory →
charge payment → notify warehouse).

## Graceful shutdown

```javascript
const shutdown = async () => {
  await worker.pause();              // stop accepting new jobs
  await worker.close();              // finish in-flight jobs
  await queue.close();               // close connection
  process.exit(0);
};
process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);
```

## Observability

- Monitor: `bull-board` (or Arena) dashboards; track queue depth, job states,
  failure rates.
- Listen for `stalled` events (workers that crashed mid-job) and `failed` events
  for alerting.
- Log job attempts/backoff; alert on queue backlog growth.

## Validation checklist (BullMQ)

- [ ] Redis connection sets `maxRetriesPerRequest: null`
- [ ] `stalled` and `failed` event handlers present
- [ ] Graceful shutdown on SIGTERM/SIGINT
- [ ] Job data is small (IDs, not full objects)
- [ ] Timeouts set on jobs to prevent infinite execution
- [ ] Retries use exponential backoff
- [ ] Repeatable jobs specify a timezone
- [ ] Concurrency is conservative relative to downstream capacity
- [ ] `queue.add` is fire-and-forget in request handlers (don't await in hot path)

## Celery (Python/Django)

- Configure with Redis/RabbitMQ broker; `task.delay(...)` / `apply_async`.
- `max_retries` + `task.retry(exc=e, countdown=2**attempt)` for backoff.
- Idempotency: design tasks to be safe on duplicate execution.
- Use beat for scheduled/cron tasks.
- Result backend optional; prefer explicit status/progress tracking.

## When a full workflow engine beats a queue

Simple queues suffice for fire-and-forget jobs. For long-running sagas,
compensation, and multi-step workflows, consider a workflow orchestrator
(Temporal-style) instead of hand-rolling choreography.

## Sources

- `bullmq-specialist`, `django-pro` (Celery), `dotnet-backend` (BackgroundService
  / Hangfire), `laravel-expert` (queues/jobs), `backend-architect`.