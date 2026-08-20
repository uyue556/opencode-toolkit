# GraphQL

GraphQL gives clients exactly the data they need. But the flexibility that makes
it powerful also makes it dangerous: without controls, clients can craft queries
that bring down the server.

## Principles

- Schema-first design — the schema is the contract and the documentation.
- Prevent N+1 queries with DataLoader.
- Limit query depth and complexity.
- Mutations should be specific, not generic "update" operations.
- Errors are data — use union types for expected failures.
- Nullability is meaningful — design it intentionally.
- Use fragments for reusable selections.

## Schema design

- **Nullability**: non-null fields must always resolve. Non-null everywhere is a
  footgun: one failing field propagates null up through its parents and breaks
  the whole response. Make optional/uncertain fields nullable.
  - `[User!]!` = non-null list of non-null users (recommended).
  - `[User!]` = nullable list of non-null users.
  - `[User]!` = non-null list of nullable users (rarely useful).
  - `[User]` = nullable list of nullable users (avoid).
- **Pagination**: use connection style (`edges { node, cursor }`, `pageInfo`)
  or at minimum `first/after` cursor pagination.
- **Input types** for complex mutations, and **payload types** (result + errors)
  so mutations can return expected failures as data.
- Avoid `JSON`/`Any` types — they bypass GraphQL's type safety.
- Define `enum` types; use `UPPER_SNAKE` enum values.

## Resolvers & DataLoader (N+1 prevention)

Without batching, fetching 10 posts with authors = 11 queries (1 + 10).
DataLoader batches into 2. Create loaders per request.

```javascript
import DataLoader from 'dataloader';

function createLoaders(db) {
  return {
    userLoader: new DataLoader(async (ids) => {
      const users = await db.user.findMany({ where: { id: { in: ids } } });
      const userMap = new Map(users.map(u => [u.id, u]));
      return ids.map(id => userMap.get(id) || null); // same order as input ids
    }),
  };
}

const resolvers = {
  Post: { author: (post, _, { loaders }) => loaders.userLoader.load(post.authorId) },
};
```

Key points: create loaders per request (caching scope), return results in the
same order as input IDs, return null (not skip) for missing items.

## Security

- **Limit depth & complexity** — circular schemas (`user.posts.author.posts...`)
  let clients craft exponential queries. Add validation rules:
  `depthLimit(10)` and complexity limits (scalar/object/list costs), custom
  field costs for expensive resolvers.
- **Disable introspection in production** (or use persisted queries).
- **Authorize in resolvers, not just directives.** Directives can't express
  "user can edit own posts or any post in groups they moderate". Enforce
  business-rule authorization in the resolver, checking ownership and roles.
- **Field-level authorization** — protect private fields (email, phone) per
  resolver, since parent resolution runs before field auth.
- **Query cost analysis** for rate limiting by cost, not just by count.
- **Subscription cleanup** — track active subscriptions, clean up on
  `onDisconnect`, or memory grows over time.

## Client integration

- Apollo Client normalizes responses into a cache. Configure `typePolicies`
  (`keyArgs`, `merge`) for pagination. Prefer cache updates over `refetch`.
- `graphql-codegen` generates fully-typed TS from schema + operations
  (`useGetUserQuery`, `useCreateUserMutation`).

## Sharp edges quick-reference

| Symptom                              | Fix                                              |
| ------------------------------------ | ------------------------------------------------ |
| N+1 queries, slow list responses     | DataLoader batching per request                  |
| Timeouts on nested queries           | depth + complexity limits                        |
| Schema visible in prod               | disable introspection / persisted queries        |
| Unauthorized access                  | authorize in resolvers (ownership + roles) + field-level checks |
| Whole response null from one error   | design nullability intentionally                 |
| Memory growth over time              | cleanup subscriptions + ping handling            |

## When to pick GraphQL vs REST vs tRPC

See `api-design.md` for the decision tree. GraphQL shines for diverse clients,
complex relationships, and subscriptions; it costs more in server machinery
(DataLoader, limits, batching). REST wins for simple CRUD and public caching.

## Sources

- `graphql`, `api-patterns` (graphql section), `backend-architect`.