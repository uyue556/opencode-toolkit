# Node.js Backend: Express, NestJS, Hono, tRPC

Node is the default backend stack in this skill set. Framework choice:

| Framework | Best for |
| --------- | -------- |
| Express   | Simple, familiar, huge ecosystem; keep it layered |
| NestJS    | Enterprise, DI/modules, opinionated structure |
| Fastify   | High-throughput, schema-based validation |
| Hono      | Edge/serverless (Cloudflare Workers, Deno, Bun), tiny footprint |
| tRPC      | Type-safe full-stack TS in a shared repo |

## Layered Express/TS structure

`Routes → Controllers → Services → Repositories → DB`. Rules:
- Routes contain zero business logic — delegate to controllers/services.
- Controllers extend a `BaseController` with `handleSuccess`/`handleError`.
- Services receive dependencies via constructor (DI) so they're unit-testable.
- Repositories encapsulate Prisma/TypeORM queries; never use the ORM client
  directly in controllers.
- Central config (unifiedConfig) instead of scattered `process.env`.
- Validate all external input with Zod at the boundary.
- Wrap async handlers so unhandled rejections don't crash the process.
- Observability: Sentry (or equivalent) captureException on every error; no
  silent failures, no `console.log` for real errors.

## Zod validation

```typescript
import { z } from 'zod';

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8).regex(/[A-Z]/),
});
const result = schema.safeParse(req.body);  // prefer safeParse over parse
if (!result.success) return res.status(422).json(result.error.flatten());
```

- Infer types with `z.infer<typeof schema>` — no duplicate interfaces.
- Use `z.coerce` for FormData/query strings; `.refine`/`.superRefine` for
  cross-field rules (set `path` so errors attach to the right field).
- Validate environment variables with Zod and fail fast.
- Prefer `safeParse` to avoid scattered try/catch.

## JWT auth (Express)

- `authenticateToken` middleware: read `Authorization: Bearer`, verify with
  `jwt.verify` (check expiry, issuer, audience), attach `req.user`.
- Short-lived access tokens (~1h) + refresh tokens stored in DB (revocable).
- Hash passwords with bcrypt (salt rounds ≥ 10); never store plain text.
- Don't reveal whether a user exists on failed login (uniform 401).

## Rate limiting (Express)

- `express-rate-limit` + Redis store for distributed limiting.
- Stricter limiters on `/auth/login` and `/auth/register`; skip counting
  successful logins.
- Tiered limits by user plan; return `X-RateLimit-*` headers and `Retry-After`.

## NestJS patterns

- Modules: feature modules with `controllers`, `providers`, `exports` — export
  the SERVICE, not the module.
- Request lifecycle order: Middleware → Guards → Interceptors (before) → Pipes
  → Route handler → Interceptors (after).
- Guards for auth/roles; Pipes for DTO validation (class-validator); Interceptors
  for transforms/logging; Exception filters for error shaping.
- DI errors ("can't resolve dependencies of X"): check provider is in `providers`
  array, exported if crossing boundaries, decorated with `@Injectable()`, and
  constructor-parameter order matches.
- Circular dependencies: use `forwardRef()` on BOTH sides, or better, extract
  shared logic to a third module.
- ORM choice: Prisma (type safety) vs TypeORM (relations/legacy) vs Mongoose
  (Mongo). `@Column()` not `@Column('description')` — misleading TypeORM errors
  are often entity syntax.
- Testing: `Test.createTestingModule` with mocked providers; `getRepositoryToken`
  for repositories; JwtService mocked; typecheck → unit → e2e.

## Hono (edge) quick facts

- Web-standards based; runs on Workers/Deno/Bun/Node with the same code.
- Middleware: `logger`, `cors`, `csrf`, `bearerAuth`, `jwt`, `compress`,
  `bodyLimit`, `timeout`, `secureHeaders` built in.
- Validate with `zValidator('json', schema)` → `c.req.valid('json')` typed.
- RPC client `hc()` gives end-to-end type safety (like tRPC) for shared repos.
- Don't use Node-specific APIs (`fs`, `path`, `process`) if you want portability;
  type Worker bindings with a `Bindings` generic.
- Always `return c.json(...)` — a missing return yields an empty response.

## tRPC essentials

- Routers + procedures (`query`/`mutation`/`subscription`); inputs validated by
  Zod; `context` built per request (App Router and Pages Router need separate
  context factories).
- `enforceAuth` middleware throwing `TRPCError({ code: 'UNAUTHORIZED' })`;
  compose protected procedures.
- Client: `@tanstack/react-query` integration; mutations invalidate cached
  queries; server-side callers for SSR/RSC.

## Cloudflare Workers

- Fetch API (not Node globals); bindings via `wrangler.toml`, accessed through
  `env` in the `fetch` handler.
- KV for simple cache/key-value; D1 (SQLite) for relational; Durable Objects for
  stateful coordination.
- `ctx.waitUntil()` for post-response async work; keep bundles small (free tier
  ~1MB); use `wrangler tail` for live logs.

## Sources

- `nodejs-backend-patterns`, `backend-dev-guidelines`, `nestjs-expert`,
  `hono`, `trpc-fullstack`, `zod-validation-expert`, `cloudflare-workers-expert`,
  `typescript-expert`, `api-security-best-practices` (JS examples).