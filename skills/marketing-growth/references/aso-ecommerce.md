# ASO & E-commerce Reference

App Store Optimization and e-commerce integration guidance.

## Table of Contents
1. App Store Optimization (ASO)
2. E-commerce / Product Catalog

---

## 1. App Store Optimization (ASO)

Complete workflow for Apple App Store and Google Play: research, metadata, conversion, ratings/reviews, launch/updates, analytics.

### Platform requirements (verify current limits before launches)
| Field | Apple App Store | Google Play |
|---|---|---|
| Title | 30 chars | 50 chars |
| Subtitle | 30 chars | — |
| Promotional text | 170 chars (editable without app update) | — |
| Short description | — | 80 chars |
| Full description | 4,000 chars | 4,000 chars |
| Keywords | 100 chars (comma-separated, no spaces, no plurals/dups) | none (extracted from title + description) |
| What's New | 4,000 chars | — |

### Keyword research
Balance search volume vs competition; relevance first; include 3–4 word long-tails; research quarterly; don't copy competitor keywords blindly. Front-load keywords in title/description; write for humans first, SEO second.

### Metadata
- Apple: optimize title + subtitle + 100-char keyword field (no plurals, duplicates, or spaces between commas) + promotional text.
- Google: keywords come from title/description — use every character.
- Focus on user benefits, not feature lists; A/B test titles/descriptions/screenshots; refresh on major updates.

### Visual assets
Icon recognizable at 60×60px and is the single most important visual element (A/B test it). **First 2–3 screenshots decide** — most users don't scroll; use captions to tell the value story; consistent visual style.

### Ratings & reviews
Respond within 24–48h, always courteous; address reported issues; thank supporters; prompt for ratings after positive experiences (never after bugs/billing issues).

### Launch & updates
Soft-launch in smaller markets; coordinate PR with launch; update frequently (signals active development); monitor daily first 2 weeks; iterate on critical issues immediately.

### Localization
Prioritize EN/ES/ZH/FR/DE; native speakers, not machine translation; cultural adaptation; test locally; measure downloads per locale.

### ASO Health Score (0–100)
Four 25-point buckets: Metadata Quality · Ratings & Reviews · Keyword Performance (top-10/50/100 counts) · Conversion Metrics (impression→install). Output specific, prioritized recommendations.

### Tracking
Keyword position changes, impression→install conversion, download velocity, category benchmarks. **Note:** keyword search volume is approximate (no official data); Apple keyword changes require app submission (except promotional text); Play changes index in 1–2 hours; store algorithms change without notice.

### Scope boundaries
Does NOT cover paid acquisition (Apple Search Ads, Google Ads), app development, analytics implementation, or submission technical issues. Not for web apps, private enterprise apps, or beta-only apps.

### A/B testing
Define hypothesis, test variables (icon, first screenshot, title), duration from sample-size math, success metrics, significance thresholds.

---

## 2. E-commerce / Product Catalog

### BuyWhere product catalog (AI shopping agents)
BuyWhere exposes a product-catalog surface for shopping flows, price comparison, and deal discovery via MCP or API.

- **Entry points:** developer portal `https://buywhere.ai/developers/` · API key signup `https://buywhere.ai/api-keys/` · MCP guide `https://api.buywhere.ai/docs/guides/mcp` · Cursor plugin `https://github.com/BuyWhere/buywhere-cursor-plugin`.
- **Workflow:** confirm the integration surface (portal/API keys/MCP guide/plugin) → confirm the user's runtime (Cursor / Claude Desktop / custom MCP client / REST API) — don't assume the same config across hosts → guide the first successful connection with one minimal product-search request → expand into price comparison, deal discovery, shopping-agent routing.
- **Best practices:** start from the live developer portal or API-key flow before config details; keep the first proof to one successful query; don't claim product/retailer counts without runtime evidence; avoid deprecated docs.
- **Security:** treat API keys as secrets; placeholders only; confirm the target host before suggesting filesystem paths or commands.

### General e-commerce marketing note
For e-commerce campaigns use the paid-ads (Advantage+ Shopping, catalogs, retargeting windows) and email references (cart abandonment is bottom-of-funnel retargeting + failed-payment-style recovery flows); reference `references/paid-ads.md` and `references/email-marketing.md`.

---

## Sources
Consolidated from: app-store-optimization, buywhere-product-catalog.
