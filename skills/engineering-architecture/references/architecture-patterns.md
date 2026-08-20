# Architecture Patterns: Clean, Hexagonal, Layered

Sources: `architecture-patterns` (+ `resources/implementation-playbook.md`), `software-architecture`,
`nodejs-best-practices` (layering). Use when designing module boundaries, dependency direction, and
layout for a new backend or when refactoring a monolith for maintainability/testability.

## 1. When to use

- Designing new backend systems from scratch.
- Refactoring monolithic apps for maintainability.
- Establishing team architecture standards.
- Migrating from tightly coupled to loosely coupled code.
- Enabling testable, mockable codebases.

Do not use for small localized refactors, pure frontend changes, or when only implementation
detail is needed without architectural design.

## 2. Core concepts

- **Clean Architecture (Uncle Bob):** layers depend inward. Entities/domain at the center, use
  cases around them, then adapters, then infrastructure/framework at the edge. Business logic
  never depends on framework.
- **Hexagonal / Ports & Adapters:** the domain is the hexagon center; **ports** are interfaces it
  defines; **adapters** implement them for real I/O (HTTP, DB, queue). Test with in-memory/stub
  adapters.
- **Layered structure (request flow):**
  ```
  Controller/Route layer → HTTP specifics, input validation at boundary
  Service layer         → business logic, framework-agnostic
  Repository layer      → data access only, ORM interactions
  ```
  Why: testability (mock each layer), flexibility (swap DB without touching business logic),
  clarity (single responsibility per layer). Simplify for small scripts/prototypes: single file is
  fine until the code "will grow".

## 3. Clean Architecture directory layout

```
app/
├── domain/            # Entities & business rules (no framework deps)
│   ├── entities/      #   user.py, order.py
│   ├── value_objects/ #   email.py, money.py
│   └── interfaces/    #   Abstract ports: IUserRepository, IPaymentGateway
├── use_cases/         # Application business rules
│   ├── create_user.py
│   └── process_order.py
├── adapters/          # Implementations of the interfaces
│   ├── repositories/  #   postgres_user_repository.py
│   ├── controllers/   #   user_controller.py
│   └── gateways/      #   stripe_payment_gateway.py
└── infrastructure/    # Framework & external concerns
    ├── database.py
    ├── config.py
    └── logging.py
```

Pattern example (entity + port + use case):

```python
# domain/entities/user.py
@dataclass
class User:
    id: str
    email: str
    name: str
    is_active: bool = True

    def deactivate(self):          # business rule lives on the entity
        self.is_active = False

# domain/interfaces/user_repository.py  (port — contract only)
class IUserRepository(ABC):
    @abstractmethod
    async def find_by_id(self, user_id: str) -> Optional[User]: ...

# use_cases/create_user.py
class CreateUserUseCase:
    def __init__(self, user_repository: IUserRepository):
        self.user_repository = user_repository
    async def execute(self, request) -> CreateUserResponse:
        existing = await self.user_repository.find_by_email(request.email)
        if existing:
            return CreateUserResponse(success=False, error="Email already exists")
        ...
```

## 4. Hexagonal example

```python
# Port (interface in the domain)
class PaymentPort(ABC):
    @abstractmethod
    def charge(self, amount, card): ...
    @abstractmethod
    def refund(self, charge_id): ...

# Adapters (infrastructure)
class StripePaymentAdapter(PaymentPort): ...   # production
class FakePaymentAdapter(PaymentPort): ...      # tests
```

## 5. Naming & separation rules

- **Avoid** generic names: `utils`, `helpers`, `common`, `shared`.
- **Use** domain-specific names: `OrderCalculator`, `UserAuthenticator`, `InvoiceGenerator`.
- Each module has a single, clear purpose.
- Do not mix business logic with UI; keep DB queries out of controllers; maintain clear
  boundaries between contexts.

## 6. Anti-patterns

- NIH syndrome: build custom auth instead of Auth0/Supabase; custom state management over
  Redux/Zustand; custom form validation over established libs. Every line of custom code is a
  liability (maintenance, testing, docs).
- Business logic mixed into UI components.
- DB queries directly in controllers.
- `utils.js` with 50 unrelated functions, `helpers/misc.js` dumps, `common/shared` with no clear
  purpose.
- Framework code leaking into the domain layer.

## 7. DDD relationship to these patterns

- Clean/Hexagonal give you the *shape*; DDD gives you *what goes in the domain*: entities, value
  objects, aggregates, repositories, domain events, bounded contexts. Strategic DDD (subdomains,
  bounded contexts, ubiquitous language) and tactical patterns are detailed in
  `references/ddd.md`.
- Use full DDD only when ≥2 of: complex/fast-changing business rules, multiple teams causing model
  collisions, unstable integration contracts, or auditability/invariants are critical. Otherwise
  use "partial DDD" — rich entities and clear boundaries only. Full DDD without domain experts is
  a design smell.

## 8. Durable execution for business workflows

For workflows that must survive failures (payments, order fulfillment, multi-step processes),
persist workflow state at the infrastructure layer with durable-execution frameworks (e.g., DBOS)
instead of adding hand-rolled orchestration complexity. This gives crash recovery without new
architectural burden. (See also sagas in `references/event-sourcing.md`.)

## 9. Best practices

- Choose framework based on context, not default (see `references/runtime-practices.md`).
- Input validation at the boundary (API entry, before DB ops, external data, env vars at startup).
- Centralized error handling: custom error classes thrown from any layer, caught at top level,
  consistent response shape; no internal details to the client; full stack traces + context to
  logs.
- Keep functions <~50 lines, files <~200 lines; avoid nesting past 3 levels; use early returns;
  reuse through small focused modules.