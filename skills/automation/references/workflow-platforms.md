# Workflow Platforms: Zapier, Make, n8n

Pick the platform, then apply proven workflow patterns and watch the sharp edges.

## Platform selection

| Platform | When | Pricing model | Notes |
|---|---|---|---|
| **Zapier** | Simple automations, maximum app coverage (7000+), beginners | Task-based (every loop iteration = 1 task) | Linear Zaps; AI features: Zapier Agents/Copilot/MCP (30k+ actions) |
| **Make** (Integromat) | Complex workflows, visual branching, budget-conscious | Operation-based (each module execution = 1 op, incl. retries) | Visual router, powerful data functions, iterator/aggregator |
| **n8n** | Self-hosted, code-friendly, unlimited ops, technical users | Self-hosted / free ops | Can embed custom JS/Python; see the n8n references |

Key insight: no-code works until it doesn't. Know the limits, and graduate to code when you hit branching complexity, custom logic, or high volume.

## Core patterns

### 1. Trigger-Action (basic)
`[Trigger] → [Action]` — notifications, data sync. Use descriptive Zap/Scenario names, filters to prevent unwanted runs, real sample data for tests.

### 2. Multi-step sequential
`[Trigger] → [Action1] → [Action2] → ...` — each step's output feeds the next. In Make reference a module's output with `{{N.field}}` (N = module number). Add error handlers between critical steps.

### 3. Conditional branching
Zapier: **Paths** (Pro+); Make: **Router**. Always include a fallback/else path; test each path independently; document which condition triggers which path.

### 4. Data transformation
Zapier **Formatter** (text split/capitalize/replace, date formats, currency, lookup tables). Make functions:
- Text: `{{lower(1.email)}}`, `{{substring(1.name; 0; 10)}}`, `{{replace(1.text; "-"; "")}}`
- Arrays: `{{first(1.items)}}`, `{{length(1.items)}}`, `{{map(1.items; "id")}}`
- Dates: `{{formatDate(1.date; "YYYY-MM-DD")}}`, `{{addDays(now; 7)}}`
- Math: `{{round(1.price * 0.8; 2)}}`

Transform early; filter invalid data before processing.

### 5. Error handling
- Zapier retries automatically with exponential backoff; add a dedicated error step (Slack alert / email report) and path-based handling.
- Make has visual error handlers: **Break** (stop+notify), **Rollback** (undo), **Commit** (save partial, continue), **Ignore** (skip, continue).
- Always handle external APIs; log errors to a table/spreadsheet; test failure scenarios.

### 6. Batch processing
- Zapier loops: each iteration counts as a task (10 items = 10 tasks).
- Make: `Iterator` (one bundle per item) → actions → `Aggregator` (combine). Use Array Aggregator to collect results.
- Watch batch limits (~100 for many APIs), add delays for rate-limited APIs.

### 7. Scheduled automation
Explicit timezone; add buffer for long jobs; log execution times; avoid exactly midnight.

## Sharp edges (field-tested failures)

### Text instead of IDs in dropdowns — CRITICAL
Dropdowns display labels but send **IDs**. Typing "Marketing Team" sends text as the ID → "Bad Request".
**Fix:** always select from the dropdown; for dynamic values, add a Search/Find action first (e.g. Find Contact → contact_id), then feed the ID onward. Common trip-ups: user/member IDs (Slack, Teams), contact/company IDs (CRMs), project/folder IDs, category/tag IDs.

### Zap auto-disabled at 95% error rate — CRITICAL
Zapier auto-disables Zaps with ≥95% error rate over 7 days.
**Prevent:** error-handling steps, filters to block bad data, monitor task history. **Recover:** check Task History, fix root cause (auth/bad data/API change), test, re-enable, monitor 24h.

### Loops consuming unexpected tasks — HIGH
One order with 50 line items = 50+ tasks. **Reduce:** batch operations (Create Many Rows, bulk APIs), aggregate before sending, filter before looping, or use Make for high-volume loops (operations pricing).

### App updates breaking Zaps — HIGH
Field names change, new required fields appear. **Fix:** check Task History, re-select the trigger/action to refresh schema, re-map "unknown" fields, test. **Prevent:** subscribe to changelogs, keep authorizations fresh, document field mappings.

### OAuth tokens expiring — HIGH
Some apps re-auth every 60–90 days; connections die when the owner leaves. **Fix:** Settings → Apps → reconnect. **Prevent:** use service accounts/shared team accounts, monitor connection health, prefer API keys/long-lived tokens, document who connected what.

### Webhooks missing or duplicating events — MEDIUM
Webhooks are fire-and-forget. **Duplicates:** dedupe by stored event ID (search → filter "not found" → create + store ID). **Missed events:** use polling triggers for critical data, add a reconciliation schedule.

### Make operations consumed by error retries — MEDIUM
Failed + retry = 3 ops for one module; error handlers cost ops too. **Reduce:** break early, use `ignore` when failure is expected, pre-validate before expensive calls, don't over-schedule. Monitor the Operations dashboard.

### Timezone mismatches — MEDIUM
Zapier stores times in UTC while showing local. **Fix:** set timezone explicitly, document it in the Zap name ("Daily Report 9AM EST"), test around DST, use UTC for global teams.

## Delegation

- needs custom code → n8n or a real backend (Inngest, Temporal, GitHub Actions)
- needs browser automation inside a flow → `references/browser-automation.md`
- needs AI capabilities → n8n agents or `references/scripts-and-api.md`
- high-volume data processing → backend/scripts rather than per-action platforms

## References
- Make function syntax and data functions detailed in the "Data transformation" section above.
- n8n-specific deep dives: `references/n8n-workflows.md` and siblings.
