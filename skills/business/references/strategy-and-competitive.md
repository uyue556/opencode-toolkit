# Strategy & Competitive Analysis

Strategy frameworks, macro-environment audits, competitive positioning, moat assessment, and AI-disruption analysis. Sources: `osterwalder-canvas-architect`, `kotler-macro-analyzer`, `moatmri`, `competitive-landscape`, `competitor-tracking`, `competitor-alternatives`, `business-analyst`.

## Business Model Canvas (Osterwalder)

Build and audit a 9-block canvas iteratively — do not fill all blocks in one pass.

**Step 1 — Value Proposition ↔ Customer Segments lock.** Define these two first and make them logically consistent: each segment must have a clear reason the proposition is valuable to *them*.

**Step 2 — Structural design.** Build Channels, Customer Relationships, Key Activities, Key Resources, and Key Partners to *serve* the locked VP/segment pair.

**Step 3 — Financial consistency check.** Every Key Activity must have a corresponding Cost Structure entry; every Revenue Stream must map to a real customer segment. If a revenue stream has no segment, it is fiction.

**Checks:**
- Every activity accounted for in cost structure.
- Premium positioning → high-touch activities and matching cost structure; a "premium identity" claim with commodity execution is inconsistent.
- MVP: run an iterative pass before pivoting; re-validate the core lock, not just peripheral blocks.

**Limitations:** validates logical consistency, not market demand or financial viability.

## PESTEL / SWOT Strategic Audit (Kotler)

Use for market-entry research or periodic strategic audits.

1. **Gather real-time macro data** via search: GDP, inflation, central-bank rates, regulations, and policy shifts for the *specific target region*. Generic analysis without region-specific numbers is a failure.
2. **PESTEL mapping**: categorize findings into Political, Economic, Social, Technological, Environmental, Legal.
3. **SWOT synthesis**: macro trends → Opportunities & Threats; internal/user data → Strengths & Weaknesses. Link every SWOT point back to a PESTEL finding for logical continuity.

**Example trigger:** "Kotler-style strategic audit for a renewable-energy startup entering Eastern Europe, focusing on regulatory shifts and green energy subsidies."

## Moat & AI-Disruption Analysis (MoatMRI)

When asked "is my business at risk from AI / where am I exposed / what do I do in 90 days."

**Step 1 — Inputs:** industry, entity type, optional target name.

**Step 2 — 10-vector pressure map (score 0–10 each):**

| # | Vector | What to measure |
|---|---|---|
| 1 | labor_substitution | Roles directly automatable |
| 2 | customer_interface | How AI changes customer reach |
| 3 | knowledge_commoditization | Does AI commoditize the expertise sold |
| 4 | pricing_pressure | Cheaper AI-native competitors undercut |
| 5 | supply_chain_automation | Input costs / supplier changes |
| 6 | data_moat | Proprietary data AI can't replicate |
| 7 | trust_relationship_moat | Loyalty protecting against displacement |
| 8 | distribution_channel_disruption | New channels bypassing the entity |
| 9 | regulatory_compliance_exposure | AI alters regulatory/liability landscape |
| 10 | decision_speed_gap | AI accelerates decisions against them |

For each: score, headline, near-term (12 mo), far-term (3 yr). Aggregate = mean; flag any ≥7 critical. Score **all** vectors before averaging — don't stop at the obvious ones. Don't conflate data_moat with trust_relationship_moat.

**Step 3 — AI front-door takeover storyboard** (6 steps): entry point → wedge (first 10% of market) → acceleration (what compounds) → tipping point → aftermath → survivor profile.

**Step 4 — 90-day counterstrike plan** in three tracks: Days 0–30 immediate defense (what to stop/protect); 31–60 intelligence-layer build (data/relationships to fortify); 61–90 offensive positioning (turn AI pressure into a weapon). Track C must be actionable within 90 days, not aspirational.

## Competitive Landscape Analysis

### Competitor taxonomy

- **Direct**: same category, same problem, same buyer.
- **Secondary/Indirect**: different solution, same problem (e.g., Calendly vs. personal assistant).
- **DIY/Status quo**: build-it-yourself, open source, "just use a script" — often your largest competitor by volume.
- **Platform**: cloud providers / all-in-one suites that absorb your category.

### Landscape mapping document

1. Competitor profiles (company, product, target market, positioning).
2. Feature matrix (core features compared).
3. Pricing comparison (tiers, model, enterprise signals).
4. Honest strengths/weaknesses.
5. Trajectory (funding, growth signals, strategic direction).

### What to track (competitor-tracking)

- **Product/features**: changelogs, releases, integrations, API changes (weekly/monthly).
- **Pricing**: pricing-page changes (use archive.org), new tiers, free-tier changes, usage-vs-seat shifts.
- **Positioning**: homepage headline, "who it's for," comparison pages, case studies — compare vs. 6 months ago.
- **Content**: blog frequency/topics, doc quality, SEO keywords, gaps you can exploit.
- **Community/traction**: GitHub stars/forks growth, issue response, Discord/Slack counts, Reddit/HN sentiment.

### Sentiment signals

- **Churn signals (opportunity)**: "migrating away from [X]", "alternative", "frustrated with", "canceling".
- **Praise signals (learn)**: "love [X]'s [feature]", "just works".
- **Feature gaps**: "wish [X] had", "doesn't support".

### Battlecards

Structure: (1) competitor overview; (2) when we win; (3) when we lose; (4) common objections + responses; (5) differentiation (technical, pricing, support, community); (6) landmines (questions that favor you).

**Refresh cadence:** major competitors monthly, minor quarterly, emerging as needed. Update triggers: competitor feature launch, pricing change, your own ship that changes the comparison, new sales objections.

### Responding to competitor moves

- **Always respond**: false claims about you, targeting your customers, major positioning shift.
- **Consider**: competitor launches a feature you have, enters your core market, crisis creates opportunity.
- **Usually don't**: minor parity announcements, their internal issues, petty shots.

## Competitor / Alternative Pages (SEO + conversion)

Build comparison pages that rank for competitive terms, help evaluators decide, and position your product honestly.

**Core principles**: honesty builds trust (acknowledge competitor strengths), depth over surface (explain *why* differences matter), help them decide (state who each is for), and modular content (centralized competitor data, single source of truth).

### Four page formats

1. **[Competitor] Alternative (singular)** — "switching from X" intent. Structure: why people leave X → you as the alternative → detailed comparison → who should/shouldn't switch → migration path → social proof → CTA.
2. **[Competitor] Alternatives (plural)** — early research intent. Include **4–7 real alternatives**; genuinely helpful pages rank better. You first, but positioned among real options.
3. **You vs [Competitor]** — direct comparison intent. TL;DR first, at-a-glance table, category-by-category detail, who each is best for, switcher testimonials, migration support.
4. **[Competitor A] vs [Competitor B]** — two competitors, you introduce yourself as the third option. Earn trust through fairness.

### Index pages

Maintain three hubs: alternatives index, alternatives-roundup index, and vs-comparisons index. Cross-link indexes ↔ individual pages; keep "last updated" dates; sort by search volume or category.

### Centralized competitor data

One YAML/MD file per competitor with: positioning, pricing (tiers/free tier/enterprise), features rated 1–5, honest strengths & weaknesses, best-for / not-ideal-for, common complaints (from reviews), migration notes. Do the same for your own product — honestly. Pages then pull from this data so updates propagate everywhere.

### Comparison tables

Go **beyond checkmarks**: "Full support with [detail]" vs. "Basic support, [limitation]". Organize by category (core, collaboration, integrations, security, support). Include paragraph comparisons, not just tables — explain the why.

### Research process

Sign up for trials and use products yourself; mine G2/Capterra/TrustRadius themes; interview customers who switched; track their changelogs. Refresh: quarterly verify pricing/features, annual full refresh.

### SEO considerations

- Keywords by format: "X alternative / alternatives / best X alternatives", "[You] vs [X]", "X vs Y".
- Internal linking between related comparison pages.
- FAQ schema markup for common comparison questions.

## Strategic KPI Frameworks (from business-analyst)

- **North Star**: one metric capturing the business-model thesis (e.g., NRR for subscription SaaS, blended LTV/CAC for D2C). It should be derivable from funnel + revenue model, move slowly, and trade off correctly.
- **OKR / balanced scorecard**: hierarchy of strategic → tactical → operational KPIs with update cadence (monthly/quarterly for execs, weekly for managers, real-time for teams).
- **SMART KPIs**: Specific, Measurable, Achievable, Relevant, Time-bound.
