# Startups, MVP Launch & Digital Product Businesses

Validate, build, price, and launch small software businesses fast. Sources: `micro-saas-launcher`, `saas-mvp-launcher`, `notion-template-business`, `startup-analyst`, `team-composition-analysis` (see team-and-hr for org detail).

## Micro-SaaS Launcher (indie hacker playbook)

Ship small, focused, profitable software in weeks, not years.

### Idea validation framework

| Question | How to answer |
|---|---|
| Problem exists? | Talk to 5+ potential users |
| People pay? | Pre-sell or find competitors |
| You can build? | Can the MVP ship in 2 weeks? |
| You can reach them? | Distribution channel exists? |

**Quick validation:** landing-page test (measure signups), pre-sale ("join waitlist for 50% off" — no sales = pivot), competitor check (competitors = validation; no competitors = maybe no market).

**Red flags:** "everyone needs this" (too broad), no clear buyer, requires marketplace dynamics, needs massive scale. **Green flags:** clear specific pain, people already paying for alternatives, domain expertise, distribution channel access.

### MVP speed run (2 weeks)

Week 1: auth + UI → core feature (one thing) → Stripe → polish. Week 2: landing page → email flows → legal (privacy/terms) → final testing → soft launch.

**Stack (solo-founder optimized):** Next.js (frontend/full-stack), Supabase Postgres (DB + auth), Clerk/Supabase Auth, Stripe (payments), Resend/Loops (email), Vercel (hosting).

**What to skip:** perfect design, all features (one core feature only), scale optimization, custom auth (use a service), multiple pricing tiers.

### Pricing for micro-SaaS

**Starting-price framework:** your price = 20–50% of the alternative cost (competitor or manual work). Example: 10 hrs/mo × $50 = $500 value → price $49–99/mo.

| Type | Price range |
|---|---|
| Simple tool | $9–29/mo |
| Pro tool | $29–99/mo |
| B2B tool | $49–299/mo |
| Lifetime deal | 3–5x monthly |

**Mistakes:** too cheap, too complex, no free tier AND no trial, charging too late.

### Launch playbook

Pre-launch (2 wks): build email list, engage communities (give value first), create assets, line up beta testers. Launch day: Product Hunt (12:01 AM PST Tue–Thu, maker comment ready, respond to every comment, don't ask for upvotes directly), Hacker News, Reddit, X, email list. Post-launch: follow up with every signup, ask for feedback, fix critical bugs, start SEO/content, don't stop marketing after launch day.

### Distribution first (critical sharp edge)

"Build first, marketing second" is the #1 failure. Before building, answer: Where do my customers hang out? Can I reach them for free? Do I have an existing audience? Is SEO viable?

**Channels:** SEO (6–12 mo, low cost), content marketing (3–6 mo), paid (immediate, high), community (1–3 mo), Product Hunt (1 day, free), partnerships (1–2 mo, free).

**Build distribution into the product:** "Powered by" badges, invite/referral features, public profiles (SEO), shareable results, marketplace listings.

### Market selection

B2B beats B2C for solo founders (higher price tolerance, lower churn, higher support needs). Good markets: small businesses, freelancers/agencies, developers, creators with revenue, professionals. Red-flag markets: students, unfunded startups, mass consumers, markets with free alternatives.

**Pivot signals:** high interest/zero payments, users love it but won't pay, competition all free, market has no budget.

### Fixing churn

Email churned users (personal), check last active date, check onboarding completion, survey at cancellation. Quick fixes: improve onboarding (first 7 days critical), aha-moment trigger emails, filter right users, add missing must-have features, raise prices (filters serious users).

**Onboarding checklist:** clear first action, value in first session, 7-day email sequence, day-3 check-in if inactive, tracked success metric.

### Validation checks before launch

- Payment integration (Stripe or Lemon Squeezy) — required.
- Authentication — use Supabase Auth/Clerk/Auth0, don't build your own.
- Onboarding flow — required for activation.
- Product analytics (PostHog/Mixpanel) — required to not fly blind.
- Legal pages (privacy + terms) — required for payments.

## SaaS MVP Launcher (production-grade roadmap)

**Validate before building:** can you describe the problem in one sentence, name the exact customer, say what they pay today, name 5+ people talked to, confirm willingness to pay? **If you can't get 3 people to pre-pay or sign an LOI, don't build yet.**

**Modern stack (2026):** Next.js 15 + TypeScript, Tailwind + shadcn/ui, Next.js API routes or tRPC, PostgreSQL via Supabase, Prisma/Drizzle, Clerk or NextAuth.js, Stripe, Resend + React Email, Vercel + Railway, Sentry + PostHog.

**Multi-tenant schema:** User → Workspace → Subscription (stripeCustomerId, stripePriceId, status, currentPeriodEnd); plan enum FREE/PRO/ENTERPRISE.

**Best practices:** ship a working MVP in 4–6 weeks max; charge from day 1 (free users don't validate PMF); build the happy path first; use feature flags; monitor from launch day. Don't build every feature, don't optimize for scale before $10K MRR, don't build custom auth, don't skip onboarding.

**Pre-launch checklist — technical:** auth works, payments end-to-end, error monitoring, env vars documented, DB backups, rate limiting, input validation (Zod), HTTPS + security headers. **Product:** landing page, pricing page (2–3 tiers), onboarding (first value <5 min), email sequences (welcome, trial ending, payment failed), ToS/Privacy, support channel. **Marketing:** domain, SEO meta, analytics, social accounts, Product Hunt draft.

**Troubleshooting:** signup-but-no-activation → reduce steps to first value, track drop-off; high trial churn → exit survey (churn is usually perceived-value, not price); Stripe webhooks → `stripe listen --forward-to localhost:3000/api/webhooks/stripe`; prod migrations → `prisma migrate deploy`, never `dev`.

## Notion Template Business

Build and sell Notion templates as a real digital-product business.

### Template design (what makes templates sell)

Solves a specific problem, beautiful design, easy to customize, good documentation (reduces support), comprehensive (feels worth the price). Package: main template (dashboard, core pages, examples) + documentation (getting started, walkthrough, FAQ) + bonus (icons, themes).

Categories that sell: productivity (second brain, task management), business (CRM, PM), personal (finance/habit trackers), education, creative.

### Pricing

Value-based: time saved × 12 months → price at 1–3% of value. Price anchoring: Basic $15–29, Pro $39–79, Ultimate $99–199. Bundles: individual $29–49, bundle of 3–5 $79–129, all-access $149–299. Free templates = lead magnets / upsell vehicles / social proof / SEO.

### Sales channels

| Platform | Fee | Notes |
|---|---|---|
| Gumroad | 10% | Simple, trusted |
| Lemon Squeezy | 5–8% | Modern, lower fees |
| Notion Marketplace | 0% | Built-in audience, needs approval |
| Your site (Stripe) | ~3% | Full control, build audience |

**Channel mix goal:** 40% own site, 30% Gumroad/Lemon Squeezy, 20% marketplace, 10% other. **Email list is the priority** — own your audience.

### Handling piracy

Accept some piracy (pirates weren't buyers anyway); mitigate with watermarking, unique IDs, updates (pirates get old versions), community/Discord for buyers, bonus files outside Notion. Act on mass distribution (DMCA) and reselling, not small sharing.

### Scaling support

Reduce support needs (better onboarding, comprehensive docs, self-serve resources); tier support by price; automate canned responses; if overwhelmed, raise prices, reduce product line, hire a VA, create a course.

### Update strategy

Bug fixes as needed, feature adds quarterly, major refresh yearly. Free bug fixes always; free minor updates for 1 year; major versions discounted for existing buyers.

**Launch:** free template → email list → launch → Twitter thread with demo → Product Hunt (optional) → SEO content → YouTube tutorials → affiliate partnerships.

## Startup Analyst (cross-cutting advisory)

Act as an expert startup business analyst for pre-seed through Series A: market sizing (bottom-up/top-down/value theory), financial modeling (cohort revenue, unit economics, 3-scenario), competitive analysis (Porter's Five Forces, Blue Ocean), team planning, startup metrics, fundraising preparation.

**Behavioral traits:** startup-focused, data-driven, conservative, pragmatic, transparent, founder-friendly, action-oriented, investor-aware, rigorous, honest. **Quality standards:** credible cited sources, documented assumptions, realistic conservative estimates, multi-method validation, benchmarks, structured output, actionable recommendations, acknowledged limitations. **Never:** unsupported claims, overly optimistic assumptions, skipped validation, ignored competitive context, generic advice, uncited sources.

**Stage awareness:** pre-seed = PMF signals; seed = growth + unit-economics baseline; Series A = scalable repeatable model with strong unit economics.
