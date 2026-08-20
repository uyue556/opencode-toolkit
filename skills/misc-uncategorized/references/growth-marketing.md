# Growth & Marketing Ops

Consolidates: content-strategy, lead-magnets, offers, pricing, free-tier-strategy, ad-creative,
cold-email, email-systems, mailtrap-* (4), co-marketing (see dev-marketing), public-relations,
sales-enablement, customer-research, competitor-profiling, cro, onboarding, churn-prevention,
internal-comms (see dev-marketing).

## 0. Start With Context

Read `.agents/product-marketing-context.md` (or `.claude/product-marketing.md`) if present before
asking questions. Gather: business context, customer research, current state, competitive
landscape.

## 1. Customer Research

Two modes: (A) analyze existing assets (interview/sales-call transcripts, surveys, support
tickets, win/loss notes), (B) digital watering-hole research.
- From transcripts extract: pains, triggers, desired outcomes, language used, objections,
  alternatives considered, the decision moment.
- Surveys: segment by tier/use-case/tenure; flag open-ended vs multiple-choice conflict; find the
  20% of responses with the most signal.
- Watering holes by ICP: B2B SaaS → Reddit (role subs), G2/Capterra, HN, LinkedIn, SparkToro;
  devs → r/devops, r/programming, HN, Stack Overflow, Discord; B2C → app-store reviews (1–3 star),
  Reddit hobby subs, YouTube/TikTok comments; enterprise → LinkedIn, analyst reports, job postings.
- Extract per item: source, verbatim quote, context, sentiment, theme tag, profile signals.
- Synthesize themes ranked by frequency × intensity with representative quotes and implications.
- Personas from research only — minimum 5–10 data points per segment; never invent.

## 2. Competitor Profiling

From competitor URLs, produce structured profiles. Principles: facts over opinions (every claim
traceable), structured/comparable (same template), current data (always date-stamp, flag stale),
honest assessment. Save raw scraped data before synthesizing so it can be re-read without
re-running expensive APIs. Include: positioning, pricing, features, SEO strength, content
strategy, target audience, strengths/weaknesses.

## 3. Content Strategy

- **Searchable** content: target keyword/question, match intent exactly, keyword in title/
  headings/first para/URL, comprehensive coverage, optimize for AI/LLM discovery.
- **Shareable** content: novel insight, original data, counterintuitive take, stories, identity-
  affirming, honest/vulnerable experiences.
- Content types: use-case (`[persona] + [use-case]`), hub-and-spoke (only for major topics; most
  content works under `/blog`), template libraries, thought leadership, data-driven, expert
  roundups (15-30 experts), case studies (Challenge→Solution→Results→Learnings), meta content.
- Pillars: 3–5 topics you'll own; each pillar spawns a cluster; interlink strategically.
- Keyword research by buyer stage (awareness/consideration/decision/implementation).
- Ideation sources: keyword data, call transcripts, surveys, forums, competitor analysis, sales/
  support input. Prioritize by traffic potential × intent fit × effort.

## 4. Lead Magnets

Principles: solve ONE specific problem, match the buyer stage, high perceived value / low time
investment, natural path to product, easy to consume. Types: checklists, templates, toolkits,
mini-courses, calculators, benchmark reports, swipe files, guides.
Gating strategy: ask for the minimum (email) at awareness; deeper data at decision. Frame the
exchange ("get X free"). Landing page: headline + benefit + preview + one field form + instant
delivery. Promote via blog CTAs/content upgrades, exit-intent, social.

## 5. Offer Design

The value equation (from Direct Response): **Value = Dream Outcome × Perceived Likelihood of
Achievement ÷ (Time Delay × Effort & Sacrifice)**. Improve value by raising the dream outcome,
raising believability, reducing delay, reducing effort. Anatomy of a complete offer: lead magnet,
tripwire, core product, profit maximizers/upsells, retentions, equity/back-end. Diagnostic loop:
state the current offer → find the weakest value lever → fix it → test. Banned vocabulary: vague
superlatives, "revolutionary", "game-changing" unless backed by proof. Use `pricing` skill when the
problem is package/price structure rather than the offer promise.

## 6. Pricing

Three axes: who is paying, what is the value metric, how is it packaged. Value-based pricing:
price to the value delivered, not cost+. Value metrics that scale naturally (requests, compute,
storage, seats). Tier structure: Good-Better-Best; differentiate on value metric + features +
limits, not just price. Research: Van Westendorp (price sensitivity meter: too cheap / cheap /
expensive / too expensive) and MaxDiff (ranked preferences). Signs to raise prices: usage
outgrows plans, strong ROI proof, new differentiated features. Pricing-page best practices: anchor
highest tier visible, annual/monthly toggle with annual highlighted, FAQ, trust elements. Pricing
psychology: anchoring, decoy effect, rounded vs precise.

## 7. Free Tier Strategy

Definitions: free trial (time-limited full access — for high-touch enterprise), free tier
(permanently free with limits — for self-serve dev tools), freemium (free + premium), open core
(free OSS + commercial additions). Dev tools almost always need a permanent free tier, not a trial.
Good limit dimensions: API calls, compute, storage, seats. Bad dimensions: time-based trials
disguised as free ("expires after 90 days of inactivity"), arbitrary feature combos, limits that
punish success ("free up to 100 MAU"). The Goldilocks zone: meaningful usage, covers hobbyists,
triggers on growth not time, predictable.
Feature gating: keep the core loop free, gate scale/collaboration/premium; avoid the "free tier
tax" (resentment when free is deliberately crippled). Upgrade triggers: usage limit hits, team
growth, advanced needs. GitHub model: free for public, paid for private/teams. Open core:
commercialize support, managed hosting, enterprise features — keep the community relationship.

## 8. Ad Creative

Modes: generate from scratch vs iterate from performance data.
- Google Ads (RSA): 3 headlines + 2 descriptions; include keyword, offer, benefit; A/B by angle.
- Meta: 3-5 headlines + 1 primary text, 1.91:1 images, first 125 chars matter.
- LinkedIn: 90-150 chars, professional tone, 4:5 or 1:1 visuals.
- TikTok: hook in first 1-2 sec, short punchy captions, native feel.
- Generating copy: define angles (problem, outcome, social proof, contrast, authority, scarcity-
  free) → generate variations per angle → validate against platform specs → organize for upload.
- Iteration: analyze winners (what angle/hook/image), analyze losers, generate new variations,
  keep an iteration log. Quality standard: specific, benefit-led, no fluff, honest.

## 9. Cold Email

Write like a peer not a vendor; every sentence earns its place; personalization connects to the
problem (remove the personalized opening and if the email still works, it's not personalized);
lead with their world ("you/your" beats "I/we"); one low-friction ask (interest-based CTA beats
meeting request).
Voice: smart colleague sharing something relevant. Calibrate: C-suite ultra-brief; technical
precise/no fluff. Avoid AI-tell patterns ("I hope this email finds you well", "came across your
profile", "leverage", "synergy", "best-in-class").
Frameworks: Observation→Problem→Proof→Ask; Question→Value→Ask; Trigger→Insight→Ask;
Story→Bridge→Ask.
Subject lines: 2-4 words, lowercase, internal-looking ("reply rates", "hiring ops"), no
product pitch/urgency/emoji/first name. Follow-ups: 3-5 emails, increasing gaps, each adds
something new; breakup email honors the close. Never fake "Re:"/"Fwd:", no HTML/multiple links,
no identical templates with only name swapped.

## 10. Email Systems & Deliverability

Principles: transactional vs marketing separation (separate IPs/providers); permission is
everything (double opt-in, easy unsubscribe); deliverability is infrastructure (SPF/DKIM/DMARC
not optional); one email one goal; timing/frequency matter (preference center).
DNS records: SPF `v=spf1 include:_spf.google.com include:sendgrid.net ~all`; DKIM TXT from
provider; DMARC `v=DMARC1; p=quarantine; rua=mailto:dmarc@yourdomain.com`. Verify with
mail-tester.com / MXToolbox.
Critical rules: never send without authentication; don't use shared IP for transactional
(Postmark/Resend for transactional, ConvertKit/Customer.io for marketing); process bounces (hard
= remove immediately, soft = retry 3x/72h then hard; complaints = unsubscribe immediately);
visible one-click unsubscribe + List-Unsubscribe header (CAN-SPAM/GDPR); always send multipart
(html + text); 60/40 text:image rule with alt text; explicit preview text (hidden div + React
`<Preview>`, 40-100 chars); IP warm-up (wk1 50-100/day → double weekly); per-recipient send
logging + retry (Promise.allSettled pattern); rate-limit bulk sends.
Queue transactional emails with retry/backoff; track lifecycle Queued→Sent→Delivered→Opened→
Clicked→Bounced→Complained; version templates (v1/v2 testing 10%); preference center for GDPR.

## 11. Mailtrap (Quick Reference)

- Sandbox (testing): SMTP host `sandbox.smtp.mailtrap.io`, port 2525; or Email API
  `https://send.api.mailtrap.io/api/send` with `Api-Token: Bearer <token>`; account_id in paths.
  Capture email in dev/staging/CI, HTML inspection, spam checks, fake inbox.
- Sending domain: add domain, verify DNS (SPF/DKIM/DMARC), watch proxied DNS (must set records
  on the authoritative zone, not just the proxy); complete via API or UI.
- Sending emails: prefer Email API over SMTP; tokens via env; rate limits respected; template vs
  non-template JSON bodies.
- Contacts: manage contacts/lists/segments/custom fields/imports/CRM syncs; bulk import via
  array; custom events with name+payload.

## 12. Public Relations

PR mix: press page + media kit (facts, logos, spokesperson, boilerplate, FAQ), reporter
relationships, newsjacking, HARO responses, thought leadership. Pitch quality bar: relevant to
the beat, clear news hook, short, journalist-first. Measure: placements, audience reach, share of
voice, inbound inquiries. Skip PR when there's no real story/audience yet.

## 13. Sales Enablement

Collateral that reps actually use. Principles: sales uses what sales trusts (involve reps; test
drafts with top performers); situation-specific; scannable over comprehensive (3-second rule);
tie to business outcomes.
- Deck: 10-12 slides (problem, solution, proof, pricing, next steps); customize by buyer type.
- One-pagers: problem in one sentence, your solution, 3 differentiators, one proof point, CTA.
- Objection handling docs: category (price/timing/competition/authority/status quo/technical) →
why they say it → response approach → proof point → follow-up question. Two formats: quick-ref
table for live calls, detailed doc for training.
- ROI calculators: inputs (time/cost/error metrics) → calculations (time saved, cost reduction,
  revenue impact) → outputs (ROI %, payback period, 3-yr value). Persona-based value props.
- Demo scripts: opening (2 min, agenda + goals), discovery recap, live walkthrough, objection
  handling, CTA.

## 14. CRO (Conversion Rate Optimization)

Framework (highest impact first): (1) value-proposition clarity, (2) headline effectiveness, (3)
CTA placement/copy/hierarchy, (4) visual hierarchy & scannability, (5) trust signals/social proof,
(6) objection handling, (7) friction points. Output: quick wins (implement now), high-impact
changes (prioritize), test ideas, copy alternatives. Page-specific: homepage (instant clarity),
landing page (single goal), pricing page (anchors, FAQ), feature page (benefits), blog (capture).
Form optimization: reduce fields, inline validation, clear labels, error recovery.

## 15. Onboarding (CRO)

Principles: time-to-value is everything; one goal per session; do don't show; progress creates
motivation. Define activation: find the aha moment (the specific action that predicts retention);
activation metrics. Flow design: immediate post-signup (first 30s), onboarding checklist pattern,
empty states with one clear next action, tooltips/guided tours (rare). Multi-channel: email +
in-app coordination. Handle stalled users: detect (no activation within X), re-engage (nudge
emails, checkpoints). Measure: activation rate, time-to-activation, funnel drop-off.

## 16. Churn Prevention

Cancel flow design: make it genuinely easy (structure: pause → explain → save offer → exit
survey), exit survey design, dynamic save offers (price, plan, feature unlock), cancel-flow UI
patterns. Risk signals + health-score model (see dev-marketing churn). Involuntary churn: the
dunning stack — pre-dunning (card exp warnings, multiple payment methods), smart retry logic
(3-5 retries over ~2 weeks), dunning email sequence (day 0/3/7/10), recovery benchmarks. Metrics:
monthly churn <5%, net revenue churn <2%, involuntary churn <20%. Cohort analysis. A/B test cancel
flows.
