---
name: backend
description: "One consolidated skill for backend engineering: REST/GraphQL/tRPC API design, API documentation (OpenAPI/Postman/SDKs), authentication & API security, API integration (webhooks, events, OAuth third-party APIs), payments (Stripe/PayPal), microservices & server architecture, caching, queues/background jobs, and database access (Postgres/Neon, N+1 prevention). Use whenever the user is working on 后端/后台, 接口, API design, REST endpoints, GraphQL schema, server code, microservices, auth, webhooks, payment integration, database-backed services, Node/Python/.NET/Laravel backends. Trigger words: backend, REST, GraphQL, tRPC, OpenAPI, Swagger, JWT, OAuth, webhook, endpoint, API security, microservice, queue, background job, server, 接口设计, 后端开发, 微服务."
---

# Backend Engineering

Production-grade backend services, APIs, and integrations. This skill routes to
sub-topic references so you can deep-dive without a giant single file. Read the
routing table below, open the relevant `references/*.md`, and follow its guidance.

## When to use this skill

- Designing or evolving an API surface: REST, GraphQL, or tRPC.
- Writing server-side code: routes, controllers, services, middleware, auth.
- Documenting APIs: OpenAPI/Swagger specs, Postman collections, client SDKs.
- Securing endpoints: authentication, authorization, validation, rate limiting.
- Integrating third-party APIs: webhooks, OAuth, event streams, payments.
- Building server architecture: microservices, resilience, caching, queues.
- Database-backed services: schema, connection handling, migration, query perf.

## Core workflow

1. **Clarify the contract first.** What does the API/interface promise? Who consumes
   it (public, internal, one frontend)? Contract-first design (types/spec before
   implementation) is what prevents breaking-change debt. See
   `references/api-design.md`.
2. **Pick the right API style.** REST, GraphQL, and tRPC solve different problems.
   Use the decision tree in `references/api-design.md`; do not default to REST.
3. **Design the data model and service layers.** Keep routes thin, business logic in
   services, persistence behind repositories. See `references/architecture.md`.
4. **Think security from the start.** Auth, authorization (not just authentication),
   input validation, rate limiting. See `references/api-security.md`.
5. **Document as you go.** OpenAPI spec + Postman collection + SDK-friendly examples
   keep docs in sync with code. See `references/api-documentation.md`.
6. **Handle async reality.** Webhooks, events, queues, and retries are where backend
   reliability is won or lost. See `references/api-integration.md` and
   `references/queues-and-jobs.md`.
7. **Test, monitor, and polish DX.** API mocking, observability (logging/metrics/
   tracing), and reducing time-to-first-call are part of the job. See
   `references/api-documentation.md` and `references/architecture.md`.

## Selection routing (open the reference that matches the task)

| If the task is about...                                   | Open reference file                          |
| ---------------------------------------------------------- | -------------------------------------------- |
| REST vs GraphQL vs tRPC choice, resource design, naming,    | `references/api-design.md`                    |
| versioning, endpoints, pagination, status codes, errors     | `references/api-design.md`                    |
| GraphQL schema, resolvers, DataLoader, depth limits         | `references/graphql.md`                       |
| Authentication (JWT/OAuth/API keys), authorization/RBAC,    | `references/api-security.md`                  |
| input validation, rate limiting, OWASP API Top 10           | `references/api-security.md`                  |
| OpenAPI/Swagger spec generation & validation                | `references/api-documentation.md`             |
| API docs, Postman collections, SDK/codegen, onboarding      | `references/api-documentation.md`             |
| Webhooks, event-driven architectures, outbox, saga,         | `references/api-integration.md`               |
| API composition, retries, idempotency                       | `references/api-integration.md`               |
| Payments, subscriptions, refunds, PCI, signatures           | `references/payments.md`                      |
| Safe invalidation, N+1 queries, connection pooling, Neon    | `references/databases.md`                     |
| Redis queue jobs, BullMQ, workers, scheduling, retry/backoff| `references/queues-and-jobs.md`               |
| Microservices boundaries, layering, caching, observability, | `references/architecture.md`                  |
| resilience, deployment                                      | `references/architecture.md`                  |
| Node/Express/NestJS/Hono/tRPC/Zod code                       | `references/nodejs.md`                        |
| FastAPI/Django/DRF/Celery                                   | `references/python.md`                        |
| ASP.NET Core / EF Core / background services                | `references/dotnet.md`                        |
| Laravel / Eloquent / validation / queues                    | `references/laravel.md`                       |
| API behavior testing, fuzzing, bug-hunting                  | `references/api-security.md` (testing section)|

## Best practices that apply everywhere

- **Contract-first.** Define request/response types before implementing handlers.
  The schema or typed interface is the documentation; keep it committed alongside
  the implementation (`references/api-design.md`).
- **Consistent error semantics.** Pick one error shape (status code + machine code +
  human message) and use it on every endpoint. Never leak stack traces to clients.
- **Validate at boundaries.** Validate external input (requests, webhook payloads,
  third-party responses, env vars) at the edge; internal code can trust its types.
- **Auth versus authorization.** Authentication proves identity; authorization
  checks whether *this* user may do *this* thing. Check both, per-request and ideally
  per-field in GraphQL.
- **Idempotency keys** on state-changing operations and **idempotent webhook
  handlers** — providers retry and do not guarantee single delivery.
- **Verify webhook signatures** with the provider SDK or HMAC comparison, using
  timing-safe comparison, and return 2xx fast (before expensive work).
- **Offload heavy work.** Anything slow or long-running belongs in a queue/worker,
  not the request path. Keep job payloads small (pass IDs, not objects).
- **N+1 is the top perf bug.** Batch/prefetch related data (`select_related`,
  `prefetch_related`, ORM eager loading, DataLoader in GraphQL).
- **Observability from day one.** Correlation IDs, structured logs, request/error
  metrics, and distributed traces make production problems findable.
- **Least privilege + HTTPS everywhere.** Secrets via env/config, never in code.

## Do & Don't

Do:
- Do choose the API style for the context (REST when simple CRUD/public/cacheable;
  GraphQL for diverse clients with complex relations; tRPC for shared-repo,
  type-safe TS full-stack).
- Do paginate every list endpoint (offset or cursor) and enforce limits.
- Do design for addition over modification (additive fields, optional params).
- Do make mutations specific (named actions), not generic "update" catch-alls.
- Do plan versioning and deprecation at design time — Hyrum's Law: observable
  behavior becomes an implicit contract.
- Do treat every third-party API response as untrusted data.

Don't:
- Don't put business logic in route handlers — keep controllers thin.
- Don't concatenate raw SQL with user input — parameterized queries or an ORM.
- Don't store passwords in plain text — bcrypt/Argon2 with salt rounds ≥ 10.
- Don't trust client-side confirmation for money flows — rely on server-side
  webhook/API verification.
- Don't skip rate limiting on auth endpoints.
- Don't expose verbose internal errors, stack traces, or schema introspection in
  production.

## Common pitfalls (and the fix)

- **N+1 queries** — a list of 100 rows triggers 101 queries. Fix: eager loading /
  DataLoader / annotate before serializing.
- **Webhook duplicate processing** — providers retry on any non-2xx or timeout.
  Fix: store event IDs, check before processing, reply fast.
- **Unbounded queries** — loading an entire table OOMs the worker. Fix: paginate,
  use `.iterator()`/stream for batch jobs.
- **GraphQL DoS via deep/nested queries** — limit query depth and complexity.
- **Breaking changes without versioning** — add fields, don't remove them; version
  when consumers must change.
- **Async error swallowing** — unhandled promise rejections / silent catch. Wrap
  handlers, capture errors, fail loudly.
- **JWT secret in code or too long-lived** — env var, short access tokens, rotate
  refresh tokens, validate issuer/audience.

## Examples

- **Design a REST API for a resource.** Resource = plural noun. `GET /api/tasks`,
  `POST /api/tasks`, `GET/PATCH/DELETE /api/tasks/:id`, list with
  `?page&pageSize&sortBy` and a paginated envelope. Consistent error body
  `{error:{code,message}}`. See `references/api-design.md`.
- **Secure an endpoint.** JWT bearer auth middleware → verify token (expiry,
  issuer, audience) → attach user → role/permission check → validate body with
  schema → rate limit per user/IP. See `references/api-security.md`.
- **Integrate a webhook receiver.** Verify HMAC/`Stripe-Signature`, parse event,
  check `event_id` dedupe table, process, return 2xx, on failure let provider
  retry. See `references/api-integration.md` and `references/payments.md`.
- **Add a background job.** Queue `sendEmail` with `{ userId }` (not the whole
  object), attempts 3, exponential backoff, graceful shutdown on SIGTERM, monitor
  failed/stalled jobs. See `references/queues-and-jobs.md`.

## Reading order for new backend engineers

1. `references/api-design.md` — fundamentals of good interfaces.
2. `references/architecture.md` — how services are structured.
3. `references/api-security.md` — how to keep it safe.
4. `references/api-integration.md` — how systems talk to each other.
5. Then the language/framework file for your stack (`nodejs.md`, `python.md`,
   `dotnet.md`, or `laravel.md`).