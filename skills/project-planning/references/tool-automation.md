# PM Tool Automation (Rube MCP / Composio)

Automate project-management tools through Composio toolkits via Rube MCP. Merged from 11 automation skills: Asana, Basecamp, Confluence, Freshservice, Jira, Linear, Miro, Monday, Todoist, Trello, Wrike. Plus Linear CLI/GraphQL patterns from `linear-claude-skill`.

## Table of Contents
- [Shared Rube MCP Pattern](#shared-rube-mcp-pattern)
- [Common Patterns Across All Tools](#common-patterns-across-all-tools)
- [Per-Tool Quick References](#per-tool-quick-references)
- [Linear CLI / Official MCP (alternative backend)](#linear-cli--official-mcp-alternative-backend)

## Shared Rube MCP Pattern

### Prerequisites
- Rube MCP connected (`RUBE_SEARCH_TOOLS` available).
- Active tool connection via `RUBE_MANAGE_CONNECTIONS` with the tool's toolkit name.
- **Always call `RUBE_SEARCH_TOOLS` first** to get current tool schemas — tool names and params drift; never hardcode against stale schemas.

### Setup
1. Add `https://rube.app/mcp` as an MCP server. No API keys needed.
2. Verify `RUBE_SEARCH_TOOLS` responds.
3. Call `RUBE_MANAGE_CONNECTIONS` with the toolkit.
4. If the connection is not ACTIVE, follow the returned auth link to complete OAuth.
5. Confirm ACTIVE before running any workflow.

## Common Patterns Across All Tools

### ID Resolution (the #1 gotcha)
- Nearly every tool requires **IDs/GIDs, not display names**. Resolve names → IDs first:
  - **Asana:** `ASANA_GET_MULTIPLE_WORKSPACES` → workspace GID → `ASANA_GET_WORKSPACE_PROJECTS` → project GID.
  - **Linear:** `LINEAR_GET_ALL_LINEAR_TEAMS` → team ID → `LINEAR_LIST_LINEAR_STATES` → state ID.
  - **Jira:** `JIRA_GET_ALL_PROJECTS` → project key; `JIRA_GET_FIELDS` → custom field IDs.
  - **Basecamp:** `bucket_id` = `project_id`; resolve person names via `GET_PEOPLE`; to-do set/list/message-board IDs live in the project's `dock` array.
  - **Confluence:** space key vs numeric space ID vs numeric page ID; `GET_SPACE_BY_ID` needs numeric, `GET_PAGE_BY_ID` takes an integer.
  - **Trello:** board ID must be 24-char hex or 8-char shortLink (URL slugs invalid); resolve names first.
  - **Wrike:** opaque alphanumeric IDs (`IEAGTXR7I4IHGABC`); never guess — always resolve from list/search.
  - **Monday:** board/item IDs are large integers; group IDs and column IDs are strings (e.g., `status_1`); workspace IDs are integers.
  - **Todoist:** IDs may be numeric or alphanumeric; if a 400 occurs, fetch the numeric `id` via GET_PROJECT.

### Pagination
- **Cursor/offset tools** (Asana, Linear): check for `next_page`/cursor in the response; pass it to the next request.
- **startAt/maxResults tools** (Jira, Freshservice, Trello, Wrike, Miro, Monday): continue until `startAt + maxResults >= total`, or honor the cursor/`limit` param.
- **Search index delays** (Trello): newly created/updated cards may not appear immediately.

### Response parsing
- Data is often nested (`data`, `data.data`, `data.details[]`). Parse defensively; optional fields may be absent.
- Basecamp content is **HTML only, never Markdown**; updates replace the entire body.
- Confluence content must be **storage format (XHTML)**, not Markdown/plain text.

### Rate limits
- Throttle sequential requests; honor `Retry-After` on 429s; use batch endpoints (Trello `GET_BATCH`, Miro `CREATE_ITEMS_IN_BULK`, Todoist `BULK_CREATE_TASKS`) and implement exponential backoff with jitter.

### Version conflicts (Confluence)
- Updates require the exact next version number (current + 1); always fetch current version immediately before updating.

### Enums / quirks worth memorizing
- **Linear priority:** 0=none, 1=urgent, 2=high, 3=medium, 4=low (integers, not strings).
- **Todoist priority is INVERTED vs UI:** API 1=normal, 4=urgent (UI shows p1=urgent). Clarify which convention the user means.
- **Freshservice:** status/priority/source are numeric codes, not strings; default only returns last-30-days tickets unless `updated_since` used.
- **Jira:** user operations use account IDs, not usernames/emails; custom fields use `customfield_10001` IDs; mentions use account IDs.
- **Jira sprints/boards:** only one active sprint per board at a time; boards are Jira Software-only.
- **Monday:** `MONDAY_CHANGE_SIMPLE_COLUMN_VALUE` auto-creates missing labels; `MONDAY_UPDATE_ITEM` does not. `column_type` uses exact snake_case enums.
- **Basecamp:** `status="draft"` on messages → HTTP 400; use `status="active"`.
- **Wrike:** DELETE_FOLDER/DELETE_SPACE are permanent; use MODIFY_FOLDER (recycle bin) unless deletion is intended.

## Per-Tool Quick References

### Asana
| Task | Tool Slug | Key Params |
|---|---|---|
| List workspaces | ASANA_GET_MULTIPLE_WORKSPACES | (none) |
| Search tasks | ASANA_SEARCH_TASKS_IN_WORKSPACE | workspace, text |
| Create task | ASANA_CREATE_A_TASK | workspace, name, projects |
| Create subtask | ASANA_CREATE_SUBTASK | parent, name |
| List project tasks | ASANA_GET_TASKS_FROM_A_PROJECT | project_gid |
| Create project | ASANA_CREATE_A_PROJECT | workspace, name |
| List sections | ASANA_GET_SECTIONS_IN_PROJECT | project_gid |
| Add task to section | ASANA_ADD_TASK_TO_SECTION | section, task |
| Parallel requests | ASANA_SUBMIT_PARALLEL_REQUESTS | actions |

All IDs are string GIDs; most ops are workspace-scoped.

### Basecamp
| Task | Tool Slug | Key Params |
|---|---|---|
| List projects | BASECAMP_GET_PROJECTS | status |
| List to-do lists | BASECAMP_GET_BUCKETS_TODOSETS_TODOLISTS | bucket_id, todoset_id |
| Create to-do list | BASECAMP_POST_BUCKETS_TODOSETS_TODOLISTS | bucket_id, todoset_id, name |
| Create to-do | BASECAMP_POST_BUCKETS_TODOLISTS_TODOS | bucket_id, todolist_id, content |
| Create message | BASECAMP_CREATE_MESSAGE | bucket_id, message_board_id, subject, status |
| List all people | BASECAMP_GET_PEOPLE | (none) |

### Confluence
| Task | Tool Slug | Key Params |
|---|---|---|
| Search content | CONFLUENCE_SEARCH_CONTENT | query, spaceKey, limit |
| CQL search | CONFLUENCE_CQL_SEARCH | cql, expand, limit |
| List pages | CONFLUENCE_GET_PAGES | spaceId, sort, limit |
| Create page | CONFLUENCE_CREATE_PAGE | title, spaceId, body |
| Update page | CONFLUENCE_UPDATE_PAGE | id, title, body, version |
| Add label | CONFLUENCE_ADD_CONTENT_LABEL | content ID, label |

### Freshservice
| Task | Tool Slug | Key Params |
|---|---|---|
| List tickets | FRESHSERVICE_LIST_TICKETS | filter, updated_since, page, per_page |
| Get ticket | FRESHSERVICE_GET_TICKET | ticket_id, include |
| Create ticket | FRESHSERVICE_CREATE_TICKET | subject, description, status, priority, email |
| Bulk update | FRESHSERVICE_BULK_UPDATE_TICKETS | ids, update_fields |
| Outbound email ticket | FRESHSERVICE_CREATE_TICKET_OUTBOUND_EMAIL | email, subject, description |
| Service request | FRESHSERVICE_CREATE_SERVICE_REQUEST | item_display_id, email, quantity |

### Jira
| Task | Tool Slug | Key Params |
|---|---|---|
| Search issues (JQL) | JIRA_SEARCH_FOR_ISSUES_USING_JQL_POST | jql, maxResults |
| Create issue | JIRA_CREATE_ISSUE | project, issuetype, summary |
| Edit issue | JIRA_EDIT_ISSUE | issueIdOrKey, fields |
| Assign issue | JIRA_ASSIGN_ISSUE | issueIdOrKey, accountId |
| Add comment | JIRA_ADD_COMMENT | issueIdOrKey, body |
| List boards | JIRA_LIST_BOARDS | (none) |
| List sprints | JIRA_LIST_SPRINTS | boardId |
| Move to sprint | JIRA_MOVE_ISSUE_TO_SPRINT | sprintId, issues |
| Get fields | JIRA_GET_FIELDS | (none) |

JQL quick syntax: `project = "PROJ"`, `status = "In Progress"`, `assignee = currentUser()`, `created >= -7d`, `ORDER BY created DESC`; combine with `AND`/`OR`/`NOT`. Custom fields use IDs (`customfield_10001`).

### Linear
| Task | Tool Slug | Key Params |
|---|---|---|
| List teams | LINEAR_GET_ALL_LINEAR_TEAMS | (none) |
| Create issue | LINEAR_CREATE_LINEAR_ISSUE | team_id, title, description |
| Search issues | LINEAR_SEARCH_ISSUES | query |
| List issues | LINEAR_LIST_LINEAR_ISSUES | team_id, filters |
| Update issue | LINEAR_UPDATE_ISSUE | issue_id, fields |
| List states | LINEAR_LIST_LINEAR_STATES | team_id |
| List projects | LINEAR_LIST_LINEAR_PROJECTS | (none) |
| Create project | LINEAR_CREATE_LINEAR_PROJECT | name, team_ids |
| List cycles | LINEAR_LIST_LINEAR_CYCLES | team_id |
| Run GraphQL | LINEAR_RUN_QUERY_OR_MUTATION | query, variables |

Issues, states, and cycles are **team-specific** — always resolve team_id first.

### Miro
| Task | Tool Slug | Key Params |
|---|---|---|
| List boards | MIRO_GET_BOARDS2 | query, sort, limit, offset |
| Create board | MIRO_CREATE_BOARD | name, description |
| Add sticky note | MIRO_CREATE_STICKY_NOTE_ITEM | board_id, data, style, position |
| Add frame | MIRO_CREATE_FRAME_ITEM2 | board_id, data, geometry, position |
| Bulk add items | MIRO_CREATE_ITEMS_IN_BULK | board_id, items |
| Share board | MIRO_SHARE_BOARD | board_id, emails, role |

Item types have different required fields (sticky = `data.content`; frame = `geometry.width/height`); position defaults to (0,0) — items may overlap.

### Monday.com
| Task | Tool Slug | Key Params |
|---|---|---|
| List boards | MONDAY_LIST_BOARDS | limit, page, state |
| Create board | MONDAY_CREATE_BOARD | board_name, board_kind, workspace_id |
| List columns | MONDAY_LIST_COLUMNS | board_id |
| Create item | MONDAY_CREATE_ITEM | board_id, item_name, column_values |
| Update column | MONDAY_UPDATE_ITEM | board_id, item_id, column_id, value |
| Move item to group | MONDAY_MOVE_ITEM_TO_GROUP | item_id, group_id |
| Add comment/update | MONDAY_CREATE_UPDATE | item_id, body |
| Raw GraphQL | MONDAY_CREATE_OBJECT | query, variables |

Column values include raw `value` (JSON) and rendered `text`. Subitems are nested under parents (query via parent IDs).

### Todoist
| Task | Tool Slug | Key Params |
|---|---|---|
| List projects | TODOIST_GET_ALL_PROJECTS | (none) |
| Create project | TODOIST_CREATE_PROJECT | name, color, view_style |
| List sections | TODOIST_GET_ALL_SECTIONS | project_id |
| Create task | TODOIST_CREATE_TASK | content, project_id, due_string, priority |
| Bulk create tasks | TODOIST_BULK_CREATE_TASKS | tasks (array) |
| Complete task | TODOIST_CLOSE_TASK | task_id |
| Get all tasks | TODOIST_GET_ALL_TASKS | filter, ids |

Filter terms must reference real entities (`#Project`, `@Label`) or you'll get HTTP 400; use `search: keyword` for text; `completed` filters don't work on GET_ALL_TASKS.

### Trello
| Task | Tool Slug | Key Params |
|---|---|---|
| List user's boards | TRELLO_GET_MEMBERS_BOARDS_BY_ID_MEMBER | idMember='me', filter='open' |
| List board lists | TRELLO_GET_BOARDS_LISTS_BY_ID_BOARD | idBoard |
| Create card | TRELLO_ADD_CARDS | idList, name, desc, pos, due |
| Move card | TRELLO_UPDATE_CARDS_BY_ID_CARD | idCard, idList |
| Search cards | TRELLO_GET_SEARCH | query, modelTypes='cards' |
| Assign member | TRELLO_ADD_CARDS_ID_MEMBERS_BY_ID_CARD | idCard, value |
| Batch read | TRELLO_GET_BATCH | urls |

Rate limit ~300 req/10s per token.

### Wrike
| Task | Tool Slug | Key Params |
|---|---|---|
| Create task | WRIKE_CREATE_TASK | folderId, title, responsibles, status |
| Modify task | WRIKE_MODIFY_TASK | taskId, title, status, addResponsibles |
| Get folders | WRIKE_GET_FOLDERS | project, descendants |
| Create folder | WRIKE_CREATE_FOLDER | folderId, title |
| Get custom fields | WRIKE_GET_ALL_CUSTOM_FIELDS | (none) |
| Launch blueprint | WRIKE_LAUNCH_TASK_BLUEPRINT_ASYNC | task_blueprint_id, title, parent_id |
| Invite user | WRIKE_CREATE_INVITATION | email, role |

Dates: `yyyy-MM-dd`; DateTime: `yyyy-MM-ddTHH:mm:ssZ`; duration in minutes.

## Linear CLI / Official MCP (alternative backend)

From `linear-claude-skill`: when Linear MCP tools aren't available, use the Linear CLI via Bash instead of reporting a blocker.

```bash
linear issues view ENG-123
linear issues create --title "Title" --description "Description"
linear issues update ENG-123 -s "STATE_ID"
linear issues comment add ENG-123 -m "Comment text"
linear issues list
```

### Security: never expose API keys
- **Safe:** validate `LINEAR_API_KEY` is set with masked output; run commands with secrets injected (e.g., `varlock run -- ...`); check `.env.schema` (no values).
- **Never:** `linear config show`, `echo $LINEAR_API_KEY`, `printenv | grep LINEAR`, `cat .env`.

### Project planning workflow (Linear)
- **Every issue attached to a project; every project linked to an initiative.** Missing project → not on project board; missing initiative → not on roadmap.
- Create the project FIRST (linked to initiative), set state `planned`, then create issues directly in it. Set `in-progress` when work begins, `completed` when done. Don't create issues in a "holding" project and move them later.
- States: `backlog`, `planned`, `in-progress`, `paused`, `completed`, `canceled`.
- Status convention: assigned → `Todo`; unassigned → `Backlog`.
- Label taxonomy: ONE Type label (`feature`/`bug`/`refactor`/`chore`/`spike`) + 1-2 Domain labels (`security`, `backend`, `frontend`...) + scope labels when applicable (`blocked`, `breaking-change`, `tech-debt`).

### Tool selection
| Tool | When |
|---|---|
| Official Linear MCP (`mcp.linear.app`) | Most operations — preferred |
| Helper scripts | Bulk operations, MCP unavailable |
| SDK (`@linear/sdk`) | Complex ops (loops, conditionals) |
| GraphQL API | Operations not supported by MCP/SDK |

Use the official MCP server (`mcp.linear.app/sse`) — do not use deprecated community servers. For bulk updates, use a specialist sub-agent or batch scripts.
