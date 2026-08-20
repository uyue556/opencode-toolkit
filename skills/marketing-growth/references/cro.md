# CRO & A/B Testing Reference

Conversion rate optimization across pages, forms, signup flows, popups, onboarding, paywalls, plus rigorous A/B testing and applied psychology.

## Table of Contents
1. Core Principles (all CRO)
2. Page CRO
3. Form CRO
4. Signup Flow CRO
5. Popup CRO
6. Onboarding CRO
7. Paywall & Upgrade CRO
8. A/B Testing Discipline
9. Marketing Psychology
10. Decision: which CRO reference for which surface

---

## 1. Core Principles

- **One page, one goal** — one primary conversion action, everything else demoted.
- **Value before ask** — show value before demanding commitment.
- **Respect is a conversion lever** — easy dismissal/opt-out, no dark patterns, no fake urgency.
- **Measure before you optimize** — score readiness first, never optimize a fundamentally broken page/flow.
- Fix fundamentals before testing: score <70 → don't run tests.

---

## 2. Page CRO

### Page Conversion Readiness & Impact Index (0–100)
| Category | Weight |
|---|---|
| Value Proposition Clarity | 25 |
| Conversion Goal Focus | 20 |
| Traffic–Message Match | 15 |
| Trust & Credibility Signals | 15 |
| Friction & UX Barriers | 15 |
| Objection Handling | 10 |

Bands: 85+ High Readiness (test optimizations) · 70–84 Moderate (fix key issues first) · 55–69 Low · <55 Not Ready (CRO won't work yet). If <70, **don't recommend testing**.

### Diagnostic order (impact order, not arbitrary)
1. **Value prop & headline clarity** — what problem, for whom, why this over alternatives, what outcome. Failure modes: vague positioning, feature lists without benefits, cleverness over clarity.
2. **CTA strategy & hierarchy** — primary CTA visible above the fold, action+value oriented; secondary actions de-emphasized; repeat at decision points.
3. **Visual hierarchy & scannability** — clear reading path, whitespace, supportive visuals.
4. **Trust & social proof** — relevant to audience, specific (numbers > adjectives), placed near CTAs.
5. **Objection handling** — price/value, fit, time-to-value, complexity, risk of failure; resolve via FAQs, guarantees, comparisons, process transparency.
6. **Friction & UX** — excess fields, slow load, mobile issues, confusing flows.

### Output
Conversion Readiness Summary (score + verdict) → Quick Wins (low effort, high confidence, no test needed) → High-Impact Improvements (validate via testing) → Testable Hypotheses (hypothesis, change, expected impact, primary metric) → copy alternatives with rationale.

**Page-type guidance:** homepage = positioning + audience routing; landing = message match + single CTA; pricing = clarity + risk reduction; feature = benefit framing + proof; blog = contextual CTAs.

---

## 3. Form CRO

For forms that are NOT signup/registration (lead capture, contact, demo request, application, survey, quote, checkout).

### Form Health & Friction Index (0–100)
| Category | Weight |
|---|---|
| Field Necessity & Efficiency | 30 |
| Value–Effort Balance | 20 |
| Cognitive Load & Clarity | 20 |
| Error Handling & Recovery | 15 |
| Trust & Friction Reduction | 10 |
| Mobile Usability | 5 |

Bands: 85+ High-Performing · 70–84 Usable with Friction · 55–69 Conversion-Limited (structural issues) · <55 Broken (**redesign before testing**).

### Core principles
- **Every field has a cost:** 3 fields baseline · 4–6 fields −10–25% · 7+ fields −25–50%+. Fields must earn their place.
- **Data collection ≠ data usage:** if a field isn't used/acted on/required legally → it's friction, not value.
- **Reduce cognitive load first:** people abandon from *thinking* more than typing.

### Field-level rules
Email: single field, inline validation, typo correction, correct keyboard. Name: single field by default. Phone: optional unless critical, explain why if required, auto-format. Company: auto-suggest, infer from email domain. Job title: dropdown if segmentation matters, optional. Free-text: optional unless essential, clear guidance. Radio if <5 options; searchable selects if long.

**Layout:** easiest first (email, name) → commitment-building → sensitive/high-effort last. Labels always visible (placeholders are examples only). Single column default. Multi-step only for 6+ fields with distinct sections (progress indicator, back nav, save progress, one topic per step).

**Errors:** inline validation after interaction (not keystroke), clear visual feedback, never clear input on error, specific + human + actionable ("Please enter a valid email ([name@company.com](mailto:name@company.com))" not "Invalid input").

**Submit:** avoid "Submit/Send"; use action+outcome ("Get My Quote", "Request Demo"). Disabled+loading on submit, clear success state, next-step expectations.

**Trust:** privacy reassurance near submit, expected response time, testimonials when appropriate.

**Mobile:** ≥44px touch targets, correct keyboards, autofill, single column, sticky submit.

**Measurement:** form view→start, start→completion, field-level drop-off, error rate by field, time to complete, device split.

---

## 4. Signup Flow CRO

### Core principles
1. **Minimize required fields** — essential: email/password (or phone); often needed: name; usually deferrable: company, role, team size, phone, address.
2. **Show value before commitment** — let them experience the product first; value first, signup second.
3. **Reduce perceived effort** — progress indicator, group related fields, smart defaults, pre-fill.
4. **Remove uncertainty** — "Takes 30 seconds", show what happens after signup, no surprises.

### Field-by-field
Email: single field, inline validation, typo check. Password: show toggle, requirements upfront, strength meter, allow paste, consider passwordless. Name: single full-name field (test first/last split), optional unless used. **Social auth:** prominent; B2C Google/Apple/Facebook, B2B Google/Microsoft/SSO; often higher conversion than email. Phone: defer unless essential. Company: defer/auto-suggest/infer from domain. Use-case/role: defer to onboarding or keep to one question.

### Single-step vs multi-step
Single-step when ≤3 fields, simple B2C, high-intent visitors. Multi-step when >3–4 fields, complex B2B needing segmentation. Multi-step: progress bar, easy questions first, hard questions after psychological commitment, back nav, save progress. Progressive commitment: email only → password+name → customization (optional).

### Trust & microcopy
"No credit card required" (if true), privacy note, security badges, testimonial near form. Inline validation, specific errors, don't clear form on error.

### Mobile
44px+ targets, proper keyboard types, autofill, social auth, single column, sticky CTA.

### Post-submit
Clear confirmation + immediate next step. If email verification: explain, easy resend, spam reminder, change-email option. Consider delaying verification, magic links, let users explore while pending.

### Measurement
Form start rate, completion rate, field-level drop-off, time to complete, error rate by field, social-vs-email ratio, mobile vs desktop.

---

## 5. Popup CRO

Strategy/copy/triggers/rules for popups, modals, overlays, slide-ins, banners. (Form inside → Form CRO; page → Page CRO.)

### Core principles
1. **Timing > design** — right popup at the wrong moment fails.
2. **Value must be immediate** — user understands the interruption's worth in <3 seconds.
3. **Respect is a conversion lever** — easy dismissal increases long-term conversion.
4. **One popup, one job.**

### Triggers (choose intentionally)
- Time-based: avoid "after 5s"; better 30–60s of active engagement.
- Scroll-based: 25–50% depth — best for long content.
- Exit intent: desktop cursor-to-browser-chrome; mobile back-swipe/scroll-up — e-commerce, lead recovery.
- **Click-triggered (highest intent):** zero interruption cost — lead magnets, demos.
- Session/page count: after X pages/visits.
- Behavior-based: pricing page visits, add-to-cart without checkout, repeated views.

### Popup types
Email capture (specific benefit, email-only field) · Lead magnet (preview what they get, minimal fields, instant delivery) · Discount (clear incentive, single-use/limited) · Exit intent (different offer than entry popup, objection handling) · Announcement banner (one message, dismissable, time-bound) · Slide-in (doesn't block content).

### Copy
Headlines: benefit ("Get [result] in [timeframe]"), question, social proof, curiosity. CTA: first-person + specific ("Get My Guide", "Send Me the Checklist"). Decline copy neutral and respectful ("No thanks", "Maybe later") — no guilt.

### Rules
Visible "X", click-outside and ESC close, mobile-friendly (bottom slide-ups, no full-screen blockers). Frequency cap: max once/session, respect dismissals, 7–30 day cooldown. **Hard exclusions: checkout, signup flows, critical conversion steps.** Accessibility: keyboard navigable, focus trap, screen-reader compatible. Privacy: clear consent, link to policy, no pre-checked opt-ins. Comply with Google interstitial guidelines (no intrusive mobile full-screen popups before content).

### Benchmarks (directional)
Email popup 2–5% · exit intent 3–10% · click-triggered 10%+.

---

## 6. Onboarding CRO

Goal: get users to their **aha moment** as fast as possible and build habits.

### Core principles
1. **Time-to-value is everything** — remove every step between signup and first value; can they experience value *before* signup?
2. **One goal per session.**
3. **Do, don't show** — interactive > tutorial.
4. **Progress creates motivation.**

### Define activation
The action that correlates most strongly with retention (what retained users do that churned users don't). Examples: PM = create first project + add teammate; analytics = install tracking + first report; collaboration = invite first teammate; marketplace = first transaction.

### Post-signup (first 30 seconds)
Product-first (simple/B2C/mobile; risk: blank-slate overwhelm) vs Guided setup (needs personalization; risk: friction before value) vs Value-first (demo data; risk: not "real"). Whatever you choose: clear single next action, no dead ends, progress indication.

### Patterns
- **Checklist:** 3–7 items ordered by value, quick wins first, progress bar, celebration on completion, dismissable. Item = action verb + benefit hint + time estimate.
- **Empty states are onboarding opportunities:** explain what the area is for, show what it looks like with data, primary CTA to add first item, optional import/template.
- **Tooltips/tours:** max 3–5 steps, point to real UI, dismissable, don't repeat for returning users, prefer user-initiated.
- **Progress indicators:** start at 20% not 0%, easy early wins, don't block features behind completion.

### Multi-channel
Trigger-based emails (welcome, incomplete at 24h/72h, activation celebration, feature discovery D3/7/14, stalled re-engagement). Email reinforces in-app actions, doesn't duplicate them, drives back with specific CTA. Push: permission timing critical, clear value, reserve for genuine value moments.

### Engagement loops
Trigger → Action → Variable Reward → Investment. Milestone celebrations acknowledge achievements, suggest next, are shareable.

### Stalled users
Define stall criteria; re-engage with email sequence (value reminder → blockers → help/demo → urgency), in-app recovery (welcome back, pick up where left off), human touch for high-value accounts.

### Metrics
Activation rate, time to activation, onboarding completion, D1/7/30 retention, feature adoption. Funnel: Signup → Step1 → Step2 → Activation → Retention; fix biggest drops.

---

## 7. Paywall & Upgrade CRO

Convert free→paid or upgrade tiers at moments of proven value.

### Core principles
1. **Value before ask** — after the aha moment, never before.
2. **Show, don't tell** — preview what they're missing.
3. **Friction-free path** — easy to upgrade, don't hide pricing.
4. **Respect the no** — easy to continue free, keep trust.

### Trigger points
Feature gates (explain why paid, preview, quick unlock, continue option) · Usage limits (show what upgrade provides, don't block abruptly, option to buy more) · Trial expiration (early warnings 7/3/1 days, value summary, easy reactivation) · Time-based prompts (gentle, dismissable) · Context-triggered (power users, teams, approaching limits).

### Screen components
Headline focuses on **what they get** ("Unlock [Feature] to [Benefit]") not price · value demonstration (preview, before/after, "With Pro you could…") · feature comparison (mark current plan, emphasize recommended, outcomes not feature lists) · clear pricing (annual vs monthly) · optional social proof · specific CTA · **escape hatch** ("Not now" / "Continue with Free" — never shame).

### When NOT to show
During onboarding, mid-flow, repeatedly after dismissal, before product understanding. Frequency: cap per session, cool-down in days, escalate only for genuine deadlines (trial end).

### Dark patterns to avoid
Hiding close button, confusing plan selection, buried downgrade, misleading urgency, guilt-trip copy, surprise charges, hard-to-cancel, bait-and-switch, data hostage.

### A/B test ideas
Trigger timing/type, headline/copy, price presentation (annual vs monthly, per-day framing, "Most Popular" badge), trial length (7/14/30), credit-card-required, feature emphasis, social proof, personalization (usage stats, segment-specific).

### Metrics
Paywall impression rate, CT→upgrade, upgrade completion, revenue/user, churn post-upgrade, time to upgrade.

---

## 8. A/B Testing Discipline

### Hard gates (do not skip)
1. **Hypothesis lock:** observation, single specific change, directional expectation, defined audience, measurable success criteria. Confirm: *"Is this the final hypothesis we are committing to?"*
2. **Validity check:** assumptions about traffic stability, user independence, metric reliability, randomization, external factors (seasonality, releases). If weak → delay/redesign.
3. **Test type:** default A/B; A/B/n needs more traffic; MVT very high traffic; split-URL for structural changes.
4. **Metrics:** ONE primary metric (pre-registered, tied to hypothesis), secondary metrics for context, **guardrail metrics** that must not degrade (stop test if significantly negative).
5. **Sample size & duration:** baseline, MDE, α=95%, power=80%; estimate required n per variant. No sample-size estimate → don't proceed.
6. **Tracking verification:** events fire within 30s; variant ID on every event; no double-count on reload (variant ID in dedup key); first 100 assignments within ±5% of allocation; guardrail dashboards live.

### Running
Do: monitor technical health, document external factors. Don't: stop early on "good-looking" results, change variants mid-test, add traffic sources, redefine success criteria.

### Analyzing
Don't generalize beyond the tested population; don't claim causality beyond the change; don't override guardrail failures. Outcomes: significant positive → consider rollout · significant negative → reject + document · inconclusive → more traffic or bolder change · guardrail failure → don't ship even if primary wins.

### Document
Record: hypothesis, variants, metrics, sample size vs achieved, results, decision, learnings, follow-up ideas — in a shared searchable location.

### Refusal conditions
Unknown baseline, insufficient traffic, undefined primary metric, multiple variables changed without design, unclear hypothesis.

---

## 9. Marketing Psychology

Apply the few models that matter, scored and ethical — never a bias encyclopedia.

### PLFS score
`PLFS = (Leverage + Fit + Speed + Ethics) − Implementation Cost` (−5 → +15). 12–15 apply immediately · 8–11 prioritize · 4–7 test carefully · 1–3 defer · ≤0 don't recommend. Max 5 models; each maps to a specific behavior and includes an ethical note.

### Model selection by journey stage
- **Awareness:** Mere Exposure, Availability Heuristic, Authority, Social Proof.
- **Consideration:** Framing, Anchoring, Jobs-to-be-Done, Confirmation Bias.
- **Decision:** Loss Aversion, Paradox of Choice, Default Effect, Risk Reversal.
- **Retention:** Endowment, IKEA Effect, Status-Quo Bias, Switching Costs.

### Ethics (non-negotiable)
No dark patterns, false scarcity, hidden defaults, or exploiting vulnerable users. Transparency, reversibility, informed choice, user-benefit alignment. If ethical risk > leverage → don't recommend.

### Example application — Paradox of Choice (pricing)
Why: too many options overload cognition → avoidance. Apply: reduce to 3 tiers, highlight "Recommended", hide advanced options behind expansion. Test: 3 vs 5 tiers, recommended vs neutral. Guardrail: never hide pricing or mislead.

---

## 10. Decision: which CRO section for which surface

| Surface | Use |
|---|---|
| Landing/pricing/feature/homepage page | §2 Page CRO |
| Lead/contact/demo/checkout form | §3 Form CRO |
| Account creation / trial signup | §4 Signup CRO |
| Popup/modal/banner | §5 Popup CRO |
| Post-signup product experience | §6 Onboarding CRO |
| Free→paid / upgrade screens | §7 Paywall CRO |
| Any test design & analysis | §8 A/B Testing |
| "Why does this work psychologically" | §9 Psychology |

---

## Sources
Consolidated from: page-cro, form-cro, signup-flow-cro, popup-cro, onboarding-cro, paywall-upgrade-cro, ab-test-setup, marketing-psychology.
