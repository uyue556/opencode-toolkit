# Deduplication Notes — business

Consolidated 79 source skills (69 `business`, 3 `business-strategy`, 1 `consulting`, 3 `product`, 1 `product-management`, 2 `finance`) into ONE `business` skill with 9 reference files.

## Topics Merged (per reference file)

| Reference | Source skills merged |
|---|---|
| `strategy-and-competitive.md` | osterwalder-canvas-architect, kotler-macro-analyzer, moatmri, competitive-landscape, competitor-tracking, competitor-alternatives, business-analyst (KPI part) |
| `market-sizing.md` | market-sizing-analysis (+ data-sources.md), startup-business-analyst-market-opportunity, startup-analyst (sizing part) |
| `finance-and-modeling.md` | startup-financial-modeling, startup-business-analyst-financial-projections, startup-business-analyst-business-case, startup-metrics-framework, kpi-dashboard-design, business-analyst (BI part), quant-analyst, backtesting-frameworks, risk-manager, risk-metrics-calculation, options-flow-analyzer, longbridge |
| `pricing-and-monetization.md` | pricing-strategy, usage-based-pricing, monetization |
| `product-management.md` | idea-autopsy, before-you-build, idea-os, product-manager, product-manager-toolkit (+ references/prd_templates.md), product-decision-agent, product-marketing, product-marketing-context |
| `marketing-and-gtm.md` | marketing-plan (+ 13 reference files: methodology, aarrr, budget-planning, funding-stage-unlocks, growth-patterns, current-state-rubric, client-types, ops-stack-mapping, team-and-agency-model, plan-template, measurement-framework), product-marketing-context, sales-automator |
| `revops-and-sales.md` | revops (+ references: lifecycle-definitions, scoring-models, routing-rules, automation-playbooks), pipedrive-automation, zoho-crm-automation, sales-automator |
| `startups-and-launch.md` | micro-saas-launcher, saas-mvp-launcher, notion-template-business, startup-analyst |
| `team-and-hr.md` | team-composition-analysis, hr-pro, find-complementary-founders, startup-analyst (org part) |
| `operations-and-supply-chain.md` | inventory-demand-planning, production-scheduling, quality-nonconformance, returns-reverse-logistics, energy-procurement, carrier-relationship-management, customer-support |
| `odoo-erp.md` | 22 odoo-* skills |
| `consulting-and-org.md` | web-project-brainstorming (consulting), crossframe-org |

## Notable Duplicates Dropped / Merged

- **product-marketing vs product-marketing-context** — near-identical; both create the positioning/ICP/messaging context doc. Merged into one section in `product-management.md`; kept the newer `.agents/product-marketing.md` canonical path and 12-section schema.
- **startup-analyst vs startup-business-analyst-{market-opportunity, financial-projections, business-case}** — the three command-style skills are thin orchestration wrappers around market-sizing-analysis / startup-financial-modeling / team-composition-analysis. Their unique content (report section structures) was folded into the respective references; the wrapper boilerplate was dropped.
- **competitive-landscape (37 lines, essentially an index) vs competitor-tracking (322) vs competitor-alternatives (761)** — the tiny index skill's frameworks are fully covered by the two substantive skills; merged.
- **product-manager (53 lines, an index/pitch) vs product-manager-toolkit (362)** — index was dropped; toolkit's frameworks (RICE, MoSCoW, PRDs, discovery) carry the topic.
- **startup-metrics-framework (37 lines, empty index)** — content reconstructed from startup-financial-modeling + monetization benchmarks; the source had only placeholder text.
- **sales-automator** — appears in both marketing (cold email) and revops (lead routing) contexts; guidance kept once in marketing reference, cross-referenced.
- **Dropped generic "Use this skill when / Do not use when / Instructions / Limitations" boilerplate** present in ~40 skills — meaningless filler, removed.
- **Dropped self-promotional pricing/pitch content**: options-flow-analyzer's "$29 one-time" Gumroad pitch; notion-template-business's self-referential "Graduating to SaaS" delegation triggers; marketing-plan's client-specific example (example-quietude) kept only as a structural reference.

## Scripts

**No scripts carried.** None of the 79 source skills shipped a `scripts/` directory. Note: `product-manager-toolkit` references `rice_prioritizer.py` and `customer_interview_analyzer.py` in its SKILL.md, but those scripts **do not exist** in the source library (only `references/prd_templates.md` was present) — they could not be carried over.

## Gaps / Doubts

- **CrossFrame suite dependency**: `crossframe-org` is explicitly designed to be routed by `crossframe-suite` and reads from `../crossframe/`. The standalone reference in `consulting-and-org.md` captures the routing rules and hard rules but cannot replicate the canonical CrossFrame protocol files that live outside these libraries.
- **`find-complementary-founders`** requires external Moltbook/GitHub infrastructure and its own scripts (not shipped in this library's copy — references exist but no `scripts/` was present). I captured the workflow/principles only.
- **finance cluster (quant/backtesting/risk/options/longbridge)** is arguably out-of-scope for a "business" domain; kept as a labeled optional cluster with a strong "not financial advice" disclaimer. Longbridge is a CLI wrapper around its own toolchain.
- **Odoo cluster (22 skills)** was heavily compressed into a single reference; each source is a ~100-line "example-first" guide. The reference preserves the durable patterns but drops the worked examples. If a user needs deep Odoo config, the upstream skills should be re-fetched.
- **Notion-template-business** is a niche but fully-formed digital-product playbook; folded into startups reference. Some platform-specific facts (fees, prices) may age; flagged as "adjust" in text.
- **Customer support** was a broad capability inventory rather than a workflow; condensed to its actionable design principles.
