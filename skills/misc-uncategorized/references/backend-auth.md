# Backend, Auth & Frontend Architecture

Consolidates: supabase, supabase-automation, nextjs-supabase-auth, clerk-auth,
claimable-postgres, neon-object-storage, redis-cli, graphql-schema, formik-patterns,
frontend-data-contracts, frontend-observability, frontend-optimistic-mutations, use-dom,
telegram-mini-app, vercel-deployment, vercel-cli-with-tokens, vercel-automation, vercel-optimize,
new-rails-project, bevy-ecs-expert, swift-concurrency-expert, shader-programming-glsl,
posix-shell-pro, powershell-windows, windows-shell-reliability, composition-patterns,
newman/postman (see testing).

## 0. General Rules for Fast-Moving Backend Tools

Supabase, Clerk, Vercel, and others change frequently — **verify against official changelog +
docs before implementing**, don't rely on training data. Always verify your fix with a test query;
recover from errors instead of looping after 2-3 failed attempts.

## 1. Supabase

Core principles: check `https://supabase.com/changelog.md` for breaking changes; verify work;
recover don't loop; newly created tables may not be auto-exposed to the Data API (grant
`anon`/`authenticated` via explicit `GRANT`); **enable RLS on every table in exposed schemas**;
security checklist: never use `user_metadata` claims for authz (user-editable — use
`raw_app_meta_data`/`app_metadata`), RLS policies should match the actual access model, storage/
view/auth traps. Use the Supabase CLI and MCP server for schema management; consult official
docs for the task at hand.

**Supabase Automation (Rube MCP)**: query/manage tables, projects/orgs, schema inspection, edge
functions, storage buckets. Patterns: ID resolution, pagination, SQL best practices. Pitfalls:
ID formats, SQL execution scope, sensitive data handling.

## 2. Next.js + Supabase Auth

- Browser client: `createBrowserClient(url, anonKey)` from `@supabase/ssr`.
- Server client: `createServerClient(url, anonKey, { cookies: { getAll, setAll } })` with
  `await cookies()`.
- Auth middleware: refresh sessions + protect routes in `middleware.ts`.
- Auth callback route: exchange code for session.
- Server Actions + Server Components: get user via the server client.
Validation checks: don't use `getSession()` for auth checks, OAuth needs a callback route, no
browser client in server context, protected routes need middleware, hardcoded redirect URL is a
bug, auth calls need error handling, auth actions need revalidation, client-only route protection
is insufficient.

## 3. Clerk Auth (Next.js)

- Setup: `ClerkProvider` in root layout; env vars `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY`,
  `CLERK_SECRET_KEY`, sign-in/sign-up URL and after-sign-in/up URLs. Use `<SignIn/> <SignUp/>
  <UserButton/> <SignedIn/> <SignedOut/>`.
- Middleware: single `middleware.ts` at root with `clerkMiddleware` + `createRouteMatcher`;
  `auth.protect()`; role/permission protection (`auth.protect({role:'org:admin'})`). Never use
  multiple middleware files (redirect loops); centralize redirects in middleware.
- Server components: `await auth()` (userId/sessionId/orgId/claims) and `currentUser()` (full
  user, counts toward rate limits — prefer `auth()` for checks).
- Client hooks: `useUser/useAuth/useSession/useOrganization`; **always check `isLoaded`**; hooks
  only in client components.
- Organizations/multi-tenancy: org-scoped data MUST filter by `orgId` from `auth()`; use role
  constants not hardcoded strings; `<Protect role="org:admin">`.
- Webhook user sync: verify with **svix** signature (never skip), handle `user.created/updated/
  deleted` with upsert (race conditions), exclude `/api/webhooks` from middleware protection.
- API route protection: `auth()` in the handler (middleware can be bypassed — CVE-2025-29927), org
  scoping for multi-tenant, role checks for admin.
Sharp edges: 4KB session-token cookie limit; `auth()` is async in App Router; middleware blocks
webhook endpoints; never expose `CLERK_SECRET_KEY` to client (no `NEXT_PUBLIC_`).

## 4. Claimable Postgres (Neon)

Instant temporary Postgres DBs via `neon.new` with no login/signup. REST API: create a database
(GET/POST to the endpoint), check status, error responses. CLI + SDK + Vite plugin. Agent
workflow: use API path or CLI path, verify with an output checklist.

## 5. Neon Object Storage

S3-compatible object storage that branches with your Neon project. Setup env vars; prefer the
Files SDK (`neon.ts` files SDK) over raw AWS S3 client; infrastructure-as-code via `neon.ts`;
works with branching (files + DB stay in sync).

## 6. redis-cli

Reference + usage: connection (default 127.0.0.1:6379, `REDISCLI_AUTH` env for password — never
on the command line), URI connection, common commands. Install: Homebrew/apt/yum/Alpine, build
from source, or Docker.

## 7. GraphQL Schema Patterns

Core rules: colocate `.gql` files with components; run codegen to generate typed hooks; queries
return data, mutations require REQUIRED error handling. Fetch policies and options. Mutation UI
requirements (pending/error/refetch states).

## 8. Formik Patterns

Basic form setup, Yup validation schemas, conditional validation, field helpers (Input/Select),
submission with GraphQL, edit forms via `initialValues` + `enableReinitialize`, multi-step forms
(session persistence), anti-patterns (over-splitting, not using `validationSchema`, mutating
values directly).

## 9. Frontend Architecture Family (stareezy-1)

Three portable, framework-agnostic disciplines for React/React Native:
- **frontend-data-contracts**: typed network boundary — one client is the only fetch boundary;
  **parse, don't validate** (boundary transform); one response envelope; branded (nominal)
  identifiers; one normalized error type; per-field errors → form fields; library adapters;
  conventions checklist.
- **frontend-observability**: typed event taxonomy (canonical `ANALYTICS_EVENTS` constants +
  union type, never inline strings); best-effort non-blocking provider fan-out (each adapter in
  its own try/catch, window-guarded, SSR-safe); single `track()` entry via `useAnalytics()` hook
  that no-ops outside a provider; field Core Web Vitals (LCP≤2500, INP≤200, CLS≤0.1) through the
  same fan-out; **consent gates everything** (checked once at the boundary); error reporting at
  route/segment boundaries, PII-scrubbed. Firebase adapter covers web + RN with one shape.
- **frontend-optimistic-mutations**: when to be optimistic (and when not — never for money-moving
  writes); TanStack Query optimistic lifecycle; non-optimistic writes with server-owned fields;
  cache coherence (lock-step detail + lists); idempotency for safe retries; retry policy;
  library adapters.

## 10. Expo DOM Components (use-dom)

`'use dom';` directive lets web code run verbatim in a webview on native + render as-is on web.
Use for web-only libraries (charts, syntax highlighters), migrating web code, complex CSS, iframes,
Canvas/WebGL. Don't use when native performance is critical or for simple UI. Rules, the `dom`
prop, exposing native actions, Expo Router integration, detecting DOM env, assets, platform
behavior.

## 11. Telegram Mini Apps

Setup: include `telegram-web-app.js`, call `tg.ready()` + `tg.expand()`, `tg.initDataUnsafe.user`.
TON Connect: `@tonconnect/ui-react`, `TonConnectUIProvider` + manifest URL; send transaction with
`validUntil` + messages (amount in nanoton `amount * 1e9`).
**Security: validate initData server-side** (HMAC-SHA256 of sorted `k=v` lines with `WebAppData`
+ bot token) — never trust client data.
UX: MainButton (native submit), BackButton, theme via `tg.themeParams` CSS vars, haptic
feedback. Monetization: TON payments, Telegram Stars (currency `XTR`, empty provider_token),
referral links (`t.me/your_bot?start=ref_<id>`), gamification.
Performance: bundle <200KB gzipped, code splitting, lazy routes; Vite manualChunks. TON mobile
issues: HTTPS required, handle connection states, test real devices + multiple wallets + iOS/Android.

## 12. Vercel Deployment

Env vars: three environments (dev/preview/production); `NEXT_PUBLIC_` inlines into the browser
bundle — NEVER use it for secrets (service role keys, DB URLs, JWT secrets, Stripe secret).
Edge vs Serverless: edge = fast cold starts, limited APIs (auth checks, redirects, transforms);
nodejs = full Node APIs (DB queries, heavy compute). Preview deployments must use a separate
staging DB (branching DBs from Neon/PlanetScale/Supabase). Serverless function 50MB limit → dynamic
imports for heavy libs (sharp, puppeteer), split into start/status functions. Edge runtime missing
Node APIs (fs, path, child_process). Function timeouts → move long work to queues. CORS for API
routes; stale data after deploy → revalidation config. Validation checks: secrets in
`NEXT_PUBLIC_`, hardcoded URLs, Node API in edge runtime, API routes without CORS/error handling,
large imports, dynamic pages without revalidation.

**Vercel CLI with tokens**: locate `VERCEL_TOKEN` (env, .env, or ask — never echo to shell
history); locate project/team; `vercel link`; deploy with `--token`; prefer `VERCEL_TOKEN` env.

**Vercel Automation (Rube MCP)**: deployments, env vars, domains/DNS, projects, teams; ID
resolution + pagination patterns.

**Vercel Optimize**: audit deployed apps for cost/performance using metrics, project config, code
scans, version-aware rules; pipeline collects/merges signals → gate candidates → deep-dive +
reconcile → briefs → verify → render report. Stop on blockers; ask about audit scope when needed.

## 13. New Rails Project

Stack guidance: database (default to something sensible for the task), background jobs, testing,
code maintenance, frontend, general guidance; verify with `rails` conventions. Minimal opinionated
scaffold.

## 14. Bevy ECS (Rust)

Components: `#[derive(Component, Reflect, Default)]`; systems as functions with query params;
resources `#[derive(Resource)]`; scheduling with `add_systems`/`add_plugins`. Examples: spawning
entities with `#[require(...)]`, query filters (With/Without/Changed/Or).

## 15. Swift Concurrency

Review/fix actor isolation and Sendable violations: triage the issue → apply the smallest safe
fix → verify. Common fixes: `@MainActor`, `Sendable` conformances, `nonisolated`, avoiding
captured mutable state across `async`.

## 16. GLSL Shaders

Structure: vertex (positions, varyings) + fragment (per-pixel color); uniforms/varyings;
swizzling & vector math; example: raymarching SDF sphere. Best practices: minimize branching,
use precision qualifiers, watch for precision issues on mobile.

## 17. Shell Scripting

- **posix-shell-pro**: strict POSIX sh for portability — avoid bashisms, no arrays (use
  `set --` or `IFS` tricks), portable conditionals, `$()` over backticks, quoting discipline,
  CI/CD integration, migration from bash. Quality checklist.
- **powershell-windows**: operator syntax (parentheses required), NO Unicode/emoji in scripts
  (encoding issues), always null-check before access, complex string interpolation, error
  handling with `ErrorActionPreference` + try/catch, Windows path rules, array ops, JSON with
  explicit `-Depth`.
- **windows-shell-reliability**: encoding & redirection (differences across PowerShell versions),
  paths & spaces (quoting, `&` call operator), binary/cmdlet pitfalls, dotnet CLI reliability,
  env vars, long paths, troubleshooting shell errors.

## 18. React Composition Patterns

Rule categories by priority: (1) component architecture (HIGH — composition over inheritance,
compound components, prop patterns), (2) state management (MEDIUM — colocate state, controlled vs
uncontrolled), (3) implementation patterns (MEDIUM), (4) React 19 APIs (MEDIUM — actions, use,
etc.). Details in the full compiled reference.
