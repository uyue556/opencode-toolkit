---
name: cloud
description: "Cloud engineering across AWS, Azure, GCP, Firebase, and multi-cloud/hybrid environments. Use whenever the user works with cloud infrastructure, serverless, IaC, cost optimization, cloud networking, cloud security, cloud storage, or deploys to a cloud provider. Triggers: AWS, Lambda, CDK, CloudFormation, Terraform, S3, DynamoDB, Azure, Azure Functions, Cosmos DB, Blob Storage, Key Vault, Azure SDK, GCP, Cloud Run, Firebase, Firestore, serverless, 无服务器, 云架构, 云计算, 云成本, 降本增效, 多云, 混合云, 基础设施即代码, IaaS, PaaS, FinOps, IaC, Kubernetes, Istio, rclone, cost optimization, cloud migration, VPN, Direct Connect."
---

# Cloud Engineering (AWS · Azure · GCP · Multi-cloud)

Consolidated guidance for designing, deploying, operating, and optimizing applications on
AWS, Azure, GCP, Firebase, and hybrid/multi-cloud setups. The library it replaces was ~90%
per-service/per-language SDK cookbooks (mostly Azure) plus a set of deep architecture,
serverless, IaC, cost, and networking skills. This skill keeps the deep guidance up front and
routes SDK detail into references.

## When to use this skill

Use it for any task that touches a cloud provider: provisioning infrastructure, writing
serverless functions, picking services, cutting costs, connecting networks, securing
resources, or using a cloud SDK. If the task is pure application logic with no cloud
involvement, don't use it.

## Core workflow

1. **Establish context first.** If AWS is involved, resolve the effective profile, region,
   account, and caller identity *before* any command — see `references/aws-cost-ops.md`
   (§ Context discovery). Never guess a region and never read `~/.aws/credentials` or print
   secrets.
2. **Pick the right sub-topic** and read the corresponding reference (routing table below).
   Read the reference *before* writing code — the "why" matters more than the snippet.
3. **Verify facts.** Use AWS docs MCP (`aws-mcp-setup`), Azure official docs, or GCP docs for
   anything version-sensitive (limits, region availability, API signatures, SDK versions).
   Do not rely on memory for service quotas or model IDs.
4. **Author with least privilege and IaC.** Express infrastructure as code
   (CloudFormation/CDK/SST, Bicep, Terraform, or Pulumi) so it is reviewable and repeatable.
5. **Validate before deploy.** `cdk synth` + `cdk-nag`, `cfn-lint`/`cfn-nag`, `terraform
   plan`, `azd up --dry-run`, `sst diff`, `gcloud run deploy --no-promote`, etc. Run lint and
   tests. Confirm the target account with `aws sts get-caller-identity` before any deploy.
6. **Design for failure, cost, and observability from day one**: DLQs, retries, alarms,
   budgets, structured logs, and tagging on every resource.

## Selection routing

| Task / trigger | Go to |
|---|---|
| Lambda, API Gateway, SQS/SNS, DynamoDB Streams, cold starts, SAM | `references/aws-serverless.md` |
| Event-driven design, Step Functions, Well-Architected serverless lens | `references/aws-serverless.md` (§ EDA) |
| CDK stacks/constructs, CloudFormation, SST v4 (Ion) | `references/aws-iac.md` |
| AWS bills, Cost Explorer, budgets, unused-resource cleanup | `references/aws-cost-ops.md` |
| AWS MCP servers, docs lookup, context discovery, Bedrock AgentCore | `references/aws-cost-ops.md` (§ MCP & context) |
| Cloud Run services/functions, Pub/Sub, Cloud SQL, cold starts | `references/gcp.md` |
| Firebase auth, Firestore, security rules, Cloud Functions v2 | `references/gcp.md` (§ Firebase) |
| Azure Functions, Durable Functions, isolated worker, azd/Container Apps | `references/azure.md` |
| Azure SDK usage (Cosmos, Blob, Key Vault, Service Bus, AI, Identity, …) | `references/azure.md` (§ SDK index & common patterns) |
| Multi-cloud decisions, service comparison, hybrid architecture, TCO | `references/multi-cloud.md` |
| Cost across all clouds, reserved/spot/committed use, tagging | `references/multi-cloud.md` (§ FinOps) |
| VPN / Direct Connect / ExpressRoute / Interconnect, hybrid DNS | `references/multi-cloud.md` (§ Networking) |
| Istio routing, canary, circuit breakers, fault injection | `references/multi-cloud.md` (§ Service mesh) |
| rclone cloud storage sync/copy/mount, S3-compatible storage | `references/rclone.md` |

## Best practices that hold across every cloud

- **Right-size before you scale.** Measure memory/CPU, then choose. More memory = more CPU on
  serverless; over-provisioning is the #1 cost leak.
- **Minimize cold starts.** Small packages, lazy init, modular SDK imports, SnapStart /
  startup CPU boost / pre-warmed instances. Since Aug 2025 AWS bills Lambda INIT time — cold
  starts are now a *cost* issue, not just latency.
- **Design for failure.** Async triggers need DLQs and idempotent handlers. Partial batch
  failure (`ReportBatchItemFailures`, `batchItemFailures`) beats whole-batch retry. SQS
  visibility timeout ≈ 6× function timeout.
- **Least privilege, always.** No wildcard IAM, no hardcoded keys or connection strings.
  Credentials live in Secret Manager / Key Vault / env vars, never in source or chat.
- **Infrastructure as code.** Separate stateful (DBs, buckets) from stateless (compute/API)
  stacks; tag everything for cost allocation; enable monitoring by default.
- **Log structured JSON with correlation IDs**, and emit a custom metric for cold starts.
- **Pay-per-use beats idle.** Serverless for variable loads, reserved/committed capacity for
  steady loads, spot/preemptible for batch and CI.

## Do & Don't

**Do**
- `--dry-run` / `-i` before any destructive or money-moving operation (deletes, `sync`,
  `purge`, releases, rollbacks).
- Set explicit timeouts on every HTTP/database call and handle them gracefully.
- Use connection pooling + reuse (HttpClientFactory, static clients); never create a client
  per request (socket exhaustion).
- Stream large data instead of buffering it in memory or `/tmp` (Cloud Run /tmp counts
  against memory; Lambda has payload limits).
- Watch for infinite/recursive invocation loops — filter S3/DynamoDB triggers by prefix and
  write outputs to a *different* location; set reserved concurrency as a circuit breaker.
- Follow the shared-responsibility model: provider secures the cloud, you secure what's in it.

**Don't**
- Don't guess regions, account IDs, or ARNs — resolve or use `!Sub`/pseudo-params.
- Don't call an async API with `.Result`/`.Wait()`/`Thread.Sleep` (thread starvation).
- Don't rely on local filesystem/state in serverless runtimes.
- Don't mirror traffic to production or canary a feature without a way back.
- Don't put all resources in one monolithic template; use nested/cross-stack patterns.

## Common pitfalls (sharp edges)

| Symptom | Root cause | Fix |
|---|---|---|
| Lambda "Task timed out" | default 3s timeout; HTTP timeout too short | set timeout = expected + buffer; use `getRemainingTimeInMillis` |
| 413 / "Malformed Lambda proxy response" | API Gateway 10 MB / Lambda 6 MB sync limits | presigned S3 URLs for uploads/downloads |
| Sudden Lambda cost jump | INIT phase now billed (Aug 2025) | shrink package, SnapStart, lazy imports |
| 504 on Azure Functions after ~4 min | load balancer hard 230s HTTP timeout (any plan) | async + Durable Functions / queue + status polling |
| Cloud Run container killed (OOM) | `/tmp` writes consume memory | stream to GCS, size memory with `/tmp` in mind |
| Cloud Run work "runs slowly" | CPU throttled between requests | `--cpu-throttling=false` or move to Cloud Tasks/Pub/Sub |
| VPC connector drops DB connections | 10-min idle timeout | `pool_recycle`/`pool_pre_ping`, TCP keep-alive |
| `sst deploy` ARN breaks at deploy time | Pulumi `Output<T>` stringified into a template literal | use `$interpolate` |
| CDK deploy fails with name conflicts | explicit `functionName`/`restApiName` | let CDK generate unique names |
| Azure Functions sockets exhausted | new HttpClient per request | `IHttpClientFactory` or static client |

## Examples (one per cloud)

**AWS** — HTTP API + Lambda + DynamoDB with partial batch failure and DLQ: see
`references/aws-serverless.md`. Deploy with SAM or CDK; run `sam local start-api` / `cdk
diff` before deploy.

**GCP** — containerized Express service on Cloud Run with `--cpu-boost`, `--min-instances 1`,
`--concurrency 80`, Secret Manager-mounted env vars, and a Pub/Sub push subscription for
async work: see `references/gcp.md`.

**Azure** — isolated-worker C# function with DI, App Insights, warmup trigger, and Durable
Functions fan-out/fan-in for image processing: see `references/azure.md`.

**Multi-cloud** — pick best-of-breed services, standardize on Terraform + Kubernetes +
PostgreSQL, connect to on-prem with VPN/Direct Connect/ExpressRoute, and budget every
environment: see `references/multi-cloud.md`.

## Sources

Consolidated from the `cloud` skill library (144 SKILL.md files): AWS serverless/EDA, CDK,
CloudFormation, SST, cost ops/optimizer/cleanup, MCP setup, context discovery, Bedrock
AgentCore, GCP Cloud Run, Firebase, Azure Functions, azd, ~100 Azure SDK cookbooks, cloud &
hybrid architect, multi-cloud, cost optimization, hybrid networking, Istio, and rclone. See
`dedup-notes.md` for the merge map.
