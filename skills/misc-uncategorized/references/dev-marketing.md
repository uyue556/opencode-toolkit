# Developer Marketing & DevRel

Consolidates the jonathimer/devmarketing-skills family: developer-audience-context,
developer-onboarding, developer-churn, developer-listening, developer-newsletter,
developer-advocacy, developer-sandbox, technical-tutorials, changelog-updates,
app-store-changelog, docs-as-marketing, open-source-marketing, power-user-cultivation,
sdk-dx, co-marketing, docs-guard, internal-comms.

## 0. Foundation: Developer Audience Context

Start any dev-marketing task by reading `.agents/developer-audience-context.md`. If missing,
create it via auto-draft from the codebase (README, docs, landing pages, package.json, GitHub
issues, blog posts) or by walking 10 sections: Product overview, Target developers, Personas,
Pain points, Alternatives, Voice & tone, Content channels, Buying process, Competitors,
Positioning. Define the audience once; every other DevRel skill consumes this file.

## 1. Developer Onboarding / TTFV

First value = when the developer *sees the tool doing something useful*, not "made an API call."
Benchmarks: simple APIs <5 min; SDKs <10 min; complex infra <30 min; self-hosted <60 min.
TTFV killers: email verification before dashboard, hidden API keys, quickstart assumes deps,
first example needs paid features, errors without resolution guidance, outdated docs.
TTFV audit: fresh account + screen-record first 30 min + note confusion + time each step; repeat
with 5 personas.
Quickstart structure: specific goal in 5 minutes → prerequisites w/ version check commands →
install (one command, copy button) → init with placeholder key → first request (complete working
example) → expected output shown → next steps. Add progress indicators (Stripe-style) and
contextual next steps (Vercel-style). Never bury the action under history/theory.

## 2. Technical Tutorials

Anatomy: title/meta (what you'll build, time, prereqs) → overview (what you'll learn, final
preview) → prerequisites check (verification commands + expected output) → the build in
progressive steps (layer-cake: each step adds one concept) → checkpoint "it works!" moments →
what you built (recap + full code) → troubleshooting (common errors w/ exact error text →
cause → fix, incl. `EADDRINUSE`, missing module, syntax errors) → next steps.
Copy-paste friendly: complete, runnable blocks; expected output printed after each step;
environment setup made foolproof. Add visual confirmation (screenshot/expected terminal output).

## 3. Developer Churn

Dev churn differs from SaaS churn: value-sensitive not price-sensitive; DX drives decisions;
support tickets = friction not engagement; project-based cycles; peer recommendations win.
The 6 reasons: (1) DX issues, (2) pricing/billing friction, (3) superior alternatives (sudden
churn, team churn together), (4) project death (can't prevent — don't waste energy), (5)
integration failure, (6) involuntary churn (payment).
Health score: API calls 30% + login freq 20% + feature adoption 20% + support sentiment 15% +
billing health 15%. Thresholds: 80-100 healthy, 60-79 watch, 40-59 at-risk, 0-39 critical.
Early-warning signals: API calls -50% WoW, 14+ days no login, pricing-page visits while logged
in, downgrades, data-export questions, sudden silence.
Exit surveys: ≤5 questions, learning not selling, offer value for time. Win-back: wait 30-60
days, 3 emails (what's new → social proof → direct offer 30 days free), never permanent
discounts, nothing for project-death churners. Reduce involuntary churn (often 20-40% of total):
dunning sequence 3-4 emails over ~14 days, smart retries 3-5x over 2 weeks, card-updater
services, in-app warnings. Metrics: monthly churn <5%, net revenue churn <2%, win-back >5%.

## 4. Developer Listening

Monitor technical platforms (GitHub, HN, Reddit programming subs, Stack Overflow, X, Discord).
Keyword categories: brand (incl. misspellings, team names, GitHub org), competitor, problem
(error messages, workflow phrases), buy intent ("best X for Y"). Track sentiment, find frustrated
users before they churn, gather unfiltered feedback, spot content/docs gaps.

## 5. Developer Newsletter

Pick ONE type: product updates / curated links / original content / community digest /
educational series. Weekly is the sweet spot for developers. Strategy: clear identity, audience
context loaded first, content that developers open — practical, specific, skimmable. Address
deliverability (SPF/DKIM/DMARC, see growth-marketing email section).

## 6. Developer Advocacy

Conference talks: pick conference by goal (large industry = reach, niche = expertise).
CFP formula: Specific Problem + Unique Angle + Clear Takeaways. Cover talk proposals, live-coding
demo prep (fail-safe slides, backup branches), podcast appearances, building in public, and
impact measurement.

## 7. Developer Sandbox / Interactive Playgrounds

Principles: instant gratification, progressive complexity, real API + real results, zero friction.
Pre-populated examples (start with the 5 most common use cases; quality checklist). Shareable
URLs, embeddable playgrounds. Gating: keep un-gated for low-friction evaluation; gate for
email/signup; progressive gating strategy. Playground→signup conversion funnel design. Client vs
server-side sandboxes with security considerations (rate limits, no secrets in client).

## 8. Changelogs & Release Notes

Format: Keep a Changelog structure ([Unreleased] + dated version sections). Categories: Added /
Changed / Deprecated / Removed / Fixed / Security. Good entries: specific + quantified
("Reduced API response time by 40%"), include context ("Fixed timeout errors when uploading
large files (#234)"), link resources, explain impact. Bad entries: "New feature", "Fixed bug",
"Various improvements". Use semantic versioning; communicate breaking changes clearly.
App Store notes (app-store-changelog): triage git history by user impact, draft user-facing
bullets (benefit-first), validate against App Store length limits.

## 9. Docs as Marketing

Docs = acquisition (rank in search), activation (quickstarts), retention (references), referral
(developers share docs they love). Four doc types: Tutorials (learning), How-to Guides (task),
Reference (accurate), Explanation (conceptual) — each with a marketing function. Navigation that
reduces bounce: Getting Started → Quickstart (<5 min) → install → core concepts.

## 10. Open Source Marketing

Growth = Real value × Discoverability × First-use experience (any zero ⇒ zero).
README is your landing page: one-liner, badges, GIF/screenshot, Why [project]?, Quick start (<5
lines to first value), install (all platforms), usage examples, docs link, contributing, license.
Repo optimization: keyword-rich description (100 chars), 5-10 topics, releases w/ semver +
changelogs, issue/PR templates, enable discussions + sponsors. Community: build in public, solve
real problems, celebrate contributors, consistent presence.

## 11. Power-User Cultivation

Spectrum: Active user → Engaged → Advocate → Champion → Contributor. Don't push everyone up —
meet developers where they are. Identify candidates by behavioral signals (top-10% usage, long
tenure, multi-project), community signals (answers questions, detailed bug reports), content
signals (blog posts, tutorials, conference talks, Stack Overflow answers). Score candidates;
run champion programs with clear benefits (early access, direct line, recognition), CONTRIBUTING.md
templates, contributor recognition, and content bounty programs.

## 12. SDK DX (sdk-dx)

API design principles: (1) optimize for the common case (least code for the frequent path), (2)
progressive disclosure (Level 1 simple → Level 3 full control), (3) fail fast and clearly
(validate at construction; actionable error messages with next steps), (4) sensible defaults
(auto retries, timeouts, content-type).
Error messages that guide: framework (what happened → why → what to do → where to get help);
distinguish error types (validation/not-found/auth/rate-limit). TypeScript: strong types,
autocomplete-driven design, enum/literal types, JSDoc everywhere + inline examples.
Versioning: semver; define breaking changes; deprecation process with migration guides.

## 13. Co-Marketing

Partner criteria: same buyer persona, different problem; adjacent in workflow; complementary;
similar stage/size. Score partners on audience fit, size, brand alignment, engagement quality,
reciprocity, ease of execution. Find partners in integration ecosystems, adjacent categories,
community signals (shared podcasts, conferences), data (Crossbeam/Reveal, G2 neighbors).
Campaign types: content partnerships, webinars, product/integration marketing, community.
Approach with a cold outreach template; align on goals, ownership, timeline, success metrics.

## 14. Docs Guard (docs-guard)

Review generated/changed documentation before it ships. Severity: accuracy must-fix (wrong
commands, outdated API signatures, incorrect claims), versioning/drift (docs contradict code,
missing migration notes), substance should-fix (missing edge cases, no examples), structure
worth-noting. Verify every command/example against the actual codebase.

## 15. Internal Comms (internal-comms)

Types: 3P updates (Progress/Plans/Problems), company newsletters, FAQ answers, status/incident
reports, leadership updates. Match the type to the right template; format for internal audience
(clarity, action items, no fluff).
