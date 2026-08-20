# Clean Code, Deep Modules & Codebase Design

Sources: `software-architecture`, `codebase-design` (+ `DEEPENING.md`, `DESIGN-IT-TWICE.md`),
`nodejs-best-practices` (style-relevant parts). Use whenever writing or restructuring code —
these rules apply even for small changes.

## 1. Code style rules

- **Early returns** over nested conditions.
- **No duplication** — extract reusable functions/modules.
- **Decompose** functions >80 lines into smaller ones; keep functions <50 lines when possible;
  split files >200 lines into multiple files (unless the code is only used in one file).
- Prefer arrow functions / concise idioms where the language supports them.
- Avoid deep nesting (max ~3 levels).
- Proper error handling with typed catch blocks.
- Meaningful, specific names — avoid `utils`, `helpers`, `common`, `shared`.

## 2. Library-first approach

- Search for existing libraries/SaaS/third-party APIs before writing custom code (e.g., use a
  retry library like `cockatiel` instead of hand-rolling retry logic).
- Custom code is justified for: specific business logic unique to the domain; performance-critical
  paths; cases where external deps would be overkill; security-sensitive code needing full control;
  or after a thorough evaluation found no fit.

## 3. Deep-module vocabulary (use exactly these terms)

- **Module** — anything with an interface and an implementation (function, class, package, or
  tier-spanning slice). *Avoid*: unit, component, service.
- **Interface** — everything a caller must know: type signature + invariants, ordering constraints,
  error modes, required config, performance characteristics. *Avoid*: API, signature (too narrow).
- **Implementation** — the body inside a module. Distinct from **Adapter** (a thing that satisfies
  an interface at a seam).
- **Depth** — leverage at the interface: behaviour per unit of interface the caller must learn.
  A module is **deep** when lots of behaviour sits behind a small interface; **shallow** when the
  interface is nearly as complex as the implementation (avoid).
- **Seam** (Feathers) — a place where you can alter behaviour without editing in that place; where
  the module's interface lives. *Avoid*: boundary (overloaded with DDD bounded context).
- **Adapter** — a concrete thing that satisfies an interface at a seam; describes role, not
  substance.
- **Leverage** — what callers get from depth: one implementation pays back across N call sites and
  M tests.
- **Locality** — what maintainers get from depth: change/bugs/knowledge/verification concentrate in
  one place. Fix once, fixed everywhere.

## 4. Designing deep modules

When designing an interface ask: can I reduce the number of methods? simplify parameters? hide
more complexity inside?

Principles:
- **Depth is a property of the interface, not the implementation.** Internal seams (private,
  used by own tests) are separate from the external seam.
- **Deletion test:** if deleting the module removes complexity → pass-through; if complexity
  reappears across N callers → it's earning its keep.
- **The interface is the test surface.** Callers and tests cross the same seam.
- **One adapter = hypothetical seam; two adapters = real one.** Don't introduce a seam unless
  something actually varies across it.

Designing for testability:
1. Accept dependencies, don't create them (inject the payment gateway; don't `new` it inside).
2. Return results, don't produce side effects (`calculateDiscount(cart)` not
   `applyDiscount(cart): void`).
3. Small surface area — fewer methods/params = fewer tests, simpler setup.

## 5. Deepening a cluster (DEEPENING.md)

Classify dependencies before deepening:
1. **In-process** (pure computation) — always deepenable; merge and test through the new interface.
2. **Local-substitutable** (has local test stand-in like PGLite, in-memory FS) — deepenable;
   test with the stand-in; the seam is internal.
3. **Remote but owned (ports & adapters)** — define a port at the seam; deep module owns logic;
   transport injected as adapter; tests use in-memory adapter, production uses HTTP/gRPC/queue.
   Shape: "Define a port at the seam, implement an HTTP adapter for production and an in-memory
   adapter for testing, so the logic sits in one deep module even though it's deployed across a
   network."
4. **True external (mock)** — third-party services you don't control; take as an injected port;
   tests provide a mock adapter.

Seam discipline: don't introduce a port unless ≥2 adapters are justified (typically production +
test). Don't expose internal seams through the interface just because tests use them.

**Testing: replace, don't layer.** Old unit tests on shallow modules become waste once the
deepened module's interface has tests — delete them. Write tests at the new interface asserting on
observable outcomes, not internal state; tests should survive internal refactors.

## 6. Design It Twice (alternative interfaces)

When exploring interface options for a deepening candidate: frame the problem space → spawn 3+
parallel sub-agents, each producing a **radically different** interface with a distinct constraint:
1. Minimize the interface (1–3 entry points, max leverage per entry).
2. Maximise flexibility (many use cases + extension).
3. Optimise for the most common caller (make the default case trivial).
4. (If applicable) Design around ports & adapters.

Each sub-agent outputs: interface (types/invariants/errors), usage example, what the
implementation hides, dependency strategy + adapters, trade-offs. Present sequentially, compare by
depth / locality / seam placement, then give an opinionated recommendation (optionally a hybrid).

## 7. Anti-patterns (style-level)

- Generic naming dumps: `utils.js` with 50 unrelated functions; `helpers/misc.js` as dumping
  ground; `common/shared.js` with unclear purpose.
- Deep nesting, giant functions, files that mix concerns.
- Side-effectful functions where pure functions would do.
- Recreating libraries when established ones exist (custom auth, custom state management, custom
  form validation).