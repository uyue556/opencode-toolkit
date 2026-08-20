# Postmortems (Blameless)

Source: `postmortem-writing` (reliability), `incident-response-smart-fix` (devops, RCA
discipline), `brendangregg-use-tsa` (devops, evidence discipline).

## When to use
After any SEV1/SEV2, customer-facing outage > 15 min, data loss or security incident, a
near-miss that could have been severe, a novel failure mode, or an incident requiring unusual
intervention.

## Blameless culture

| Blame-focused | Blameless |
|---|---|
| "Who caused this?" | "What conditions allowed this?" |
| "Someone made a mistake" | "The system allowed this mistake" |
| Punish individuals | Improve systems |
| Hide information | Share learnings |
| Fear of speaking up | Psychological safety |

## Timeline

Day 0: incident occurs → Day 1–2: draft doc → Day 3–5: meeting → Day 5–7: finalize + create
tickets → Week 2+: action items done → Quarterly: review patterns across incidents.

## Standard postmortem structure

1. **Executive summary** — what happened, impact (customers, revenue, tickets, data).
2. **Timeline (all times UTC)** — chronological table: deploy/alert/ack/investigation/
   decision/rollback/resolution.
3. **Root cause analysis** — proximate cause; contributing factors; 5 Whys; a simple system
   diagram. Evidence for every step.
4. **Detection** — what worked, what didn't, detection gap (how long between cause and alert).
5. **Response** — what worked / could be improved.
6. **Impact** — customer, business (revenue, support cost, eng-hours), technical.
7. **Lessons learned** — what went well, went wrong, where you got lucky.
8. **Action items** — table: Priority | Action | Owner | Due date | Ticket. No orphan items.
9. **Appendix** — graph links, related incidents, references.

### 5 Whys template

```
Why #1: Why did the service fail?        → Answer + evidence
Why #2: Why were connections exhausted?  → Answer + evidence
... (5 total) → Root causes identified (primary/secondary/tertiary)
→ Systemic improvements (prevention / detection / mitigation)
```

### Quick postmortem (minor incidents)

Keep it short: What happened / Timeline / Root cause / Fix (immediate + long-term) / Lessons.

## Facilitation guide (60 min)

- Opening (5): remind everyone of blameless culture.
- Timeline review (15): chronological walkthrough, clarify, find gaps.
- Analysis (20): what failed, why, what conditions allowed it, what would have prevented it.
- Action items (15): brainstorm, prioritize, assign owners/dates.
- Closing (5): summarize, confirm owners, schedule follow-up.

Tips: keep on track, redirect blame to systems, encourage quiet participants, document
dissenting views, time-box tangents.

## Anti-patterns

| Anti-pattern | Problem | Better |
|---|---|---|
| Blame game | Shuts down learning | Focus on systems |
| Shallow analysis | Doesn't prevent recurrence | Ask why 5 times |
| No action items | Waste of time | Concrete next steps |
| Unrealistic actions | Never completed | Scope to achievable tasks |
| No follow-up | Actions forgotten | Track in ticketing |

## Do & Don't

Do: start immediately (memory fades); be specific (exact times, exact errors); include graphs;
assign owners; share widely.
Don't: name and shame — ever; skip small incidents (they reveal patterns); make it a blame doc;
create busywork; skip follow-up.

## Evidence discipline (from USE/TSA)

- Every claim in an RCA must trace to a command and its output. Record what you ruled out —
  exoneration narrows the search.
- Keep falsifiable hypotheses on record even when ruled out.
- Confirm the causal chain: trigger → mechanism → symptom, every link evidenced. "Would removing
  this cause prevent recurrence? Does it explain all primary evidence?"
- "Deployed" is not "verified": re-measure after the fix with the same instruments.
