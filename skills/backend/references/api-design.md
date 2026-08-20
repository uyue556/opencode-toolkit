# API Design

## Why design matters

Good interfaces make the right thing easy and the wrong thing hard. Every
observable behavior of an API — including undocumented quirks, error text,
timing, ordering — becomes a de facto contract once anyone depends on it
(Hyrum's Law). Design for extension from the start, plan deprecation at design
time, and prefer the "one version at a time" rule: extend rather than fork.

## Choosing the API style

| Style   | Use when                                                              | Avoid when                                      |
| ------- | --------------------------------------------------------------------- | ----------------------------------------------- |
| REST    | Simple CRUD, public APIs, need HTTP caching, many heterogeneous clients | Deeply nested/complex relations, mobile overfetch |
| GraphQL | Diverse clients with different data needs, complex relationships, need subscriptions | Simple CRUD (REST is simpler), heavy public caching |
| tRPC    | TypeScript monorepo where client+server share code; want end-to-end type safety without schema/codegen | Public/third-party consumers, non-TS clients |
| gRPC    | Internal service-to-service, typed contracts, streaming, low latency | Public browser clients without a gateway |

2025 lesson: GraphQL isn't always the answer. For simple CRUD, REST is simpler.
For high-performance public APIs, REST with caching wins. Choose for the context,
not by default.

## REST resource design

- Plural nouns, no verbs in URLs: `GET /api/tasks`, not `GET /api/getTasks`.
- Nested paths for sub-resources: `GET /api/tasks/:id/comments`.
- Map CRUD to HTTP methods: GET (read), POST (create), PUT (full replace),
  PATCH (partial update), DELETE (remove). PATCH is what clients actually want;
  PUT requires the full object every time.
- Avoid deep nesting (>2 levels). Use query params or a dedicated relation path.
- Convention: camelCase for query params and response fields, `is/has/can`
  prefixes for booleans, `UPPER_SNAKE` for enum values.

### Status codes

| Code | Meaning |
| ---- | ------- |
| 200  | Success (GET/PUT/PATCH) |
| 201  | Created (POST) |
| 204  | No content (DELETE) |
| 400  | Malformed request |
| 401  | Not authenticated |
| 403  | Authenticated but not authorized |
| 404  | Not found |
| 409  | Conflict (duplicate, version mismatch) |
| 422  | Validation failed (semantically invalid) |
| 429  | Rate limited |
| 500  | Server error (never expose internals) |

Use 401 vs 403 correctly: 401 = missing/bad credentials; 403 = authenticated
but not allowed.

### Consistent error format

Pick one error strategy and use it everywhere — don't mix "returns null",
"throws", and "returns {error}" across endpoints.

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid task data",
    "details": { "fieldErrors": { "email": "must be a valid email" } }
  }
}
```

Machine-readable `code`, human-readable `message`, optional `details`. Log the
full error server-side; return only the safe message to the client.

### Pagination

Paginate every list endpoint from day one. Two approaches:

- **Offset** (`?page=1&pageSize=20`): simple, stable for small data. Return
  `pagination: { page, pageSize, totalItems, totalPages }`.
- **Cursor** (Relay-style `first/after`, or `limit/cursor`): stable under inserts,
  better for large/live data. Return `hasNextPage`, `startCursor`, `endCursor`.

Enforce a max page size (e.g. 100) and default (e.g. 20).

### Filtering, sorting, sparse fieldsets

Use query parameters: `?status=in_progress&assignee=user123&createdAfter=...`,
`?sortBy=createdAt&sortOrder=desc`. Support field selection when bandwidth
matters. Document defaults and allowed enum values.

## Contract-first design

Define the interface before implementing it:

```typescript
interface TaskAPI {
  createTask(input: CreateTaskInput): Promise<Task>;
  listTasks(params: ListTasksParams): Promise<PaginatedResult<Task>>;
  getTask(id: string): Promise<Task>;
  updateTask(id: string, input: UpdateTaskInput): Promise<Task>;
  deleteTask(id: string): Promise<void>;
}
```

- Separate **input types** (what the caller provides) from **output types**
  (what the system returns, including server-generated fields).
- Use **discriminated unions** for variants so consumers get type narrowing.
- Use **branded types** for IDs to prevent passing a `UserId` where a `TaskId`
  is expected.
- Prefer addition over modification: add optional fields; never remove or change
  the type of existing fields.

## Validation at boundaries

- Validate where external input enters: API handlers, form submission handlers,
  third-party API response parsing (**always treat third-party responses as
  untrusted**), and environment-variable loading.
- Do NOT validate between internal functions that already share type contracts.
- Use allowlists, not blocklists.

## Versioning

- **URL versioning** (`/api/v1/...`): visible, simple, most common.
- Header/query versioning: keeps URLs clean but is less discoverable.
- Policy: document deprecation timelines, keep old versions alive during
  migration, communicate breaking changes with a changelog.

## Anti-patterns checklist

- Verbs in URLs (`/api/createTask`) — bad.
- Inconsistent error formats across endpoints — bad.
- List endpoints without pagination — bad.
- Breaking changes to existing fields (type changes, removals) — bad.
- Endpoints that return different shapes depending on conditions — bad.
- Third-party API responses used without validation/sanitization — bad.

## Verification

- [ ] Every endpoint has typed input/output schemas
- [ ] Errors follow one consistent format
- [ ] Validation happens at boundaries only
- [ ] List endpoints support pagination
- [ ] New fields are additive and optional
- [ ] Naming is consistent across endpoints
- [ ] Docs/types are committed alongside the implementation

## Sources

- `api-and-interface-design` (addyo/agent-skills), `api-patterns`,
  `api-designer`, `api-design-principles`, `api-analyzer`, `backend-architect`.
