# Runtime & Language Best Practices (Node.js as the worked example)

Source: `nodejs-best-practices`. This file teaches *decision-making*, not copy-paste code.
Principles here generalize to any stack; Node.js is the concrete worked example.

## 1. Framework selection (2025 decision tree)

```
Edge/Serverless (Cloudflare, Vercel)      → Hono (zero-dep, fastest cold starts)
High-performance API                       → Fastify (2–3× Express)
Enterprise / team familiarity / structure  → NestJS (DI, decorators, modules)
Legacy / max ecosystem                     → Express
Full-stack with frontend                   → Next.js API Routes or tRPC
```

Selection questions: deployment target? cold-start critical? team experience? legacy to maintain?

## 2. Runtime & module system

- Node.js 22+: `--experimental-strip-types` runs `.ts` directly (no build step for simple
  projects/scripts).
- New projects → **ESM** (import/export, tree-shaking, async loading). Existing codebases →
  CommonJS.
- Runtimes: Node (largest ecosystem), Bun (performance + built-in bundler), Deno
  (security-first + built-in TS). Choose on requirements.

## 3. Layered architecture (see architecture-patterns.md)

Controller/Route → Service (business logic, framework-agnostic) → Repository (data access).
Simplify when: small scripts (single file), prototypes (less structure), and always ask "will this
grow?".

## 4. Error handling

- Centralized: custom error classes thrown from any layer; caught at top level (middleware);
  consistent response format.
- Client gets: appropriate HTTP status + error code + user-friendly message. **No internal
  details.**
- Logs get: full stack trace, request context, user ID (if applicable), timestamp.
- Status codes: 400 bad input · 401 missing/invalid credentials · 403 valid auth but not allowed ·
  404 not found · 409 conflict/duplicate · 422 schema-valid-but-business-fails · 500 our fault.

## 5. Async patterns & event loop

- `async/await` — sequential async ops. `Promise.all` — parallel independent. `Promise.allSettled`
  — parallel with possible failures. `Promise.race` — timeout / first response.
- Async helps I/O-bound (DB, HTTP, FS, network). **Async doesn't help CPU-bound** (crypto, image
  processing, heavy math) → worker threads or offload.
- Never use sync methods in production (`fs.readFileSync`); stream large data.

## 6. Validation

- Validate at boundaries: API entry, before DB ops, external data, env vars at startup.
- Fail fast, be specific, don't trust even "internal" data.
- Libraries: Zod (TS-first, inference), Valibot (tree-shakeable), ArkType (performance), Yup
  (React Form integration).

## 7. Security checklist (not code)

- Input validation everywhere; parameterized queries (no string-concat SQL); bcrypt/argon2 for
  passwords; JWT signature + expiry always verified; rate limiting; security headers; HTTPS in
  production; CORS properly configured; secrets only via env vars; dependencies audited regularly.
- Trust nothing: query params, body, headers, cookies, uploads, external API responses — all
  validated/verified.

## 8. Testing strategy

- Unit (business logic): `node:test`/Vitest. Integration (API): Supertest. E2E (full flows):
  Playwright.
- Test priorities: critical paths (auth, payments, core business) → edge cases (empty inputs,
  boundaries) → error handling. Skip framework code and trivial getters.
- Node 22+: built-in test runner `node --test src/**/*.test.ts` with coverage and watch mode.

## 9. Do / Don't

Don't: default to Express for edge projects; use sync methods in prod; put business logic in
controllers; skip input validation; hardcode secrets; trust external data; block the event loop
with CPU work. Do: choose framework by context; ask user preferences; layered architecture for
growing projects; validate all inputs; env vars for secrets; profile before optimizing.

## 10. Decision checklist (before implementing)

- Asked user about stack preference?
- Chosen framework for THIS context (not default)?
- Considered deployment target?
- Planned error-handling strategy?
- Identified validation points?
- Considered security requirements?

## Generalization

Whatever the language, apply the same meta-rules: choose the tool by the workload profile, keep a
layered structure proportional to expected growth, centralize errors, validate at boundaries, keep
secrets out of code, trust nothing, and let the test pyramid follow the critical paths.