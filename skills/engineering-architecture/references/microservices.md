# Microservices & Distributed Systems

Sources: `microservices-patterns` (+ `resources/implementation-playbook.md`), `architect-review`,
`monopoly/patterns`, `monopoly/tech-matrix`, `monopoly/scale-benchmarks`.

## 1. When to use (and when not)

Use when: decomposing a monolith into services, designing service boundaries and contracts,
implementing inter-service communication, managing distributed data/transactions, building
resilient distributed systems, service discovery/load balancing, event-driven architectures.

Do NOT use when: the system is small enough for a **modular monolith** (default until justified),
you need a quick prototype, or there's no operational support for distributed systems.
Microservices REQUIRE all of: clear domain boundaries, team >10 developers, different scaling
needs per service.

## 2. Decomposition strategies

- **By business capability** (recommended first): Order, Payment, Inventory services — one team,
  one service, own their data.
- By subdomain (DDD bounded contexts).
- By team/organizational boundaries.
- Strangler-fig migration (see §6) for legacy monoliths.

Workflow: identify domain boundaries and ownership per service → define contracts, data ownership,
communication patterns → plan resilience, observability, deployment → migration steps + guardrails.

## 3. Communication patterns

- **Synchronous REST/gRPC** — request/response, easy to reason about; watch for latency chains and
  tight coupling.
- **Asynchronous event-driven** — services publish events (OrderCreated) to a broker (Kafka,
  RabbitMQ, SQS); consumers react. Decouples producers/consumers; requires eventual consistency.
- **API Gateway** — centralize auth, rate limiting, routing, protocol translation at the edge.

Choose per link: REST for public/browser APIs, gRPC for internal service-to-service (low latency,
strict contracts, streaming), GraphQL where clients need flexible queries (see
`references/api-graphql.md`).

## 4. Data management

- Database-per-service; no shared DB across services.
- Distributed transactions: prefer sagas (see `references/event-sourcing.md`); avoid 2PC.
- Solve the dual-write problem with the **outbox pattern**.
- Eventual consistency is the norm across services.

## 5. Resilience patterns

- **Circuit breaker** — prevent cascade failures; CLOSED/OPEN/HALF-OPEN. Tools: Resilience4j,
  Polly, Envoy.
- **Bulkhead** — isolate failure domains (per-service thread pools / semaphores) so one slow
  service can't starve critical ones.
- **Timeouts & retries** — always time out; retry with backoff; make operations idempotent.
- **Backpressure** — consumers signal producers to slow down.
- **Rate limiting** — at API gateway (per user/IP/endpoint).
- **Leader election** — single-writer guarantee for cron-like jobs / failover (Raft via etcd,
  Consul; ZooKeeper; Redis Redlock with caution).
- **Service mesh** — cross-cutting concerns (logging, auth, proxy) via sidecar when mature.

Resilience first: assume everything fails; design so it fails gracefully and recovers.

## 6. Strangler fig migration

1. Deploy proxy in front of monolith (no user impact).
2. Route one feature to a new microservice.
3. Verify; deprecate that feature in the monolith.
4. Repeat per feature.
5. Monolith empty → decommission.

Trade-offs: zero downtime, incremental risk; dual maintenance during migration, proxy latency.

## 7. Scale estimation formulas

```
avg RPS   = DAU × avg_requests_per_user_per_day / 86400
peak RPS  = avg_RPS × peak_multiplier
  Social media 5–10× · E-commerce 3–5× · News 10–20× · B2B SaaS 2–3× · Gaming 5–15×
storage/day   = requests_per_day × avg_payload
storage/year  = × 365 (× replication factor ~3; reduced by cache hit ratio)
bandwidth in  = avg_request_size × RPS ; out = avg_response_size × RPS
```

Payloads: tweet 500B · social post 2KB · profile 5KB · image 200KB–2MB · video 50–150MB/min ·
API JSON 1–20KB.

## 8. Known scale limits (approximate — hardware dependent)

| Technology | Writes | Reads | Shard/cluster trigger |
|---|---|---|---|
| PostgreSQL | ~5–20K/s | ~50–200K/s (replicas) | >5TB or >20K writes/s |
| MySQL | ~10–25K/s | ~60–250K/s | >5TB or >25K writes/s |
| MongoDB | ~20–50K/s | ~50–100K/s | >100GB or >50K writes/s |
| Cassandra | ~200K–1M/s | ~200–500K/s | rarely needs sharding |
| DynamoDB | managed | managed | provisioned mode |
| Redis | ~500K–1M ops/s | same | >50GB or cluster |
| Elasticsearch | ~10–50K docs/s | ~1–10K queries/s | >100M docs/index |
| Kafka | 1M+ msgs/s/cluster | consumer groups | configurable retention |
| RabbitMQ | ~50–100K msgs/s | connection-limited | until consumed |

Capacity by scale (approx infra + cost): 1K DAU → single server + managed DB ($50–200/mo);
10K DAU → 2–4 app servers + RDS + Redis ($300–800/mo); 100K DAU → ASG + replicas + Redis cluster
($2–8K/mo); 1M DAU → sharding/Aurora + Kafka + CDN + WAF ($20–80K/mo); 10M DAU → multi-region +
microservices + distributed DB + SRE ($200K–2M+/mo).

## 9. Tech decision matrix (short form)

- **DB:** relational+joins+ACID → PostgreSQL. KV extreme scale → DynamoDB/Cassandra. KV speed →
  Redis. Document-shaped → MongoDB. Time-series → InfluxDB/Timescale. Graph → Neo4j. Search →
  ES/OpenSearch/Typesense (Postgres FTS under ~1M docs).
- **Cache:** default Redis; Memcached only for multi-threaded simple KV.
- **Queue:** event replay/audit → Kafka/Kinesis; simple task queue → SQS (AWS) / RabbitMQ
  (self-hosted); fire-and-forget real-time → Redis Pub/Sub / NATS; fan-out → SNS→SQS or Kafka
  consumer groups.
- **API protocol:** public/browser → REST; internal services → gRPC; flexible client queries →
  GraphQL; real-time bidirectional → WebSocket; one-way push → SSE.
- **Search:** <1M docs → Postgres FTS; beyond → Typesense (easy ops) / Elasticsearch (complex
  analytics).
- **Object storage:** Cloudflare R2 for user-facing media (zero egress); S3 for AWS-integrated.
- **Orchestration:** startup → ECS+Fargate; scale (team>5 or >10 services) → EKS/GKE.
- **LB:** AWS ALB (L7) / NLB (L4); Cloudflare for global + DDoS; Traefik K8s-native.
- **Observability:** open-source → Prometheus+Grafana+Loki+Jaeger (OpenTelemetry); managed →
  Datadog / Grafana Cloud.
- **CDN:** Cloudflare default (DDoS + CDN + DNS + free SSL + Workers).

## 10. SLO & latency budgets

| Availability | Monthly downtime |
|---|---|
| 99% | 7.2 h |
| 99.9% | 43.8 min |
| 99.95% | 21.9 min |
| 99.99% | 4.38 min |
| 99.999% | 26 s |

Four nines requires multi-AZ, automated failover, zero-downtime deploys, chaos engineering,
24/7 on-call. Latency: <100ms feels instant; 100–300ms acceptable; >1s frustrating. DB query
targets: key-value <1ms (cache), simple query <5ms, complex <50ms, reporting <500ms (async if
>1s).