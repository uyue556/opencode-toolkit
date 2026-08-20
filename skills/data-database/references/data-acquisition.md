# Data Acquisition

Synthesized from: `web-scraper` (+ references), `firecrawl-scraper`, `x-twitter-scraper`,
`alpha-vantage`, `exa-search`, `tavily-web`, `arrowspace` (spectral search overlap).

## ToC

1. [Web scraping workflow](#web-scraping-workflow)
2. [Strategy selection](#strategy-selection)
3. [Extraction & transformation](#extraction--transformation)
4. [API-based acquisition](#api-based-acquisition)
5. [Respect & reliability](#respect--reliability)

## Web scraping workflow

Clarify → Reconnaissance → Strategy → Extract → Transform → Validate → Format/Deliver.

1. **Clarify**: target, required fields, volume, output format, legal/ethical bounds. Ask before scraping
   when scope is ambiguous. Discovery mode: propose likely targets.
2. **Reconnaissance**: initial fetch → evaluate quality (HTML vs JSON vs JS-rendered) → classify content
   (static page, SPA, API-backed, CSV/PDF).
3. **Strategy**: choose per classification (below).
4. **Extract**: parse per mode (table/list/article/product/contact/FAQ/pricing/events/jobs/custom),
   handle pagination (next-page, cursor, infinite scroll, sitemap).
5. **Transform**: clean, normalize, type-cast; deduplicate; enrich only when useful.
6. **Validate**: check required fields, confidence rating, auto-recover before reporting failure.
7. **Format**: Markdown table / JSON / CSV per user preference; compare across URLs when needed.

## Strategy selection

- **Webfetch + LLM extraction**: simple static pages, low volume.
- **Browser automation**: JS-rendered/SPA, login-required, infinite scroll — use headless browser
  with realistic UA and waits.
- **Bash (curl + jq)**: JSON APIs, CSV downloads, XML parsing — fastest and most robust when the data
  is already structured.
- **Hybrid**: fetch HTML, then switch strategies if content is client-rendered.
- **Dedicated services**: Firecrawl for deep scraping, screenshots, PDF parsing, crawling at scale;
  robust retry/rate-limit handling.
- **X/Twitter (Xquik)**: tweet search, user lookup, follower export, media downloads, monitors,
  webhooks. Inspect any third-party SDK before installing; use the TypeScript SDK + API key.
- **ArrowSpace**: spectral vector search via graph Laplacian eigenstructure — when cosine/L2 similarity
  misses latent structure (adjacency/community patterns), e.g. link graphs, product affinity.

## Extraction & transformation

- Table mode → parse rows/columns with header mapping. List mode → repeated item pattern. Article mode →
  title/author/date/body (+ reading time). Product mode → name, SKU, price, currency, availability,
  reviews. Contact mode → email/phone/address (verify format). Pricing mode → plan tiers + price + period.
- Multi-URL extraction: parallelize with rate limiting; keep a stable order; dedupe across URLs.
- Transforms always: trim whitespace, normalize currency/numbers, standardize dates, collapse empty rows.
- Output rules: Markdown tables get clean headers/alignment; JSON is flat and typed; CSV escapes
  correctly. Enrichment (geocoding, category lookup) only when it adds decision value.

## API-based acquisition

- **Alpha Vantage**: financial market data — equities, options, forex, crypto, commodities, economic
  indicators. Get an API key, use the documented base URL + request pattern, respect rate limits
  (delay between requests; exponential backoff on 429/5xx). Categories: quote, daily OHLCV, fundamentals,
  income statement, crypto, indicators. Check the API for errors before parsing.
- **Exa**: semantic search + similar content + structured research API.
- **Tavily**: web search + content extraction + crawling + research.
- General: treat API docs as source of truth; handle pagination, rate limits, and schema changes;
  cache responses you'll reuse.

## Respect & reliability

- Rate limit politely (add delay), respect robots.txt and ToS, respect access terms (auth/paywalls).
- Don't over-fetch; store only what you need; keep personal data handling compliant.
- Failure protocol: retry with backoff → degrade gracefully → report precisely what failed.
- Assume target sites change structure; validate schema per run and alert on drift.
