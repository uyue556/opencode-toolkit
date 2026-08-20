# SaaS / App Automation via MCP (Rube + Composio) & Standalone Integrations

Automate SaaS apps through the **Rube MCP** server (which fronts Composio toolkits) — Slack, Notion, Outlook,
HubSpot, Stripe, Zendesk, Intercom, Freshdesk, ClickUp, Airtable, Shopify, Google Analytics, Zoom, CircleCI, Render,
SendGrid, and more — plus lightweight standalone OAuth integrations (Google Docs/Drive) and email automation.

## ToC
- [The Rube MCP pattern](#the-rube-mcp-pattern)
- [Universal practices (IDs, pagination, enums)](#universal-practices-ids-pagination-enums)
- [Per-app quick reference](#per-app-quick-reference)
- [Standalone Google OAuth (Docs/Drive)](#standalone-google-oauth-docsdrive)
- [Email automation (SendGrid, Outlook)](#email-automation-sendgrid-outlook)

## The Rube MCP pattern

All app-automation skills share one shape. Follow it for any app before touching app-specific tools:

1. **Search tools first, always.** `RUBE_SEARCH_TOOLS` returns current tool schemas — schemas change, never trust
   memorized field names.
2. **Establish the connection.** Add `https://rube.app/mcp` as an MCP server (no API keys needed). Then
   `RUBE_MANAGE_CONNECTIONS` with the app's toolkit (e.g. `slack`, `notion`). If not `ACTIVE`, follow the returned
   auth link (OAuth). Confirm `ACTIVE` before running anything.
3. **Resolve display names to IDs first.** Almost every app wants IDs, not labels (see universal practices).
4. **Execute the app workflow, then verify** by reading back the created/updated object.
5. **Handle pagination and nested responses** (below).

## Universal practices (IDs, pagination, enums)

### ID resolution — the most common failure

Dropdowns and display names show labels but APIs need **IDs**. Resolve first:
- Channel name → channel ID (`SLACK_FIND_CHANNELS`), user name/email → user ID (`SLACK_FIND_USERS`).
- Notion database/page IDs, Airtable base/table IDs, HubSpot contact/company IDs, Stripe customer IDs —
  find by search before create/update, then reuse the returned ID.
- Persist IDs returned by create calls (`response.data.id`, message `ts`, etc.) — you'll need them for
  update/edit/thread/delete operations.

### Pagination

Most list endpoints paginate with a cursor or page token:
- Follow the pagination token (`response_metadata.next_cursor`, `nextCursor`, page numbers) until empty.
- Set explicit limits for reliable paging; de-duplicate across pages by `id`.
- Filter by date range / status / scenario to avoid pulling entire datasets (operations data can be huge).

### Enum & format validation

- Languages/timezones/statuses are enum-valued: pull the current enum list first
  (`MAKE_LIST_ENUMS_LANGUAGES`, `MAKE_LIST_ENUMS_TIMEZONES`, etc.) and use the exact string values. Cache static
  enum lists; invalid enum values cause configuration errors.
- Respect amount units (Stripe uses cents), Unix vs ISO timestamps (Slack scheduling wants Unix `post_at`), and
  timezone conventions (explicit timezone strings).

### Rate limits & nested responses

- Honor `Retry-After` on HTTP 429; back off on list endpoints for large workspaces.
- Results are often nested (`response.data`, `response.data.results[0].response.data` in wrapped executions,
  `matches` vs `data_preview.matches`). Parse defensively with fallbacks for optional fields.
- Some toolkits are thin (e.g. Make has only operations/languages/timezones) — for full scenario management use the
  app's native API/webhooks, or compose the equivalent workflow from individual app tools.

## Per-app quick reference

| App | Typical operations | Gotchas |
|---|---|---|
| **Slack** | Send message (`markdown_text` preferred over `text`/`blocks`), search (`in:#ch` `from:@u` modifiers), channels/users, reactions, threads, schedule (`post_at` Unix, ≤120 days) | `FIND_CHANNELS` needs `query`; replies need `thread_ts` or they post top-level; conversation history returns main timeline only — use thread fetch; `LIST_ALL_CHANNELS` is public-only; 403 → check OAuth scopes |
| **Notion** | Pages, databases, blocks, schema, comments; filter syntax on queries | Resolve page/database IDs first; blocks must be added with valid block types |
| **Outlook** | Email search (KQL + OData filters), folders, calendar events, contacts | OData `$filter` syntax; use KQL for mail search |
| **Outlook Calendar** | Create/list/search/update/delete events, find meeting times, online meetings | Timezone handling matters; resolve event IDs; set online meeting provider for Teams/Meet links |
| **HubSpot CRM** | Contacts, companies, deals/pipeline, tickets, custom properties; batch ops | Resolve IDs; batch operations for volume; custom properties need valid names/types |
| **Stripe** | Customers, charges, subscriptions, invoices, products/prices, refunds | Amounts in **cents** (integer); refunds require idempotency thinking |
| **Zendesk** | Tickets (list/search/create/update/reply), users, organizations | Ticket lifecycle; resolve requester via user search |
| **Intercom** | Conversations, replies/state, contacts, admins/teams, segments/counts, companies | Admin ID resolution; query filters |
| **Freshdesk** | Tickets, contacts, companies, notes/replies | Resolve contact/company IDs; pagination |
| **ClickUp** | Tasks, workspace hierarchy (space/folder/list), comments, team/members | ID formats + hierarchy rules; rate limits |
| **Airtable** | Records, bases/tables, fields/schema, comments; formula syntax | Resolve base/table IDs; formula syntax differs from Excel |
| **Shopify** | Products, orders, customers, collections, inventory | GraphQL queries for rich data; pagination |
| **Google Analytics** | Accounts/properties, standard/batch/pivot/funnel reports, key events | Resolve property IDs; discover dimensions/metrics; report schema changes |
| **Zoom** | Meetings, recordings, participants/reports, webinars | Some ops require paid plans; rate limits; time handling |
| **CircleCI** | Trigger pipelines, monitor workflows/jobs, artifacts, test results | Project slug format `gh/org/repo`; pipeline→workflow→job hierarchy |
| **Render** | Services, deployments, projects | Deploy-and-monitor pattern: trigger → poll status → report |
| **SendGrid** | Single Sends (marketing campaigns), contacts/lists, sender identity, stats/activity, suppressions | Legacy vs Marketing API mismatch; async campaign sends; verify sender identity first |
| **HelpDesk** | Tickets, views, canned responses, custom fields | Cursor-based pagination |
| **Make** | Operations data, language/timezone enums (limited toolkit) | Thin toolkit — use native API for scenario management |

## Standalone Google OAuth (Docs/Drive)

For Google Docs and Drive there is a lightweight standalone path that needs **no MCP server** — just standalone OAuth
via a local script (token cached on disk, refreshed automatically).

- **Docs**: create doc (optionally with initial content), find by title, get text (by ID or full URL), append/insert
  text, replace text. Doc IDs are extracted automatically from URLs.
- **Drive**: search (full-text, by title, by URL, shared-with-me, paginated), find folder by exact name, list
  root/folder contents, download; write: upload (root or folder, custom name), create folder, move, copy, rename, trash.
- **Search query formats**: Drive full-text search syntax (`name contains 'X'`, `fullText contains`, `mimeType`,
  `sharedWithMe`, `trashed=false`). Token management handles refresh automatically; keep the token file out of
  source control.

## Email automation (SendGrid, Outlook)

### SendGrid

- **Sender identity first** — verify the sender before sending marketing Single Sends.
- Single Sends: create campaign → send (async; poll send status). Contacts/lists: manage lists, add/remove contacts
  (dedupe by email). Statistics/activity: view sends, opens, clicks, bounces. Suppressions: manage bounces/spam/unsubscribes.
- Watch the **Legacy vs Marketing API** split — use the matching endpoint family for the account.

### Outlook mail & calendar

- Mail: search/filter with **KQL** (`from:`, `subject:`, `hasattachment:`) and **OData filters** (`$filter`), manage
  folders, contacts, attachments.
- Calendar: create events (set timezone explicitly), list/search with OData filters, update, delete/decline, and use
  the availability endpoint to **find meeting times** across attendees before booking.

## Composing multi-app workflows

Instead of one giant app toolkit, compose: `RUBE_SEARCH_TOOLS` for each target app → connect the needed toolkits →
chain individual app tools → save as a recipe (`RUBE_CREATE_UPDATE_RECIPE`) for reuse. Equivalents of a Make scenario
can often be built directly from the individual apps' tools.
