# SEO / AEO (AI Search / GEO)

Consolidates: seo-aeo-landing-page-writer, seo-aeo-meta-description-generator,
seo-aeo-schema-generator, seo-aeo-internal-linking, seo-dataforseo, seo-geo, seo-hreflang,
seo-images, seo-page, seo-programmatic, seo-schema, seo-sitemap, seo-competitor-pages,
alternatives-pages, pagespeed-enhancer, analytics.

## 1. When to Use

- Building/rewriting landing pages or blog content that must rank in search AND be citable by AI.
- Writing title tags / meta descriptions / schema / sitemaps / hreflang.
- Auditing a single page, an image set, a sitemap, or a programmatic SEO system.
- GEO work: optimizing for ChatGPT, Perplexity, AI Overviews, llms.txt.

## 2. GEO / AI Search (from seo-geo)

Key data points (Feb 2026):
- AI Overviews reach 1.5B users/month, >50% of queries; ChatGPT 900M weekly users.
- **Brand mentions correlate ~3x more strongly with AI visibility than backlinks.** YouTube
  mentions ~0.737, Reddit high, Wikipedia high; Domain Rating only ~0.266.
- Only 11% of domains are cited by both ChatGPT and Google AI Overviews → platform-specific work.

GEO analysis criteria (weights):
1. **Citability (25%)** — optimal passage length **134–167 words**; direct answer in first 40–60
   words; definitions following "X is…"; self-contained answer blocks; specific stats with sources.
2. **Structural readability (20%)** — clean H1→H2→H3; question-based headings; short paragraphs
   (2–4 sentences); tables for comparison; lists for steps.
3. **Multi-modal (15%)** — content with multi-modal elements sees ~156% higher selection rates.
4. **Authority & brand signals (20%)** — byline w/ credentials, pub + last-updated dates, citations
   to primary sources, Wikipedia/Wikidata presence, mentions on Reddit/YouTube/LinkedIn.
5. **Technical accessibility (20%)** — AI crawlers do NOT execute JS → SSR critical; robots.txt
   allows GPTBot, OAI-SearchBot, ClaudeBot, PerplexityBot (block CCBot/training crawlers if desired);
   `/llms.txt` present; RSL 1.0 licensing.

Platform citation sources: Google AIO ← top-10 pages (92%); ChatGPT ← Wikipedia (47.9%), Reddit
(11.3%); Perplexity ← Reddit (46.7%); Bing Copilot ← Bing index + IndexNow.

llms.txt format (`/llms.txt` at domain root):
```
# Title of site
> Brief description
## Main sections
- `Page title -> https://example.com/page`: Description
## Optional: Key facts
- Fact 1
```

Output a `GEO-ANALYSIS.md`: readiness score /100, platform breakdown, crawler status, llms.txt
status, brand-mention analysis, passage citability, SSR check, top-5 high-impact changes, schema
recommendations, content reformatting suggestions.

## 3. Landing Page Writer (seo-aeo-landing-page-writer)

Map inputs: product name, audience, primary keyword, pain points, features→benefits, USPs, social
proof, CTAs. Write a **25–40 word AEO extraction sentence** answering "What is [product]?" —
standalone, no jargon, placed in a blockquote right after the H1.

Narrative arc (in exact order): Hero (H1 + AEO sentence + CTA) → Problem (pain only, no product) →
Solution → Features-as-Benefits (table) → Social proof → Mid-page CTA → How It Works (numbered) →
Comparison (table, include ≥1 honest point where the alternative wins) → FAQ (≥6 entries, each
<50 words, self-contained) → Trust signals → Final CTA.

Checklists: keyword in title/H1/first paragraph; headings hierarchical; FAQ count; no
"revolutionary/game-changing/best-in-class"; no "Submit"/"Click Here" CTAs; paragraphs ≤4 lines.

## 4. Meta Description & Title Generator

3 variants each, distinct CTR mechanics: V1 Benefit lead, V2 Question hook, V3 Social
proof/specificity.
- Title: 50–60 chars (hard 60). Meta: 140–155 chars (hard 160). Never end mid-sentence near limit.
- Primary keyword in first 3 words of title; first half of description. ≥1 power word; description
  ends with CTA verb. No "click here", no all-caps, no passive openers.
- OG/Twitter tags: write distinct, more conversational copy — never copy-paste the meta description.

## 5. Schema Generator

Supported types → rich results: FAQPage, Article, Product, HowTo, Review, AggregateRating,
BreadcrumbList, Organization, WebPage, WebSite. Default recommendations: landing pages →
FAQPage + Product + BreadcrumbList; blog → Article + FAQPage + BreadcrumbList.
- One `<script type="application/ld+json">` block per type (never combine).
- Required fields missing = Critical; recommended missing = warning; do not ship incomplete schema.
- All URLs absolute `https://`; no HTML in JSON-LD strings; validate in Google Rich Results Test;
  request re-indexing after deploy (rich results can take weeks).
- FAQPage schema is the strongest AEO signal — put it on any page with an FAQ section.

## 6. Internal Linking

1. Detect orphan pages (zero incoming links) — fix these before adding new links.
2. Semantic overlap matrix: match pages by primary-keyword similarity + content summary.
3. Assign link types: **Cluster → Pillar** (highest priority), **Pillar → Cluster**, **Cluster →
   Cluster**, **Contextual Boost**.
4. Write a context sentence for every anchor — the anchor must read naturally.
5. Anchor rules: exact-match anchor for same target only once; never "click here/read more/learn
   more"; <100 outgoing links per page.

## 7. Programmatic SEO

Assess data source, template engine, URL patterns, internal-link automation. Quality gates before
scaling: unique content per page (compute uniqueness — penalized content is auto-detected as
thin/reused), canonical strategy, sitemap integration, index-bloat prevention.
- Safe at scale: genuine per-item data pages (products, locations, people with real attributes).
- Penalty risk at scale: near-duplicate pages with templated filler, doorway pages, no unique value.

## 8. On-page, Images, Sitemap, Hreflang Quick Checks

**Single page** (`seo-page`): title/H1 uniqueness, meta, headings hierarchy, content quality,
internal links, canonical, schema present, image alts, Core Web Vitals (reference).

**Images** (`seo-images`): descriptive alt text, file size (compress), modern format (WebP/AVIF,
JPEG XL emerging), `<picture>` + srcset for responsive, `loading="lazy"` for non-LCP,
`fetchpriority="high"` + `decoding="async"` for LCP image, explicit width/height to prevent CLS,
descriptive file names, CDN usage.

**Sitemap** (`seo-sitemap`): validate well-formed XML, correct `<lastmod>`, all URLs reachable,
no blocked-by-robots entries; sitemap index for >50k URLs.

**Hreflang** (`seo-hreflang`): every URL has self-referencing tag, return tags on each paired
language page, `x-default` present, valid language/region codes (ISO 639-1 / 3166-1), canonical
URLs align with hreflang, protocol-consistent, cross-domain support. Methods: HTML `<link>` tags,
HTTP headers, or XML sitemap (recommended for large sites).

## 9. Alternatives / Comparison Pages

Page types: "X vs Y", "Alternatives to X", "Best [category] tools", comparison tables.
- Keyword categories: "[competitor] alternative", "[competitor] vs [you]", "switch from X".
- Honest tables: feature matrix with accurate data; mark subjective comparisons; include migration
  concerns (data import, pricing, learning curve).
- Name competitors when you have honest, factual differentiators; stay general when you don't.
- Legal: no defamation/false claims; use trademarks nominatively; consult legal when uncertain.
- Schema: Product + AggregateRating (all four fields: ratingValue, reviewCount, bestRating,
  worstRating), SoftwareApplication, ItemList.

## 10. PageSpeed Enhancer

Phase workflow: (1) ingest & classify URL; (2) batch-scan 4 sections — Performance, Accessibility,
Best Practices, SEO (Lighthouse/PageSpeed); (3) risk report; (4) fix in batches:
- Quick wins: image compression (cwebp/sharp/sips/Pillow), self-host fonts + woff2 + `@font-face`,
  preconnect, `fetchpriority`, lazy-load below-fold.
- Medium: server-side caching, static generation, remove unused JS, inline critical CSS.
- Refactor tier: full QA cycle (route splitting, edge caching).
Pre-deploy gate + verification checklist (re-run scans, compare scores).

## 11. DataForSEO CLI (seo-dataforseo)

Commands (MCP-backed, mind API credits):
- SERP: `/seo dataforseo serp <kw>`, `serp-youtube <kw>`, `youtube <video_id>`
- Keywords: `keywords <seed>`, `volume <kws>`, `difficulty <kws>`, `intent <kws>`, `trends <kw>`
- Domain/competitors: `backlinks <domain>`, `competitors <domain>`, `ranked <domain>`,
  `intersection <d1> <d2>`, `traffic <domains>`, `top-searches <domain>`
- Technical: `onpage <url>`, `tech <domain>`, `whois <domain>`
- Content: `content <kw/url>`, `listings <kw>`

## 12. Analytics (from analytics)

Principles: track for decisions not data; start with questions; consistent naming; maintain data
quality.
- Event naming: **Object-Action** (`project_created`, `plan_upgraded`).
- Essential events: marketing site (page_view, form_submit, cta_click); product (signup_completed,
  feature_used, plan_upgraded, error_seen).
- Standard props: user id, plan, source, timestamp; UTM params standardized.
- GA4 quick setup + custom events; GTM container + dataLayer pattern; debug/validate events.
