# Dedup Notes — content-writing consolidation

Consolidated 71 source SKILL.md files (content: 66, writing: 3, creative: 2) into one
`content-writing` skill with 7 reference files.

## Topics merged (by reference file)

- **references/blog-and-articles.md** — blog-writing-guide (Sentry standards), seo-aeo-blog-writer,
  wordpress-centric-high-seo-optimized-blogwriting-skill, tutorial-engineer, dev-to-hashnode,
  devrel-content (content-type table + outline only). All the "how to write a blog post" advice
  converged onto one structure (problem → mechanism → tradeoffs → next steps).
- **references/copywriting-and-marketing.md** — copywriting-psychologist (mechanism-first stack,
  decision matrix), content-marketer (pipeline; fluff stripped), internal-comms-anthropic +
  internal-comms-community (exact duplicates, merged).
- **references/storytelling-and-creative.md** — beautiful-prose (full style contract),
  explain-like-socrates, crossframe-essay (Chinese long-form essay discipline distilled to its
  portable principles), bulletmind (structured bullet output), article-illustrations (digest-style
  summary captured).
- **references/technical-writing.md** — devrel-content (core), tutorial-engineer,
  documentation-and-adrs, documentation-templates, reference-builder, readme, wiki-* (page-writer,
  onboarding, researcher, QA, changelog), plus AI-friendly docs guidance.
- **references/seo-content.md** — seo-fundamentals, seo-plan, seo-aeo-content-cluster,
  seo-aeo-keyword-research, seo-keyword-strategist, seo-content-writer, seo-content-planner,
  seo-meta-optimizer, seo-snippet-hunter, seo-structure-architect, seo-cannibalization-detector,
  seo-content-refresher, seo-content-auditor, seo-authority-builder, seo-audit,
  seo-forensic-incident-response, seo-content, seo-aeo-content-quality-auditor.
- **references/editing-and-proofreading.md** — professional-proofreader (+ its
  references/inline-text-mode.md), avoid-ai-writing, humanize-chinese, unslop, short (writing lib).
- **references/scientific-and-academic.md** — scientific-writing (visual-schematics/"mandatory
  figures" overreach trimmed to a guideline; venue/reporting details distilled), citation-management.
- **references/newsletters-and-distribution.md** — internal-comms (3P/status/newsletter patterns),
  daily-news-report (quality-gating/fault-tolerance principles; the heavy MCP/Chrome DevTools
  orchestration was dropped as out-of-scope tooling), dev-to-hashnode (distribution half),
  content-marketer (measurement half).

## Notable duplicates identified & dropped

- **internal-comms-anthropic ≡ internal-comms-community** — byte-for-byte identical. Kept one;
  both named in dedup.
- **~15 SEO-* skills** are near-dup families from the same template: seo-content-writer,
  seo-content-planner, seo-content-auditor, seo-keyword-strategist, seo-meta-optimizer,
  seo-snippet-hunter, seo-structure-architect, seo-cannibalization-detector, seo-content-refresher,
  seo-authority-builder, seo-aeo-* (bloated boilerplate "Use this skill when / Instructions /
  Limitations" repeated verbatim in every file). Collapsed into one seo-content.md organized by
  concern (plan, write, meta, snippets, refresh, cluster, audit).
- **seo-audit ⊇ seo-fundamentals ⊇ seo-content ⊇ seo** — four overlapping audit/quality skills.
  Kept seo-fundamentals' explanation of *how* engines judge quality and collapsed the three
  audit-style skills into §8.
- **seo-aeo-content-cluster ≈ seo-content-planner** and **seo-aeo-keyword-research ≈ seo-keyword-
  strategist** — merged pairs (clusters, keyword tiers).
- **blog-writing-guide (Sentry) and devrel-content** both prescribe: banned marketing language,
  the "would I share this?" test, problem-first opening, honest trade-offs. Kept Sentry's stricter
  list as canonical, pulled devrel's content-type table and SEO-for-developers notes into it.
- **avoid-ai-writing, humanize-chinese, unslop, beautiful-prose** all target AI tics — kept each
  for its distinct angle (English audit table / Chinese academic / deterministic CLI / style
  contract).
- **short vs bulletmind** — both compress; kept separate (prose vs bullet tree).

## Notable skills dropped / not merged (and why)

- **cv-generator (874 ln)** — CV/resume generation, different domain (not content writing).
- **prompt-library** — generic prompt templates, not content-specific workflow.
- **search-specialist, defuddle, mermaid-expert, hugo-to-markdown, wiki-vitepress,
  documentation-generation-doc-generate** — tooling/execution skills (search, scraping, diagram
  syntax, Hugo conversion, VitePress build, doc-from-code generation), not writing craft. Their
  doc-writing essence, where present, was folded into technical-writing.md.
- **youtube-summarizer, youtube-seo-optimizer** — video transcript summarization / YouTube metadata
  SEO; out of scope for text content writing (YouTube SEO title rules could be a future extension).
- **daily-news-report's** browser/MCP automation orchestration — environment-specific tooling;
  kept only the editorial principles (quality gating, fault tolerance).
- **wiki-qa, wiki-researcher, crossframe-{critical,debate,dialogue,notebook,teach,casebook}** —
  suite-specific routing documents whose value depends on the parent CrossFrame suite; only the
  portable essay-writing discipline was captured in storytelling-and-creative.md.
- **modellix (creative)** — Modellix API/CLI media generation tooling, not writing craft.
- **seo-image-gen** — AI image generation for SEO assets; tooling/production, borderline; excluded.
- **scientific-writing's** scientific-schematics/generate-image "mandatory figures" pipeline —
  tooling-dependent and overreach; kept as guideline prose in scientific-and-academic.md.
- **content-marketer / seo-plan / seo-audit** marketing/fluff boilerplate ("Use this skill when…")
  dropped per dedup rules.

## Scripts

**None carried.** No `scripts/` directories existed in any source library (verified via find; the
`humanize-chinese`, `scientific-writing`, and `citation-management` skills *reference* CLI scripts
that are not present locally). CLI usage patterns (BibTeX pipeline, unslop `--deterministic`,
humanize-chinese command sequence) are preserved as text in the references.

## Gaps & doubts

- Deep-read 20 source SKILL.md files (~3,200 lines); the remaining ~51 were skimmed via frontmatter
  + headings per the reading strategy. CrossFrame and wiki suites are routes into richer suites and
  were necessarily summarized.
- readme (848 ln) and citation-management (1,117 ln) were read partially (first sections + heading
  maps + 400-500 ln each); their remaining sections are template/checklist repetitions already
  captured. cv-generator's detailed extraction rules were not read in depth (dropped as out of
  domain).
- The Chinese-language content (crossframe-* and humanize-chinese) is preserved in Chinese where it
  is canonical; this skill's prose is bilingual-aware but trunk text is English.