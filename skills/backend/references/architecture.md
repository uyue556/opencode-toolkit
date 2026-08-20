# Server Architecture: Layering, Microservices, Caching, Resilience, Observability

Architecture is about clear boundaries, well-defined contracts, and resilience
built in from the start. Favor simplicity over premature complexity; keep
services stateless so they scale horizontally.

## Layered architecture

```
Routes → Controllers → Services → Repositories → Database
```

- **Routes only route** — zero business logic in route handlers.
- **Controllers coordinate** — parse request, call services, format responses,
  handle errors.
- **Services decide** — business rules, framework-agnostic, DI-injected,
  unit-testable.
- **Repositories persist** — encapsulate queries and transactions, expose
  intent-based methods (`findActiveUsers()`, not `prisma.user.findMany(...)`).
- No layer skipping, no cross-layer leakage.

### Canonical Node/TS directory structure

```
src/
├── config/          # unified config (single source of truth)
├── controllers/     # BaseController + controllers
├── services/        # business logic
├── repositories/    # data access
├── routes/          # route definitions
├── middleware/      # auth, validation, error handling
├── validators/      # Zod/schema definitions
├── types/           # shared types
├── tests/           # unit + integration tests
├── app.ts / server.ts
```

Corollary: `process.env` accessed anywhere is a smell; centralize config.
Async handlers should be wrapped so unhandled rejections surface as errors.

## Microservices

- **Service boundaries** come from the business domain (DDD/bounded contexts),
  not technical convenience.
- **Database per service** — data ownership + eventual consistency. A shared DB
  is an anti-pattern to avoid (or a legacy bridge).
- **Synchronous** calls (REST/gRPC) for request/response; **async** (queues,
  events) for everything that can be decoupled. Prefer async for integration.
- **API Gateway / BFF** for client-specific backends and aggregation.
- **Strangler pattern** to migrate a monolith incrementally.
- **Saga / CQRS** for distributed transactions and read/write separation (see
  `api-integration.md` for saga choreography).

## Resilience patterns

- **Timeouts** on all external calls, with deadline propagation.
- **Retries** with exponential backoff + jitter and a retry budget; only retry
  idempotent-safe operations.
- **Circuit breaker** — after N failures, fail fast for a window, then allow
  probe traffic.
- **Bulkheads** — isolate thread/connection pools so one slow dependency
  doesn't exhaust the process.
- **Graceful degradation** — fallback responses, cached data, feature toggles.
- **Idempotency** — request IDs / idempotency keys on state-changing operations.
- **Health checks** — liveness and readiness probes for orchestrators.
- **Backpressure / load shedding** — drop or queue excess work instead of
  crashing.

## Caching strategies

- Layers: CDN (static, edge) → HTTP (Cache-Control, ETags) → application
  (Redis/in-memory) → query result cache.
- Patterns: cache-aside (read: check cache, miss → load + store; write:
  invalidate), read-through, write-through, write-behind.
- **Invalidation is the hard part**: TTL + event-driven invalidation (publish
  invalidation events) + cache tags.
- Don't cache user-specific data with a global key; namespace per user
  (`cache:user:{id}:posts`).
- Rate-limit/cost-analysis with caching so a cache stampede (thundering herd)
  doesn't hit the DB — use single-flight or short random TTLs.

## Observability

- **Structured logs** with correlation/request IDs propagated across services.
- **Metrics**: RED (Rate, Errors, Duration) for services; HTTP metrics,
  queue depths, error rates.
- **Distributed tracing** (OpenTelemetry/Jaeger/Zipkin) with trace context
  passed in headers.
- Every critical path observable: log security events, monitor failed auth
  attempts, alert on error rate spikes.
- Don't log sensitive data.

## Deployment & operations

- Containerization + CI/CD; blue-green or canary rollouts.
- Secrets in env/config store, never in code or images.
- Database migrations run as a separate, reversible step; avoid destructive
  schema changes mid-deploy.
- Feature flags for gradual rollouts and instant kill-switches.

## Concurrency & performance basics

- Prefer async/non-blocking I/O; never block the event loop with CPU work.
- Connection pooling for DB and HTTP clients; size pools conservatively.
- Compression (gzip/brotli), response size reduction, batch endpoints.
- Horizontal scaling requires stateless services + shared session/cache store.

## When NOT to use microservices

For most applications a well-layered modular monolith is simpler, cheaper, and
easier to operate. Introduce microservices when teams/boundaries/scale genuinely
require independent deployability. Do not introduce microservice architecture
unless requested or clearly justified.

## Sources

- `backend-architect`, `backend-dev-guidelines`, `api-and-interface-design`,
  `api-integration`, `django-pro`, `nestjs-expert`, `backend-development-feature-development`.