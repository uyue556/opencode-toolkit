# Dedup Notes — marketing-growth

Consolidated 63 SKILL.md files from `marketing` (55), `growth` (3), `seo` (4), `ecommerce` (1) into one skill with 11 reference files, 3 scripts, and 1 vendored reference.

## What was merged (topic → reference)

| Topic | Source skills merged | Destination |
|---|---|---|
| Technical SEO / indexing | tools-page-seo-optimizer, nextjs-seo-indexing, indexing-issue-auditor, seo-drift | `references/seo.md` |
| Programmatic SEO | programmatic-seo | `references/seo.md` §3 |
| Schema | schema-markup, schema-markup-generator | `references/seo.md` §4 |
| GEO | geo-fundamentals | `references/seo.md` §5 |
| Social metadata / OG | social-metadata-hardening | `references/seo.md` §6 |
| Local SEO | local-legal-seo-audit | `references/seo.md` §7 |
| Keywords | keyword-extractor | `references/content-copywriting.md` §4 |
| Copywriting / editing | copywriting, copy-editing | `references/content-copywriting.md` §1–2 |
| Brand voice | brand-guidelines, brand-guidelines-anthropic, brand-guidelines-community, content-creator | `references/content-copywriting.md` §3 |
| Content creation | content-creator | `references/content-copywriting.md` §5 |
| Social strategy | social-content, social-post-writer-seo | `references/social-media.md` |
| LinkedIn depth | linkedin-post-writer (+ hook-formulas ref), linkedin-content-generator, linkedin-profile-optimizer | `references/social-media.md` §10 + `references/linkedin-hook-formulas.md` |
| Chinese platforms | xiaohongshu-content-strategist, wechat-official-account-strategist | `references/social-media.md` §11 |
| Social publishing | socialclaw, taisly-social-media-posting | `references/social-media.md` §12, `references/automation.md` |
| Email sequences | email-sequence | `references/email-marketing.md` |
| Email automation | mailchimp/klaviyo/convertkit/brevo/activecampaign-automation | `references/automation.md` §2 |
| Paid ads | paid-ads | `references/paid-ads.md` |
| Ad analysis | ad-campaign-analyzer | `references/paid-ads.md` §10 |
| CRO | page-cro, form-cro, signup-flow-cro, popup-cro, onboarding-cro, paywall-upgrade-cro | `references/cro.md` |
| A/B testing | ab-test-setup | `references/cro.md` §8 |
| Psychology | marketing-psychology | `references/cro.md` §9 |
| Launches | launch-strategy | `references/growth-hacking.md` §2 |
| Referral / viral | referral-program, growth-engine (viral loops, K-factor) | `references/growth-hacking.md` §3–4 |
| Free tools | free-tool-strategy | `references/growth-hacking.md` §5 |
| Viral generators | viral-generator-builder | `references/growth-hacking.md` §6 |
| Growth ideas | marketing-ideas | `references/growth-hacking.md` §7 |
| Growth engine | growth-engine | `references/growth-hacking.md` §8 |
| Competitor research | competitor-analysis | `references/competitive-research.md` §1 |
| Competitor ads | competitor-ad-intelligence | `references/competitive-research.md` §2 |
| ASO | app-store-optimization | `references/aso-ecommerce.md` §1 |
| E-commerce | buywhere-product-catalog | `references/aso-ecommerce.md` §2 |
| Social/email MCP automation | instagram, instagram-automation, linkedin-automation, linkedin-cli, twitter-automation, tiktok-automation, reddit-automation, youtube-automation | `references/automation.md` §3–4 |

## Notable duplicates identified & dropped

- **`brand-guidelines-anthropic` and `brand-guidelines-community` are byte-for-byte duplicates** of each other (same "Anthropic Brand Styling" content, 83 lines each). Dropped both; kept `brand-guidelines` (Sentry tone model) as the general brand-voice reference and generalized it.
- **Composio/Rube MCP automation skills** (mailchimp, klaviyo, convertkit, brevo, activecampaign, instagram, linkedin, twitter, tiktok, reddit, youtube) all share an identical boilerplate (prereqs, setup, quick-reference, limitations). Deduplicated into one patterns reference (`references/automation.md`) instead of reproducing each platform's near-identical scaffold. Per-platform operation tables retained.
- **`instagram` vs `instagram-automation`**: the former is a Portuguese Graph-API integration, the latter a Composio wrapper; both cover posting/analytics. Merged into the Instagram row of `references/automation.md`.
- **`social-orchestrator` (Portuguese)** overlaps `socialclaw`/`social-content` for multi-channel publishing; its cross-channel coordination guidance was folded into `references/social-media.md` §12 and `references/automation.md`.
- **`growth-engine`** overlaps referral-program (viral loops), email-sequence (onboarding), launch-strategy, and ASO; kept only its unique content (Pirate Metrics applied, K-factor calculator, cross-domain checklist) in `references/growth-hacking.md`.
- **`linkedin-content-generator`** (7-command suite) largely overlaps linkedin-post-writer + social-content; unique value (command table, feedback/memory loop) folded into `references/social-media.md` §10.
- **`screenshots`** (Playwright marketing screenshots): high-quality standalone workflow, but it is an asset-generation tool rather than marketing strategy; summarized in the social-media sources note and left out of the main skill to keep focus (playwright script template is tooling, not guidance).
- **`social-post-writer-seo`** is subsumed by `social-content` (same post-structure guidance, less depth). Dropped.
- **`linkedin-cli`** merged into automation reference §3 (CLI row).
- **`x-article-publisher-skill`** (28 lines, "publish articles to X") is a stub with no workflow; noted and dropped (covered by twitter-automation publish path).
- **`marketing-ideas`'s "140-idea library"** body was not present in the file (placeholder); only the MFS scoring framework was carried.

## Scripts carried

- `scripts/validate_meta.py` — from `seo/tools-page-seo-optimizer` (pre-deploy meta/content gate).
- `scripts/list_urls.mjs` — from `marketing/competitor-analysis` (URL dedup by domain for discovery batches).
- `scripts/extract_vs_names.mjs` — from `marketing/competitor-analysis` ("X vs Y" competitor extraction).
- `references/linkedin-hook-formulas.md` — vendored from `marketing/linkedin-post-writer/references/hook-formulas.md` (16 LinkedIn hook skeletons, MIT, attribution header preserved).

Not carried: `competitor-analysis/scripts/{compile_report.mjs, capture_screenshots.mjs, gate_candidates.mjs, merge_partials.mjs, md_utils.mjs}` — pipeline glue tied to the Browserbase "browse cloud search" workflow; only the two self-contained utilities (list_urls, extract_vs_names) were carried. No other source library had scripts directories.

## Gaps / doubts

- **Composio MCP boilerplate** was read only via headings + frontmatter for 6 of the 11 automation skills; the common-patterns summary is reliable but per-platform edge cases (exact tool names, rate-limit numbers) were not exhaustively verified.
- **`marketing-ideas` 140-idea library** content is missing from the source file; the skill's value is preserved as a framework, but no idea list could be carried.
- **`social-orchestrator`** and **`growth-engine`** are in Portuguese; translated into the merged references (AARRR targets, onboarding sequence, viral loops) — language nuance may be lost.
- **App Store / store limits and platform benchmarks** (email open-rate 20–40%, CPM bands, cookie durations) are dated guidance from source files; flagged in SKILL.md and references to verify against current platform rules.
- **`app-store-optimization`** described 7 Python scripts (keyword_analyzer, metadata_optimizer, aso_scorer, etc.) but none are present in the source directory; only documented, not carried.
