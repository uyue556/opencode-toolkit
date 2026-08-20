# n8n Workflows: Patterns, Expressions, Node Config, Validation

Deep guide to building n8n workflows: choosing an architectural pattern, writing expressions correctly,
configuring nodes operation-aware, and validating iteratively. Read `../SKILL.md` first for the shared workflow.

## ToC
- [The 5 core patterns](#the-5-core-patterns)
- [Workflow creation checklist](#workflow-creation-checklist)
- [Expression syntax (`{{ }}`)](#expression-syntax-)
- [Node configuration](#node-configuration)
- [Validation & fixing errors](#validation--fixing-errors)
- [n8n MCP tools](#n8n-mcp-tools)
- [Common gotchas](#common-gotchas)

## The 5 core patterns

About 90% of real workflows are one of these. Pick the pattern before you wire nodes.

| Pattern | Shape | Use when |
|---|---|---|
| **Webhook Processing** (most common) | Webhook → Validate → Transform → Respond/Notify | Receiving data (form submissions, Stripe/GitHub webhooks, Slack commands) |
| **HTTP API Integration** | Trigger → HTTP Request → Transform → Action → Error Handler | Fetching/syncing external REST APIs |
| **Database Operations** | Schedule → Query → Transform → Write → Verify | ETL, DB sync, backup |
| **AI Agent Workflow** | Trigger → AI Agent (model + tools + memory) → Output | Conversational AI, tool access, multi-step reasoning |
| **Scheduled Tasks** | Schedule → Fetch → Process → Deliver → Log | Recurring reports, periodic fetching, maintenance |

Triggers: Webhook (instant), Schedule (cron), Manual (testing), Polling (change detection).
Transforms: Set (field mapping), Code (complex logic), IF/Switch (routing), Merge (combine streams).
Outputs: HTTP Request, database writes, comms (Email/Slack/Discord), storage.
Error handling: Error Trigger, IF on error conditions, Stop and Error, per-node Continue On Fail.

### Data-flow shapes

- **Linear**: `Trigger → Transform → Action → End` (simple, single path)
- **Branching**: `Trigger → IF → [true] / [false]` (conditional routing)
- **Parallel**: `Trigger → [Branch 1] + [Branch 2] → Merge` (independent ops)
- **Loop**: `Trigger → Split in Batches → Process → Loop` (large datasets)
- **Error handler**: `Main Flow → [Success]; ... → Error Trigger → Error Handler` (separate workflow)

### Quick start examples

- Webhook → Slack: `Webhook (path form-submit, POST)` → `Set (map fields)` → `Slack (post #notifications)`
- Scheduled report: `Schedule (daily 9AM)` → `HTTP Request (fetch analytics)` → `Code (aggregate)` → `Email` + `Error Trigger → Slack`
- DB sync: `Schedule (15 min)` → `Postgres (query new)` → `IF (records exist)` → `MySQL (insert)` → `Postgres (update timestamp)`
- API integration: `Manual Trigger` → `HTTP Request (GET)` → `Split in Batches (100)` → `Set` → `Postgres (upsert)` → `Loop`

Use `search_templates` / `get_template` from n8n-mcp to pull real templates instead of starting from scratch.

## Workflow creation checklist

Plan: identify the pattern → list required nodes (`search_nodes`) → map data flow → plan error handling.
Build: create workflow with the right trigger → add sources → configure credentials → transforms → outputs → error handling.
Validate: validate each node, then the whole workflow, test with sample data, handle empty/edge cases.
Deploy: review settings (execution order v1 = connection-based, timeout, error handling) → activate → monitor first executions → document.

## Expression syntax (`{{ }}`)

All dynamic content in n8n uses **double curly braces**: `{{expression}}`.

- `{{$json.field}}` — current node output. Bracket notation for spaces: `{{$json['field name']}}`
- `{{$node["Node Name"].json.field}}` — any previous node. **Node names in quotes, case-sensitive, exact match.**
- `{{$now}}` / `{{$now.toFormat('yyyy-MM-dd')}}` / `{{$now.plus({days: 7})}}` — dates (Luxon)
- `{{$env.API_KEY}}` — environment variables

### The #1 mistake: webhook data is NOT at the root

The Webhook node wraps payloads: `{ headers, params, query, body: { ...user data } }`.

```
❌ {{$json.name}}          ✅ {{$json.body.name}}
❌ {{$json.email}}         ✅ {{$json.body.email}}
```

### When NOT to use expressions

- **Code nodes** use direct JS access (`$json.email`), never `={{...}}`.
- **Webhook paths** must be static strings — no expressions.
- **Credentials** go in the n8n credential system, not expressions or parameters.

### Validation rules

1. Always wrap in `{{ }}` (no braces → literal text).
2. Spaces in field/node names → bracket notation with quotes.
3. Exact, case-sensitive node names.
4. No nested `{{` (double-wrap) and no braces inside Code nodes.

Quick-fix table:

| Mistake | Fix |
|---|---|
| `$json.field` | `{{$json.field}}` |
| `{{$json.field name}}` | `{{$json['field name']}}` |
| `{{$node.HTTP Request}}` | `{{$node["HTTP Request"]}}` |
| `{{$json.name}}` (webhook) | `{{$json.body.name}}` |
| `'={{$json.email}}'` in Code | `$json.email` |

Common error messages: "Cannot read property 'X' of undefined" (bad data path) → check the object actually exists;
"X is not a function" → wrong variable type; expression shows as literal text → missing `{{ }}`.
Test in the expression editor (click "fx") — it gives a live preview and highlights errors in red.

## Node configuration

Configuration is **operation-aware**: the same node type has different required fields per resource+operation,
and fields appear/disappear based on other field values (`displayOptions`).

- `get_node({nodeType: "nodes-base.httpRequest"})` with **standard** detail (the default, ~1-2K tokens) covers 95% of needs.
- Escalate to `mode: "search_properties", propertyQuery: "auth"` to find a specific field, then `detail: "full"` (~3-8K tokens) only when needed.
- Configure minimal → validate → add fields → validate again. Expect 2-3 cycles.

Example dependency chain (HTTP Request): `POST` → `sendBody: true` → `body` becomes required.
Slack: operation `post` needs `channel`+`text`; operation `update` needs `messageId`+`text` (different fields!).
IF node: binary operators (`equals`, `contains`) use `value1`+`value2`; unary (`isEmpty`, `isNotEmpty`) use `singleValue: true`
(auto-added by n8n's auto-sanitization on save).

**Don't over-configure upfront** — start minimal, add optional fields only when needed. Don't copy configs blindly between operations.

## Validation & fixing errors

Validation is iterative, not one-shot: validate → read errors → fix → validate again (usually 2-3 cycles).

### Error levels

- **Errors** (must fix, block execution): `missing_required`, `invalid_value`, `type_mismatch`, `invalid_reference`, `invalid_expression`
- **Warnings** (should fix): `best_practice`, `deprecated`, `performance` — e.g. "Slack API can have rate limits" → suggestion: `retryOnFail`
- **Suggestions** (optional): `optimization`, `alternative`

### Validation profiles

- `minimal` — required fields only (fast, permissive)
- `runtime` — values + types + allowed values (recommended for pre-deployment)
- `ai-friendly` — like runtime but fewer false positives (for AI-generated config)
- `strict` — everything incl. best practices/performance/security (production; noisy)

### Common fixes

- `missing_required` → `get_node` to see required fields, add them.
- `invalid_value` → error message lists allowed values; update.
- `type_mismatch` → convert type (`config.limit = 100` not `"100"`).
- `invalid_expression` → add `{{ }}`, check references (see expression section).
- `invalid_reference` → typo'd node name; fix spelling.

### Auto-sanitization

On ANY workflow save, n8n auto-fixes operator structures: removes `singleValue` on binary ops, adds
`singleValue: true` on unary ops, adds IF/Switch metadata. It cannot fix broken connections (use
`cleanStaleConnections`), branch-count mismatches, or corrupt states.

### Workflow-level errors

- Broken connection: "target node not found" → remove stale connection or create the node.
- Circular dependency: `A → B → A` → restructure to remove the loop.
- Multiple triggers → only one executes → split into separate workflows.
- Disconnected node → connect it or remove it.

### Recovery strategies

1. **Start fresh** when severely broken: build minimal valid config, add features incrementally.
2. **Binary search** when it validates but misbehaves: remove half the nodes, test, narrow down.
3. **Clean stale connections**: `n8n_update_partial_workflow({operations:[{type:"cleanStaleConnections"}]})`.
4. **Auto-fix preview first**: `n8n_autofix_workflow({applyFixes:false})` then apply.

**False positives are real** — "missing error handling", "no retry", "missing rate limiting", "unbounded query"
warnings are acceptable in dev/low-risk workflows. Use the `ai-friendly` profile when noise is a problem.

## n8n MCP tools

### nodeType formats — two different prefixes

- **Search/validate tools** (`search_nodes`, `get_node`, `validate_node`, `validate_workflow`): short prefix `nodes-base.slack`, `nodes-langchain.agent`
- **Workflow tools** (`n8n_create_workflow`, `n8n_update_partial_workflow`): full prefix `n8n-nodes-base.slack`, `@n8n/n8n-nodes-langchain.agent`

`search_nodes` returns both (`nodeType` + `workflowNodeType`).

### Tool selection

| Tool | Use when |
|---|---|
| `search_nodes` | Finding nodes by keyword (<20ms) |
| `get_node` | Understanding node operations (`detail:"standard"` default) |
| `validate_node` | Checking a node config (`profile:"runtime"`) |
| `n8n_update_partial_workflow` | Editing workflows — the most-used tool; build **iteratively**, one operation at a time |
| `validate_workflow` / `n8n_validate_workflow` | Checking the whole workflow |
| `n8n_deploy_template` | Deploying a template (auto-fix + auto-upgrade on by default) |
| `n8n_test_workflow` / `n8n_executions` | Testing and inspecting runs |

### Smart parameters & intent

- Use semantic branch names instead of numeric indices: `addConnection {source:"IF", target, branch:"true"}`; Switch uses `case: N`.
- Include `intent` on `n8n_update_partial_workflow` ("Add error handling for API failures") — the tool uses it to give better responses.
- Use `get_node({mode:"docs"})` for readable docs; `get_node({mode:"versions"})` to check breaking changes.

### Availability

`search_nodes`, `get_node`, `validate_node`, `validate_workflow`, `search_templates`, `get_template`,
`tools_documentation`, `ai_agents_guide` work without an n8n API. Create/update/list/validate-by-ID/test/
executions/deploy/autofix require `N8N_API_URL` + `N8N_API_KEY`.

## Common gotchas

1. **Webhook payload nesting** — data under `$json.body` (`{{$json.body.email}}`).
2. **Multiple input items** — a node processes all items; use `{{$json[0].field}}` or "Execute Once" for the first only.
3. **Auth 401/403** — configure credentials in the Credentials section (not parameters), test before activation.
4. **Execution order** — use connection-based (v1), not legacy top-to-bottom.
5. **Expressions showing as literal text** — missing `{{ }}`.
6. **Wrong nodeType prefix** in MCP calls — `nodes-base.*` for search/validate, `n8n-nodes-base.*` for workflows.
7. **`detail:"full"` by default** — wasteful; standard covers 95%.
