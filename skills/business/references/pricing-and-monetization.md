# Pricing & Monetization

Design pricing, packaging, and monetization for digital products — from strategy through Stripe implementation and churn prevention. Sources: `pricing-strategy`, `usage-based-pricing`, `monetization`.

## The Three Pricing Decisions

Every pricing system must explicitly answer:

1. **Packaging** — what's included in each tier.
2. **Value metric** — what customers pay for (users, usage, outcomes).
3. **Price level** — how much each tier costs.

Failure in any one weakens the whole system.

## Value-Based Pricing Framework

Anchor price to customer-perceived value, not internal cost.

```
Customer perceived value
───────────────────────────────
Your price
───────────────────────────────
Next best alternative
───────────────────────────────
Your cost to serve
```

**Rules:** price above the next best alternative; leave customer surplus; cost is a floor, not a basis. Capture roughly 10–30% of value created.

**Value-based process:**
1. Calculate economic value delivered (e.g., saves 2h/wk = $200/mo value).
2. Capture 10–30% of created value.
3. Validate with willingness-to-pay research.
4. Test 3 price points.

## Pricing Research Methods

- **Van Westendorp (Price Sensitivity Meter)**: 4 questions (too expensive / too cheap / expensive-but-acceptable / cheap-good-value). Outputs: PMC, PME, OPP (optimal price point), IDP (indifference point). Use for early pricing, price-increase validation, segment comparison.
- **Feature value research (MaxDiff / Conjoint)**: informs packaging, not price levels. Reveals table-stakes features, differentiators, premium-only features, low-value candidates to remove.
- **Willingness-to-pay testing**: direct WTP (directional only), Gabor-Granger (demand curve), conjoint (feature + price sensitivity).

## Value Metrics

The value metric is what scales price with customer value. Good metrics: align with delivered value, scale with customer success, easy to understand, hard to game.

| Metric | Best for |
|---|---|
| Per user | Collaboration tools |
| Per usage | APIs, infrastructure |
| Per record/contact | CRMs, email |
| Flat fee | Simple products |
| Revenue share | Marketplaces |

**Validation test:** *as customers get more value, do they naturally pay more?* If not, the metric is misaligned.

### Usage metrics developers accept

Good: API calls/requests (Stripe per transaction), compute time (Lambda GB-sec, Vercel build minutes), storage (per GB), bandwidth, active users/MAU (Auth0).
Problematic: proprietary "compute units" (developers can't estimate), compound metrics with multipliers, metrics that punish success (per-user pricing that penalizes viral growth), hidden multipliers (retries count, health checks count).

## Tier Design

- **2 tiers**: simple segmentation. **3 tiers**: default (Good/Better/Best). **4+**: broad market, careful UX.
- **Good**: entry point, limited usage, removes friction.
- **Better (anchor)**: where most customers should land; full core value; best value-per-dollar; highlight with "Most popular" badge.
- **Best**: power users/enterprise; advanced controls, scale, support.
- **Differentiation levers**: usage limits, advanced features, support level, security/compliance, customization/integrations.
- **Ideal simple structure**: optional free tier (limited but useful) → one paid tier (everything most need) → optional enterprise (custom). Max 3 tiers with clear differentiation, recommended badge, annual discount 20–30%.

**Persona-based packaging:** define personas (size/use case/sophistication/budget), map each persona to exactly one tier, price to segment WTP — avoid "one price fits all."

## Freemium vs. Free Trial

- **Freemium works when**: large market, viral/network effects, clear upgrade trigger, low marginal cost.
- **Free trial works when**: value requires setup, higher price points, B2B evaluation cycles, sticky post-activation usage.
- **Hybrid**: reverse trials, feature-limited free + premium trial. Trial without card optimizes activation; trial with card optimizes retention.

## Price Increases

**Signals it's time:** very high conversion, low churn, customers under-paying relative to value, market price movement.

**Strategies:** (1) new customers only; (2) delayed increase for existing; (3) value-tied increase; (4) full plan restructure. Grandfather existing customers — "new pricing disadvantages existing customers" is a classic bait-and-switch anti-pattern.

## Price Testing (safe methods)

Preferred: new-customer pricing, sales-led experimentation, geographic tests, packaging tests.
Avoid: blind A/B price tests on the same page, surprise customer discovery.

## Enterprise Pricing

Introduce when deals > $10K ARR, custom contracts, security/compliance needs, or sales involvement required.
Common structures: volume-discounted per seat, platform fee + usage, outcome-based pricing.

## Pricing Page Strategy

Requirements: clear recommended tier, transparent differentiation, annual discount logic, enterprise escape hatch. Lead with simple cases and real numbers ("$47/mo for a typical SaaS app" beats "$0.001 per request"); reveal complexity gradually (edge cases in FAQ); compare to alternatives when provable.

**Anti-patterns:** "Contact sales" for all pricing, hidden prices, complex unit definitions, multiple interdependent metrics, requiring a spreadsheet to calculate.

## Cost Predictability (usage-based products)

- **Usage dashboards**: current vs. limit per meter, projected bill.
- **Usage alerts**: at 50/75/90/100% of limit, daily spike detection.
- **Spending caps**: hard stop (best for dev/non-critical; risk: production outage), soft stop (best for production; risk: unexpected overage), burst allowance, automatic scaling.
- **Billing transparency**: itemize the invoice ("245,000 requests @ $0.01/1k = $2.45"), not a single line.
- **The bill should tell a story.**

**Value communication:** cost-of-alternatives comparison (self-host vs. $99/mo), time-savings math, ROI calculators for enterprise.

**Pricing positioning options:** premium (higher price, perceived value, needs differentiation), value (comparable price, more features, needs clear comparison), penetration (lower price, needs path to profitability), usage-aligned.

## Monetization Implementation (Stripe)

```python
import stripe, os
stripe.api_key = os.environ["STRIPE_SECRET_KEY"]
STRIPE_WEBHOOK_SECRET = os.environ["STRIPE_WEBHOOK_SECRET"]
```

**Key flows:**
- **Checkout Session** (recommended for conversion): `mode="subscription"`, `line_items=[{"price": price_id, "quantity": 1}]`, `subscription_data={"trial_period_days": 14}`, `allow_promotion_codes=True`.
- **Customer Portal**: self-service plan changes/cancellation via `billing_portal.Session.create`.
- **Webhooks**: handle `customer.subscription.created/updated/deleted`, `invoice.payment_succeeded/failed`, `customer.subscription.trial_will_end`. Verify signatures with `stripe.Webhook.construct_event`.
- **Status check**: subscription status, trial_end, current_period_end, cancel_at_period_end → map to tier ("free" if none).

**Billing platforms:** Stripe Billing, Orb, Lago (OSS), Metronome, Chargebee. Usage metering: Segment, Rudderstack, or custom.

**Revenue dashboard metrics:** MRR (new + expansion − contraction − churn), ARR, churn rate, NRR (target >100%).

## Churn Prevention

**Churn signals (high risk):** no login 14 days, usage drop >70% in 2 weeks, started-cancellation-but-incomplete, unresolved support ticket.
**Medium risk:** no login 7 days, usage drop >40%, onboarding incomplete, never used core feature.

**Anti-churn sequence (calendar):**
- Day 0: 7 days inactive → "We miss you, what happened?"
- +3: no response → case study of similar successful user.
- +7: not returned → special offer (20% off 3 months).
- Day 14: trial expiring → in-app modal + urgent email.
- Day 30: canceled → offboarding email; re-engage 3 months later with news.

**Exit survey reasons:** too expensive, not enough usage, missing feature X, found better alternative, technical issues, other. Missing feature → roadmap + notify on launch.

**Unit economics health (B2C SaaS benchmarks):** monthly churn <2% excellent, 2–5% good; LTV/CAC 3–5x good; payback <6 mo excellent, 12–18 ok; trial→paid >15% excellent; MoM growth >20% excellent.

**Churn benchmarks (micro-SaaS):** <3% monthly excellent, 3–5% good, 5–7% needs work, >7% critical.
