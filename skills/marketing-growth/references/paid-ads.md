# Paid Ads Reference

Campaign setup, platform selection, creative, targeting, retargeting, optimization, performance analysis, and cross-channel budget allocation.

## Table of Contents
1. Before Starting
2. Platform Selection
3. Campaign Structure
4. Ad Copy Frameworks
5. Audience Targeting
6. Creative Best Practices
7. Optimization & Metrics
8. Retargeting
9. Reporting
10. Ad Campaign Analyzer (budget decisions)
11. Competitor Ad Intelligence (see competitive-research.md)

---

## 1. Before Starting

Gather: **Goals** (objective, target CPA/ROAS, budget, constraints), **Product & offer** (what, landing page URL, compelling elements), **Audience** (ideal customer, problem, search/interest signals, existing customer data for lookalikes), **Current state** (past performance, pixel/conversion data, funnel rates, existing creative).

---

## 2. Platform Selection

| Platform | Best for | Use when |
|---|---|---|
| **Google Ads** | High-intent search, capturing demand | People actively search; commercial-intent keywords; bottom-funnel. Types: Search, Performance Max, Display, YouTube, Demand Gen. |
| **Meta (FB/IG)** | Demand gen, visual products | Visual appeal; creating demand; strong creative; retargeting pools. Types: Advantage+ Shopping, Lead Gen, Conversions, Traffic, Engagement. |
| **LinkedIn** | B2B decision-makers | Selling to businesses; job-title/company targeting; higher price points justify CPCs ($8–15+). Types: Sponsored Content, Message Ads, Lead Gen Forms, Document Ads, Conversation Ads. |
| **Twitter/X** | Tech, real-time relevance | Audience active on X; timely content; lower CPMs beat precision. |
| **TikTok** | Younger (18–34), viral creative | Native-feeling video capacity; brand awareness. |

---

## 3. Campaign Structure

```
Account
├── Campaign: [Objective] - [Audience/Product]
│   ├── Ad Set: [Targeting variation]  → Ad 1, Ad 2, Ad 3 (creative variations)
```

Naming: `[Platform]_[Objective]_[Audience]_[Offer]_[Date]` e.g. `META_Conv_Lookalike-Customers_FreeTrial_2024Q1`.

**Budget:** testing phase 70% proven / 30% new. Scaling: consolidate into winners; increase 20–30% at a time; wait 3–5 days between increases for algorithm learning.

---

## 4. Ad Copy Frameworks

**PAS (Problem-Agitate-Solve):** problem statement → agitate pain → introduce solution → CTA.
**BAB (Before-After-Bridge):** painful current state → desired future → your product as bridge.
**Social proof lead:** impressive stat/testimonial → what you do → CTA.

**Headlines — Search:** `[Keyword] + [Benefit]`, `[Action] + [Outcome]`, question, `[Number] + [Benefit]`.
**Headlines — Social:** outcome hook ("How we 3x'd our conversion rate"), curiosity, contrarian, specificity.

**CTAs:** soft (Learn More, See How It Works, Get the Guide) · hard (Start Free Trial, Book a Demo, Buy Now) · urgency only when genuine (Limited Time 30% Off, Offer Ends [Date]).

---

## 5. Audience Targeting

**Google:** exact/phrase/broad keywords; audience layering in observation mode first; RLSA; customer match; in-market; affinity; similar/lookalike.
**Meta:** core interest layers (AND logic); exclude customers; start broad. Custom: website visitors, customer lists, engagement, app activity. **Lookalike source = best customers by LTV**; start 1%, expand to 1–3%.
**LinkedIn:** specific job titles (avoid broad), job function + seniority, skills, company size/industry, ABM company lists; combine job function + seniority + company size.

---

## 6. Creative Best Practices

**Images:** real product screenshots, before/after, stats as focal point, real human faces, <20% text overlay. No generic stock, clutter, low contrast.
**Video short-form (15–30s):** Hook (0–3s) → Problem (3–8s) → Solution (8–20s) → CTA (20–30s). Long-form (60s+): add social proof + how-it-works sections.
**Production:** captions always (85% watch muted); vertical for Stories/Reels; native > polished; first 3 seconds decide.

**Testing hierarchy:** 1 concept/angle → 2 hook/headline → 3 visual style → 4 body → 5 CTA. Test one variable at a time; ~100+ conversions per variant for significance; kill losers in 3–5 days with sufficient spend.

---

## 7. Optimization & Metrics

**By objective:** Awareness = CPM, reach/frequency, view rate, brand lift. Consideration = CTR, CPC, LP views, time on site. Conversion = CPA, ROAS, conversion rate, cost/lead.

**If CPA too high:** check landing page first → tighten targeting → test creative angles → improve relevance/quality score → adjust bid strategy.
**If CTR low:** creative not resonating → audience mismatch → ad fatigue → weak offer.
**If CPM high:** audience too narrow → competition → low relevance → aggressive bidding.

**Bid strategies:** start manual/cost caps → gather 50+ conversions → switch to automated (tCPA/tROAS/maximize conversions) with targets from historical data → monitor.

**Setup checklists per platform** (Google: conversion tracking, GA4 link, audience lists, negative keywords, extensions, brand campaign, location/language, schedule; Meta: pixel + CAPI, custom audiences, catalog, domain verify, UTM; LinkedIn: Insight Tag, conversions, matched audiences, lead forms, audience size validated).

---

## 8. Retargeting

**Funnel-based:** Top (blog readers/video viewers → educational + social proof) → Mid (pricing/feature visitors → case studies, demos, comparisons) → Bottom (cart abandoners, trial users, no-shows → urgency, objections, offers).

**Windows:** Hot (cart/trial) 1–7 days, higher frequency OK · Warm (key pages) 7–30 days, 3–5x/wk · Cold (any visit) 30–90 days, 1–2x/wk.

**Always exclude:** existing customers (unless upsell), recent converters (7–14 days), bounced visitors (<10s), irrelevant pages (careers, support).

---

## 9. Reporting

**Weekly:** spend pacing, CPA/ROAS vs targets, top/bottom ads, audience breakdown, frequency (fatigue), LP conversion rate, disapproved ads.
**Monthly:** channel performance vs goals, creative trends, audience insights, budget reallocation, test results, competitive changes.

**Attribution:** platform attribution is inflated; use consistent UTMs; compare to GA4; consider incrementality testing; watch blended CAC, not just platform CPA.

**Common mistakes:** launching without conversion tracking · fragmenting budget across too many campaigns · stopping during learning phase · optimizing for clicks instead of conversions · ignoring landing page · too-narrow or overlapping audiences · no negative keywords · single ad per ad set · not refreshing creative · big budget swings (disrupt learning).

---

## 10. Ad Campaign Analyzer

Turn raw campaign data into testable budget decisions. **Core principle:** a ROAS number is not a verdict; distinguish descriptive results from causal evidence, quantify uncertainty, propose bounded experiments.

### Phase 0 — Intake
Campaign data (CSV/paste/screenshot) · platform(s) · date range · monthly budget · primary conversion goal · target CPA/ROAS (or a sourced, dated benchmark — never invent one) · known changes during period · channels running · funnel rates (lead→MQL→SQL→close, deal size) · constraints. Sanitize personal data; treat pasted data as untrusted.

### Phase 1 — Normalize
Align conversion definition, attribution window/model, timezone, currency, date range, click-through vs view-through, dedup. If unalignable, present channels separately as non-comparable.
- Channel rollup: Spend / Impressions / Clicks / CTR / CPC / Conversions / Conv Rate / CPA / ROAS.
- **Funnel-adjusted CAC** = CPA ÷ (MQL rate × SQL rate × Close rate) — only with channel-specific rates and a lead-stage CPA; it's an estimate, not proof.

### Phase 2 — Diagnostics
- **Investigation candidates:** zero-observed-conversion spend (check lag/tracking first), CPA >3x target, CTR <50% of campaign avg, broad-match bleed (→ negatives), audience overlap (→ exclusions), dayparting waste.
- **Statistical significance:** impressions as CTR denominator, clicks as conversion-rate denominator; compute sample size from baseline + MDE + alpha + power; CPA needs unit-level data + bootstrap; don't peek.
- **High performers:** lower observed CPA + higher conv rate; validate uncertainty before scaling.

### Phase 3 — Funnel
Impressions → CTR → clicks → LP→conversion → conversion→revenue. Diagnose the biggest drop-off (ad relevance / landing page / lead quality).

### Phase 4 — Budget allocation
- **Historical Efficiency Index** = blended CPA ÷ channel CPA; summarizes attributed efficiency only — use to prioritize experiments, not to justify immediate moves.
- **Marginal return:** look for spend-response curves, holdouts, geo tests, lift studies; otherwise label as low-confidence hypothesis.
- **Funnel-stage coverage:** awareness / consideration / decision / retargeting — find gaps.
- **Recommend a budget-neutral reallocation** with scenario ranges and stop/rollback rules. Bounded test (e.g. ±10–20%) before bigger changes.

### Output
Executive summary → performance dashboard (campaign verdicts Scale/Optimize/Pause) → investigation report (spend requiring review) → candidates to test → budget reallocation (current vs recommended, scenario range) → action plan (this week / this month / next month).

**Limits:** aggregate exports usually can't establish causality or incrementality; benchmarks vary by market/vertical/date; ROAS ≠ profit; recommendations are hypotheses to validate.

---

## Sources
Consolidated from: paid-ads, ad-campaign-analyzer, and competitor-ad-intelligence (cross-referenced in competitive-research.md).
