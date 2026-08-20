# Deduplication Notes — automation consolidation

## Scope

- Source libraries: `automation` (54 SKILL.md) + `browser-automation` (3 SKILL.md) = **57 SKILL.md** scanned.
- Output: `automation/` with `SKILL.md`, `references/` (10 files), `scripts/run_actor.js`, `dedup-notes.md`.
- 15 files deep-read in full; the rest skimmed via frontmatter + headings.

## Topics merged

1. **n8n (14 skills)** — the largest cluster. Merged into `n8n-workflows.md` (patterns, expressions, node
   configuration, validation, MCP tools), `n8n-code.md` (JS/Python Code nodes + Custom Code Tool),
   `n8n-agents.md` (agents/tools/memory/RAG/human review), `n8n-advanced.md` (sub-workflows, error handling,
   binary/data, multi-instance).
2. **No-code platforms (Zapier + Make)** — merged into `workflow-platforms.md`.
3. **Browser automation (3)** — Skyvern, BrowserAct, browser-harness (CDP) into `browser-automation.md`, plus the
   auto-research browser boundary.
4. **Apify (12 skills)** — `scraping-apify.md`: ultimate-scraper actor tables + the 9 analysis skills'
   (audience/trend/competitor/lead/influencer/content/brand/market-research) shared run workflow + e-commerce
   scraping + actor development + actorization.
5. **Rube MCP / Composio SaaS apps (18 skills)** — one shared pattern (search tools → connect → resolve IDs →
   paginate) + per-app quick-reference tables in `saas-mcp-automation.md`.
6. **Email automation** — SendGrid, Outlook (mail + calendar) folded into `saas-mcp-automation.md`.
7. **CI/CD, git, API** — GitHub Actions, CircleCI, Render, smart-git, Gemini into `scripts-and-api.md`.
8. **Discovery/audit/prompting** — flowhunt audit + prompt-engineer into `discovery-audit.md`.

## Notable duplicates merged (not reproduced multiple times)

- **Webhook `.body` nesting** — repeated in n8n-expression-syntax, n8n-code-javascript, n8n-code-python; kept once in
  `n8n-workflows.md` (+ cross-reference in `n8n-code.md`).
- **Code node return format `[{json: {...}}]`** — duplicated across JS + Python code-node skills; merged into
  `n8n-code.md` with a JS/Python side-by-side.
- **Validation loop & profiles** — appears in n8n-validation-expert AND n8n-mcp-tools-expert; merged into
  `n8n-workflows.md` (one copy).
- **The 9 Apify "analysis" skills** (audience, trend, competitor, lead, influencer, content, brand, market, + ultimate
  scraper) share an identical 5-step workflow + same `run_actor.js`; collapsed into one section + selection tables.
- **The 18 Rube MCP app skills** all repeat the same setup (RUBE_SEARCH_TOOLS → RUBE_MANAGE_CONNECTIONS → ACTIVE) and
  near-identical pitfalls (ID resolution, pagination, rate limits); collapsed into one pattern + quick-ref tables.
- **Error handling core ideas** (bounded retries, status-code mapping, error workflows) overlap between n8n-error-handling
  and zapier/make error sections; each kept in its own platform reference (platform-specific), not duplicated across.
- **`$fromAI` JSON-only / binary can't cross tool boundary** — stated in n8n-agents, n8n-code-tool, n8n-binary-and-data;
  kept the full explanation in `n8n-agents.md` and `n8n-advanced.md`, short cross-refs elsewhere.

## Notable skills dropped / de-emphasized and why

- **community-building** — off-domain (Discord/Slack community growth, not automation); dropped. Surface mention in
  dedup-notes only.
- **prompt-engineer** — not automation per se; retained only as a compressed section in `discovery-audit.md` because
  prompt discipline feeds agent/tool-description design.
- **gemini-api-integration** — API integration is adjacent to automation; kept as a condensed section in
  `scripts-and-api.md`.
- **auto-research** — research-gating workflow; kept as the "research with a browser" pattern inside
  `browser-automation.md` (its Chinese-triggered examples are preserved in spirit).
- **cicd-automation-workflow-automate** — thin (<60 lines), heavily templated; its actionable content (stages, caching,
  quality gates, approvals, rollback) folded into `scripts-and-api.md`.
- **apify-brand-reputation-monitoring / market-research / audience-analysis / content-analytics / trend-analysis /
  competitor-intelligence / lead-generation / influencer-discovery** — each is the same run-an-actor skill with a
  different actor table; merged into `scraping-apify.md`.
- **marketing fluff** ("Ready to write Python in n8n Code nodes!", "This skill is the deep guide...") and duplicated
  boilerplate ("Use this skill only when...", "Related Skills" lists) stripped throughout.

## Scripts carried over

- `scripts/run_actor.js` — Apify actor runner (start run → poll → quick-answer in chat or export CSV/JSON with
  CSV-injection protection and long-field truncation). Copied from
  `automation/apify-ultimate-scraper/reference/scripts/run_actor.js`; USER_AGENT generalized
  (`opencode/skills-automation/1.0`). The same script ships (slightly varied) in 10 Apify skills — one copy kept.
- No other source libraries contained scripts. Browser-automation skills have no bundled scripts.

## Gaps / doubts

- **Make toolkit is thin** (operations/languages/timezones only) — deeper Make scenario-building guidance relies on
  the visual UI or native API; the skill can only point at it.
- **Per-app Rube MCP quick-refs are condensed** — 18 app skills collapsed into tables; unusual app-specific workflows
  (e.g. Zoom webinars, Google Analytics funnels, CircleCI project slug) are summarized, not fully documented.
- **browser-harness and BrowserAct** assume locally installed tooling (paths like `~/Developer/browser-harness`,
  `uv tool install browser-act-cli`) that isn't part of this repo; verify installation on the target machine.
- **skyvern reference links** (prompt-writing.md, engines.md, etc.) point at the upstream GitHub repo and were not
  copied; SKILL.md routes to them implicitly via the tool docs.
- **Community-building** content (channel templates, onboarding) is dropped; if it's needed later it should live in a
  dedicated community/growth skill, not automation.
- The `references/` files intentionally stay lean on per-platform "Known Pitfalls" depth — read the live tool schema
  (RUBE_SEARCH_TOOLS / get_node) rather than trusting these tables, since schemas drift.
