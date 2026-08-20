# Product Analytics & Tracking

Synthesized from: `analytics-tracking`, `analytics-product`, `segment-cdp`, `segment-automation`,
`posthog-automation`, `mixpanel-automation`, `amplitude-automation`, `monte-carlo-monitor-creation`,
`monte-carlo-validation-notebook`.

## ToC

1. [Measurement readiness & strategy](#measurement-readiness--strategy)
2. [Event model design](#event-model-design)
3. [Identity resolution](#identity-resolution)
4. [Conversion & attribution](#conversion--attribution)
5. [Validation & governance](#validation--governance)
6. [CDP implementation (Segment)](#cdp-implementation-segment)
7. [Platform automation](#platform-automation)
8. [Data monitoring (Monte Carlo)](#data-monitoring-monte-carlo)

## Measurement readiness & strategy

Track for decisions, not curiosity. Start with questions and work backwards. Score measurement
readiness (0–100) across: decision alignment, event model clarity, data accuracy & integrity,
conversion definition quality, attribution & context, governance & maintenance. Below threshold →
fix instrumentation before relying on analytics.

## Event model design

- Events represent **meaningful state changes**, not page views or button clicks as an end.
- Naming: Object + Action convention, e.g. `User Signed Up`, `Order Completed`; consistent casing,
  no dynamic names.
- Properties = context, not noise: include `order_id`, `total`, `currency`, `products[]`, `utm_source`,
  etc. Define required vs optional, types, and allowed values (enum) per event.
- Tracking plan as contract: YAML/JSON schema per event + identify traits; enforce with Protocols-like
  validation and TypeScript types so the compiler catches missing required props.
- Events: `page_view`/`track`, `identify` (user traits), `group` (company), `alias` (identity merge).
- **GA4/GTM**: implement consistently; audit event names for casing/lowercase drift; verify every event
  fires with the expected schema before launch.

## Identity resolution

- Track anonymous users first (anonymousId auto-generated), then `identify(userId, traits)` on
  signup/login to merge pre-auth history.
- `alias(prevId, newId)` to link identities (e.g. pre-signup email to permanent user ID).
- B2B: `group(companyId, ...)` associates users with an org.
- Sharp edges: anonymous ID persists until explicit reset — always `analytics.reset()` on logout;
  track calls without identify remain anonymous; timestamps must include timezone.

## Conversion & attribution

- Define conversions explicitly (what counts, counting rules — per user, per session, once vs every).
- UTM discipline: agree parameter semantics; capture consistently; avoid case/padding drift.
- Attribute honestly: first-touch/last-touch/multi-touch; document which model is used and why.

## Validation & governance

- Required validation before launch: event fires correctly, properties present, schema valid, no PII
  blast radius (don't send PII to all destinations — restrict per-destination).
- Privacy/compliance: consent-gating before tracking; data retention; GDPR export/deletion paths.
- Common failure modes: missing `reset()` on logout, hardcoded write keys in clients, oversized
  property values, inconsistent casing, dynamic event names, tracking before consent.
- Deliverables: measurement strategy summary, tracking plan, conversion list, implementation notes.

## CDP implementation (Segment)

- Browser: analytics.js — `analytics.identify(id, traits)`, `analytics.track(event, props)`,
  `analytics.group(id, traits)`, `analytics.page()`, `analytics.alias(prev, new)`.
- Server-side (Node.js): `analytics.track/identify/group`; batch events; write key is client-visible
  (by design) — use server-side keys for privileged destinations.
- HTTP tracking API: strict size limits; schema validation; dead-letter failures.
- Device mode bypasses Protocols blocking; events may be lost on page navigation — add retries/buffering.
- Destinations configuration: map events to destinations; filter PII per destination; monitor delivery.

## Platform automation

Tool-specific automation via MCP/Rube-style tooling (setup & rate-limit notes in each skill):

- **PostHog**: capture/list events, feature flags, projects, user profiles; pagination + ID resolution.
- **Mixpanel**: aggregate events, segmentation queries, funnels, user profiles, cohorts, JQL/Insights;
  expression syntax + pagination; avoid >X events per batch.
- **Amplitude**: send events, user activity, identify users, cohorts, event categories; async ops + retries.
- **Segment (automation)**: track/identify/group/page/alias, batch operations, source management.
- Always: confirm event/ID semantics with the user; handle rate limits; check the target environment
  (prod vs dev) before sending test data.

## Data monitoring (Monte Carlo)

- Monitor types: row count, freshness, schema, volume, custom SQL (e.g. NULL-rate, uniqueness,
  segmentation distribution).
- Monitors-as-code: validate understanding → identify tables/columns → assign domain/ownership → ask
  about scheduling → confirm → create → present results. Output MaC YAML for CI/CD deployment.
- Validation notebooks: for dbt PR changes, generate before/after comparison queries (row count, NULL
  rates, changed-field distribution, time-axis continuity) as a parameterized notebook; run per PR to
  catch regressions before merge (see `sql-postgres.md` validation patterns).
