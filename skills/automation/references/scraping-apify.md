# Web Scraping & Extraction: Apify

AI-driven data extraction with Apify Actors. Two modes: **run existing actors** (selection, schema, execute, summarize)
and **build your own** (actor development & actorization). Also covers the e-commerce scraping workflow.

## ToC
- [Running an actor (quick workflow)](#running-an-actor-quick-workflow)
- [Actor selection by use case](#actor-selection-by-use-case)
- [E-commerce scraping workflow](#e-commerce-scraping-workflow)
- [Building actors](#building-actors)
- [Actorization (convert existing software)](#actorization-convert-existing-software)

## Running an actor (quick workflow)

1. **Understand the goal and select an Actor** (tables below).
2. **Fetch the Actor's input schema**:
   ```bash
   export $(grep APIFY_TOKEN .env | xargs) && mcpc --json mcp.apify.com \
     --header "Authorization: Bearer $APIFY_TOKEN" tools-call fetch-actor-details \
     actor:="ACTOR_ID" | jq -r ".content"
   ```
   (Requires `.env` with `APIFY_TOKEN`, Node 20.6+, and `npm install -g @apify/mcpc`.)
3. **Ask the user preferences**: output format (Quick answer in chat / CSV / JSON) and result count.
4. **Run** with `scripts/run_actor.js` (see `../scripts/`):
   ```bash
   node --env-file=.env ../scripts/run_actor.js --actor "ACTOR_ID" --input 'JSON_INPUT'
   # or --output YYYY-MM-DD_file.csv --format csv | --format json
   ```
5. **Summarize**: count of results, file location, key fields, and suggested follow-up actors.

If no Actor matches, search the Apify Store: `tools-call search-actors keywords:="SEARCH_KEYWORDS" limit:=10`.

**Cost safety:** check the Actor's live pricing before a paid run; show actor, targets, result cap, and max charge; get
explicit approval; set a conservative `maxItems` (applies across the whole run).

Error handling: `APIFY_TOKEN not found` → create `.env`; `mcpc not found` → install; `Actor not found` → check ID
spelling; `Run FAILED` → check the console link in the error; `Timeout` → reduce input size or raise `--timeout`.

## Actor selection by use case

| Use case | Primary actors |
|---|---|
| **Lead Generation** | `compass/crawler-google-places`, `poidata/google-maps-email-extractor`, `vdrmota/contact-info-scraper` |
| **Influencer Discovery** | `apify/instagram-profile-scraper`, `clockworks/tiktok-profile-scraper`, `streamers/youtube-channel-scraper` |
| **Brand Monitoring** | `xquik/x-tweet-scraper`, `apify/instagram-tagged-scraper`, `apify/instagram-hashtag-scraper`, `compass/Google-Maps-Reviews-Scraper` |
| **Competitor Analysis** | `apify/facebook-pages-scraper`, `apify/facebook-ads-scraper`, `apify/instagram-profile-scraper` |
| **Content Analytics** | `apify/instagram-post-scraper`, `clockworks/tiktok-scraper`, `streamers/youtube-scraper` |
| **Trend Research** | `apify/google-trends-scraper`, `clockworks/tiktok-trends-scraper`, `apify/instagram-hashtag-stats` |
| **Review Analysis** | `compass/Google-Maps-Reviews-Scraper`, `voyager/booking-reviews-scraper`, `maxcopell/tripadvisor-reviews` |
| **Audience Analysis** | `xquik/x-follower-scraper`, `apify/instagram-followers-count-scraper`, `clockworks/tiktok-followers-scraper` |
| **E-commerce** | `apify/e-commerce-scraping-tool` (Amazon 20+ regions, Walmart, Costco, HomeDepot, European retailers, IKEA, Google Shopping) |

Useful chained workflows: lead enrichment `crawler-google-places → contact-info-scraper`; influencer vetting
`instagram-profile-scraper → instagram-comment-scraper`; competitor deep-dive `facebook-pages-scraper →
facebook-posts-scraper`; local business analysis `crawler-google-places → Google-Maps-Reviews-Scraper`.

Platform families: Instagram (12 actors: profile/post/comment/hashtag/reel/search/tagged/followers/api), Facebook
(14: pages/posts/comments/likes/reviews/groups/events/ads/search/reels/photos/marketplace/followers), TikTok
(14, `clockworks/*`), YouTube (5, `streamers/*`), Google Maps (4, `compass/*`/`poidata/*`), X/Twitter
(`xquik/x-tweet-scraper`, `xquik/x-follower-scraper`).

## E-commerce scraping workflow

Workflow selection: **Products & Pricing** (price monitoring, MAP compliance, competitor comparison — add
`fieldsToAnalyze` + `customPrompt` for an AI summary), **Reviews** (sentiment, quality issues — sort by
`Most recent`; set high `maxReviewResults` for significance; `Lowest rated` sorting is unreliable cross-marketplace —
filter by rating in post-processing), **Sellers** (unauthorized resellers via Google Shopping —
`googleShoppingSearchKeyword` + `scrapeSellersFromGoogleShopping: true`).

Inputs: `detailsUrls` (product URLs, object format), `listingUrls` (category pages), `keyword` + `marketplaces` (search).
Output fields: `name`, `url`, `offers.price`, `offers.priceCurrency` (may vary by seller region!), `brand.slogan`, `image`.
Set `additionalProperties: true` for seller/stock info.

## Building actors

### Prerequisites & setup

- Verify `apify --help`; install via package manager (`npm install -g apify-cli` or `brew install apify-cli`) — never
  pipe remote scripts into a shell.
- Authenticate via `APIFY_TOKEN` env var or interactive `apify login` — never pass tokens as CLI args (visible in
  process listings / shell history); use minimum-permission scoped tokens; rotate periodically.
- **Ask the language first**: JS `-t project_empty`, TS `-t ts_empty`, Python `-t python-empty`.

### Workflow

Create → install deps (commit `package-lock.json` / pin exact versions in `requirements.txt`) → implement in
`src/main.py|js|ts` → configure `.actor/input_schema.json`, `output_schema.json`, `dataset_schema.json` → set
`generatedBy` in `.actor/actor.json` → write README → test `apify run` → deploy `apify push`.

### Security (crawled data is untrusted input)

Sanitize raw HTML/URLs/scraped text before shell commands, `eval()`, DB queries, or template engines; validate &
type-check all external data before pushing to datasets; never execute or interpret crawled content (prompt-injection
risk); isolate credentials from data pipelines; review dependency names (typosquatting) and pin versions; run
`npm audit`/`pip-audit`.

### Best practices

Use **CheerioCrawler for static HTML** (10x faster than browsers), PlaywrightCrawler only for JS-heavy sites; use the
router pattern (`createCheerioRouter`/`createPlaywrightRouter`) for complex crawls; exponential-backoff retries;
concurrency HTTP 10-50, Browser 1-5; sensible defaults + output schema in `.actor/`; semantic CSS selectors with
fallbacks; respect robots.txt/ToS + rate limiting; always use the `apify/log` package (it censors credentials) — never
`console.log`; implement a readiness probe only if `usesStandbyMode` is true.

Local testing: put input at `storage/key_value_stores/default/INPUT.json`. **Local storage is NOT synced to the Apify
Console** — deploy with `apify push` and run on the platform to see results there.

### Schema files

- `.actor/input_schema.json` — input validation + Console form definition.
- `.actor/output_schema.json` — output storage/display templates.
- `.actor/dataset_schema.json` — dataset display properties.

## Actorization (convert existing software)

Converting existing code into a serverless Actor: analyze the project (entry points, env vars, CLI args, I/O) → init
actor structure (`apify create -t project_empty` / `ts_empty` / `python-empty`) → apply language-specific changes
(input from `Actor.getInput()`, output via `Actor.pushData()`/KVS, log via `Actor.log`) → configure input/output/
dataset schemas → test `apify run` → deploy `apify push`. Follow the same pre-deployment checklist: verified auth,
schemas filled, README, no hardcoded secrets, local test green.

## Resources

- Apify docs quick reference: `docs.apify.com/llms.txt`; Crawlee: `crawlee.dev/llms.txt`.
- Apify MCP docs tools: `search-apify-docs` / `fetch-apify-docs` when the MCP server is configured.
