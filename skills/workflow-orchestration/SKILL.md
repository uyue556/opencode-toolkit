---
name: workflow-orchestration
description: >
  Design and operate reliable production workflows and pipelines. Covers durable
  execution platforms (Temporal, Inngest, Trigger.dev, QStash, AWS Step
  Functions, n8n, Airflow, Dagster, Prefect, Kubeflow), orchestration patterns
  (sequential/parallel/orchestrator-worker/saga/entity/event-driven/fan-out),
  pipeline & DAG definition (Airflow, MLOps), agent-driven task workflows
  (spec-build-review loops, plan execution, subagent delegation, acceptance-gated
  delivery, verification discipline) and CI/CD + git automation playbooks
  (GitHub Actions, GitLab CI, guarded PR workflows). Use whenever the user
  mentions 工作流, 编排, 流水线, workflow, orchestration, durable execution,
  step function, state machine, saga, DAG, cron, scheduled task, background job,
  job queue, retry, 重试, 幂等, idempotency, Temporal, Airflow, Inngest,
  Trigger.dev, QStash, n8n, pipeline, 调度, 状态机, execution plan, issue gate,
  acceptance criteria, subagent-driven development, CI/CD.
---

# Workflow Orchestration

Turn brittle multi-step processes and AI agents into durable, retryable,
observable workflows. The design decisions that matter are *where state lives,
how retries behave, and how steps checkpoint* — not which library you import.

## When to use this skill

- Designing durable/multi-step workflows, background jobs, scheduled tasks, or
  event-driven pipelines.
- Choosing and wiring an orchestration platform.
- Structuring agentic work: spec → build → review loops, executing written
  plans, dispatching subagents, acceptance-gated delivery with verification.
- Defining pipelines/DAGs (data, ML/MLOps, CI/CD) with step sequencing and
  failure handling.
- Building automation playbooks: issue triage, AI PR review, deployment,
  rollback, guarded merge.

Not for: simple CRUD endpoints, a single stateless API call, or pure real-time
streaming (use Kafka/event processors).

## Core workflow (routing)

| Task | Go to |
|------|-------|
| Pick a platform; durable-execution sharp edges | `references/durable-execution-platforms.md` |
| Pattern recipes (sequential, saga, entity, fan-out, async callback) | `references/orchestration-patterns.md` |
| DAGs, Airflow, ML/MLOps pipelines | `references/pipelines-dags.md` |
| Agent loops, plan execution, subagents, issue gates, verification | `references/agent-workflow-design.md` |
| Track/state-machine delivery (phased plans, revert-by-unit) | `references/state-machines-tracks.md` |
| CI/CD pipelines, PR/issue automation, git discipline | `references/git-ci-orchestration.md` |

## Core principles (read before the details)

1. **Workflows orchestrate; activities execute.** Workflow code is *deterministic*
   decision logic; every external interaction (API, DB, file, network) lives in an
   activity/step. Same inputs must replay to the same outputs.
2. **Steps are checkpoints.** Each step result is persisted. Make steps small,
   independently retryable, and make every external side effect **idempotent**
   (idempotency keys, check-then-act, upserts).
3. **Events are the trigger language.** Prefer event-driven triggers over polling
   where reactivity matters; keep cron for truly time-based jobs.
4. **Fail by design.** Always set retries with exponential backoff + jitter,
   activity timeouts, heartbeats for >10s work, and a dead-letter/failure path.
5. **Observability is not optional.** You must be able to see where a workflow
   failed (logs, DLQ, failure callbacks, dashboards).
6. **Verification before completion.** No completion claim without fresh evidence.

## Selection cheatsheet

- **Mission-critical, long-running, distributed transactions →** Temporal
  (strongest durability) or Step Functions/Azure Durable for vendor-locked stacks.
- **Serverless, TypeScript, event-driven, great DX →** Inngest (durable steps,
  fan-out, cron, `step.sleep`).
- **AI background jobs, integration-rich TS →** Trigger.dev (task-based, built-in
  OpenAI/Stripe integrations, machine presets).
- **Reliable HTTP delivery, schedules, queues without infra →** QStash.
- **Low-code visual workflows, non-engineers →** n8n (add Error Trigger + retries).
- **Data batch/DAG pipelines →** Airflow, Dagster, Prefect, Kubeflow.
- **10-step payment flow where a hiccup means lost money →** durable execution
  with idempotency keys everywhere. Non-negotiable.

## Best practices

- **Keep workflows bounded.** Fan-out scaling: for millions of tasks, spawn ~1K
  child workflows × ~1K tasks each, not one giant workflow.
- **Break long loops into per-item steps** (each `step.run`/`task` is a
  checkpoint); use `sleep` for waits instead of busy work; avoid thousands of tiny
  waits (each creates checkpoint state).
- **Never put side effects in workflow code.** No `random()`, `Date.now()`,
  threading, global state, or direct I/O inside a workflow. `workflow.now()` /
  `workflow.random()` are the deterministic substitutes.
- **Set `startToCloseTimeout` (and heartbeat) on EVERY activity.** Activity
  timeout must be < workflow timeout.
- **Use `ContinueAsNew` / child workflows** before event history grows unbounded
  (e.g., 50K events / 50MB).
- **Version workflows safely** with `workflow.get_version()` or new workflow
  types; route new executions, keep old replays compatible.
- **Classify retryable vs permanent errors** before configuring retries; never
  retry validation failures, card-declined, resource-not-found.
- **Run the smallest verification that proves each claim**; run the full suite at
  phase boundaries; never claim green on a partial run.
- **Route by risk:** production deploys, destructive ops, credential changes, and
  billing-affecting actions always require explicit human approval.

## Do & Don't

Do:
- Ask scope-clarifying questions one at a time before building (finish
  requirement discovery before code).
- Add a dead-letter handler to every production workflow (retries are not a
  substitute for failure detection).
- Make webhook/event handlers fast-acknowledge, then delegate heavy work to a
  task/queue; never do 30s of work inline and risk double-processing.
- Keep step/task ids stable, descriptive, kebab-case.

Don't:
- Don't retry non-retryable errors. Classify before configuring retries.
- Don't store big payloads in workflow state — persist to S3/DB and pass a
  reference.
- Don't set `depends_on_past` in Airflow, hardcode dates, or put heavy logic in
  DAG files.
- Don't ship retry config without backoff, or timeouts without heartbeats.
- Don't dispatch multiple implementing subagents on the same task in parallel
  (conflicts); don't skip review stages.
- Don't claim completion without running the verification command.

## Common pitfalls

- Duplicate side effects on retry (charge twice, email thrice) — **fix:
  idempotency keys derived from stable inputs**.
- Non-determinism errors on replay (random UUID / clock reads in workflow code).
- Workflows hanging forever (no activity timeout).
- Retry storms overwhelming a failing service (no backoff/jitter).
- Silent failure after retries are exhausted (no DLQ, no alert).
- In agent workflows: claiming "done" without running the verification command.

## Structure of this skill

- `references/durable-execution-platforms.md` — platform selection + sharp edges.
- `references/orchestration-patterns.md` — pattern recipes, workflow/activity split.
- `references/pipelines-dags.md` — Airflow DAG patterns, ML/MLOps orchestration.
- `references/agent-workflow-design.md` — spec-build-review, plans, subagents,
  issue gates, acceptance-driven delivery, verification discipline.
- `references/state-machines-tracks.md` — phased track delivery, revert-by-unit.
- `references/git-ci-orchestration.md` — CI/CD pipelines + git/PR automation.
- `dedup-notes.md` — what was merged and dropped.
