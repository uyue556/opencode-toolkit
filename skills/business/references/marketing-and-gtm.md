# Marketing & Go-to-Market

Produce comprehensive marketing plans, GTM strategy, and budget planning. Sources: `marketing-plan`, `product-marketing`, `product-marketing-context`, `sales-automator`, `competitor-alternatives`.

## The AARRR Framework

AARRR is the spine of every marketing plan. It forces every recommendation to be funnel-stage-tagged, making the plan executable in priority order.

| Stage | Question | Common metrics |
|---|---|---|
| **Acquisition** | How do strangers become aware? | Visits, MQLs, CAC by channel |
| **Activation** | Do they have an experience that converts? | Signup completion, time-to-value, trial→paid |
| **Retention** | Do they stay and deepen? | DAU/WAU/MAU, week-1/4/12 retention, churn |
| **Referral** | Do retained users bring more users? | Viral coefficient, NPS, ambassador attribution |
| **Revenue** | What do they pay, how does it compound? | ARPU, LTV, expansion, ARR/MRR |

**Signup boundary rule:** signup *intent* = Acquisition; signup *completion* and everything after = Activation. Apply consistently.

**Brand and content are cross-cutting**, not a sixth stage — they serve every stage.

### Diagnosing the binding constraint (which stage is highest leverage)

- **No users** → Acquisition (build first 100).
- **Users bounce** → Activation (bridge signup to first felt value; onboarding is often the most leveraged move).
- **Activation works, users churn** → Retention (lifecycle, churn prevention).
- **Retention strong, growth slow** → Referral / Revenue (WOM mechanics + pricing).
- **Everything works at small scale** → Acquisition scaling.

If a plan ends up evenly distributed across all five stages, the diagnostic was weak — re-examine.

### Stage patterns

- **Acquisition**: SEO content (organic compounding), founder-led channels, paid (only after organic baseline works — premature paid amplifies what's broken), app store optimization, PR, events, partnerships.
- **Activation**: bedrock fixes, onboarding rebuild, app-store listing rewrite, paywall structure + trial length, free→paid bridge. Get to first felt value as fast as possible.
- **Retention**: lifecycle emails (ship post-purchase first, onboarding emails last since they reference UI), preference centers, win-back as quarterly campaign, support-as-marketing, community.
- **Referral**: start with whoever is already raising their hand (5 inbound ambassadors → launch with those 5), share-after-value moments, two-sided rewards, gifting.
- **Revenue**: run the pricing audit before testing changes (listed vs. effective price often differ), annual plan defaults, bundling, upsells.

## 13-Section Marketing Plan Structure

Deliverable: a single Notion-paste-ready markdown doc (8,000–12,000 words), specific to the client, structured as:

1. **Executive summary** — 3 big bets, 90-day priorities, 12-month outcome; lift-and-share into investor updates. Written last, presented first.
2. **Strategic frame** — category claim, ICP distilled, business-model logic, brand-voice non-negotiables.
3. **Current state** — team, budget, what's done/in-flight/stuck. Score against the 17-section rubric (positioning, research, homepage, product pages, conversion pages, competitor comparison, content, onboarding, email lifecycle, sales material, messaging, pricing, CRO, launches, ads, SEO, internationalization), 0–5 each, total /85, plus a "shape interpretation."
4. **Acquisition** — channels current + planned + skipped; 90-day and 12-month moves; skills + tools.
5. **Activation** — onboarding, first session, paywall, lifecycle setup.
6. **Retention** — lifecycle flows, churn prevention, win-back.
7. **Referral** — ambassador/affiliate/WOM mechanics.
8. **Revenue** — pricing, packaging, upsells, bundles, B2B ACV.
9. **90-day roadmap** — weeks 1–2 Unblock, 3–4 Foundation, 5–8 Velocity, 9–12 Compound. AARRR-tagged, owner-assigned.
10. **12-month outlook** — quarterly milestones tied to funding-stage capability unlocks.
11. **Marketing operations stack** — skills + MCP/API integrations mapped to each AARRR stage.
12. **Tactical idea bank** — cross-referenced to AARRR + client status (Now/Q2/Q3+/Skip with rationale).
13. **Measurement, RACI, open decisions** — north-star metric, leading indicators, RACI, blocking decisions, appendix.

**Workflow:** INIT (research + intake) → REVIEW (13 sections interactively, save as you go, resumable) → FINALIZE (compile, verify cross-references, publish). Use a `progress.md` state machine (fresh → INIT → REVIEW → FINALIZE → finalized); never silently overwrite a finalized plan.

**Quality bar:** every move names its AARRR stage; anchored in real client data; roadmap has owners; funding-stage section explains what changes when the round closes; ops stack names specific skills + MCPs; idea bank shows what you're *not* doing and why; open decisions explicit (CAC unknown is the highest-impact one).

## Client-Type Variations

- **B2B SaaS**: SEO + content + outbound + LinkedIn; Activation = signup + trial; Revenue = expansion/NRR.
- **D2C consumer app**: App Store + paid social + influencer; Activation = onboarding + paywall; Revenue = subscription + upsell.
- **Hybrid hardware + software**: PR + retail + Shopify SEO; Activation = unboxing + hardware→app bridge; Revenue = blended LTV (hardware margin + software recurring); bundle strategy.
- **Marketplace**: two funnels (supply + demand); liquidity is the critical early metric; Revenue = take-rate × GMV.
- **Developer tool**: technical content + DevRel + docs SEO; Activation = first build/integration; Referral = team adoption.
- **Deep-tech/clinical**: academic publishing + conference speaking + investor backchannel; pilot → paid expansion.
- **Commerce/DTC (non-subscription)**: paid social + Shopify/Amazon; Activation = first purchase + cart recovery; Retention = post-purchase + loyalty.

When in doubt, lead with the archetype that best fits the primary monetization model.

## Budget Planning (scientific)

**Method 1 — Revenue-Based (5–40% of ARR):** budget → revenue goal. Conservative 5% (profit-preserving), standard growth 15–25%, aggressive (deploying capital) up to 40%. Requires blended CAC.

**Method 2 — Goal-Based (reverse-engineer):** revenue goal → budget.

```
Marketing budget = [(New ARR / (ARPC × 12)) × CAC] / annual retention rate
```

Worked example ($1M → $2M ARR): $600 ARR/new customer → 1,667 customers → ×$100 CAC = $166.7K → /0.85 retention = ~$200K.

**Always add 10–20% experimental budget** on top — CAC is the main dependency and the experimental layer funds the next channel before the current one plateaus.

**Blended CAC** (must include everything): marketing salaries, ad spend, tech stack, content production, agency retainers, SDR/BDR salaries, tools. "We don't run ads" still has a CAC — it's hidden in content/SEO/retainers.

**Forecast reality check:** unless publicly traded, forecasts are educated guesses. The annual goal is a defensible direction; the 90-day roadmap is what's actionable now; monthly variance is expected, quarterly review adjusts.

## Growth Patterns (the real shape of SaaS growth)

- **Phase 1 — $0–10K ARR** (grueling, 6–12 mo): every customer hard-won; runway + ambiguity tolerance.
- **Phase 2 — $10–100K ARR** (treacherous middle): $8–10K MRR is when founders can go full-time; flame-outs happen just as things start working.
- **Phase 3 — $100K–1M ARR** (acceleration): doubling time shrinks; early customers become salespeople.
- **Linear growth** = plannable revenue machine ($10K MRR/mo). **Step-function** = plateau → jump triggered by new segment/tier/channel. Combined they *look* exponential — that's the myth.
- **S-curve layering (Channel × Product × Market):** start the next curve before the current one plateaus. SEO matures in 6–12 mo; paid = quick wins with diminishing returns; content compounds.
- **Don't promise exponential.** Name the binding constraint per phase. Plateaus aren't failures — they're moments between S-curves.

## Team & Agency Model

- **Strategy lives in-house; execution can be outsourced.** First hire is a strategist, not a tactician (look for a π-shaped marketer — two deep skill sets).
- **Title conservatively** — Manager/Lead, not VP/CMO, for the first marketing hire.
- **Funding tiers** determine capability: pre-seed organic-only → seed-close +$5–15K/mo paid + first hire → seed-deployment +$20–50K/mo + designer → Series A $50–150K/mo + full team → Series B+ brand/PR.

## Sales Automation (cold email / outbound)

For outreach and lead nurturing:
1. Lead with value, not features.
2. Personalize using research.
3. Keep emails short and scannable.
4. One clear CTA.
5. Track what converts.

**Output:** email sequence (3–5 touchpoints), A/B subject lines, personalization variables, follow-up schedule, objection-handling scripts, tracking metrics. Write conversationally; show empathy for customer problems.

**Related outbound principles:** response time is the single biggest factor in lead conversion (5 min = 21x more likely to qualify; 30 min = 10x drop; 24 hrs = cold) — build speed into the workflow.
