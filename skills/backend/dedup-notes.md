# Dedup Notes — backend consolidation

Consolidated 79 source skills (backend=39, framework=13, fullstack=1,
api-integration=26) into one `backend` skill with 13 references.

## What was merged (notable duplicates)

| Source skills (duplicates)          | Where merged |
| ----------------------------------- | ------------ |
| api-design-principles, api-patterns, api-designer, api-and-interface-design, api-analyzer, api-design-checklist asset | `references/api-design.md` (REST design, status codes, versioning, pagination, contract-first) |
| graphql, api-patterns (graphql), backend-architect (GraphQL) | `references/graphql.md` |
| api-security-best-practices, backend-security-coder, api-fuzzing-bug-bounty, api-patterns (auth/rate-limit) | `references/api-security.md` |
| openapi-spec-generator, api-integration/openapi-spec-generation, api-documentation-generator, api-documenter, postman-collection-generator, api-sdk-generator, api-onboarding | `references/api-documentation.md` |
| api-integration (event-driven), payment-integration, stripe-integration, paypal-integration, plus webhook/outbox/saga from backend-architect | `references/api-integration.md` + `references/payments.md` |
| backend-architect, backend-dev-guidelines, api-and-interface-design (interfaces), backend-development-feature-development | `references/architecture.md` |
| neon-postgres, neon-functions, django-perf-review, django-pro (ORM), backend-dev-guidelines (repositories), dotnet-backend (EF Core) | `references/databases.md` |
| bullmq-specialist, django-pro (Celery), dotnet-backend (BackgroundService), laravel-expert (queues) | `references/queues-and-jobs.md` |
| nodejs-backend-patterns, backend-dev-guidelines, nestjs-expert, hono, trpc-fullstack, zod-validation-expert, cloudflare-workers-expert, typescript-expert | `references/nodejs.md` |
| fastapi-pro, fastapi-router-py, django-pro, django-perf-review, django-access-review | `references/python.md` |
| dotnet-backend, dotnet-backend-patterns | `references/dotnet.md` |
| laravel-expert | `references/laravel.md` |
| twilio-communications, whatsapp-cloud-api, slack-bot-builder, telegram-bot-builder, algolia-search, hubspot-integration, plaid-fintech, salesforce-development, moodle-external-api-development, shopify-development, shopify-apps, api-integration (auth/token) | `references/api-integration.md` (general patterns: OAuth for user-scoped APIs, API key rotation, webhook signatures, sandbox/live separation, rate-limit backoff) |

## Notable drops (and why)

- **2slides-ppt-generator, riffkit, youtube-full, unsplash-integration** —
  marketing/media API helpers, not backend engineering.
- **discord-automation, microsoft-teams-automation, postmark-automation,
  salesforce-automation, square-automation, telegram-automation,
  whatsapp-automation** — Composio/Rube MCP tool-automation recipes, not
  backend design; vendor-specific and tool-coupling-bound.
- **copilot-sdk** — SDK for driving the Copilot CLI via JSON-RPC; niche
  tooling, not backend.
- **comfyui-gateway** — specific OSS project gateway; dropped the project-
  specific config (queue/webhook/auth concepts already covered).
- **x402-express-wrapper** — Spanish-language MCP payment-wall wrapper for a
  specific provider; payment concepts covered generically in payments.md.
- **junta-leiloeiros** — Portuguese-language Brazil-specific scraping tool;
  not general backend.
- **pubmed-database, uniprot-database** — domain-specific REST data APIs for
  bio/database research; not general backend.
- **cohesivity** — a specific BaaS provisioning tool (cohesivity.ai); too
  vendor-specific; infra provisioning covered by architecture.md deployment
  section.
- **appdeploy** — MCP tool-specific deploy helper; deployment concepts covered.
- **shadcn, nextjs-app-router-patterns, tanstack-query-expert** — frontend /
  fullstack UI frameworks; out of backend scope. (tRPC/auth/DX essence kept in
  nodejs.md.)
- **vibe-code-cleanup** — fullstack frontend cleanup; kept only the general
  "audit env vars, fix imports, verify before deleting" discipline implicitly;
  frontend-focused so dropped from backend.
- **api-testing-observability-api-mock** — thin (~54 lines) API-mock guidance;
  folded conceptually into api-documentation.md (sandbox/mock) rather than a
  full reference.

## Scripts

No `scripts/` directories existed in any of the 79 source libraries (only
small `.env.example`/JSON boilerplate assets, too vendor-specific to carry).
The `api-patterns` skill referenced `scripts/api_validator.py` but the file was
not present in the source tree. `references/databases.md` documents the
`npx -y neon@latest init` CLI flow instead. No scripts carried over.

## Gaps / doubts

- Could not deep-read all 79 files; ~24 were read fully, the rest skimmed via
  frontmatter + headings. Per-subtopic signal was captured.
- Go and Ruby/Rails had no dedicated source skill (only mentioned inside
  `backend-architect`), so no framework reference was written for them; their
  essentials are implied by architecture.md.
- Deep vendor skills (twilio-communications 1586 lines, shopify-apps 1507,
  slack-bot-builder 1407, salesforce-development 950) were sampled, not fully
  read; the general integration patterns were extracted. If a user needs
  exhaustive vendor docs, fetch the provider's official docs directly.
