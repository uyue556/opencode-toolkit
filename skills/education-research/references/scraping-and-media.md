# Scraping, Transcripts, and News Briefing

External data gathering via DeepAPI (*deepapi*), YouTube transcript fetching
(*youtube-transcript*), and multi-source news sentiment briefing
(*news-sentiment-engine*).

## 1. DeepAPI — Credentialed Scrape / Search / Email

Use when the task needs a supported DeepAPI endpoint and the user has provided
or confirmed credentials.

### Environment & safety

- Read `DEEPAPI_API_BASE_URL` and `DEEPAPI_API_KEY` from the environment. If
  either is missing, stop and ask for setup. Never commit, print, log, paste, or
  expose the key.
- Every request: `Authorization: Bearer $DEEPAPI_API_KEY`,
  `Content-Type: application/json`, and a unique `Idempotency-Key` per POST.
  Retries must reuse the SAME Idempotency-Key.
- Scrape/search routes require an explicit spend cap (`maxCostUsd` or
  `maxCostMicrousd`). Start with small result caps (`maxItems`).

### Execution loop

1. Choose the narrowest endpoint that matches the task.
2. Send the request with headers and spend cap.
3. If `status: running`, wait `next.afterSecs`, then call `next.method` +
   `next.path` until `status` is `succeeded` or `failed`.
4. If `error.retryable`, wait `error.retryAfterSecs` before retrying.
5. On HTTP 402 `insufficient_credits`, stop and ask the user to top up at
   https://deepapi.co/credits, then retry with the same Idempotency-Key.
6. Report `requestId`, `status`, `debitMicrousd`, `costFinal`, and the useful
   part of `output`.

### Endpoint table

| Method | Path | Notes / default cap |
|---|---|---|
| POST | `/v1/scrape/website` | clean text+markdown per page; cap 1.00; body: `urls`, `maxPages` |
| POST | `/v1/scrape/linkedin/profile` | cap 0.05; body: `profiles` |
| POST | `/v1/scrape/github/profile` | cap 0.03; body: `usernames` |
| POST | `/v1/scrape/twitter/search` | cap 0.03; body: `handles`, `maxItems`, `sort` |
| POST | `/v1/scrape/linkedin/jobs` | cap 0.05; body: `query`, `location`, `maxItems` |
| POST | `/v1/scrape/linkedin/company` | cap 0.05; body: `companies` |
| POST | `/v1/scrape/linkedin/people` | cap **≥0.50**; body: `titles`, `locations`, `maxItems` |
| POST | `/v1/scrape/linkedin/posts` | cap 0.05; body: `profiles`, `maxItems` |
| POST | `/v1/scrape/twitter/user` | cap 0.05; body: `handles` |
| POST | `/v1/scrape/twitter/replies` | cap **≥0.20**; body: `url` |
| POST | `/v1/scrape/youtube/transcript` | cap 0.05; body: `url`, optional `language` |
| POST | `/v1/scrape/youtube/channel` | cap 0.30; body: `channels`, `maxItems` |
| POST | `/v1/scrape/youtube/search` | cap 0.10; body: `query`, `sort`, `maxItems` |
| POST | `/v1/email/send` | no spend cap; keep `send: false` unless approved; no `inboxId` |
| GET | `/v1/email/messages` · `/v1/email/drafts` | read-only, debit 0 |
| POST | `/v1/email/drafts/{id}/send` | only after explicit approval of that draft |
| POST | `/v1/research/deep` | cap 0.10; body: `query`, optional `context` |
| POST | `/v1/generate/image` | cap 0.20; save `output.images` base64 to files |
| POST | `/v1/search/web` | cap 0.05; `query` < 500 chars; treat snippets as summaries |
| GET | `/v1/requests/{requestId}` | status polling, no debit |

Example scrape call:

```bash
test -n "$DEEPAPI_API_KEY" || { echo "DEEPAPI_API_KEY is not set"; exit 1; }
curl -s "$BASE/v1/scrape/website" \
  -H "Authorization: Bearer $DEEPAPI_API_KEY" -H "Content-Type: application/json" \
  -H "Idempotency-Key: $(uuidgen)" \
  -d '{"maxCostUsd":"1.00","waitForFinishSecs":60,"urls":["https://example.com"],"maxPages":1}'
```

Email rules: attachments, hidden/image HTML, URL shorteners, and high-risk
direct sends are blocked by policy. Do not pass inbox IDs — use
`emailIdentityId` or omit it.

## 2. YouTube Transcripts

Fetch a video's transcript and save clean text. Primary path is DeepAPI
`/v1/scrape/youtube/transcript` (server-side, avoids local-IP bot flagging).
Fall back to `yt-dlp` when the key is missing, credits run out, or the request
fails twice — and tell the user whenever you fall back.

- **Save location**: real project dir if it makes sense, else `~/Downloads`.
  Name file `Channel_Title` with spaces → `_` (fall back to video ID).
- **DeepAPI path**: POST with `{"url":…,"maxCostUsd":"0.05","waitForFinishSecs":60}`
  (add `"language":"de"` etc. for non-English). Poll while `status: running`.
  Extract text with `.output[0].text`; `.output[0].segments` gives timed
  segments (`startSecs`, `durationSecs`, `text`). Empty output = no captions;
  report it, don't retry.
- **yt-dlp path**: `yt-dlp --skip-download --write-subs --write-auto-subs
  --sub-langs "en.*" --sub-format json3 -o "$OUT/$NAME.%(ext)s" "URL"`.
  **Always use `json3`, never VTT/SRT** (auto-VTT repeats every line twice).
  Flatten json3 → txt with `scripts/yt_json3_to_txt.py`.
- **Failure handling**: on first failure run `yt-dlp -U` once, retry once, then
  stop. **429 / "Sign in to confirm you're not a bot" = IP flagged — STOP, do
  not retry in a loop** (makes it worse). Never download audio for Whisper
  unless the user explicitly asks.
- Report the saved path; print text if short; if DeepAPI was used report cost
  in dollars.

## 3. News Sentiment Briefing

Collect AI/tech news from multiple RSS sources and produce a ranked, tagged
briefing with Claude-powered sentiment analysis. Use for daily/weekly briefings,
product-launch monitoring, and deduplicating overlapping coverage.

**Request pattern** (can be given directly as instructions):

> Collect latest AI/tech news from RSS feeds. Rank top 5 by importance to the
> tech industry. For each: summary (2–3 sentences), sentiment
> (positive/negative/neutral), impact score (1–5), industry tags, one-sentence
> commentary. Output as a structured briefing card.

**Output format per article**: Title + source + publish date; Summary (2–3
sentences); Industry tags (`[AI, Semiconductor, Cloud, …]`); Sentiment;
Impact score (1–5); Commentary (1-sentence industry perspective).

**Caveats**: RSS feeds lag/disappear/throttle/duplicate; sentiment and impact
scores are briefing aids, not authoritative analysis; cross-check outputs
against original articles before publication or investment use. (Optional
upstream setup clones a third-party Node project `tellmefrankie/news-engine` —
review and pin that repo yourself; don't expose keys to an unreviewed
checkout.)
