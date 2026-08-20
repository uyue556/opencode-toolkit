---
name: engineering-architecture
description: >
  Senior software architecture skill: decision frameworks, ADRs, clean/hexagonal/DDD patterns,
  event sourcing & CQRS, microservices, C4 documentation, code auditing/review, refactoring,
  system-design/scaling, and debugging methodology. Use whenever the user asks to design or
  review a system, pick a tech stack, write an architecture decision record (ADR), map bounded
  contexts, generate C4/architecture documentation, make code production-ready, audit or review
  a codebase, scale a service, refactor for maintainability, or investigate a hard-to-diagnose
  bug. Triggers: architecture, system design, ADR, 架构, 系统设计, 架构评审, 决策记录, DDD,
  领域驱动设计, 限界上下文, 事件溯源, CQRS, 微服务, scalable, 扩展性, code review, 代码评审,
  code audit, 代码审计, production-ready, refactoring, 重构, debugging, 调试.
risk: critical
source: consolidated
---

# Engineering Architecture

A single, opinionated workflow for designing, documenting, reviewing, and evolving software
architecture. Everything here derives from the source skills consolidated in `dedup-notes.md`;
detail lives in `references/`. This skill routes, standards and warns; the references hold the
templates, tables, and code.

## When to use

- Designing a new system, service, module, or API.
- Making or documenting an architectural decision (see `references/architecture-decisions.md`).
- Applying clean/hexagonal/DDD/microservices/event-driven patterns.
- Writing architecture documentation: ADRs, C4 model, technical manuals.
- Auditing or reviewing a codebase for production readiness, security, performance, quality.
- Planning refactors (god classes, N+1, over-coupling) or scaling a system.
- Debugging a hard problem systematically.

Do **not** use it for small, local code changes that carry no architectural weight — apply the
clean-code rules only (see `references/code-quality.md`).

## Core principles

1. **Requirements drive architecture; trade-offs inform decisions; ADRs capture rationale.**
2. **Start simple.** Complexity is a liability — add it only when proven necessary. Removing
   complexity is far harder than adding it. You can always add a pattern later.
3. **Match pattern/size to team, scale, and timeline**, not hype. A solo MVP should not carry
   microservices; an enterprise should not be a pile of `utils.js`.
4. **Design for failure.** Everything fails; make it fail gracefully and recover.
5. **Measure before scaling and before rescuing performance.**
6. **Document the "why"**, not just the "what". If it's hard to reverse, surprising, or a real
   trade-off, write an ADR.
7. **Keep business logic independent of frameworks and infrastructure.**

## Core workflow

1. **Clarify context first.** Gather scale (users, data, RPS), team size/expertise, timeline
   (MVP vs long-term), domain complexity, and hard constraints (budget, legacy, compliance).
   Classify the project: MVP (<1K users, solo, weeks) → simple; SaaS (1K–100K, 2–10 devs,
   months) → modular monolith; Enterprise (100K+, 10+ devs, years) → distributed. See
   `references/architecture-decisions.md` (context discovery + selection trees).
2. **Ask the 3 questions before any pattern.** (a) What specific problem does it solve?
   (b) Is there a simpler alternative? (c) Can we defer the complexity until it's needed?
3. **Route to the right sub-workflow** (table below).
4. **Document decisions as ADRs** for anything significant.
5. **Verify with tests, audits, and trade-off review** — never hand over unvalidated design.

## Selection routing

| Task | Route to |
|------|----------|
| Decision-making framework, ADRs, trade-offs, onboarding docs | `references/architecture-decisions.md` |
| Clean/Hexagonal/DDD code structure, layering, dependency rules | `references/architecture-patterns.md` |
| Strategic DDD: subdomains, bounded contexts, ubiquitous language, context maps | `references/architecture-patterns.md` (§DDD) + `references/ddd.md` |
| Event sourcing, event store design, projections, CQRS, sagas | `references/event-sourcing.md` |
| Service decomposition, inter-service comm, resilience (bulkhead/circuit breaker) | `references/microservices.md` |
| Full system blueprint, scale estimation, tech selection, scaling roadmap, design interview | `references/system-design.md` |
| C4 docs (Context/Container/Component/Code), Mermaid, OpenAPI, technical manuals | `references/c4-documentation.md` |
| Clean code, naming, function/module sizes, deep modules, code-style rules | `references/code-quality.md` |
| Production audit, security/perf/quality review, report template | `references/code-audit.md` |
| GraphQL schema/federation/performance/security | `references/api-graphql.md` |
| Node.js/JS runtime decisions (framework, async, validation, security) | `references/runtime-practices.md` |
| MCP servers, VS Code extensions, model routing, AEO scoring, CLI tooling | `references/developer-tools.md` |
| Systematic debugging (evidence, controlled comparison, correlation) | `references/debugging.md` |

## Do

- Write ADRs early, keep them short, be honest about trade-offs, link related decisions, and
  mark superseded ones. (Never mutate an accepted ADR — write a new one.)
- Validate all inputs at boundaries; never trust external/internal data unexamined.
- Use parameterized queries, environment variables for secrets, proper auth on protected routes,
  and structured error responses that leak nothing internal.
- Prefer deep modules: lots of behaviour behind a small interface at a real seam.
- Make every distributed step idempotent; design compensating actions carefully.
- Produce a Mermaid diagram for every system design; always show your math for scale estimates.
- Use evented patterns only when justified: audit trail, temporal queries, read/write divergence,
  or replay needs. Otherwise CRUD suffices.
- Audit codebases autonomously: scan everything, fix (not just report), verify with tests,
  measure before/after.
- Debug with evidence: capture an untouched baseline, run one controlled comparison, and require
  at least two independent signals before attributing cause.

## Don't

- Don't adopt microservices/CQRS/event sourcing as status symbols — start monolith/crud and
  extract later when a real trigger appears.
- Don't create generic modules named `utils`/`helpers`/`common`; name by domain
  (`OrderCalculator`, `UserAuthenticator`).
- Don't put business logic in controllers, DB queries in controllers, or frameworks in the domain.
- Don't skip optimistic concurrency in event stores or skip idempotency in event handlers.
- Don't collect full bug reports unless narrow evidence fails — they leak account and app data.
- Don't change multiple variables at once when debugging or intervening.
- Don't approve high-risk changes without a validation plan.

## Common pitfalls

- **Over-engineering**: pattern picked for the wrong project class. Use the classification matrix
  and the 3 questions.
- **False positives in audits**: flag only after understanding context; verify manually.
- **No follow-through**: an audit report that no one actionably owns is waste — turn findings into
  issues with owners and timelines.
- **God classes / huge files**: >500-line classes, >200-line files, and >10 cyclomatic complexity
  fail review.
- **Saga compensation untested**: the rollback path is the most failure-prone part; test it.
- **Event store drift**: mutating or deleting stored events, and skipping checkpoints.
- **Treating one snapshot as cause**: a hot CPU at one instant proves nothing; correlate across the
  symptom window.

## Sub-workflows (TL;DR; full detail in references)

- **Decision**: gather context → classify project → 3 questions → pick pattern → trade-off doc →
  ADR. `references/architecture-decisions.md`
- **Design**: clarify → estimate (DAU→RPS, storage, bandwidth) → blueprint layers → Mermaid →
  stack table → trade-offs. `references/system-design.md`
- **Review**: tag findings `[SPOF]`, `[BOTTLENECK]`, `[SECURITY_GAP]`, `[SCALE_LIMIT]`, etc.,
  and output a graded audit report. `references/code-audit.md`
- **Scale**: phase roadmap keyed to user counts with build-vs-buy and cost ranges.
- **Document**: bottom-up C4 (Code→Component→Container→Context) with OpenAPI specs at container
  level. `references/c4-documentation.md`
- **Debug**: baseline → symptom branch → one controlled comparison → correlate (≥2 signals) →
  classify confidence → gate interventions → verify. `references/debugging.md`

## Examples

- "Design a URL shortener": clarify → compute DAU/RPS/storage → blueprint (DNS/LB/API/DB/cache)
  → Mermaid diagram → trade-offs stated → phased roadmap. See `references/system-design.md`.
- "Is full DDD worth it here?": run the viability check (≥2 of: complex/fast-changing rules,
  team model collisions, unstable contracts, auditability critical) — else use richer entities
  only. `references/architecture-patterns.md`
- "Make this production-ready": autonomous scan → grade findings by severity → fix criticals
  (injection, hardcoded secrets, missing auth, weak hashing) → add observability → test →
  before/after report. `references/code-audit.md`

## References index

- `references/architecture-decisions.md` — ADR templates (MADR, light, Y-statement, deprecation,
  RFC), lifecycle, adr-tools, review process, context discovery, pattern selection trees.
- `references/architecture-patterns.md` — Clean Arch directory layout, Hexagonal ports/adapters,
  layered service structure, DDD strategic/tactical patterns.
- `references/ddd.md` — DDD viability + routing, subdomain classification, bounded-context catalog,
  context maps (ACL, OHS, customer-supplier…), ubiquitous-language format, aggregate/entity/VO
  discipline.
- `references/event-sourcing.md` — event store requirements & schemas (Postgres/EventStoreDB/
  DynamoDB), CQRS command/query buses, projections, sagas (choreography vs orchestration), outbox.
- `references/microservices.md` — decomposition by capability, REST vs events, resilience patterns,
  strangler-fig migration, tech scale benchmarks.
- `references/system-design.md` — design blueprint by layer, scale-estimation formulas, tech
  decision matrix, scaling roadmap phases, system-design-interview scorecard.
- `references/c4-documentation.md` — 4-level C4 workflow (bottom-up), per-level templates +
  Mermaid/classDiagram syntax, OpenAPI generation, long-form technical-manual process.
- `references/code-quality.md` — code style rules (early return, sizes, naming), deep-module
  vocabulary (module/interface/seam/adapter/depth), deepening + design-it-twice, anti-patterns.
- `references/code-audit.md` — autonomous audit workflow, issue taxonomy by severity, production
  readiness checklist, audit report template, code-review response approach.
- `references/api-graphql.md` — GraphQL schema first, federation, DataLoader/N+1, caching,
  security/rate limits, subscriptions, testing.
- `references/runtime-practices.md` — runtime/framework/moduule-system selection, layered arch
  in Node, error handling + status codes, async patterns (event-loop awareness), validation,
  security checklist, testing priorities.
- `references/developer-tools.md` — MCP server development, VS Code extension lifecycle, model
  routing (tokenwise), AEO tool scoring (Clarvia), GitHub image upload, Android CLI.
- `references/debugging.md` — symptom-first workflow, baseline capture, controlled comparison,
  correlation rules, confidence levels, intervention gates, redaction/safety.

## Limitations

- This skill guides and templates; always validate generated designs against the real system,
  run tests, and get expert review before production.
- Scale numbers, benchmarks, and technology capacity tables are approximate and hardware-dependent.
- Not a substitute for environment-specific compliance, security, or performance validation.
- Some source skills carried vendor-specific tooling (MCP, Node, GraphQL, Android); cross-check
  against the current tool/spec version before relying on it.