# Revenue Operations, Sales & CRM Automation

Design and optimize the revenue engine: lead lifecycle, scoring, routing, handoffs, pipeline hygiene, and CRM automation. Sources: `revops`, `sales-automator`, `pipedrive-automation`, `zoho-crm-automation`, `bamboohr-automation`.

## Core Principles

- **Single source of truth**: one system of record for every lead/account; pick a CRM as canonical and sync everything to it.
- **Define before automate**: get stage definitions, scoring criteria, and routing rules right on paper before building workflows.
- **Measure every handoff**: marketing→sales, SDR→AE, AE→CS — each needs an SLA, tracking, and an accountable owner.
- **Revenue team alignment**: marketing, sales, and CS must agree on definitions. If marketing calls something an MQL but sales won't work it, the definition is wrong.

## Lead Lifecycle Framework

| Stage | Entry criteria | Exit criteria | Owner |
|---|---|---|---|
| **Subscriber** | Opts in to content | Provides company info / shows engagement | Marketing |
| **Lead** | Identified contact | Meets minimum fit | Marketing |
| **MQL** | Passes fit + engagement threshold | Sales accepts/rejects within SLA | Marketing |
| **SQL** | Sales qualifies via conversation | Opportunity created or recycled | Sales (SDR/AE) |
| **Opportunity** | BANT confirmed | Closed-won/lost | Sales (AE) |
| **Customer** | Closed-won | Expands/renews/churns | CS |
| **Evangelist** | High NPS, referral activity | Program participation | CS/Marketing |

**MQL requires BOTH fit AND engagement.** Fit = matches ICP (size, industry, role, stack). Engagement = buying intent (pricing page, demo request, multiple visits). Neither alone suffices.

**MQL→SQL handoff SLA:** alert rep instantly → contact within 4 business hours → qualify/reject within 48 hours → rejected leads recycle to nurture with reason code.

## Lead Scoring

### Dimensions

- **Explicit (fit)** — who they are: company size, industry, revenue, title, seniority, tech stack, geography.
- **Implicit (engagement)** — what they do: page visits (pricing/demo weighted), content downloads, email engagement, product usage (PLG).
- **Negative** — competitor email domains, student/personal email, unsubscribes, spam complaints, job-title mismatches.

### Building a scoring model

1. Define ICP attributes and weight them.
2. Identify high-intent behaviors from closed-won data.
3. Set point values per attribute/behavior.
4. Set MQL threshold (typically 50–80 / 100).
5. **Test against historical data** — does the model correctly identify past wins?
6. Launch, measure, recalibrate (monthly for PLG, quarterly for enterprise).

**Point-value references:** demo request +30, pricing page +20 (decays −5/wk), trial signup +25, C-suite title +25, target industry +20, uses competitor +10, spam complaint −100, competitor domain −50, student email −30, careers-page visitor −30.

**Threshold calibration:** pull 6–12 mo closed-won data, retroactively score, find the natural breakpoint, set threshold just below where 80% of wins would have scored. Watch: MQL→SQL acceptance <30%, sales rejecting as "not ready," high scorers not converting.

### Common scoring mistakes

Weighting content downloads too heavily (research ≠ buying intent), no negative scoring, set-and-forget (recalibrate quarterly), scoring all page visits equally.

## Lead Routing

| Method | Best for |
|---|---|
| Round-robin | Equal territories, similar deal sizes |
| Territory-based | Regional teams, industry specialists |
| Account-based (ABM) | Named accounts → named reps |
| Skill-based | Deal complexity, product line, language |

**Essentials:** route to the most specific match first, fall back to general; always have a fallback owner (unassigned leads go cold fast); round-robin should respect rep capacity/availability; log every routing decision.

**Routing decision tree:** named/target account → account owner; ACV >$50K → enterprise AE; PLG signup with team usage → PLG specialist; territory match → territory owner; default → round-robin with 1-hour SLA.

**Speed-to-lead:** 5 min = 21x more likely to qualify; 30 min = 10x drop; 24 hr = cold. Implement instant alert + auto-task with 5-min SLA + escalation chain (rep at 5min → backup at 15 → manager at 30 → reassign at 60).

## Pipeline Stage Management

| Stage | Required fields | Exit criteria |
|---|---|---|
| Qualified | contact, company, source, fit | Discovery scheduled |
| Discovery | pain, current solution, timeline | Needs confirmed, demo scheduled |
| Demo/Evaluation | tech requirements, decision makers | Positive eval, proposal requested |
| Proposal | pricing, terms, stakeholder map | Proposal reviewed |
| Negotiation | redlines, approval chain, close date | Terms agreed, contract sent |
| Closed Won | signed contract, payment terms | Handoff to CS |
| Closed Lost | loss reason, competitor | Post-mortem logged |

**Stage hygiene:** required fields per stage (block advancement), stale-deal alerts (2x average days), stage-skip detection, close-date discipline (pushes require reason).

**Pipeline metrics:** stage conversion rates, time in stage, pipeline velocity, coverage ratio (target 3–4x quota), win rate by source (20–30%).

## Deal Desk

Trigger when: ACV >$25K, non-standard terms, multi-year contracts, discounts beyond tiers, custom legal. Approval tiers: standard auto → 10–20% off = sales manager → 20–40% = VP Sales → 40%+ or custom = deal desk → multi-year/enterprise = finance + legal. Document every exception; if everyone asks for the same exception, make it standard.

## Data Hygiene & Enrichment

- **Dedup matching keys**: email domain + company name + phone. Merge priority: CRM wins; most recent activity wins for fields. Run weekly.
- **Required-fields enforcement**: block stage advancement if empty; use progressive profiling.
- **Enrichment**: Clearbit (real-time), Apollo (contacts + sequences), ZoomInfo (enterprise).
- **Quarterly audit**: merge duplicates, validate email deliverability, archive 12+ mo-inactive, audit stage distribution, spot-check enrichment accuracy.

## RevOps Metrics Dashboard

Lead→MQL 5–15%; MQL→SQL 30–50%; SQL→Opportunity 50–70%; pipeline velocity = (#deals × avg deal size × win rate) / avg cycle; CAC with LTV:CAC > 3:1; speed-to-lead <5 min; win rate 20–30%.

Three views: marketing (volume, MQL rate, attribution, cost/MQL), sales (pipeline value, stage conversion, velocity, forecast accuracy), executive (CAC, LTV:CAC, revenue vs target, coverage).

## CRM Automation (HubSpot / Salesforce / Zapier)

**Essential automations:** lifecycle stage auto-update, task creation on handoff, SLA alerts, deal-stage triggers (proposal send, forecast update, CS notify on close).

**Common recipes:**
- MQL alert: rotate owner, email + Slack notify, create follow-up task (4-hr SLA).
- SLA escalation: 12h warning → 24h manager alert → 48h reassign.
- Auto-MQL on score threshold, suppress from nurture.
- Meeting booked → notify AE with context, update stage.
- Closed-won → handoff to CS (update stage, assign CS owner, kickoff task, welcome sequence, remove from sales).
- Stale-deal detection: 2x average stage time → task + manager escalation.
- Recycled lead re-entry: reset engagement score (keep fit), lower-frequency nurture, re-trigger on re-score.
- Daily lead activity digest to owners.

**Zapier cross-tool:** new lead → CRM + Slack + task; meeting booked → CRM + prep email; deal closed → onboarding stack; score crosses threshold → retargeting + SDR sequence; SLA breach → multi-channel alert; weekly pipeline digest.

**Platforms:** HubSpot (workflows), Salesforce (Flows + custom Rep Assignment object for round-robin), Calendly/SavvyCal (round-robin scheduling, criteria-based meeting routing, no-show workflows).

## Tool-Specific Automation (Rube MCP / Composio)

For Pipedrive, Zoho CRM, and BambooHR via Rube MCP (Composio):

- **Always** call `RUBE_SEARCH_TOOLS` first to get current tool schemas — never hard-code tool names.
- Verify connection ACTIVE via `RUBE_MANAGE_CONNECTIONS` with the right toolkit before running workflows.
- **Pipedrive**: search orgs/persons before creating to avoid duplicates; resolve IDs; watch pagination and rate limits; deal→contact→org link sequence.
- **Zoho CRM**: list modules + get field definitions first; learn search-criteria syntax; manage pagination.
- **BambooHR**: employee CRUD, time-off, benefits, dependents; use incremental sync patterns and ID resolution.

**Common patterns:** ID resolution (search before create), incremental sync, time-off workflow (request → approval → calendar), known pitfalls around ID formats and parameter quirks.
