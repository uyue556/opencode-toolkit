# Azure: Functions, Durable, azd & the SDK Library

Merges `azure-functions`, `azd-deployment`, and consolidates the ~100 Azure SDK cookbooks
into an index + shared patterns. Use for Azure Functions, Azure AI services, storage,
Cosmos DB, identity/Key Vault, messaging, monitoring, and management SDKs.

## Table of contents

1. [Azure Functions & Durable Functions](#azure-functions--durable-functions)
2. [azd: Azure Developer CLI & Container Apps](#azd-azure-developer-cli--container-apps)
3. [Azure SDK shared patterns](#azure-sdk-shared-patterns)
4. [Azure SDK index (all services × languages)](#azure-sdk-index)

## Azure Functions & Durable Functions

### Programming models

- **.NET isolated worker** is the only model for new projects (in-process is deprecated,
  support ends **Nov 10, 2026**). `[Function]` + `[HttpTrigger(AuthorizationLevel.Function)]
  HttpRequestData` returning `HttpResponseData`; `Program.cs` with
  `ConfigureFunctionsWorkerDefaults()` + DI. Migration: `FunctionName`→`Function`,
  `HttpRequest`→`HttpRequestData`, `IActionResult`→`HttpResponseData`, constructor-injected
  `ILogger<T>`.
- **Node v4**: code-centric `app.http / app.timer / app.storageBlob` — no `function.json`.
- **Python v2**: decorators (`@app.route`, `@app.timer_trigger`, `@app.blob_trigger`,
  `@app.queue_trigger`); always runs out-of-process; Linux hosting only.
- Triggers/bindings need the **extension bundle** in `host.json`
  (`Microsoft.Azure.Functions.ExtensionBundle [4.*, 5.0.0)`), or explicit
  `Microsoft.Azure.Functions.Worker.Extensions.*` packages in isolated worker. Missing
  extensions = "No job functions found" / silent trigger failures.

### Durable Functions

- **Function chaining**: sequential activities, state auto-persisted between each, built-in
  retry, survives restarts. `context.CallActivityAsync` per step; start via
  `[DurableClient] ScheduleNewOrchestrationInstanceAsync` → returns status URLs
  (`statusQueryGetUri`, `sendEventPostUri`, `terminatePostUri`).
- **Fan-out/fan-in**: start all activities in parallel, `Task.WhenAll`, aggregate. Memory
  efficient (stores task IDs), supports thousands of parallel activities.
- Use for workflows that outlive any single timeout (days-long, chunked, callback-based).

### Cold start & production

- **Premium plan** pre-warms runtime, not your code → add a `[WarmupTrigger]` function that
  initializes expensive resources; `az functionapp config set --prewarmed-instance-count 3`;
  `--minimum-elastic-instance-count` for always-ready.
- Static/singleton clients via DI; `PublishTrimmed` + partial trim; run-from-package
  deployment.
- **HTTP timeout is 230 s regardless of plan** (load balancer hard limit) — host.json
  `functionTimeout` does not apply to HTTP. Use Durable Functions / queue + 202 Accepted +
  status polling / webhook callback for long work.
- **Consumption plan caps execution at 10 minutes** (default 5). Longer → Premium or
  Durable/chunking.
- **Socket exhaustion**: never `new HttpClient()` per request — use `IHttpClientFactory`
  or a static client. Same for Blob/Cosmos/ServiceBus clients.
- **Thread starvation**: no `.Result`, `.Wait()`, `Thread.Sleep` — `await` all the way.
- **Logging**: injected `ILogger<T>` needs `AddApplicationInsightsTelemetryWorkerService()`
  + `ConfigureFunctionsApplicationInsights()`; `context.GetLogger()` always works;
  configure levels/sampling in `host.json`.
- Queue triggers: messages retried to `maxDequeueCount` (default 5) then moved to
  `<queue>-poison`; configure `visibilityTimeout`, `batchSize`, `newBatchThreshold`.

## azd: Azure Developer CLI & Container Apps

Deploy containerized frontend + backend to Azure Container Apps with Bicep.

```bash
azd auth login && azd init && azd env new <env> && azd up
```

- `azure.yaml`: `services.<name> = {project, language, host: containerapp, docker: {path,
  remoteBuild: true}}`. **Always `remoteBuild: true`** — local builds fail on M1/ARM Macs
  targeting AMD64.
- Config flows: local `.env` → `.azure/<env>/.env` (azd-managed, auto-populated from Bicep
  **outputs**) → `main.parameters.json` (`${VAR}` / `${VAR=default}`). Set secrets with
  `azd env set`, not parameter defaults.
- Preserve Portal-added custom domains across redeploys: save in `preprovision` hook,
  restore/verify in `postprovision`; set Bicep `customDomains: empty(...) ? null : …`.
- Reference existing resources (`resource x '…' existing = { name: … }`) instead of
  recreating; use `|| true` in RBAC hooks to tolerate "already exists".
- Internal service discovery: `http://ca-backend-<token>` between apps in the same
  environment.
- Managed identity: `identity: {type: SystemAssigned}` + output `principalId`, then
  `az role assignment create` in `postprovision` (Azure OpenAI, AI Search, etc.).
- Commands: `azd up | provision | deploy [--service backend] | show | env get-values`;
  logs: `az containerapp logs show -n <app> -g <rg> --follow`.

## Azure SDK shared patterns

Nearly every Azure SDK skill follows the same skeleton — install `azure-<service>`, set
env vars (`AZURE_SUBSCRIPTION_ID`, service-specific endpoint/connection string), and:

1. **Authenticate with `DefaultAzureCredential`** (from `azure-identity`). It works in local
   dev (VS Code/CLI) *and* production (managed identity / service principal) with no code
   changes. Prefer **Microsoft Entra ID (managed identity)** over API keys in production;
   keep key/connection-string auth for local scripts. Customize by excluding credentials or
   enabling interactive browser; build explicit chains with
   `ChainedTokenCredential`/`ManagedIdentityCredential`/`ClientSecretCredential`/
   `AzureCliCredential`.
2. **Know the client hierarchy** — e.g. Cosmos: `CosmosClient → Database → Container →
   Item`; Blob: `BlobServiceClient → BlobContainerClient → BlobClient`; Service Bus:
   `ServiceBusClient → sender/receiver`; AI services: `<Service>Client(endpoint, cred)`.
3. **Use the right operations** — Cosmos reads need id **and** partition key; Blob upload
   from file/bytes/stream + performance tuning (chunk sizes, parallel upload); Service Bus
   receive modes (peek-lock/auto-complete) and settlement; Event Hubs producer/consumer
   with blob checkpointing; Event Grid publishes CloudEvents/EventGridEvents.
4. **Async everywhere** (Python/TS have async clients; .NET `await`).
5. **Best practices per service** — connection pooling, retries, exponential backoff,
   batch sizes, and never logging secrets. Env-var-driven config (`AZURE_*`).

The index below is the full per-service, per-language map.

## Azure SDK index

Grouped by service area. Language variants (all follow the shared patterns above) — **.NET**,
**Java**, **Python**, **TS/JS**, **Rust** as noted. Full per-service guides live in the
source library (`/home/administrator/.config/opencode/skill-libraries/cloud/`).

- **AI / ML**
  - OpenAI (chat/embeddings/images/audio/RAG): `azure-ai-openai-dotnet`
  - ML platform (v2): `azure-ai-ml-py`
  - AI Foundry projects/agents: `azure-ai-projects-{dotnet,java,py,ts}`;
    `azure-ai-agents-persistent-{dotnet,java}`
  - Content Safety: `azure-ai-contentsafety-{java,py,ts}`
  - Document Intelligence: `azure-ai-document-intelligence-{dotnet,ts}`;
    `azure-ai-formrecognizer-java`
  - Language: `azure-ai-language-conversations-py`, `azure-ai-textanalytics-py`
  - Vision: `azure-ai-vision-imageanalysis-{java,py}`
  - Speech: `azure-ai-transcription-py`, `azure-speech-to-text-rest-py`,
    `azure-ai-voicelive-{dotnet,java,py,ts}`
  - Translation: `azure-ai-translation-{text-py,document-py,ts}`
  - Anomaly detection: `azure-ai-anomalydetector-java`; Content understanding:
    `azure-ai-contentunderstanding-py`
  - Search: `azure-search-documents-{dotnet,py,ts}`
- **Identity & security**: `azure-identity-{dotnet,java,py,rust,ts}`; Key Vault
  `azure-keyvault-py`, `azure-keyvault-{keys,secrets,certificates}-rust`,
  `azure-keyvault-{keys,secrets}-ts`, `azure-security-keyvault-{keys}-{dotnet,java}`,
  `azure-security-keyvault-secrets-java`
- **Storage**: Blob `azure-storage-blob-{java,py,rust,ts}`; File `azure-storage-file-share-{py,ts}`,
  Data Lake Gen2 `azure-storage-file-datalake-py`; Queue `azure-storage-queue-{py,rust,ts}`
- **Databases**: Cosmos DB `azure-cosmos-{java,py,rust,ts}`, `azure-cosmos-db-py` (TDD +
  clean code); Tables `azure-data-tables-{java,py}`; PostgreSQL `azure-postgres-ts`
  (node-postgres); management: `azure-resource-manager-{cosmosdb,mysql,postgresql,redis,sql,
  durabletask,playwright}-dotnet`
- **Messaging / real-time**: Service Bus `azure-servicebus-{dotnet,py,rust,ts}`; Event Hubs
  `azure-eventhub-{dotnet,java,py,rust,ts}`; Event Grid `azure-eventgrid-{dotnet,java,py}`;
  Web PubSub `azure-messaging-webpubsub-java`, `azure-messaging-webpubsubservice-py`,
  `azure-web-pubsub-ts`; Communication Services `azure-communication-{common,chat,sms,
  callautomation}-java` (`callingserver-java` is deprecated → Call Automation)
- **Monitoring / observability**: Monitor query `azure-monitor-query-{java,py}`; ingestion
  `azure-monitor-ingestion-{java,py}`; OpenTelemetry distro/exporter
  `azure-monitor-opentelemetry-{py,ts}`, `azure-monitor-opentelemetry-exporter-{java,py}`
- **Config & app platform**: App Configuration `azure-appconfiguration-{java,py,ts}`;
  Container Registry `azure-containerregistry-py`; Batch `azure-compute-batch-java`; Maps
  `azure-maps-search-dotnet`; Playwright testing `azure-microsoft-playwright-testing-ts`;
  Entra auth events (Functions trigger) `microsoft-azure-webjobs-extensions-authentication-
  events-dotnet`
- **Management (azure-mgmt-*)**: API Center `{dotnet,py}`, API Management `{dotnet,py}`,
  Application Insights `dotnet`, Bot Service `{dotnet,py}`, Fabric `{dotnet,py}`, MongoDB
  Atlas `dotnet`, Weights & Biases `dotnet`, Arize AI observability `dotnet`

## Source

`azure-functions` (vibeship-spawner-skills), `azd-deployment` (community), plus ~100 Azure
SDK cookbooks (template: install → env vars → auth → client → workflow → best practices).
