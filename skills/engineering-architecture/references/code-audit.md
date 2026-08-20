# Code Audit, Review & Production Readiness

Sources: `production-code-audit`, `architect-review`. Use when the user says "make this
production-ready", "audit my codebase", "make this professional/corporate-level", "optimize
everything", or wants enterprise-grade quality / an architecture review.

## 1. Autonomous codebase discovery

Automatically (don't ask): read all files recursively; identify tech stack (package.json,
requirements.txt, etc.); map architecture/patterns/dependencies; understand purpose; find entry
points (main files, routes, controllers); map data flow.

## 2. Issue taxonomy

**Architecture:** circular dependencies; tight coupling; god classes (>500 lines or >20 methods);
missing separation of concerns; poor module boundaries; design-pattern violations.

**Security:** SQL injection (string concatenation); XSS (unescaped output); hardcoded secrets; missing
auth/authorization; weak password hashing (MD5/SHA1 → bcrypt 12+); missing input validation; CSRF;
insecure dependencies.

**Performance:** N+1 queries; missing indexes; sync ops that should be async; missing caching;
O(n²)+ algorithms; large bundles; unoptimized images; memory leaks.

**Code quality:** cyclomatic complexity >10; duplication; magic numbers; poor naming; missing error
handling; inconsistent formatting; dead code; TODO/FIXME.

**Testing gaps:** no tests on critical paths; coverage <80%; no edge cases; flaky tests; no
integration tests.

**Production readiness:** missing env vars; no logging/monitoring; no error tracking; no health
checks; incomplete docs; no CI/CD.

## 3. Fix, then verify (workflow)

1. **Refactor architecture** — break up god classes, fix circular dependencies (e.g., decouple via
   event bus), define module boundaries.
2. **Fix security** — parameterized queries, move secrets to env (fail on missing), add auth
   middleware + role checks, whitelist mass-assignment fields, upgrade hashing.
3. **Optimize performance** — fix N+1 (join or batch), add indexes, cache hot queries (with TTL),
   parallelize independent async ops.
4. **Improve quality** — reduce complexity, remove duplication, fix naming.
5. **Add tests** for untested critical paths; run the suite after every change.
6. **Add production infrastructure** — structured logging, error tracking, health endpoints
   (`/health`, `/ready`), metrics, rate limiting, API docs.
7. **Document** — README, API docs, deployment guide, CI/CD pipeline.
8. **Verify + report** — run tests, re-scan security, measure performance, produce a graded report
   with before/after metrics.

Prioritize: critical (security/data-loss) first, then high, then medium/low. Fix everything, but
focus sprints on critical/high to avoid paralysis by 200+ issues.

## 4. Production audit checklist

- **Security:** no SQL injection; no hardcoded secrets; auth on protected routes; authorization
  checks; input validation on all endpoints; bcrypt (10+ rounds); HTTPS enforced; deps clean.
- **Performance:** no N+1; indexes on foreign keys; caching implemented; API response <200ms;
  bundle <200KB gzipped.
- **Testing:** coverage >80%; critical paths tested; edge cases covered; no flaky tests; tests in
  CI/CD.
- **Production readiness:** env vars configured; error tracking; structured logging; health checks;
  monitoring/alerting; docs complete.

## 5. Audit report template

```markdown
# Production Audit Report
**Project / Date / Overall Grade [A-F]**

## Executive Summary          (2-3 sentences + critical/high counts + fix timeline)

## Findings by Category
### Architecture (Grade: A-F)    issue → fix
### Security (Grade: A-F)        issue → fix
### Performance (Grade: A-F)
### Testing (Grade: A-F)         coverage % + issues

## Priority Actions              critical → timeline; high → timeline
## Timeline
```

## 6. Architectural review (architect-review)

Response approach: analyze architectural context → assess impact of changes
(High/Medium/Low) → evaluate pattern compliance → identify violations/anti-patterns →
recommend improvements with specific refactoring suggestions → consider scalability →
document decisions (ADRs when needed) → give concrete next steps.

Coverage: modern patterns (Clean/Hex/DDD, microservices, EDA/ES/CQRS, serverless, API-first,
layered); distributed systems (service mesh, streaming, saga/outbox/event sourcing, circuit
breaker/bulkhead/timeout, distributed caching, load balancing/service discovery, tracing);
SOLID + design patterns (repository/UoW/spec, factory/strategy/observer/command, decorator/
adapter/facade, DI/IoC, anti-corruption layers); cloud-native (K8s, IaC, GitOps, auto-scaling,
edge); security architecture (zero trust, OAuth2/OIDC/JWT, API security, encryption, secret
management, defense in depth); performance & scalability (h/v scaling, caching layers, sharding/
partitioning, CDN, async + queues, connection pooling); data (polyglot persistence, data
mesh/warehouse, ES/CQRS, db-per-service, replication, streaming); quality attributes (reliability,
availability, fault tolerance, scalability, security, maintainability, testability, cost);
practices (TDD/BDD, DevSecOps, feature flags, blue-green/canary, immutable infra, platform
engineering, SRE).

Safety: avoid approving high-risk changes without validation plans; document assumptions and
dependencies to prevent regressions.

## 7. Pitfalls

- Too many issues → focus critical/high, create sprints.
- False positives → understand context, verify manually, ask developers.
- No follow-up → create GitHub issues, assign owners, track in standups.
- Reporting without fixing → the audit should transform the code, not just describe it.
- Schedule regular audits (quarterly) — prevention is cheaper than fixing production bugs.