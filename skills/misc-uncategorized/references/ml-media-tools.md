# ML/AI Tools & Research

Consolidates: gemini-live-api-dev, gemini-omni-flash-api, huggingface-lora-space-builder,
huggingface-tool-builder, machine-learning-ops-ml-pipeline, monte-carlo-asset-health,
monte-carlo-performance-diagnosis, monte-carlo-remediation, monte-carlo-storage-cost-analysis,
automated-triage, tune-monitor, mmx-cli, podcast-generation, web-media-getter, last30days,
efficient-web-research, pdf-conversion-router, latex-paper-conversion, ingest-youtube, hasdata,
hasdata-cli, adhx, helium-mcp, mercury-mcp, prompt/LLM usage (see ai-agents for Langfuse).

## 0. Routing

- Building with Gemini Live/Omni Flash → §§1-2.
- Hugging Face → §§3-4. MLOps pipeline → §5.
- Monte Carlo data observability → §§6-10. MiniMax → §11. Podcast gen → §12.
- Media/research/data gathering → §§13-19.

## 1. Gemini Live API

Real-time bidirectional streaming (WebSocket). Models, SDKs (Python/JS), partner integrations,
audio formats (mulaw, linear16 PCM). Auth via API key; connect, send audio/text, handle stream
events. Common patterns: conversation loop, interruption handling, function calling in streaming.

## 2. Gemini Omni Flash

Generative video editing: text-to-video, image-referenced video, first-frame-to-video, remove
elements, change backgrounds. Tags in prompts set image roles; simple tags recommended
(`[image1]`, `[image2]`); explicit source/reference declaration for multi-image scenes. Audio
handling in video editing (separate audio input/settings). Workflow from reference docs; prompts
for single scene vs removing unwanted elements.

## 3. Hugging Face LoRA Space Builder

Build + publish a Gradio demo on HF Spaces for a user-provided LoRA. "Good" demos: working, small,
clearly labeled. Workflow: (1) gather LoRA info (from HF model card: base model, trigger words,
license), (2) pick the base diffusers pipeline (read `base_card.text` for the inference snippet,
note the pipeline class), (3) design the UI for that LoRA (sliders bound to the pipeline args),
(4) write `app.py`, `requirements.txt`, `README.md` (title, license, model link, usage), (5) publish
Space (upload files, order of operations matters for batched approval), (6) smoke-test
(text-to-image works, gallery renders). Watch license compatibility between LoRA + base model.

## 4. Hugging Face Tool Builder

Build scripts/tools using the HF API. Script rules (small, standalone, configurable). Endpoints:
Models, Datasets, Spaces, Inference API. Access via `huggingface_hub` / HTTP with token;
`hf` CLI for common operations.

## 5. Machine Learning Pipeline (MLOps orchestration)

Multi-agent pipeline: Phase 1 data & requirements analysis → Phase 2 model development &
training → Phase 3 production deployment & serving → Phase 4 monitoring & continuous improvement.
Configuration options and success criteria per phase. Deliverables: data report, model card,
serving config, monitoring plan.

## 6. Monte Carlo Asset Health

Check a data table/asset health via Monte Carlo MCP. **Tool routing: always call through the
bundled server** — fully-qualified names `mcp__plugin_mc-agent-toolkit_monte-carlo-mcp__<tool>`.
**Must read reference files (`references/workflows.md`, `references/parameters.md`) before any MCP
call.** Health report format: freshness, active alerts, monitors, upstream issues, diagnosis,
recommendations, importance/tags/warehouse. Status determination rules.

## 7. Monte Carlo Performance Diagnosis

Diagnose pipeline performance issues (slow jobs, expensive queries, latency trends). Workflow:
identify scope → Tier 1 discovery → bridge jobs to tables → Tier 2 diagnosis → present findings.

## 8. Monte Carlo Remediation

Investigate + remediate data-quality alerts: get alert context → assess triage priority → root
cause analysis (TSA) → blast radius → table context → check monitoring/queries → investigation
summary; then execute remediation with whatever external tools the user has connected (graceful
degradation when a capability is missing).

## 9. Monte Carlo Storage Cost Analysis

Analyze warehouse for stale/unused/redundant tables via `analyze_storage_costs`. Classifies waste
patterns (Usage & Risk column), table categories, follow-up requests. Scope limitations.

## 10. Monte Carlo Automated Triage & Tune Monitor

- **automated-triage**: build an automated triage agent for MC alerts — MCP tools, triage stages,
  working example; branch A interactive, branch B automated workflow.
- **tune-monitor**: analyze a monitor's report and recommend config changes to reduce alert noise —
  supports metric, custom SQL, validation, table monitors. General recommendations: sensitivity
  tuning (ML thresholds), schedule/interval, snooze/training period, audience/notification routing.

## 11. MiniMax CLI (mmx)

Generate text, images, video, speech, music. Install + auth (OAuth persists to `~/.mmx/`). Commands:
`mmx text chat` (MiniMax-M3 default, multi-turn w/ system prompt, pin model, from file),
`mmx image generate` (machine-readable JSON for agents). Agent flags for non-interactive use.

## 12. Podcast Generation (GPT Realtime Mini)

Generate real audio narratives from text via Azure OpenAI Realtime API. Backend: convert HTTPS
endpoint to WebSocket, send text, receive PCM audio → WAV (see pcm_to_wav). Frontend: playback.
Voice options, Realtime API events, audio format. Env config for keys.

## 13. Media Getter (web-media-getter)

One query across free image/video/GIF APIs (stock + historical/archival + GIF engines) returning
normalized, licensed records. Video caveat: prefer images; audio via freesound with QA. Record
schema: title, source, URL, license, attribution.

## 14. last30days Research

Research a topic from the last 30 days on Reddit + X + Web. **Parse intent first**: TOPIC,
TARGET TOOL (if specified), QUERY_TYPE (PROMPTING / RECOMMENDATIONS / NEWS / GENERAL). Optional
API keys (OpenAI web_search for Reddit, xAI x_search for X; works with WebSearch fallback). Run
research → judge agent synthesizes sources → internalize → show summary + invite the user's vision
→ then write ONE perfect prompt based on their direction.

## 15. Efficient Web Research

Token-efficient protocol: **fetch the minimum needed; skim before you dive; stop when you can
answer.** Classify input (GitHub repo / page URL / topic query / multiple URLs / file link) and
use the matching protocol. GitHub: prefer the API over scraping — repo metadata, file tree
(recursive, cheap), single file content (base64), README only usually answers; layered fetch
(README first → tree → 1-3 relevant files); never fetch >3 files per turn; read only top of files
>300 lines. URL protocol: assess type → layered fetch.

## 16. PDF Conversion Router

Never start with one fixed pipeline: classify the PDF, classify the target output, choose the
strongest route, validate on representative sections, retry with better settings. Primary engine:
`opendataloader-pdf` first; other tools only for classify/OCR/validate/repair/fallback. Fast
classify: `pdfinfo` + `pdftotext -layout`. Document-type heuristics: medical/lab → markdown-with-
html + `--table-method cluster` + image-output off; slide deck → markdown-with-html; narrative →
markdown/text; table-heavy business → markdown-with-html + cluster; scanned → OCR first; mixed →
markdown-with-html, validate easy + hard section. Validation gates; red flags (never trust page
1); post-conversion repair pass.

## 17. LaTeX Paper Conversion

Convert academic paper LaTeX between formats (e.g. Springer→MDPI): pre-requisites/assessment,
extraction & injection script generation, systematic fixing, compilation & debugging. Best
practices + common pitfalls per target venue.

## 18. ingest-youtube

Pull a YouTube transcript into a markdown vault (typed-memory entry). `python3 ingest.py <url>
[--vault <path>] [--lang en,es]`. Uses yt-dlp; subtitle priority manual > auto; strip VTT, dedupe
repeated lines, preserve speaker labels; write to `External Inputs/YouTube/<channel>/<date>-<slug>
.md` with full frontmatter; scan for trigger keywords → writing-seed stubs. Idempotent (re-ingest
overwrites). Missing subs → metadata stub (not silent failure).

## 19. Web Scraping & Data Tools

- **hasdata**: HasData APIs for web scraping + structured extraction. Three execution modes;
  always-true response shape; high-leverage patterns (search → scrape → extract); call from code
  wiring; gotchas (rate limits, JS pages).
- **hasdata-cli**: `hasdata` subcommands for search/scraping; non-obvious triggers (reach for it
  even if user doesn't say "scrape"); universal flag patterns; output contract; exit codes
  (script-safe).
- **adhx**: fetch any X/Twitter post as clean LLM-friendly JSON (`adhx.com`-style API; converts
  x.com/twitter.com links). URL patterns, response schema, summarize/analyze engagement.
- **helium-mcp**: news research + media-bias analysis + balanced perspectives; stock/options data,
  trading strategies. MCP config for Claude/Cursor/Windsurf; tools: `search_news`,
  `search_balanced_news`, `get_source_bias`, `get_bias_from_url`, `get_ticker`,
  `get_option_price`, `get_top_trading_strategies`.
- **mercury-mcp**: cheatsheet for Mercury (proton) MCP tools — orient, message teammates, create/
  track tasks; admin tools in admin scope only.
