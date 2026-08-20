# Deduplication Notes — engineering-architecture

Consolidated 53 source SKILL.md files across 7 libraries into one skill + 13 references.

## Source libraries scanned (53 SKILL.md total)

- **architecture/** (28): architect-review, architecture, architecture-decision-records,
  architecture-patterns, c4-architecture-c4-architecture, c4-code, c4-component, c4-container,
  c4-context, codebase-design, cqrs-implementation, ddd-context-mapping, ddd-strategic-design,
  ddd-tactical-patterns, docs-architect, domain-driven-design, domain-modeling,
  event-sourcing-architect, event-store-design, graphql-architect, microservices-patterns,
  monopoly, nodejs-best-practices, production-code-audit, projection-patterns,
  saga-orchestration, site-architecture, software-architecture.
- **code/** (18): language-pro skills (c, cpp, csharp, elixir, golang, haskell, java, javascript,
  julia, php, python, ruby, rust, scala, typescript-pro, typescript-advanced-types,
  unreal-engine-cpp, sankhya-dashboard).
- **core-dev/** (1): vscode-extension-guide-en.
- **developer-tools/** (3): gh-image, mcp-tool-developer, tokenwise.
- **tools/** (1): android-cli.
- **tool-quality/** (1): clarvia-aeo-check.
- **debugging/** (1): diagnose-android-overheating.

Plus deep-read of reference files: ADR templates; DDD strategic/tactical/context-map templates;
codebase-design DEEPENING + DESIGN-IT-TWICE; domain-modeling CONTEXT-FORMAT + ADR-FORMAT;
architecture-patterns/microservices/cqrs/projection implementation playbooks (headings + key
sections); monopoly patterns/scale-benchmarks/tech-matrix/security-checklist; site-architecture
reference dirs (headings).

## Topics merged (sub-topics → reference files)

1. **Architecture decision-making & ADRs** → `architecture-decisions.md` (merged `architecture`
   decision framework + context discovery + selection trees, `architecture-decision-records`
   templates/lifecycle/adr-tools, `domain-modeling` ADR discipline, `ddd` routing to ADRs).
2. **Architecture patterns** → `architecture-patterns.md` (merged `architecture-patterns`,
   `software-architecture` layering/naming, nodejs layering).
3. **Domain-Driven Design** → `ddd.md` (merged `domain-driven-design` routing + viability,
   `ddd-strategic-design`, `ddd-context-mapping`, `ddd-tactical-patterns`, `domain-modeling`
   CONTEXT.md live-glossary discipline).
4. **Event-driven** → `event-sourcing.md` (merged `event-sourcing-architect`,
   `event-store-design`, `cqrs-implementation`, `projection-patterns`, `saga-orchestration`,
   outbox/circuit-breaker/etc. from `monopoly/patterns`).
5. **Microservices & distributed** → `microservices.md` (merged `microservices-patterns`,
   monopoly scale-benchmarks + tech-matrix, architect-review resilience knowledge).
6. **System design & scaling** → `system-design.md` (merged `monopoly` modes + patterns +
   scale-benchmarks + tech-matrix + security-checklist; architect-review audit approach).
7. **C4 & documentation** → `c4-documentation.md` (merged all five c4-* skills + `docs-architect`).
8. **Clean code & deep modules** → `code-quality.md` (merged `software-architecture` code style,
   `codebase-design` deep-module vocabulary + DEEPENING + DESIGN-IT-TWICE).
9. **Code audit & review** → `code-audit.md` (merged `production-code-audit`,
   `architect-review`).
10. **API (GraphQL)** → `api-graphql.md` (`graphql-architect`).
11. **Runtime practices** → `runtime-practices.md` (`nodejs-best-practices`, generalized).
12. **Developer tools** → `developer-tools.md` (merged `mcp-tool-developer`,
    `vscode-extension-guide-en`, `tokenwise`, `clarvia-aeo-check`, `gh-image`, `android-cli`).
13. **Debugging methodology** → `debugging.md` (`diagnose-android-overheating`, generalized).

## Notable duplicates dropped

- **C4 orchestration duplication**: the c4-container/component/context/code SKILL.md files each
  repeat the same "Use this skill / Instructions / Limitations" boilerplate. Kept the C4 workflow
  (levels, phases, Mermaid + OpenAPI templates) once in `c4-documentation.md`.
- **ADR material repeated 3×** (`architecture-decision-records`, `architecture/trade-off-analysis`,
  `domain-modeling/ADR-FORMAT`). Kept full MADR/light/Y/deprecation/RFC templates once; folded the
  "when to write / when to skip" and single-paragraph-ADR rule into the same file.
- **Generic boilerplate** ("Clarify goals, constraints...", "If detailed examples required open
  implementation-playbook.md", "Limitations: validate...") removed from every skill; the actual
  playbook content (patterns, templates) was synthesized rather than copied.
- **Overlapping code-quality rules**: `software-architecture` and `nodejs-best-practices` both
  cover error handling, validation at boundaries, anti-patterns — deduped into one list.
- **Distributed patterns** (CQRS, ES, saga, circuit breaker, bulkhead, outbox, consistent hashing,
  backpressure, 2PC) existed in BOTH `monopoly/patterns` and the event-sourcing/microservices
  playbooks — kept one merged version across `event-sourcing.md` + `microservices.md` +
  `system-design.md` §8.
- **Scale/tech data** in `monopoly/tech-matrix` and `monopoly/scale-benchmarks` partially overlap —
  kept one copy of each table.
- **Debugging output format** generalized from Android-specific ADB examples to any system, keeping
  the evidence-based core (baseline → controlled comparison → correlation → gating).
- **`architecture/site-architecture`** (28th) — skimmed headings; it's web/SEO information
  architecture (hierarchy, nav, URL patterns, internal linking) rather than software
  engineering-architecture. Not merged; noted as out-of-domain. (Its mermaid/ASCII hierarchy
  conventions are consistent with c4-documentation but for marketing sites.)
- **`architecture/monopoly`** is branded marketing fluff around genuinely good content; kept the
  content (modes, blueprint, audit tags, roadmaps, matrices), dropped the persona branding.

## Notable drops (kept out of scope)

- **code/*-pro language skills (17 of 18)**: per-language "write idiomatic X" guides (C, C++,
  C#, Elixir, Go, Haskell, Java, JS, Julia, PHP, Python, Ruby, Rust, Scala, TS, TS-advanced,
  Unreal). These are language-specific and belong in per-language domains, not a single
  architecture skill. Their *general* principles (naming, testing, error handling, performance)
  are captured in `code-quality.md` and `runtime-practices.md`. The one exception kept:
  `nodejs-best-practices` (architecture-relevant decision-making).
- **sankhya-dashboard-html-jsp-custom-best-pratices**: vendor-specific BI dashboard patterns for
  a single ERP platform (JSP/JSTL, Sankhya BI); out of scope for general engineering-architecture.
- **Specific tool installers**: `android-cli` installer guidance (download-and-review pattern) kept
  as a best practice; the `gh-image` session-cookie flow and tokenwise installer are kept as
  references because they enable developer workflow, but their repo-specific setup details are
  summarized only.

## Scripts

**No scripts carried.** None of the source libraries contained a `scripts/` directory; all
supporting material was Markdown references/templates, which were synthesized into the reference
files. No code assets were copied (the code snippets in event-store/saga/CQRS playbooks are
educational templates; representative examples were preserved in the references).

## Gaps / doubts

- **C4 Mermaid diagrams** could not be fully verified against the live Mermaid renderer; the syntax
  is copied verbatim from source templates and should be validated when rendered.
- **Scale benchmarks** (writes/s, capacity costs) are approximate and hardware-dependent — flagged
  as such in the references.
- **Node.js/2025** version claims (runtime flags, framework choice) may drift; flagged to check
  against current tool/spec versions.
- The `architecture-patterns` "durable execution / DBOS" recommendations are a vendor-tinted
  pattern; presented as an option alongside sagas, not a mandate.
- Some source SKILL.md files referenced playbooks I could only partially read; where headings
  showed unique patterns (e.g., projection multi-table/aggregation templates) I captured the
  essence rather than full code.
