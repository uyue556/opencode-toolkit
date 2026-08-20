# Domain-Driven Design (Strategic + Tactical + Context Mapping)

Sources: `domain-driven-design`, `ddd-strategic-design` (+ `references/strategic-design-template.md`),
`ddd-tactical-patterns` (+ `references/tactical-checklist.md`), `ddd-context-mapping`
(+ `references/context-map-patterns.md`), `domain-modeling` (+ CONTEXT-FORMAT/ADR-FORMAT).

## 1. Routing

- Viability check + stage routing → `domain-driven-design`
- Strategic model and boundaries → `ddd-strategic-design`
- Cross-context integrations and translation → `ddd-context-mapping`
- Tactical code modeling → `ddd-tactical-patterns`
- Read/write separation → `event-sourcing` (CQRS)
- Event history as source of truth → `event-sourcing`
- Long-running workflows → `event-sourcing` (sagas)
- Read models → `event-sourcing` (projections)
- Decision log → `architecture-decisions.md`

## 2. Viability check

Use full DDD only when **at least two** are true:
- Business rules are complex or fast-changing.
- Multiple teams are causing model collisions.
- Integration contracts are unstable.
- Auditability and explicit invariants are critical.

If the problem is simple CRUD with low business complexity, there's no access to domain
knowledge/expert proxy, or you only need localized bug fixes — do NOT use full DDD.

## 3. Strategic design

Workflow: extract domain capabilities → classify subdomains → define bounded contexts → build
ubiquitous language glossary → capture boundary decisions in ADRs before implementation.

Artifacts required: subdomain classification table, bounded context catalog, glossary with
canonical terms, boundary decisions with rationale.

**Subdomain classification**

| Capability | Subdomain type | Why | Owner team |
|---|---|---|---|
| Pricing | Core | Differentiates business value | Commerce |
| Identity | Supporting | Needed but not differentiating | Platform |

Types: **Core** (differentiates value), **Supporting** (needed, not differentiating), **Generic**
(buy off-the-shelf).

**Bounded context catalog**

| Context | Responsibility | Upstream dependencies | Downstream consumers |
|---|---|---|---|
| Catalog | Product data lifecycle | Supplier feed | Checkout, Search |
| Checkout | Order placement + payment auth | Catalog, Pricing | Fulfillment, Billing |

**Ubiquitous language**

| Term | Definition | Context |
|---|---|---|
| Order | Confirmed purchase request | Checkout |
| Reservation | Temporary inventory hold | Fulfillment |

## 4. Context mapping

Relationships between bounded contexts. Patterns: **Partnership**, **Shared Kernel**,
**Customer-Supplier**, **Conformist**, **Anti-Corruption Layer (ACL)**, **Open Host Service**,
**Published Language**.

**Mapping template**

| Upstream | Downstream | Pattern | Contract owner | Translation needed |
|---|---|---|---|---|
| Billing | Checkout | Customer-Supplier | Billing | Yes |
| Identity | Checkout | Conformist | Identity | No |

**ACL checklist**
- Define canonical domain model for the receiving context.
- Translate external terms into local ubiquitous language.
- Keep ACL code at the boundary, not inside the domain core.
- Add contract tests for mapped behavior.

Purpose: prevent domain leakage across service boundaries; plan ACLs during migration; clarify
upstream/downstream ownership of contracts.

## 5. Tactical patterns

Workflow: identify invariants first → design aggregates around them → model immutable value
objects for validated concepts → keep domain behavior in domain objects (not controllers) → emit
domain events for meaningful state transitions → keep repositories at aggregate-root boundaries.

**Aggregate design**
- One aggregate root per transaction boundary.
- Invariants enforced inside aggregate methods.
- Avoid cross-aggregate synchronous consistency rules.

**Value objects** — immutable, validation at construction, equality by value not identity.

**Repositories** — persist and load aggregate roots only; expose domain-friendly query methods;
avoid leaking ORM entities into the domain layer.

**Domain events** — past-tense names (`OrderSubmitted`); minimal stable payloads; version the
event schema before breaking changes.

Example:

```typescript
class Order {
  private status: "draft" | "submitted" = "draft";
  submit(itemsCount: number): void {
    if (itemsCount === 0) throw new Error("Order cannot be submitted empty");
    if (this.status !== "draft") throw new Error("Order already submitted");
    this.status = "submitted";
  }
}
```

## 6. Maintaining the domain model live (CONTEXT.md)

Single-context repo: one `CONTEXT.md` at root. Multiple contexts: a `CONTEXT-MAP.md` at root
pointing to each context's `CONTEXT.md` and its own `docs/adr/`.

`CONTEXT.md` is a **glossary and nothing else** — no implementation details, no spec, no scratch
pad. Create files lazily (create `CONTEXT.md` when the first term is resolved; create `docs/adr/`
when the first ADR is needed).

Format:

```md
# {Context Name}
{1-2 sentence description}

## Language
**Order**: {definition}
_Avoid_: Purchase, transaction

**Invoice**: A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request
```

Rules:
- Be opinionated — pick the best term and list others under `_Avoid_`.
- Tight definitions (1–2 sentences); define what it IS, not what it does.
- Only project-specific concepts; general programming terms don't belong.
- Group under subheadings when clusters emerge.

During the session:
- Challenge terms that conflict with the glossary immediately.
- Sharpen vague/overloaded language ("are you saying Customer or User?").
- Stress-test domain relationships with concrete edge-case scenarios.
- Cross-reference stated behavior against the code; surface contradictions.
- Update `CONTEXT.md` inline as terms resolve — don't batch.

ADR discipline (from `domain-modeling/ADR-FORMAT.md`):
- ADRs live in `docs/adr/`, `NNNN-slug.md`, lazily created, increment highest number.
- Template can be a single paragraph: what's the context, what did we decide, why. Optional
  sections only when valuable: Status, Considered Options, Consequences.
- Offer an ADR only when all three hold: hard to reverse, surprising without context, real
  trade-off. (See `architecture-decisions.md` for full ADR guidance.)

## 7. Output requirements

Always return: scope and assumptions; current stage (strategic / tactical / evented); explicit
artifacts produced; open risks + next step recommendation.

## 8. Limitations

- Does not produce executable code or choose databases/transport.
- Cannot infer business truth without stakeholder input.
- Pair DDD with testing patterns for invariant coverage; revisit when team ownership changes.
- Use only where justified — full DDD is not a licence to over-engineer simple systems.