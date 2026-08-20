---
name: devops-reliability
description: >
  Expert DevOps & SRE playbook for shipping, running, and defending production systems.
  Covers CI/CD pipelines (GitHub Actions), Docker containers, Kubernetes & GitOps (ArgoCD/Flux),
  Terraform/OpenTofu IaC, monitoring & observability (Prometheus/Grafana/Jaeger), SLI/SLO & error
  budgets, on-call & incident response, blameless postmortems, deployment strategies
  (rolling/canary/blue-green/feature flags), performance troubleshooting (USE/TSA method), remote
  GPU training ops, and cron/schedule validation. Use whenever the user mentions CI/CD, pipeline,
  部署, 上线, 发布, deployment, release, rollout, canary, 金丝雀, 回滚, rollback, Docker, container,
  容器, Kubernetes, k8s, GitOps, ArgoCD, Flux, Terraform, OpenTofu, 基础设施即代码, IaC,
  monitoring, 监控, observability, 可观测性, Grafana, Prometheus, Jaeger, SLO, SLI, 错误预算,
  error budget, on-call, 值班, incident, 故障, 事故, incident response, runbook, 告警, alerting,
  postmortem, 复盘, root cause, 根因, performance, 性能, latency, 延迟, GPU rental, 远程GPU训练,
  租卡, cron, 定时任务, pre-release, 发布前检查, launch checklist, health check, 健康检查.
  Also use for pre-launch checklists, rollback planning, release-readiness reviews, and debugging
  why production is slow or down.
---

# DevOps & Reliability (部署 · 运维 · 可靠性)

Ship safely, observe everything, respond fast, and learn from every incident. This skill
consolidates CI/CD, container/K8s operations, IaC, observability, SLOs, on-call, incident
response, postmortems, deployment strategy, and performance debugging into one workflow.
Each sub-topic routes to a reference file for detail — read only what the current task needs.

## When to use

- Designing or debugging a CI/CD pipeline (GitHub Actions, GitLab, self-hosted runners).
- Preparing a production launch: pre-launch checklist, staged rollout, rollback plan.
- Building or hardening Docker images, Docker Compose, or container security.
- Authoring Kubernetes manifests, Helm charts, security policies, or GitOps (ArgoCD/Flux).
- Writing or reviewing Terraform/OpenTofu modules, state, or multi-environment IaC.
- Instrumenting code: logging, metrics, tracing, alerting — or diagnosing slow/erroring services.
- Defining SLIs/SLOs/error budgets and SLO-based alerting.
- Taking an on-call shift, writing a handoff, or responding to an incident / writing a runbook.
- Writing a blameless postmortem.
- Deploying or babysitting a long-running GPU job on rented/remote hardware.
- Validating a cron schedule before it silently breaks in production.

## Core workflow

Follow this loop for any change you ship; each phase delegates to the reference indicated.

1. **Review before release** — run a read-only release-readiness review (migrations, config,
   secrets, rollout order, rollback risk) *before* CI/CD or manual release steps.
   → `references/deployment-strategies.md` (release review + config validation).
2. **Build & test in CI** — stage pipeline jobs (build → test → staging → approve → prod) with
   least-privilege permissions, pinned actions, concurrency, and caching.
   → `references/ci-cd-github-actions.md`.
3. **Package** — produce a minimal, secure container image (multi-stage, non-root, health check).
   → `references/docker-containers.md`.
4. **Deploy** — pick the strategy by risk (rolling by default; blue-green for high-risk;
   canary for validation; feature flags as a kill switch). Always have a rollback plan written
   before you start. → `references/deployment-strategies.md`; on Kubernetes/GitOps:
   → `references/kubernetes-gitops.md`.
5. **Observe** — make the deployed behavior visible: RED metrics, structured logs with
   correlation IDs, distributed traces. → `references/monitoring-observability.md`.
6. **Set the bar** — define SLIs/SLOs and error-budget alerts so "is it good enough?" is a
   number. → `references/slo-error-budgets.md`.
7. **Respond** — when an alert fires: triage severity, stabilize first (rollback/scale/flag),
   investigate with evidence, then restore. → `references/incident-response.md`; on-call
   handoffs → `references/sre-oncall.md`.
8. **Learn** — write a blameless postmortem with action items and owners.
   → `references/postmortems.md`.

## Selection routing

| Task | Reference file |
|---|---|
| GitHub Actions design/debug/security, matrix, caching, OIDC, self-hosted runners, release automation | `references/ci-cd-github-actions.md` |
| Pipeline architecture, approval gates, deploy strategies, rollback, DORA metrics | `references/ci-cd-github-actions.md` (stages) + `references/deployment-strategies.md` |
| Dockerfile, multi-stage builds, image size, Compose, container security | `references/docker-containers.md` |
| K8s manifests, Helm, NetworkPolicy/RBAC/PSS, service mesh, GitOps (ArgoCD/Flux), progressive delivery | `references/kubernetes-gitops.md` |
| Terraform/OpenTofu modules, testing, state, count vs for_each, versions, security scanning | `references/terraform-iac.md` |
| Instrumentation (logs/metrics/traces), RED/USE, Grafana dashboards, Jaeger/Tempo, Datadog/Sentry/PagerDuty automation, data-incident RCA | `references/monitoring-observability.md` |
| SLI/SLO definition, error budgets, burn-rate alerting, SLO dashboards | `references/slo-error-budgets.md` |
| On-call shift handoff, rotation, escalation, server/process management | `references/sre-oncall.md` |
| Active incident response, severity, runbooks, incident command | `references/incident-response.md` |
| Blameless postmortems, 5-Whys, facilitation | `references/postmortems.md` |
| "Server is slow" / performance RCA (USE, TSA, 60-second triage), CPU/disk/network diagnosis | `references/performance-troubleshooting.md` |
| Rented GPU training (AutoDL/RunPod/vast.ai), spot preemption, checkpointing, teardown safety | `references/mlops-remote-gpu.md` |
| Cron / schedule validation (never-fires, OR-semantics, midnight spikes) | `references/cron-scheduling.md` (+ `scripts/cron-engine.js`) |

## Cross-cutting principles

- **Every deployment is reversible, observable, and incremental.** If you can't roll back and
  can't see it, don't ship it.
- **Rollback first, debug later.** Speed over perfection during an incident; you earn the right
  to investigate only after users are served.
- **Alert on symptoms users feel, not causes.** "Error rate > 1% for 5 min" pages; "CPU at 85%"
  goes on a dashboard.
- **Instrument as you build**, not after the incident. Name the 2–4 questions on-call will ask,
  then make every signal answer one of them.
- **Cardinality is the failure mode.** Never use user IDs, raw URLs, or error text as metric
  labels — that belongs in logs and traces.
- **Keep the system boring.** Least privilege, non-root, read-only root FS, bounded timeouts,
  and `timeout-minutes` on every job.
- **Cost and destructive actions are the user's call.** Never auto-terminate, auto-delete, or
  release resources without explicit confirmation.
- **Only sed, don't rewrite.** When improving a workflow or config, make small reversible edits
  and verify each one, rather than regenerating the whole thing from scratch.
- **Verify telemetry itself.** Instrumentation is code: force an error in staging and confirm the
  log line, metric series, and alert all fire before you call it done.

## Best practices by area

### CI/CD
- Declare `permissions:` at workflow and job level (least privilege); pin third-party actions to
  full commit SHAs; keep `${{ }}` expressions out of `run:` (use env vars) to prevent injection.
- Set `timeout-minutes` on every job; use `concurrency` to cancel stale runs; `fail-fast: false`
  for matrix debugging.
- Use OIDC / workload identity instead of long-lived cloud credentials.
- Cache dependencies (language setup actions or `actions/cache`) and enable Docker layer caching.

### Docker
- Order layers: deps before source; use multi-stage builds; copy only needed artifacts; clean
  package-manager caches in the same RUN layer.
- Run as non-root with a fixed UID/GID; drop all capabilities; read-only root FS; add a
  HEALTHCHECK; keep secrets out of ENV and image layers.

### Kubernetes & GitOps
- Use Pod Security Standards + default-deny NetworkPolicy + least-privilege RBAC; run admission
  control (OPA Gatekeeper/Kyverno); scan images (Trivy/Checkov) before deploy.
- GitOps: keep desired state declarative in Git; auto-sync is fine for staging but gate
  production; keep secrets out of Git (External Secrets / Sealed Secrets / SOPS).
- Prefer `for_each` over `count` when the set of resources may be reordered or removed.

### Terraform
- Separate environments from modules; use `examples/` as documentation and test fixtures.
- Version pins: Terraform minor (`~> 1.9`), providers major (`~> 5.0`), modules exact.
- Test pyramid: `validate`/`fmt`/`tflint`/`trivy`/`checkov` (free) → `terraform test` (1.6+)
  → Terratest for deep integration. Mock providers (1.7+) to keep PR costs near zero.

### Observability
- Metrics tell you *that* something is wrong, traces tell *where*, logs tell *why*. Use RED for
  services, USE for resources; track percentiles, never averages.
- Structured logs (JSON, stable event names, correlation ID on every line); never log secrets.
- Sample traces 1–10% in prod (100% in dev); keep 100% of errors if your backend supports it.
- Every alert must be actionable, link a runbook, and be test-fired once.

### SLOs
- Start with user-facing services; an SLO below 100% is a feature (99.9% = ~43 min/month).
- Use multi-window burn-rate alerts (e.g., 14.4× on 1h+5m, and 6× on 6h+30m) to cut false noise.
- Error budget is policy: freeze risky changes as the budget runs out.

### Incident response & on-call
- Declare severity and incident command early; communicate every 15 min during active incidents.
- Stabilize with the fastest safe lever (rollback, scale, feature flag, circuit breaker) before
  root-causing. Escalate early; hand off cleanly; never disappear mid-shift.
- Runbooks are for 3 AM: no assumed knowledge, every step verifiable, rollback steps included.

### Performance
- Ask the problem statement first ("slow" how, since when, what changed), then run the
  60-second triage (uptime, dmesg, vmstat, mpstat, iostat, free, sar, top).
- Check errors and saturation before utilization; record what you exonerated with evidence.
- Re-measure after the fix with the *same* instruments; "deployed" is not "verified".

## Do & Don't

| Do | Don't |
|---|---|
| Backup before deploy; document the rollback plan | Deploy on Friday or rush a release |
| Monitor for 15+ min after every deploy | Walk away after hitting deploy |
| Feature-flag risky changes with an owner + expiry | Ship without a kill switch |
| Keep logs rotated, structured, secret-free | Log tokens, passwords, or full PII |
| Test rollback before you need it | Skip staging; assume prod == staging |
| Ask "why" five times in postmortems | Name, shame, or skip small incidents |
| Clean up feature flags within 2 weeks of full rollout | Nest feature flags |

## Common pitfalls

- **Cron that never fires or fires too often** — impossible dates, OR-semantics between
  day-of-month and day-of-week, `0 0` midnight spikes, steps that don't divide 60, Feb 29.
  Validate with `scripts/cron-engine.js` (`node scripts/cli.js validate "0 0 30 2 *"`).
- **Silent cron/CI failures** — a syntactically valid schedule or workflow that never runs.
  Check the trigger semantics and the runner, not just the syntax.
- **Connection-pool exhaustion** → kill long-running queries (`pg_terminate_backend`), lower
  alert thresholds, verify connection reuse in code.
- **OOM with no traceback (exit 137)** — size workers vs cgroup `memory.max`, not CPU count.
- **"Stop" doesn't stop the meter** on rented GPU boxes — only terminate/destroy does, and it
  deletes the disk. Know the verb before you click.
- **Cache never hits** — cache keys too specific; add `restore-keys` without branch/hash.
- **Metric cardinality explosion** — unbounded labels kill your metrics backend.

## Examples

1. **"My GitHub pipeline is failing at the push-image step."** Route to
   `references/ci-cd-github-actions.md`: enable runner debug (`ACTIONS_RUNNER_DEBUG=true`),
   dump `github` context, verify `packages: write` + `id-token: write` permissions and OIDC
   trust policy, check cache-from/type=gha.
2. **"Prod p99 latency went 95ms → 1.9s after the 14:02 deploy."** Route to
   `references/performance-troubleshooting.md`: host sweep clean → TSA shows Runnable-dominant
   threads → check cgroup `cpu.max`/`nr_throttled` (throttling after replica increase). Fix the
   limit; re-measure.
3. **"Write a handoff doc for my on-call shift."** Route to `references/sre-oncall.md`: fill
   the shift-handoff template (active incidents, ongoing investigations, recent changes, known
   issues, upcoming events, escalation reminders).
4. **"Is `0 0 1,15 * 1` correct?"** Route to `references/cron-scheduling.md`: explain it means
   "1st, 15th OR every Monday" (~6 fires/mo), not "1st and 15th if Monday". Guard in-script.
5. **"Deploy to prod for the first time."** Route to `references/deployment-strategies.md`:
   run the pre-launch checklist, define rollback triggers, enable the feature flag, canary at
   5% → 25% → 50% → 100%, monitor for one week, then clean up the flag.

## Sources

Consolidated from the devops (38), reliability (14), operations (4), and ml-ops (1) skill
libraries. See `dedup-notes.md` for merge and drop decisions. Detail per sub-topic lives in
`references/`.
