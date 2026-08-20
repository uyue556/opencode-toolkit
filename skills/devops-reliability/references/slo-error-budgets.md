# SLI / SLO / Error Budgets

Source: `slo-implementation` (reliability), `observability-monitoring-slo-implement` (devops),
`observability-engineer` (reliability).

## When to use
Defining reliability targets, measuring user-perceived reliability, implementing error budgets,
building SLO-based alerting, or reviewing whether a service is "good enough".

## Hierarchy

```
SLA — contract with customers
SLO — internal reliability target
SLI — actual measurement
```

## Define SLIs

Pick what you actually measure, then define the ratio over a window (typically 28d):

```promql
# Availability SLI: successful / total
sum(rate(http_requests_total{status!~"5.."}[28d]))
/
sum(rate(http_requests_total[28d]))

# Latency SLI: requests under 500ms / total
sum(rate(http_request_duration_seconds_bucket{le="0.5"}[28d]))
/
sum(rate(http_request_duration_seconds_count[28d]))
```

Also common: durability (successful writes / total writes), throughput, correctness.

## Set SLO targets

| SLO | Downtime/month | Downtime/year |
|---|---|---|
| 99% | 7.2 h | 3.65 d |
| 99.9% | 43.2 min | 8.76 h |
| 99.95% | 21.6 min | 4.38 h |
| 99.99% | 4.32 min | 52.56 min |

Consider user expectations, business needs, current performance, and the *cost* of reliability.
Never aim for 100%. Start with user-facing services; use multiple SLIs (availability, latency).

## Error budgets

- `Error Budget = 1 - SLO target` (e.g., 99.9% → 0.1% = 43.2 min/month).
- Policy drives behavior:
  - budget 100% → normal velocity
  - ≤ 50% → postpone risky changes
  - ≤ 10% → freeze non-critical changes
  - 0% → feature freeze, focus on reliability

## Implementation (Prometheus recording rules)

```yaml
groups:
  - name: sli_rules
    interval: 30s
    rules:
      - record: sli:http_availability:ratio
        expr: |-
          sum(rate(http_requests_total{status!~"5.."}[28d])) / sum(rate(http_requests_total[28d]))
      - record: sli:http_latency:ratio
        expr: |-
          sum(rate(http_request_duration_seconds_bucket{le="0.5"}[28d])) / sum(rate(http_request_duration_seconds_count[28d]))
  - name: slo_rules
    interval: 5m
    rules:
      - record: slo:http_availability:error_budget_remaining
        expr: |-
          (sli:http_availability:ratio - 0.999) / (1 - 0.999) * 100
      - record: slo:http_availability:burn_rate_5m
        expr: |-
          (1 - (sum(rate(http_requests_total{status!~"5.."}[5m])) / sum(rate(http_requests_total[5m])))) / (1 - 0.999)
```

## Multi-window burn-rate alerting

Combining a long and a short window cuts false positives. Two standard burn tiers:

```yaml
- alert: SLOErrorBudgetBurnFast
  expr: |
    slo:http_availability:burn_rate_1h > 14.4
    and
    slo:http_availability:burn_rate_5m > 14.4
  for: 2m
  labels: { severity: critical }

- alert: SLOErrorBudgetBurnSlow
  expr: |
    slo:http_availability:burn_rate_6h > 6
    and
    slo:http_availability:burn_rate_30m > 6
  for: 15m
  labels: { severity: warning }

- alert: SLOErrorBudgetExhausted
  expr: slo:http_availability:error_budget_remaining < 0
  for: 5m
  labels: { severity: critical }
```

Numbers to remember: 14.4× = error budget fully consumed in 2h for a 30d window; 6× = consumed
in 5h. Tune thresholds to your SLO window.

## SLO dashboard

Four blocks: current compliance vs target, error budget remaining (progress bar), SLI trend
(28 days), burn-rate analysis. Example queries:
```promql
sli:http_availability:ratio * 100                      # compliance %
slo:http_availability:error_budget_remaining           # remaining %
```

## Review cadence

- Weekly: compliance, budget status, trend, incident impact.
- Monthly: achievement, budget usage, postmortems, SLO adjustments.
- Quarterly: SLO relevance, target changes, process/tooling improvements.

## Best practices

1. Start with user-facing services; 2. multiple SLIs; 3. achievable targets (not 100%);
4. multi-window alerts to reduce noise; 5. track budget consistently; 6. review regularly;
7. document SLO decisions; 8. align with business goals; 9. automate reporting;
10. use SLOs for prioritization.
