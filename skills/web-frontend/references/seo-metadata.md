# SEO & metadata

Merged from `web-development/frontend-seo` (constants module + automatic canonical +
JSON-LD builders), `web-development/frontend-seo-technical` (crawlability + AI crawler
robots.txt), `front-end/fixing-metadata` (OG cards, previews, debug checklist), and the
landing SEO checklist in `landing-pages.md`.

## Metadata foundation

- **One constants module** for the site: `SITE_NAME`, `SITE_URL` (canonical root),
  `SITE_DESCRIPTION`, `SITE_AUTHOR`, default `og:*`/`twitter:*` images. Import everywhere —
  no scattered strings.
- Every route defines: `title` (≤60 chars, format "Unique | Brand"), `description`
  (≤160 chars, keyword-bearing, CTAs are fine), `canonical` (self URL), Open Graph
  (`og:title`, `og:description`, `og:image` 1200×630, `og:url`, `og:type`), Twitter card,
  `robots` when appropriate.
- Next.js: `export const metadata` (static) or `export async function generateMetadata`
  (dynamic, can `fetch`); use `template` in layouts, `openGraph` from the constants.
- Nuxt/Astro/Svelte equivalents: use framework metadata modules; keep the rule — shared
  constants + per-route title/description/canonical/OG.

## Canonical & pagination

- Canonical is the **self URL** (absolute, per page); guard against stag/query leaks.
  Derive from the route + canonical params; strip utm/campaign params.
- Pagination pages: canonical to self; first page may canonical to `/`. Use
  `og:image` per landing page; prevent duplicates (trailing slash consistency, parameters).

## Structured data (JSON-LD)

Build small builders that take page data and emit verified JSON-LD:

- `Product` — name, image, description, offers(price/currency/availability), review/rating.
- `Article`/`BlogPosting` — headline, datePublished/Modified, author, image, publisher.
- `FAQPage` — pairs of question/answer (must match visible content exactly).
- `Organization`, `Person`, `BreadcrumbList`, `Event`, `WebSite` (+ `SearchAction`).

Validate with Google's Rich Results Test / Schema.org validator before deploy.
Use framework `<script type="application/ld+json">` insertion; test raw HTML output.

## Crawlability & sitemap

- `robots.txt`: exists, valid, not blocking css/js/images, references sitemap.
- Sitemap: generated from routes (Next `app/sitemap.ts`, Astro, or a build step); gzip;
  each page within **3 clicks** of homepage.
- `noindex` intentional vs accidental; check duplicate URLs.
- Crawl budget for >10k pages: prune thin content, parameter handling, sitemap hygiene.

### AI crawler management (2025–2026)

| Crawler | Token | Purpose |
|---|---|---|
| GPTBot | `GPTBot` | OpenAI training |
| ChatGPT-User | `ChatGPT-User` | Real-time browsing (citations) |
| ClaudeBot | `ClaudeBot` | Anthropic training |
| PerplexityBot | `PerplexityBot` | Search index + training |
| Bytespider | `Bytespider` | ByteDance training |
| Google-Extended | `Google-Extended` | Gemini training — NOT Google Search |
| CCBot | `CCBot` | Common Crawl |

Blocking `Google-Extended` doesn't affect Google Search or AI Overviews (`Googlebot`);
blocking `GPTBot` doesn't stop ChatGPT citing via `ChatGPT-User`. Add rules deliberately.

## Social previews & "fixing metadata"

- Card requirements: `title`, `description`, `og:image` (1200×630, ≤5MB, MP4 alt for
  `og:video` where relevant), `url`. Remove `og`/`twitter` mismatches.
- Layering (OpenGraph base → OG video → Twitter card → JSON-LD): the first complete,
  valid layer wins in scrapers; be consistent.
- Verify cards: Facebook Sharing Debugger, Twitter Card validator, LinkedIn post inspector,
  or curl the raw HTML and check `<meta>` tags + preview image URL loads.
- Non-ASCII titles/descriptions need HTML-escaped entities; percent-encode URLs.
- Route `sitemap` and canonical URL correctness in previews — scrapers default to
  `document.URL`.

## Technical SEO checklist (per deploy)

- [ ] Sitemap + robots correct; 200s on canonical URLs; no soft-404s.
- [ ] One h1 per page with primary keyword; heading hierarchy clean.
- [ ] Page Titles unique; description unique; canonical self.
- [ ] OG/Twitter present with valid image URL (200).
- [ ] JSON-LD valid (Rich Results Test) where applicable.
- [ ] Internal links use descriptive anchor text; ≤3-click depth for key pages.
- [ ] Mobile-first rendering; progressive enhancement (content available without JS).
- [ ] http→https; trailing-slash consistent; 301s for moved pages.