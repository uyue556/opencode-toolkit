# SRE & On-Call

Source: `on-call-handoff-patterns` (reliability), `server-management` (reliability),
`pagerduty-automation` (reliability), `incident-response-incident-response` (devops).

## When to use
Taking or handing off an on-call shift, writing a handoff summary, setting up rotations,
onboarding on-call engineers, or managing pager/on-call automation.

## Handoff components

| Component | Purpose |
|---|---|
| Active incidents | What's currently broken |
| Ongoing investigations | Issues being debugged |
| Recent changes | Deployments, configs |
| Known issues & workarounds | Ops facts that save the next shift |
| Upcoming events | Maintenance, releases, expected traffic |

**Timing:** 30 min overlap. Outgoing: 15 min write doc + 15 min sync call. Incoming: 15 min
review + 15 min sync + 5 min verify alerting.

## Shift handoff template

```markdown
# On-Call Handoff: <Team>
**Outgoing**: @alice (dates)   **Incoming**: @bob (dates)   **Handoff Time**: <UTC>

## Active Incidents
- None currently active  (or: SEV2 payment degradation — link, status, next steps)

## Ongoing Investigations
1. **<Title> (TICKET)** — Status: Investigating/Monitoring; Impact; Context;
   Next steps (checkboxes); Resources (dashboards, threads).

## Resolved This Shift
- <Service outage> — duration; root cause; resolution; postmortem link; follow-up tickets.

## Recent Changes
| Service | Version | Time | Notes |
|---------|---------|------|-------|
- Configuration changes, infrastructure changes as a table too.

## Known Issues & Workarounds
1. <Issue> — Workaround; Ticket (P#).

## Upcoming Events
| Date | Event | Impact | Contact |

## Escalation Reminders
| Issue type | 1st escalation | 2nd escalation |
```

A **quick async handoff** keeps just TL;DR + watch list + recent + coming up + "I'm reachable
until X". A **mid-incident handoff** must add: current state (metrics + ETA), what we know,
what we've done, what needs to happen next, key people, communication status, and a
"please confirm you have access" checklist for the incoming engineer.

## Sync meeting agenda (15 min)

1. Active issues (5 min) — walk incidents, transfer context/theories.
2. Recent changes (3 min) — deployments, configs, regressions.
3. Upcoming events (3 min) — maintenance, traffic, releases.
4. Questions (4 min) — clarify, confirm access and alerting.

## Pre-shift checklist (condensed)

- Access: VPN, kubectl, DB read, log aggregator, PagerDuty installed+logged in.
- Alerting: schedule shows you primary; phone/Slack notifs; test alert received+acked.
- Knowledge: review past 2 weeks incidents, service changelog, critical runbooks, escalation
  contacts.
- Environment: charged hardware, quiet space, secondary contact if traveling.

## During-shift routine

Morning: check overnight alerts, dashboards for anomalies, P0/P1 tickets, skim incident
channels. Throughout: respond within SLA, document investigation progress, update team,
triage pages. End of day: hand off active issues, update docs, note items for next shift.

## Escalation guidelines

- **Immediate escalate:** SEV1 declared, data breach suspected, undiagnosed within 30 min,
  customer/legal escalation.
- **Consider escalate:** spans multiple teams, needs expertise you lack, business impact exceeds
  threshold, uncertain about next steps.
- **How:** page the escalation path, brief context in Slack, stay engaged until acknowledged,
  hand off cleanly — don't disappear.

## On-call best practices

Do: document everything; escalate early; take breaks (alert fatigue is real); keep handoffs
synchronous; test your setup before incidents.
Don't: skip handoffs; hero without escalating; ignore alerts; work sick; disappear.

## Server & process management principles

- Process tools: PM2 (Node clustering/reload), systemd (native), Docker/Podman (containers),
  K8s (orchestration). Goals: restart on crash, zero-downtime reload, use all cores, survive
  reboot.
- Monitor: availability (uptime/health), performance (response time/throughput), errors, and
  resources (CPU/memory/disk). Severity: critical = act now, warning = investigate soon,
  info = daily review.
- Logs: rotate, structured (JSON), correct levels, no sensitive data.
- Scaling: high CPU → horizontal; high memory → fix leak or add RAM; slow response → profile
  first; traffic spikes → autoscale.
- Health checks: HTTP 200 + DB connected + dependencies reachable + resources OK.
- Troubleshooting order: is it running → logs → resources → network → dependencies.
- Security: SSH keys only, firewall to needed ports, regular patches, env-var secrets, audit.

## PagerDuty automation notes

- Manage incidents (list/acknowledge/resolve), services, schedules/on-call, escalation
  policies, teams.
- Resolve the correct incident/service/schedule ID via search first — don't guess IDs.
- Acknowledge before resolving; keep an audit trail of state transitions.
- When modifying schedules or escalation policies, respect who is actually on call — changing a
  schedule mid-rotation without confirmation is how pages get dropped.
- Alert noise reduction: route by service, dedupe by incident key, cluster related alerts,
  throttle repeats — a pager that cries wolf trains people to ignore real pages.
