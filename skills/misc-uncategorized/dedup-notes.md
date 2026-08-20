# Dedup & Consolidation Notes

Consolidated 283 source SKILL.md files from `uncategorized/` into one routed skill with 14 reference
files. This documents what was merged, what was dropped, and why.

## How the merge was done

- Read the full inventory (name + description) for all 283 skills.
- Deep-read (~25) the largest / most representative SKILL.md files in full: photopea-embedded-editor,
  elon-musk, clerk-auth, personal-tool-builder, telegram-mini-app, email-systems, vercel-deployment,
  developer-churn, frontend-observability, design-spatial, seo-geo, seo-aeo-* (4), xvary-stock-research,
  nft-standards, prometheus-configuration, logic-review, invariant-guard, phase-gated-debugging,
  cold-email, open-source-marketing, sdk-dx, developer-onboarding, technical-tutorials,
  power-user-cultivation, content-strategy, churn-prevention, free-tier-strategy, changelog-updates,
  baseline-ui, ui-skills-root, axiom, efficient-web-research, accesslint-scan, pdf-conversion-router,
  ingest-youtube, macos-spm-app-packaging, subagent-orchestrator, github, supabase, crewai, langfuse,
  deterministic-design, lookdev, and the full psychology family.
- Skimmed every other skill via frontmatter + `grep '^#'` headings.

## Reference files created

- `seo-aeo.md` — 16 SEO/AEO/GEO skills
- `dev-marketing.md` — 16 developer-marketing/DevRel skills
- `growth-marketing.md` — 17 growth/marketing-ops skills
- `persuasion-psychology.md` — 19 psychologist skills
- `ui-ux-design.md` — 20 UI/UX design-system skills
- `testing.md` — 14 testing skills
- `code-correctness.md` — 28 correctness/review/debugging skills
- `ai-agents-orchestration.md` — 16 agent/orchestration/governance skills
- `backend-auth.md` — 25 backend/auth/frontend-architecture skills
- `ml-media-tools.md` — 19 ML/AI/research tools skills
- `finance-crypto.md` — 7 finance/crypto skills
- `devops-infra.md` — 10 DevOps/infra/security skills
- `personas-it.md` — 10 persona + IT advisor skills
- `notes-macos-tools.md` — 14 notes/knowledge/macOS skills
- `planning-ops.md` — 20 productivity/planning/ops skills

(Some skills are referenced from more than one file; totals exceed 283 because a few skills are
split across clusters.)

## Notable duplicates merged

- **Psychology family (19 skills)** — all share one template (context gathering → framework →
  steps → decision matrix → failure modes → ethics). Kept the shared method + each skill's unique
  framework in `persuasion-psychology.md`. Dropped the repeated boilerplate (identical
  "When to Use / Limitations" blocks) from each.
- **"One sentence - what this skill does" stub descriptions** — ~18 psychology skills had a
  placeholder frontmatter description; the real content was inside, so content was preserved.
- **developer-marketing family** — all reference the shared `developer-audience-context.md`; merged
  the "Before You Start" boilerplate into one §0.
- **seo-aeo-* engine** — landing-page-writer / meta-description / schema / internal-linking share
  the same overview/limitations boilerplate; merged into one SEO reference.
- **Brooks-Lint family** — audit/debt/review/sweep share the same `../_shared/common.md` setup and
  Iron Law; merged with each mode's distinct process.
- **Logic-Lens family** — review/locate/explain/diff/fix-all share the five-field contract and
  L1-L9 taxonomy; kept the full contract once (it is critical to downstream graders).
- **correctness-first family** (invariant-guard / lemmaly / complexity-cuts / mathguard) — same
  Iron-Law template; merged, preserving each skill's unique playbook.
- **Monte Carlo family** — 5 skills share the required "bundled MCP server" routing note; kept the
  routing rule once in the MC section and each workflow's distinct output.
- **mailtrap-* (4)** — merged into one Mailtrap quick-reference in growth-marketing.
- **UI skills** (StyleSeed ui-*/ux-*) — one design-system family; merged into `ui-ux-design.md`.
- **Rube MCP automations** (close/coda/vercel/supabase) — same "ID resolution + pagination" pattern;
  merged, kept per-platform commands.
- **Persona skills** (elon/gates/hinton/jobs/buffett/tao) — same deep-simulation template; merged
  the shared activation model + each persona's frameworks in `personas-it.md`.

## Notable skills dropped / not reproduced

- **Stale stubs and marketing-only shells**: `awareness-stage-mapper`, `brand-perception-
  psychologist`, `customer-psychographic-profiler`, `emotional-arc-designer`, `headline-psychologist`,
  `identity-mirror`, `jobs-to-be-done-analyst`, `loss-aversion-designer`, `objection-preemptor`,
  `onboarding-psychologist`, `pitch-psychologist`, `price-psychology-strategist`, `scarcity-urgency-
  psychologist`, `sequence-psychologist`, `social-proof-architect`, `subject-line-psychologist`,
  `trust-calibrator`, `ux-persuasion-engineer`, `visual-emotion-engineer` — these were NOT dropped
  (their content is substantive); the placeholder frontmatter descriptions were. Dropped only the
  empty `sharp-edges` (bare stub, no content beyond a title), `sharp-coder` "caveman compression"
  speak layer was merged into code-correctness §8, and `dagantai` (empty/missing content, no file).
- **Vendor-login-required skills** kept as trigger references rather than full workflows where the
  value was entirely in an MCP credential (`jobgpt`, `maxia`, `wellally-tech`, `event-staffing-*`).
- Boilerplate "When to Use / Limitations / Stop and ask for clarification" footers (identical in
  ~150 skills) were dropped once the distinctive content was captured.

## Scripts carried

- `scripts/layout-audit.js` — copied verbatim from `uncategorized/design-spatial/scripts/` (the
  deterministic layout-audit overlay for Playwright). Genuinely reusable and dependency-free.
- Not carried: `subagent-orchestrator/scripts/install.js` (Antigravity-specific installer for the
  skill itself — not useful post-consolidation) and `vercel-optimize/scripts/*.mjs` (a 3261-line,
  project-specific signal pipeline tightly coupled to the vercel-optimize skill's own repo layout;
  too large and not general). The vercel-optimize workflow is documented in `backend-auth.md` §12.

## Gaps / doubts

- **~250 skills skimmed via headings only.** Every skill's description + headings were read and
  routed, but full bodies were read for ~25. Distilled summaries may miss some in-body nuance for
  the skimmed skills.
- **Portuguese persona skills** (nerdzao-elite, bill-gates, elon-musk, matematico-tao, etc.) kept
  in their source language flavor; English gloss added. The user is Chinese-speaking; persona
  triggers are also given in Chinese where relevant.
- **Dated/version-specific content** (seo-geo stats from Feb 2026, Clerk CVE-2025-29927, nft gas
  guidance) preserved as written but flagged with dates; verify against current sources.
- Some tool skills (Monte Carlo, apple-notes, JobGPT, Helium, MAXIA, Mercury) depend on external
  MCP servers/credentials — captured as setup + routing, not executable without those.
