# GraphQL API Architecture

Source: `graphql-architect`. Use for enterprise GraphQL schema design, federation, performance,
security, and real-time systems.

## 1. When to use

- Designing scalable GraphQL schemas for enterprise applications.
- Building federated architectures (Apollo Federation v2) for multi-team organizations.
- Optimizing N+1 queries, caching, query complexity.
- Migrating REST → GraphQL; implementing subscriptions; securing a GraphQL API.

Do not use for simple CRUD (GraphQL adds complexity without benefit) or where REST/gRPC fits the
client needs better.

## 2. Schema design

- **Schema-first** with SDL and code generation.
- Design for evolution: versioning, backward compatibility, field deprecation, schema registry and
  governance (breaking-change detection in CI).
- Interface and union types for polymorphic queries; Relay connection patterns for lists.
- Custom scalars for validated inputs; document every field (the schema is the contract).
- Consider caching implications in schema design.

## 3. Federation (distributed GraphQL)

- Split schema into **subgraphs** owned by separate teams; a **supergraph/gateway** composes them
  (`@key`, `@shareable`, `@external`, `@requires`, `@provides`).
- Schema registry + governance for cross-team evolution.
- Gateway options: Apollo Router/Gateway; GraphQL Mesh for aggregating REST/microservices.

## 4. Performance

- **DataLoader** to batch and deduplicate resolver loads (fixes N+1).
- Query complexity analysis + depth limiting to prevent expensive/abusive queries.
- Automatic Persisted Queries (APQ) — cache client queries; reduces bandwidth and parse cost.
- Response caching at field/query level; Redis + CDN integration.
- Resolver tracing + performance analytics to find bottlenecks.
- Batch processing and request deduplication.

## 5. Security

- Field-level authorization and access control (return only authorized data).
- JWT validation; RBAC/ABAC; API keys where appropriate.
- Rate limiting and query cost analysis (reject over-budget queries).
- **Disable/restrict introspection in production** (or keep it but protect it).
- Input sanitization and injection prevention; locked-down CORS + security headers.

## 6. Real-time (subscriptions)

- WebSocket or SSE transport.
- Subscription filtering and authorization (per-topic, per-user).
- Event-driven integration; scalable subscription infrastructure; live queries where needed.

## 7. Testing & quality

- Unit tests for resolvers + schema validation; integration tests with a test client.
- Schema testing + breaking-change detection in CI.
- Load testing + performance benchmarking; contract testing between services.

## 8. Enterprise integration patterns

- REST → GraphQL migration with backward compatibility (deprecation, incremental adoption).
- Orchestrate microservices through GraphQL (careful: avoid leaking orchestration into schema).
- Event sourcing / CQRS integration; database-first approaches (Hasura, PostGraphile) for CRUD.

## 9. Recommended stack

Apollo Server + Apollo Federation + Apollo Studio; GraphQL Yoga, Pothos, Nexus; Prisma/TypeGraphQL;
GraphQL Code Generator; Relay Modern / Apollo Client on the client. Schema linting + validation
automation; development server with hot reload.