# Incident Response & Runbooks

Source: `incident-responder` (reliability), `incident-runbook-templates` (devops),
`incident-response-incident-response` (devops), `devops-troubleshooter` (devops),
`incident-response-smart-fix` (devops).

## When to use
An active incident (service down, degraded, or alert storm), writing runbooks, triaging,
escalating, or restoring service.

## First 5 minutes

1. **Assess severity & impact** — user impact (count, geography, journeys), business impact
   (revenue, SLA, brand), system scope (services, dependencies, blast radius), external factors
   (peak hours, events, regulation).
2. **Establish incident command** — one Incident Commander (decision-maker), a Communication
   Lead (stakeholders), a Technical Lead (investigation). Set up the war room.
3. **Stabilize with quick wins** — throttle traffic, flip feature flags, enable circuit
   breakers; assess rollback (recent deploys/config/infra changes); scale resources.

## Severity classification

| Severity | Impact | Response | Communication |
|---|---|---|---|
| P0 / SEV1 | Complete outage or security breach | immediate, 24/7; ack < 15 min; resolve < 1h | every 15 min, exec notified |
| P1 / SEV2 | Major degradation, significant user impact | ack < 1h; resolve < 4h | hourly, status page |
| P2 / SEV3 | Minor functionality, limited impact | ack < 2h; resolve < 24h | as needed, internal |
| P3 / SEV4 | Cosmetic, no user impact | next business day | ticketing |

## Runbook structure (write these before incidents)

1. Overview & impact · 2. Detection & alerts · 3. Initial triage · 4. Mitigation steps ·
5. Root cause investigation · 6. Resolution procedures · 7. Verification & rollback ·
8. Communication templates · 9. Escalation matrix.

Initial classification: all requests failing → service down (section 4.1); high latency →
DB/dependency; partial failures → code bug; error spike → traffic surge.

## Service-outage mitigation playbook

- **Service completely down:** check pods → logs (crash-looping) → rollout history → ROLLBACK
  if recent deploy suspect (`kubectl rollout undo`) → scale up if resource-constrained →
  verify (`kubectl rollout status`).
- **High latency:** check DB connections (pool metrics) → find slow queries
  (`pg_stat_activity` where duration > 5s) → kill long-running queries
  (`pg_terminate_backend`) → check external dependency latency → enable circuit breaker.
- **Partial failures:** group error patterns (`kubectl logs ... | grep -i error | sort | uniq -c
  | sort -rn`) → check Sentry → disable the offending feature via flag → audit recent data
  changes.
- **Traffic surge:** `kubectl top pods` → scale horizontally → enable rate limiting → if
  attack, apply NetworkPolicy blocking suspicious IP ranges.

## Rollback procedures

```bash
kubectl rollout undo deployment/<svc> -n <ns>              # k8s
kubectl rollout undo deployment/<svc> --to-revision=3      # specific revision
# feature flag off / db migration rollback / redeploy previous image tag, per platform
```

Verify recovery: health endpoint + error rate back to normal + p99 acceptable + smoke test
critical flows.

## Investigation protocol (observability-driven)

- Traces: OpenTelemetry/Jaeger for request flow. Metrics: Prometheus/Grafana/Datadog for
  patterns. Logs: ELK/Loki/Splunk for error patterns. APM + RUM for user impact.
- SRE techniques: error-budget/burn-rate analysis, **change correlation** (deployment
  timeline + config + infra), dependency mapping, cascading-failure analysis (circuit-breaker
  states, retry storms, thundering herds), capacity analysis.
- Advanced: chaos-engineering results, A/B/flag correlation, DB (query perf, connection pools,
  repl lag), network (DNS, LB health, CDN), security (DDoS, auth, certs).

## Communication standards

- Internal: status every 15 min during active incident; technical detail for eng; business
  impact/ETA for execs; coordinate cross-team.
- External: status page, support briefing, proactive outreach to major customers, regulatory
  notification if required.
- Document everything: timeline with timestamps, decision rationale, impact metrics,
  communication log.

## Resolution & recovery

Fix path: minimal viable fix → risk assessment (side effects, rollback capability) → staged
rollout with monitoring → validation → enhanced monitoring during recovery. Confirm all SLIs
back to normal, user experience validated, dependencies healthy, capacity headroom exists.

## Post-incident

Within 24h: keep monitoring, adjust alerting, collect data (metrics export, logs, timeline),
team debrief. Then blameless postmortem (see `postmortems.md`) with action items and owners.

## Multi-agent / smart-fix pattern (light)

For complex incidents, split work into parallel tracks (one agent per hypothesis) with a single
coordinator that reconciles findings; mandate verification-before-completion: never close an
investigation on "log said done" — reconcile against real state.

## Devops troubleshooter hints

- Rapid triage: reproduce → isolate (recent change? dependency? scale?) → instrument → fix →
  verify.
- Common layers to check in order: application logs, container/k8s state, network/DNS,
  resources, database, cloud provider status, security/compliance.
- Never restart/redeploy blindly to "fix" an unknown issue without first collecting evidence.
