# TypeScript & project tooling

Merged from `app-builder/javascript-typescript-typescript-scaffold`, `web-development/senior-frontend`
(build/architecture), `frontend/frontend-api-integration-patterns`, and the TypeScript
rules from the React/Next refs.

## Project scaffolding (pnpm monorepo default)

```bash
pnpm create vite my-app --template react-ts
# or: pnpm create next-app@latest --typescript --app --tailwind --eslint
```

Recommended layout for a Next.js app:

```
app/                 # routes (App Router)
  (marketing)/       # route groups
  (auth)/
  api/               # route handlers
  globals.css
components/
  ui/                # primitive, presentational components (design-system)
  feature-x/         # feature-specific components
lib/                 # framework helpers: utils, api client, constants
hooks/               # shared hooks
features/            # (alt: co-locate feature dirs, see architecture.md)
public/              # static assets (fonts, images, manifest)
```

Set up: ESLint + Prettier (format on save), strict TS, `.env.example` for env vars,
`.gitignore` for `.env*`, GitHub Actions CI for lint+typecheck+test. For monorepos use
pnpm workspaces + Turborepo; centralize versions in a root `package.json`.

## TypeScript discipline

- `"strict": true` always; `"noUncheckedIndexedAccess": true` on new codebases.
- No `any`. Prefer `unknown` + narrowing; use `satisfies` for literal preservation.
- Prefer `interface` for object contracts/extensions, `type` for unions/aliases.
- `import type` for type-only imports (enforces `verbatimModuleSyntax`/`isolatedModules`).
- Explicit return types on exported functions and components.
- Discriminated unions for state machines / async results:
  ```ts
  type Async<T> = { status: "idle" } | { status: "loading" } | { status: "success"; data: T } | { status: "error"; error: Error };
  ```
- Zod for runtime validation of external data (API responses, env vars, form inputs).
- Never re-invent types: derive from source of truth (`typeof`, `ReturnType`, generics).
- Env vars: read once through a typed module (`zod`-validated) with required/optional
  distinction — never sprinkle `process.env.X` across the codebase.

## Build & bundling

- Vite (dev speed + ESM), Next.js (App Router), or framework defaults for Angular/Svelte/Astro.
- Tree-shake: direct imports, no barrel-index churn in hot paths (`react.md`).
- Analyze bundles: `@next/bundle-analyzer`, `rollup-plugin-visualizer`,
  `source-map-explorer`. Act on the top offenders (see `performance.md`).
- Keep runtime dependencies lean; move rarely-used deps to lazy-loaded chunks.
- Type declarations: publish `.d.ts` with compiled JS for libraries; exports map
  (`main` + `types` + `exports`).

## Process rules

- Types before implementation for non-trivial features (design the data contract first).
- Shared type for API payloads lives next to the client, validated by Zod, consumed by
  components — single source of truth.
- Version everything; lockfiles committed; no `node_modules`/`.env` in git.

## Common pitfalls

| Pitfall | Fix |
|---|---|
| `any` creeping in | `noImplicitAny`, lint rule `@typescript-eslint/no-explicit-any` |
| Runtime crashes from bad API data | Zod at the boundary |
| Importing types as values (bloat) | `import type` + `verbatimModuleSyntax` |
| Environment misuse | Typed env module, validated once |
| Diverging lockfiles in monorepo | pnpm workspace + root install script |
