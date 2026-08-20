# SEO Reference

Technical SEO, indexing, on-page, programmatic SEO, schema, GEO, social metadata, local SEO, and drift monitoring. Use the routing table in SKILL.md to pick the section.

## Table of Contents
1. Indexing & Crawl Health (Search Console)
2. Tools/Product Page SEO at Scale (Content Registry)
3. Programmatic SEO
4. Schema & Structured Data
5. Generative Engine Optimization (GEO)
6. Social Metadata / Open Graph
7. Local SEO (Legal & Professional Services)
8. SEO Drift Monitoring
9. Reusable Checks & Scripts

---

## 1. Indexing & Crawl Health

### Search Console coverage states and fixes

| Status | Meaning | Fix |
|---|---|---|
| Crawled – not indexed | Google crawled but chose not to index | Improve content quality + canonical + internal links |
| Duplicate without canonical | Multiple URLs, no canonical | Add explicit canonical to preferred URL |
| Excluded by noindex | `noindex` present | Remove if the page should be indexed |
| Duplicate, Google chose different canonical | Google prefers a different URL | Align canonical with what Google naturally picks |
| Alternative page with proper canonical | Correct | Expected behavior, not a problem |
| Not found (404) | Page deleted/URL changed | Redirect or restore |
| Discovered – not indexed | Known but not crawled | Improve internal linking + crawl budget |
| Page with redirect | Chain or wrong target | Shorten chain, verify destination |

### Canonical rules
- Absolute URL, consistent scheme + www/subdomain, consistent trailing slash.
- In Next.js App Router: `export const metadata = { alternates: { canonical: 'https://…' } }` or via `generateMetadata`. Relative URLs are wrong.
- A `robots` (noindex) set in the root `layout.js` affects the **entire site** — only set it there intentionally.

### Audit checks (run on the live site)
```bash
# noindex audit
rg -n --glob '*.{js,ts,jsx,tsx}' 'noindex|robots.*noindex' app pages
# sitemap health
curl -sI https://yourdomain.com/sitemap.xml | grep -i "content-type\|status"
# static rendering (Next.js build) — ● static good, λ dynamic risky
npm run build 2>&1 | grep -E "○|●|λ"
# orphan detection — pages with <2 inbound links
for slug in $(cat data/slugs.txt 2>/dev/null); do
  C=$(grep -rl "$slug" templates/ 2>/dev/null | wc -l | tr -d ' '); [ "$C" -lt 2 ] && echo "ORPHAN RISK: $slug"
done
# redirect chains
curl -sI https://yourdomain.com/old-url | grep -i location
# robots.txt must allow important content
curl -s https://yourdomain.com/robots.txt
```

### Key principles
- Every important page needs ≥1 inbound internal link (homepage/nav + sitemap + one content page).
- Dynamic routes with known slugs should be statically generated (`generateStaticParams` in Next.js).
- Keep redirects flat: A → B → C should be A → C; use `permanent: true` (308) for SEO.
- For a full 10-phase architectural audit (indexing health → crawl architecture → sitemap → URL design → redirects → content quality → server health → performance → internal-linking redesign → rebuild plan), see the `indexing-issue-auditor` and `nextjs-seo-indexing` sources; deliver a **Master Issue Control Table** with Layer / Root Cause / Fix / Priority.

---

## 2. Tools/Product Page SEO at Scale (Content Registry)

Applies to any site with many tool, product, or feature pages. Root cause of poor rankings on such sites: **80–95% of pages share identical template prose** → Google treats them as thin near-duplicates and ranks none well. Fix content uniqueness *before* anything else.

### Phase 0 — Codebase reconnaissance (before writing code)
- How are pages generated (static, DB loop, config registry, CMS)?
- Where is the shared `<title>`/`<meta>`/`<h1>` template?
- Does each item have its own content fields or shared prose?
- Is there a central list of slugs to iterate programmatically?

### Meta title formula
```
{Tool Name} | {Specific Outcome} — {Brand}
```
Rules: ≤60 chars; primary keyword in the first 40; **unique per page**; include "Free" where accurate.

### Meta description formula
```
{What it does — one action sentence}. {Key differentiator}. {CTA}.
```
Rules: 120–160 chars; action verbs (Generate, Scan, Check, Analyze, Convert, Build, Find); custom per page.

### Content registry entry (framework-agnostic)
```yaml
slug: meta-tag-generator
meta_title: "Meta Tag Generator | Create Perfect SEO Titles & Descriptions Free"
meta_description: "Generate optimized title tags and meta descriptions with live character counters. Enforces Google's 60/160 char limits. Instant, free, no account needed."
introduction: >   # 80+ unique words minimum
best_practices:    # 3–5 tool-specific items
how_to_steps:      # 3 real steps for THIS tool
faqs:              # 2 tool-specific Q&As
related_tools:     # 2–4 slug references → internal links
```
Complete one tool fully before starting the next; never commit a partial batch.

### H1 & hierarchy
- One H1 per page = tool name. `h1 → h2 (How It Works, Best Practices, FAQs, Related Tools) → h3`. Never skip levels.

### Internal linking
- Every tool links **to** ≥2 related tools; linked **from** ≥2 others; no orphans; reachable within 3 clicks from home. Related-tool sections pass far more PageRank than a sidebar.

### URL slugs
`{primary-keyword-phrase}` — lowercase, hyphens, no stop words, no "free/online/tool" padding. 301 old → new when renaming.

### E-E-A-T (tool sites look authorless otherwise)
- Author byline + last-updated `<time>` on every tool page; `/about` with real name, credentials, contact; a trust-pillars section ("100% Free", "Privacy First", "Instant Results").

### Blog content strategy for position 50–68 keywords
Tool pages rank for transactional queries; informational queries need blog posts.
- Find them: Search Console → filter Position >49 AND <69.
- Format: `{Informational keyword} — {Year} Guide`, 1,000–1,500 words, answer the question in the first paragraph, 2–3 **inline contextual links** to tools in body copy, `datePublished`/`dateModified` schema.

---

## 3. Programmatic SEO

Decide whether building 100–10,000 templated pages is a good idea *before* building.

### Feasibility Index (0–100)
| Category | Weight |
|---|---|
| Search Pattern Validity | 20 |
| Unique Value per Page | 25 (**most important**) |
| Data Availability & Quality | 20 |
| Search Intent Alignment | 15 |
| Competitive Feasibility | 10 |
| Operational Sustainability | 10 |

Bands: 80–100 Strong Fit · 65–79 Moderate Fit · 50–64 High Risk · <50 **Do Not Proceed** (stop, recommend alternatives).

### Core principles
- **Page-level justification:** every page must answer "why does this page deserve to exist separately?" If unclear, don't index it.
- **Data defensibility hierarchy:** proprietary > product-derived > user-generated > licensed > public. Weaker data requires stronger editorial value.
- **Intent completeness:** each page fully satisfies its intent (informational/comparative/local/transactional). Partial answers at scale = high risk.
- **Quality at scale:** 100 excellent pages > 10,000 weak ones. Avoid doorway pages, auto-generated filler, near-duplicates.

### Playbooks (only where data + intent + feasibility support them)
Templates, Curation, Conversions, Comparisons, Examples, Locations, Personas, Integrations, Glossary, Translations, Directories, Profiles.

### Indexation control
Index only pages with demand + unique value + complete intent. Segment sitemaps by page type; monitor indexation rate per pattern.

### Kill switch criteria (halt/rollback)
High impressions + low engagement at scale · thin-content warnings · index bloat with no traffic · algorithmic suppression signals.

---

## 4. Schema & Structured Data

### Eligibility Index (0–100)
| Category | Weight |
|---|---|
| Content–Schema Alignment | 25 |
| Rich Result Eligibility (Google) | 25 |
| Data Completeness & Accuracy | 20 |
| Technical Correctness | 15 |
| Maintenance & Sustainability | 10 |
| Spam / Policy Risk | 5 |

Bands: 85+ Strong Candidate · 70–84 Valid but Limited · 55–69 High Risk · <55 **Do Not Implement**. Proceed only at ≥70.

### Core rules
- **Accuracy over ambition:** schema must match visible content exactly. Automatic failure if schema describes content not shown.
- **Google first, schema.org second:** only types Google supports earn rich results.
- Minimal, purposeful markup; more schema ≠ better SEO. Use `@graph` for multiple entities (one primary entity per page).
- Validate with Google Rich Results Test + Schema.org validator + Search Console Enhancements.

### Common types by page
| Page | Schema |
|---|---|
| Homepage | `WebSite` + SearchAction (sitelinks searchbox) |
| Tool/SaaS app | `SoftwareApplication` (applicationCategory, offers, featureList) |
| Blog post | `BlogPosting`/`Article` (author, publisher, datePublished/Modified, image) |
| FAQ sections | `FAQPage` (only if Q&A visible; not promo) |
| Step-by-step guides | `HowTo` (only genuine instructions, not funnels) |
| All non-home pages | `BreadcrumbList` |
| About/contact | `Organization` (sameAs, contactPoint, logo) |
| Real products | `Product` (price/availability must be visible) |
| Physical businesses | `LocalBusiness` |
| Genuine reviews | `Review`/`AggregateRating` — no self-serving reviews, ratings must match visible content |

### Implementation notes
- Each schema in its **own** `<script type="application/ld+json">` tag; don't merge into one object.
- React/Next.js: server-side render JSON-LD, escape `</` as `\u003c`. WordPress/CMS: structured plugins or custom fields, never hardcoded theme schema.
- JSON-LD in static HTML, not client-rendered.

---

## 5. Generative Engine Optimization (GEO)

Goal: be **cited** in AI answers (ChatGPT, Perplexity, Claude, Gemini), not just rank #1.

### What gets cited
Original statistics · expert quotes (name + title) · clear definitions · step-by-step guides · comparison tables · FAQ sections (3–5 Q&A) · "Last updated" timestamp · author with credentials.

### Content checklist
Question-based titles; TL;DR summary at top; original data with sources; Article + Person + FAQPage schema; fast load (<2.5s); clean HTML.

### Technical
- Allow AI crawlers you want citations from: GPTBot (OpenAI), Claude-Web, PerplexityBot, Googlebot (Gemini). Decide allow/block/selective per strategy.
- Entity building: Google Knowledge Panel, consistent NAP/info across the web, industry mentions.

### Anti-patterns
No dates → add timestamps · vague attributions → name sources · no author → show credentials · thin content → comprehensive coverage.

### Measurement
Manual "According to [Brand]" searches, citation-rate tracking, competitor citation share, AI-referred traffic (UTM).

---

## 6. Social Metadata / Open Graph

Make every shareable URL unfurl as a rich card on Facebook, LinkedIn, X, WhatsApp, Telegram, Slack, Discord.

### Why previews break
| Problem | Root cause |
|---|---|
| No preview | Missing og:title/description/image |
| Broken image | Relative URL (must be absolute) |
| Wrong size | Not 1200×630 (OG standard) |
| Plain text card | twitter:card missing or `summary` |
| Stale preview | Platform caching |
| Missing on crawl | Tags added by client-side JS |

### Gold-standard block (Next.js pattern)
```js
export function buildSocialMetadata({title, description, path, image, imageAlt, imageWidth=1200, imageHeight=630}) {
  const baseUrl = process.env.NEXT_PUBLIC_BASE_URL || 'https://www.yourdomain.com';
  const imageUrl = image?.startsWith('http') ? image : `${baseUrl}${image}`;
  const pageUrl = `${baseUrl}${path}`;
  return {
    alternates: { canonical: pageUrl },
    openGraph: { title, description, url: pageUrl, type: 'website', images: [{ url: imageUrl, secureUrl: imageUrl, width: imageWidth, height: imageHeight, alt: imageAlt || title }] },
    twitter: { card: 'summary_large_image', title, description, images: [imageUrl] },
  };
}
```
Set `metadataBase` when using relative metadata URLs.

### OG image rules
1200×630 (2:1), <8MB, HTTPS, no spaces in filename, JPEG/PNG, GET-accessible without auth.

### Platform notes
- Facebook: aggressive cache → Sharing Debugger to recrawl.
- X/Twitter: `summary_large_image`, absolute `twitter:image`, Card Validator.
- LinkedIn: caches hard → Post Inspector; ignores `twitter:` tags; image ≥1.91:1.
- WhatsApp/Telegram/Slack/Discord: use OG tags; Discord supports `og:type=article` for richer embeds.
- Debug: `curl -s <url> | grep -i "og:\|twitter:"` — if absent, tags are JS-rendered (not crawlable).

---

## 7. Local SEO (Legal & Professional Services)

Local legal sites are YMYL; Google Business Profile + E-E-A-T + citations dominate rankings. Priority order: **GBP → E-E-A-T → on-page → technical → citations → content → reviews.**

### Google Business Profile audit
Name matches website/directories exactly · correct primary + secondary categories · full address/service area · consistent phone · services listed · Q&A populated · photos updated regularly · owner responses to all reviews · review velocity healthy · regular GBP posts.

### E-E-A-T (legal)
- **Experience:** case studies/results, field experience, expert-witness history (forensic).
- **Expertise:** bio pages with credentials, bar/council registration, specializations, publications, speaking.
- **Authoritativeness:** cited externally, authoritative directories, media/press, associations.
- **Trustworthiness:** real "About", verifiable address, contact page, privacy/terms, HTTPS, no outcome guarantees, disclaimers.

### On-page
One page per practice area (`[Service] em [City] | [Firm Name]` titles) · unique expert content · location pages per city (unique, embedded map, NAP consistent) · LegalService/ProfessionalService schema · FAQ pages with FAQ schema.

### Technical
Mobile click-to-call, LCP<2.5s, CLS<0.1, INP<200ms, robots not blocking key pages, clean URLs.

### Citations & reviews
NAP identical everywhere; dedupe duplicates; legal directories (Avvo, FindLaw, Justia, Martindale-Hubbell, OAB, Jusbrasil); reviews vs. top-3 local competitors; request reviews after consultation/case resolution.

---

## 8. SEO Drift Monitoring

Detect regressions by comparing a **known-good baseline** to later snapshots.

- Capture: search performance (clicks/impressions/position from Search Console), indexation status, title/meta/H1, canonical + robots, schema types present, word count/fingerprint.
- Diff in 5 groups: rankings, indexation, metadata, directives, schema. Separate expected content changes from unexplained regressions.
- Severity: **Critical** = newly noindexed/deindexed/wrong canonical · **Warning** = material ranking decline, blank/generic metadata, missing schema · **Info** = benign change.
- Treat missing data as `unknown`, not zero. Verify a critical directive change with a second live fetch before escalating. Label causes as hypotheses.
- Keep the URL set and Search Console window stable between comparisons; compare equivalent windows.

---

## 9. Reusable Checks & Scripts

- `scripts/validate_meta.py` — pre-deploy gate: every entry has unique title ≤60, description 120–160, non-empty intro. Run before every commit.
- Live verify function (bash): all key pages 200, invalid slug 404, canonical present, favicon 200, ≥1 `application/ld+json` block.
- Batch-completion gate (bash/python): count tools with intro content vs. total; only commit at 100%.
- Duplicate-title check (python): ensure all `meta_title` values unique.

## Sources
Consolidated from: tools-page-seo-optimizer, nextjs-seo-indexing, indexing-issue-auditor, programmatic-seo, schema-markup, schema-markup-generator, social-metadata-hardening, geo-fundamentals, local-legal-seo-audit, seo-drift, keyword-extractor.
