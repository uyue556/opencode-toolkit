---
name: misc-uncategorized
description: >
  Catch-all skill covering ~283 previously "uncategorized" skills. Use this whenever the user's
  request touches SEO/AEO, marketing & growth, developer-marketing/DevRel, conversion psychology,
  UI/UX design, software testing, code correctness & debugging, AI agent orchestration, backend &
  auth, ML/AI media tools, finance & crypto, DevOps & infra, personas & role-play, note-taking &
  macOS tools, or productivity & planning. Also triggers on 搜索引擎优化, 营销, 增长, 心理学, UI, 测试,
  ​​代码质量, AI代理, 数据库, 认证, 金融, 运维, 笔记, Obsidian, 效率, persona/角色扮演, debug, refactor.
  This skill routes by theme to references/ — load the matching reference file for the task.
risk: safe
source: consolidated-from-uncategorized-library
---

# Misc Uncategorized

This skill consolidates the last catch-all source library into one routed skill. Its purpose is
simple: **route the task to the right reference file, then follow that file's workflow.** The
references preserve the best actionable content from ~283 source skills, deduplicated and organized
by theme.

## When to Use This Skill

Use this skill for any task that falls into one of the themes below. If the request is clearly
covered by a dedicated domain skill (seo, ui, testing, ai-ml, design, finance), you may still use
this one — the content here is coherent and complete on its own.

## Core Workflow

1. **Classify the request** against the routing table below. Identify the primary theme (and a
   secondary theme if mixed).
2. **Load the matching reference file** (read the relevant section; most are <300 lines).
3. **Apply the workflow in that file.** These are imperative playbooks — follow their phases in
   order, respect their gates (don't skip verification steps).
4. **Gather context before producing output.** Nearly every playbook requires context first:
   audience/product data, URLs, error messages, existing assets. Ask only for what is genuinely
   missing; don't interrogate the user.
5. **Verify output against the file's checklists** before presenting.

## Selection Routing

| If the user wants… | Load reference |
|---|---|
| SEO, AEO/AI search, GEO, llms.txt, schema, sitemap, hreflang, images, programmatic SEO, DataForSEO, alternative/comparison pages, PageSpeed, analytics | `references/seo-aeo.md` |
| Developer marketing: audience context, onboarding, churn, listening, newsletters, advocacy, sandboxes, tutorials, changelogs, docs-as-marketing, OSS marketing, power users, SDK DX | `references/dev-marketing.md` |
| Content strategy, lead magnets, offers, pricing, free tier, ad creative, cold email, email systems, co-marketing, PR, sales enablement, customer research, competitor profiling, CRO, onboarding, churn prevention | `references/growth-marketing.md` |
| Conversion psychology: headlines, subject lines, loss aversion, social proof, scarcity, trust, persuasion UX, emotional arcs, sequences, visual emotion, objections, psychographic profiles, awareness stages, identity mirroring, price psychology, brand perception, JTBD | `references/persuasion-psychology.md` |
| UI/UX: baseline/design-system lint, design philosophy/thinking/spatial, deterministic layout audit, StyleSeed (ui-setup/tokens/pattern/page/score/review/lint/update), UX audit/copy/flow, favicon, lookdev | `references/ui-ux-design.md` |
| Unit/integration tests (JUnit 5, TestNG, Vitest, Cucumber, Robot), WJTTC championship suites, HyperExecute, Newman/Postman API tests, OpenAPI→Postman, Puppeteer, accessibility scans | `references/testing.md` |
| Code correctness: logic review/locate/diff/explain/fix, invariants, algorithm-first (lemmaly), complexity cuts, math-heavy optimization, doc2math, first-principles assumption audit, debugging protocols, bug-hunt swarms, review swarms, Brooks audits/debt/review/sweep, clean code, unslop, docs guard, woo guard, re-create, deprecation & migration | `references/code-correctness.md` |
| AI agents: CrewAI, Langfuse, subagent orchestration, AgentFlow, Nika workflows, Polis protocol, YES.md governance, protect-mcp, Manifest, blockrun, cowork-to-code, accint, Antigravity maintainer, MAXIA | `references/ai-agents-orchestration.md` |
| Backend & auth: Supabase, Clerk, Next.js+Supabase auth, Neon/claimable Postgres, Redis, GraphQL, Formik, frontend data contracts/observability/optimistic mutations, Expo DOM, Telegram Mini Apps, Vercel, Rails, Bevy ECS, Swift concurrency, GLSL, POSIX/PowerShell/Windows shell | `references/backend-auth.md` |
| ML/AI tools & research: Gemini Live/Omni Flash APIs, Hugging Face Spaces/tools, MLOps pipeline, Monte Carlo data observability, MiniMax CLI, podcast generation, media getters, web research, last30days, PDF/LaTeX conversion, YouTube ingest, HasData, ADHX, Helium, Mercury | `references/ml-media-tools.md` |
| Finance & crypto: XVARY stock research, yield intelligence, Longbridge market/fundamentals/content, Atlas ledger, crypto wallet, NFT standards, billing automation | `references/finance-crypto.md` |
| DevOps & infra: CI/CD, Prometheus, Linkerd, networking, Cloudflare security audit, supply-chain risk, repo maintenance, merge conflicts, GitHub CLI | `references/devops-infra.md` |
| Personas & role-play (Elon Musk, Bill Gates, Geoffrey Hinton, Steve Jobs, Warren Buffett, Terence Tao), IT management advisors (hospital, pro, ITIL) | `references/personas-it.md` |
| Notes & tools: Obsidian (markdown, cli, bases, web clipper), JSON Canvas, Apple Notes search, macOS apps (menubar, screen recorder, SPM packaging), speed reader, Slack GIFs, Screen Studio alt, magic animator, Photopea | `references/notes-macos-tools.md` |
| Productivity & planning: spec/source-driven dev, incremental implementation, planning & breakdown, not-a-vibe-coder, batch refactor, brainstorming, idea refine/Darwin, FAF context, skill audit, permissions, privacy mask, trust metadata, anti-deception/sycophancy, event staffing, logistics, wellally health, JobGPT, Rube automations (Close/Coda/Vercel/Supabase), Mailtrap | `references/planning-ops.md` |

## Best Practices

- **Route first, read second.** Do not attempt to hold all themes in context; load the one
  reference file that matches.
- **Context over assumptions.** Marketing/psychology/DevRel playbooks all begin by establishing the
  audience or product context. Read `.agents/developer-audience-context.md` or the product-marketing
  context file if present; otherwise gather minimal context and proceed.
- **Respect gates.** Correctness playbooks (logic-*, invariant-guard, phase-gated-debugging,
  deterministic-design) have hard gates — measure, verify, get confirmation. Never skip them.
- **Cite sources.** SEO/finance/competitor playbooks require traceable claims (filing form/date,
  URL, metric source). Don't fabricate data.
- **Stay honest.** Psychology skills have explicit ethical guardrails (no fake scarcity, no dark
  patterns, no identity overclaiming). Follow them.

## Do & Don't

- DO load exactly one reference and follow its phase order.
- DO verify your work (re-run tests, re-measure overflow, re-check schema).
- DON'T pitch a solution before the audience/problem is understood.
- DON'T edit user files without the file's authorization model (e.g. phase-gated-debugging,
  re-create, brooks-sweep all require explicit approval).
- DON'T use literal field-labels synonymized when a downstream contract requires exact tokens
  (logic-* five-field format).

## Common Pitfalls

- **Overloading context.** Reading all references at once defeats the purpose; read the one you need.
- **Skipping the render/measure step in design.** A model can't see its own UI output — render it,
  screenshot it, judge with fresh eyes (see `ui-ux-design.md`).
- **Trusting training data for fast-moving tools.** Supabase, Clerk, Vercel, CrewAI and Gemini docs
  change; check the official docs/changelog before implementing.
- **Treating marketing templates as final.** Cold email, changelogs and newsletters must be
  personalized and read aloud — checklists are quality gates, not substitutes for judgment.

## Examples

- User asks "optimize this landing page for ChatGPT visibility" → `seo-aeo.md` (GEO/AEO section).
- User asks "why do developers churn and how do I win them back" → `growth-marketing.md` (churn).
- User asks "review this function, it looks wrong" → `code-correctness.md` (logic-review).
- User asks "set up auth for my Next.js app" → `backend-auth.md` (Clerk / Supabase sections).
- User asks "make this UI look less generic" → `ui-ux-design.md` (baseline-ui + design-spatial).
- User asks "build me a Telegram Mini App that monetizes" → `backend-auth.md` (Telegram section).

## Limitations

- Each reference is a distillation; for deep vendor-specific detail, consult the official docs
  linked inside the reference files.
- Some content overlaps with dedicated domain skills (seo, ui, testing, ai-ml); that is intentional
  to keep the uncategorized content coherent under one skill.
