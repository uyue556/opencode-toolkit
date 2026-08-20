# Architecture Decisions & ADRs

How to make decisions and record them. Sources: `architecture`, `architecture-decision-records`,
`domain-modeling` (ADR discipline). Works with the main skill's "Core workflow" step 4.

## 1. Context discovery (ask before designing)

Question hierarchy:

1. **Scale** — users (10 / 1K / 100K / 1M+), data volume (MB/GB/TB), transaction rate.
2. **Team** — solo or team? size/expertise? distributed or co-located?
3. **Timeline** — MVP/prototype or long-term product? time-to-market pressure?
4. **Domain** — CRUD-heavy or complex business logic? real-time? compliance/regulations?
5. **Constraints** — budget, legacy systems, stack preferences.

Project classification matrix:

| | MVP | SaaS | Enterprise |
|---|---|---|---|
| Scale | <1K | 1K–100K | 100K+ |
| Team | Solo | 2–10 | 10+ |
| Timeline | Fast (weeks) | Medium (months) | Long (years) |
| Architecture | Simple | Modular | Distributed |
| Patterns | Minimal | Selective | Comprehensive |

## 2. The 3 questions before any pattern

1. What **specific** problem does this pattern solve?
2. Is there a **simpler** alternative?
3. Can we **defer** this complexity until needed?

Red flags / anti-patterns:

| Pattern | Anti-pattern | Simpler alternative |
|---|---|---|
| Microservices | Premature splitting | Start monolith, extract later |
| Clean/Hexagonal | Over-abstraction | Concrete first, interfaces later |
| Event Sourcing | Over-engineering | Append-only audit log |
| CQRS | Unnecessary complexity | Single model |
| Repository | YAGNI for simple CRUD | ORM direct access |

## 3. Pattern selection decision tree (main concern)

- **Data access complexity HIGH** → Repository + Unit of Work (validate: will data source change
  frequently?). LOW → ORM direct access.
- **Business rules complexity HIGH** → DDD (with domain experts) or partial DDD (rich entities +
  clear boundaries). LOW → Transaction Script.
- **Independent scaling needed** → microservices only if ALL of: clear domain boundaries,
  team >10 devs, different scaling needs per service. Otherwise → Modular Monolith.
- **Real-time requirements HIGH** → event-driven + message queue (validate: can you accept
  eventual consistency?). LOW → synchronous REST/GraphQL.

## 4. ADR basics

An ADR captures Context (why), Decision (what), Consequences (what happens as a result).

Write an ADR when:

| Write ADR | Skip ADR |
|---|---|
| New framework adoption | Minor version upgrades |
| Database technology choice | Bug fixes |
| API design patterns | Implementation details |
| Security architecture | Routine maintenance |
| Integration patterns | Configuration changes |

Lifecycle: `Proposed → Accepted → Deprecated → Superseded` (also `Rejected`).

When to offer an ADR — all three must be true:
1. **Hard to reverse** — cost of changing your mind later is meaningful.
2. **Surprising without context** — a future reader will wonder why.
3. **Real trade-off** — genuine alternatives existed and you chose for specific reasons.

Qualifies: architectural shape (monorepo, event-sourced write model), integration patterns
between contexts, lock-in tech (DB, message bus, auth, deployment target), boundary/ownership
decisions, deliberate deviations from the obvious path, constraints not visible in code, and
non-obvious rejected alternatives.

## 5. ADR templates

### Standard (MADR)

```markdown
# ADR-0001: Use PostgreSQL as Primary Database

## Status
Accepted

## Context
We need a primary database for an e-commerce platform: ~10,000 concurrent users, complex
product catalog, order/payment transactions, full-text search, geospatial queries.

## Decision Drivers
- Must have ACID compliance for payment processing
- Must support complex queries for reporting
- Should support full-text search (reduce infra complexity)
- Team familiarity reduces onboarding time

## Considered Options
### Option 1: PostgreSQL
- Pros: ACID, JSONB, built-in full-text, PostGIS, team experience
- Cons: replication setup more complex than MySQL
### Option 2: MySQL
- Pros: familiar, simple replication, big community
- Cons: weaker JSON, no built-in full-text/geospatial
### Option 3: MongoDB
- Pros: flexible schema, native JSON, horizontal scaling
- Cons: weaker multi-doc transactions, less team experience

## Decision
Use PostgreSQL 15.

## Rationale
Best balance of ACID, built-in features, team familiarity, and ecosystem.

## Consequences
Positive: one DB handles transactions/search/geo; fewer services. Negative: learn PG-specific
features; may need read replicas sooner. Risks: FTS may not scale — mitigation: design for
optional Elasticsearch later.

## Related Decisions
- ADR-0002: Caching Strategy (Redis)
```

### Lightweight

```markdown
# ADR-0012: Adopt TypeScript for Frontend

**Status**: Accepted · **Date**: 2024-01-15 · **Deciders**: @alice, @bob

## Context
React codebase grew to 50+ components with prop-type-mismatch bugs. PropTypes are runtime-only.

## Decision
Adopt TypeScript for all new code; migrate existing code incrementally (`allowJs: true`).

## Consequences
Good: compile-time errors, IDE support. Bad: learning curve, initial slowdown. Mitigations:
training + gradual adoption.
```

### Y-statement

```markdown
# ADR-0015: API Gateway Selection

In the context of building a microservices architecture,
facing the need for centralized API management, authentication, and rate limiting,
we decided for Kong Gateway and against AWS API Gateway and custom Nginx,
to achieve vendor independence and plugin extensibility,
accepting that we must manage Kong infrastructure ourselves.
```

### Deprecation / supersede

```markdown
# ADR-0020: Deprecate MongoDB in Favor of PostgreSQL

## Status
Accepted (Supersedes ADR-0003)

## Context
ADR-0003 chose MongoDB for profile storage. Since then schema stabilized, team gained PG
expertise, and dual-database operational burden grew.

## Migration Plan
1. Week 1-2: PG schema + dual-write
2. Week 3-4: backfill + validate consistency
3. Week 5: switch reads to PG, monitor
4. Week 6: remove Mongo writes, decommission
```

### RFC style (for proposals)

```markdown
# RFC-0025: Adopt Event Sourcing for Order Management

## Summary / Motivation / Detailed Design / Drawbacks / Alternatives / Unresolved Questions /
## Implementation Plan / References
```

## 6. ADR management

```
docs/adr/
├── README.md           # Index + guidelines
├── template.md
├── 0001-use-postgresql.md
└── 0020-deprecate-mongodb.md   # [SUPERSEDES 0003]
```

Index table: `| ADR | Title | Status | Date |`. Statuses: Proposed, Accepted, Deprecated,
Superseded, Rejected.

Tooling:

```bash
brew install adr-tools
adr init docs/adr
adr new "Use PostgreSQL as Primary Database"
adr new -s 3 "Deprecate MongoDB in Favor of PostgreSQL"   # supersede #3
adr generate toc > docs/adr/README.md
adr link 2 "Complements" 1 "Is complemented by"
```

## 7. Review process

Before submission: context clear, all viable options considered, honest pros/cons, consequences
documented, related ADRs linked. During review: ≥2 senior engineers, affected teams consulted,
security + cost implications assessed, reversibility evaluated. After acceptance: index updated,
team notified, implementation tickets created.

## 8. Do / Don't

Do: write ADRs early; keep them 1–2 pages; be honest about cons; link decisions; update status.
Don't: change an accepted ADR (supersede instead); skip context; hide failures (rejected
decisions are valuable); be vague; leave ADRs without action.

## 9. Trade-off analysis format

```markdown
## Architecture Decision Record
- Context: problem + constraints
- Options Considered: table (option / pros / cons / complexity / when valid)
- Decision: chosen option
- Rationale: reasons tied to constraints
- Trade-offs Accepted: what we give up and why it's acceptable
- Consequences: positive / negative / mitigation
- Revisit Trigger: when to reconsider
```

Storage convention: `docs/architecture/adr-001-*.md` or `docs/adr/NNNN-*.md`.