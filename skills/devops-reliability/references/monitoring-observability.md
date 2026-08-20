# Monitoring & Observability

Source: `observability-engineer` (reliability), `observability-and-instrumentation` (devops),
`grafana-dashboards` (devops), `distributed-tracing` (reliability),
`service-mesh-observability` (devops), `datadog-automation` (reliability),
`sentry-automation` (reliability), `pagerduty-automation` (reliability),
`monte-carlo-analyze-root-cause` (devops).

## When to use
Instrumenting code, designing monitoring stacks, building Grafana dashboards, adding
distributed tracing, defining alerting, automating Datadog/Sentry/PagerDuty, or investigating
why production misbehaves.

## The three pillars

| Signal | Answers | Cost profile |
|---|---|---|
| Metric | How often / how fast, in aggregate | Fixed per series; cheap |
| Trace | Where did time go across services | Per request; usually sampled |
| Log | What happened in this specific case | Per event; grows with traffic |

Rule of thumb: **metrics tell you *that*, traces tell you *where*, logs tell you *why***.

## Instrument as you build

1. **Define "working" before instrumenting** — write the 2–4 questions on-call will ask about
   the feature (e.g., "what fraction of payments succeed first try vs after retry?"). Every
   signal must answer one of them.
2. **Structured logs**: JSON with stable event names and machine-readable fields. No string
   interpolation of event data:
   ```typescript
   logger.warn({ event: 'payment_failed', paymentId: id, provider: 'stripe',
                 errorCode: err.code, attempt: n }, 'payment failed');
   ```
   Levels: `error` = invariant broken, act; `warn` = degraded but handled; `info` = significant
   business event; `debug` = off in prod by default.
3. **Correlation IDs are mandatory** — generate/accept a request ID at the boundary and attach
   to every log, span, and outbound call (`x-request-id`).
4. **Metrics**: RED for services (Rate, Errors, Duration — histogram, not average); USE for
   resources (Utilization, Saturation, Errors). Percentiles always, averages never.
5. **Cardinality is the failure mode** — labels from small fixed sets (route template, status
   class, provider). NEVER user IDs, URLs, error text, request IDs as labels.
6. **Distributed tracing** via OpenTelemetry (vendor-neutral); auto-instrumentation covers
   HTTP/gRPC/DB clients. Manual spans only around meaningful units of work; propagate context
   across every async boundary (headers, queue metadata). Sample head-based low by default,
   100% of errors if tail sampling available.
7. **Alerting** on symptoms, not causes: `error rate > 1% for 5m` pages; `CPU at 85%` is a
   dashboard. Two severities only (page vs ticket). Every alert is actionable, links a runbook,
   has a justified threshold, and was test-fired once.
8. **Verify telemetry itself**: force an error in staging → find it by requestId; send test
   traffic → confirm series; fire each new alert once.

## Golden signals & dashboards

Golden signals: latency (P50/P99), traffic (RPS), errors (5xx rate > 1%), saturation (> 80%).
Dashboard hierarchy: critical big-number stats on top → key trends → detailed tables/heatmaps.

### Grafana
- Panel types: stat (single value), time series, table (with `up` + organize transformation),
  heatmap (`format: tsbuckets` for latency).
- Use query variables (`label_values(kube_pod_info, namespace)`) and reference them in
  expressions for reusable dashboards.
- Alerts: `for: 5m`, frequency 1m, `noDataState`, notification channel.
- **Dashboard as code**: provision via file provider (`dashboards.yml`), or Terraform
  `grafana_dashboard { config_json = file(...) }`; keep in Git.
- Common patterns: infrastructure (CPU/mem/disk/IO/pods), database (QPS, pool usage, p50/95/99
  latency, repl lag, slow queries), application (request rate, error rate, percentiles, cache
  hit rate, queue length).

## Distributed tracing (Jaeger / Tempo)

- Trace = end-to-end request; span = one operation; context = metadata propagated between
  services; tags = filterable key-values; logs = timestamped span events.
- **Sampling**: 1–10% in production (100% dev). Probabilistic, rate-limiting, or parent-based
  adaptive (`ParentBased(root=TraceIdRatioBased(0.01))`).
- Jaeger queries: `service=my-service duration > 1s`; `service=my-service error=true
  tags.http.status_code >= 500`; use the dependency graph for topology + error/latency per edge.
- Tempo (Grafana): receiver config for jaeger+otlp; S3 backend for traces; query via Grafana.
- Context propagation headers: `traceparent: 00-<traceid>-<spanid>-01`, `tracestate`.
- Correlate logs with traces: put `trace_id` in every log line's `extra`.
- Best practices: sample appropriately, meaningful tags, propagate everywhere, log exceptions
  in spans, consistent op naming, monitor overhead (<1% CPU), alert on trace errors.
- Troubleshoot "no traces": collector endpoint, network, sampling config, app logs.
  "High latency overhead": lower sampling, batch span processor.

## PromQL patterns

```promql
# Request rate by service
sum(rate(http_requests_total[5m])) by (service)

# Error rate %
sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) * 100

# p95 latency
histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le, service))
```

## Managed tools (automation via MCP/API)

### Datadog (Rube/Composio MCP)
- Query metrics (`query_metrics`), search logs, manage monitors/dashboards, create events and
  downtimes, list hosts and traces. Monitor syntax mirrors PromQL; use tag filters; page results.
  Pitfalls: check monitor state before editing; downtime must reference the exact monitor ID;
  paginate long host/trace lists.

### Sentry (Rube MCP)
- Investigate issues/events, configure alert rules, track releases, monitor projects and
  teams, manage cron monitors. Resolve IDs by search first; use `id` from search results, not
  slugs, for mutation calls.

### PagerDuty (Rube MCP)
- Manage incidents (list/acknowledge/resolve), services, schedules & on-call, escalation
  policies, teams. Resolve the incident/service ID before mutating; acknowledge before resolve;
  when re-assigning on-call, respect the active schedule and escalation policy. Check
  "on-call patterns" in `sre-oncall.md` for rotation hygiene.

### Monte Carlo (data incidents)
For data-quality incidents (freshness, volume, schema, field drift, ETL failures):
1. Intake: get alert by ID, or search tables + alerts when no ID.
2. Map blast radius: upstream/downstream lineage (`get_asset_lineage`, `get_field_lineage`).
3. Investigate by issue type (freshness/volume/schema/ETL/query-change/field-anomaly).
4. Walk upstream lineage (stale upstream → size change → ETL issues).
5. Profile data with a DB MCP (sample rows around incident time, null rates).
6. Check code changes (`get_github_prs`, `get_query_changes`, `get_change_timeline`).
7. Synthesize root cause + evidence chain + impact + fix + prevention.
Rules: never fabricate numbers; follow the evidence; check the timeline ("X changed at T, anomaly
started at T+1"); don't expose internal MCONs/UUIDs; honor opt-outs; optionally run the
Troubleshooting Agent in parallel (async, idempotent — each forced rerun is billable).

## Observability stack selection (observability-engineer)

- Metrics: Prometheus ecosystem (PromQL + recording rules) with Grafana; InfluxDB for
  high-write TSDB; Datadog/New Relic/CloudWatch for managed.
- Logs: Loki (cloud-native, Grafana), ELK, Fluentd/Fluent Bit forwarding; structured + retention
  policies; no sensitive data.
- Tracing/APM: OpenTelemetry → Jaeger/Tempo/OTLP; Zipkin; AWS X-Ray for serverless.
- Alerting/incident: PagerDuty/Opsgenie with escalation; Slack/Teams; runbook automation;
  on-call rotation hygiene.
- Cost: monitor observability cost — retention tiers, sampling rate, high-cardinality series,
  multi-tier storage. Sampled data is cheaper than complete data you never query.
- Compliance: SOC2/PCI/HIPAA logging, audit trails, data residency — design telemetry data
  classification upfront.
