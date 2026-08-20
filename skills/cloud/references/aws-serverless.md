# AWS Serverless & Event-Driven Architecture

Merges `aws-serverless` (Lambda patterns, cold starts, sharp edges) and `aws-serverless-eda`
(Well-Architected serverless design). Use for anything Lambda/API Gateway/DynamoDB/SQS/SNS/
Step Functions/EventBridge.

## Design principles (Well-Architected serverless lens)

1. **Speedy, simple, singular** — one function, one job. Concise handlers that are
   cost-aware: small packages, right-sized memory, connection reuse.
2. **Think concurrent requests, not total requests.** Lambda scales horizontally; size
   DynamoDB capacity for *concurrency*, enable auto-scaling (`PAY_PER_REQUEST` or
   provisioned + `autoScaleRead/WriteCapacity`).
3. **Share nothing** — function runtimes are short-lived. State goes in DynamoDB (session),
   S3 (files), Step Functions (workflow), ElastiCache (cache); never local disk.
4. **Assume no hardware affinity** — configuration via env vars, no hardware assumptions.
5. **Orchestrate with state machines, not function chaining.** Step Functions give visual
   workflows, built-in retries, history, parallel/sequential steps, and service
   integrations. Avoid Lambda-invokes-Lambda chains.
6. **Use events to trigger transactions** — S3 notifications, EventBridge rules, SNS
   fan-out for loose coupling and independent scaling.
7. **Design for failures and duplicates** — handlers must be idempotent; add an idempotency
   check (e.g. DynamoDB "processed" marker) and retry with exponential backoff.

## Lambda handler patterns

- Initialize SDK clients **outside** the handler (reused across warm invocations).
- Node: `context.callbackWaitsForEmptyEventLoop = false`.
- Return proper API Gateway response shape `{statusCode, headers, body}`; wrap logic in
  try/catch; log structured JSON with `context.awsRequestId` for tracing.
- Python: lazy-init pattern `_table = None; def get_table(): ...` delays heavy init to first
  use.
- Use **modular AWS SDK v3 imports** (`@aws-sdk/client-*`), never the whole `aws-sdk`.
- Table names, env-specific values come from environment variables, not code.

## API Gateway: HTTP vs REST

| | HTTP API | REST API |
|---|---|---|
| Latency | ~10 ms | higher |
| Cost | 50-70% cheaper | higher |
| Features | basic | caching, WAF, usage plans, request validation, transformation |
| Use for | most simple REST APIs | complex/enterprise APIs |

## Reliable async processing (SQS)

- Lambda → SQS with `BatchSize` and `FunctionResponseTypes: [ReportBatchItemFailures]`;
  handler returns `{batchItemFailures: [{itemIdentifier}]}` for the failed records only.
- Set queue `VisibilityTimeout` ≈ 6× Lambda timeout; configure a `RedrivePolicy` DLQ
  (`maxReceiveCount: 3`, 14-day retention) for poison messages.
- Process idempotently — at-least-once delivery means duplicates happen.

## Reacting to data changes (DynamoDB Streams)

- Enable `StreamSpecification` with `StreamViewType` (KEYS_ONLY / NEW_IMAGE / OLD_IMAGE /
  NEW_AND_OLD_IMAGES); `StartingPosition: TRIM_HORIZON`; configure `DestinationConfig
  OnFailure` (DLQ) and `MaximumRetryAttempts`.
- Unmarshall the `dynamodb.NewImage`/`OldImage` (SDK v3 `unmarshall`); branch on
  `eventName` INSERT/MODIFY/REMOVE.

## Cold start optimization (priority order)

1. **Reduce package size** (biggest impact): tree-shake, exclude dev deps, modular SDK v3.
2. **SnapStart** for Java/.NET (`SnapStart: {ApplyOn: PublishedVersions}` +
   `AutoPublishAlias`). Note: since Aug 2025 AWS bills the INIT phase, so this is now also a
   money saver.
3. **Increase memory** — 1 GB gets a full vCPU, faster init.
4. **Delay heavy imports / lazy init**.
5. **Provisioned concurrency** — only as last resort (expensive).
- Track cold starts with a custom metric (`isColdStart` flag → `console.log('COLD_START')`).
- Check CloudWatch `INIT_REPORT` → `Init Duration` ms to measure.

## Local dev & deploy (SAM / CDK)

- SAM: `sam build` → `sam local start-api` → `sam local invoke <Fn> --event events/e.json`
  → `sam deploy --guided`; debug with `--debug-port 5858` + VS Code attach.
- CDK: `cdk init app --language typescript`, `cdk synth`, `cdk diff`, `cdk deploy`; use
  `NodejsFunction` (TS) / `PythonFunction` for automatic bundling.
- Prefer HTTP API SAM resource for simple APIs; add CORS at the API level.

## Sharp edges

- **INIT now billed (Aug 2025)** — see cold-start section; functions with heavy init and
  frequent cold starts cost 10-50% more.
- **Timeouts** — default 3 s, max 900 s. Set to expected duration + buffer; check
  `context.getRemainingTimeInMillis()` and save progress before throwing; set timeouts on
  all downstream HTTP calls.
- **OOM** — forced termination with no catchable exception. Stream large objects (S3
  `GetObjectCommand` response `Body` as async iterable); monitor memory; use
  aws-lambda-power-tuning to find the optimal memory.
- **VPC-attached Lambda** — Hyperplane ENIs removed most overhead, but first cold start
  still pays; use VPC endpoints for DynamoDB/S3 instead of NAT; only attach a VPC when you
  really need RDS/ElastiCache/private resources.
- **Payload limits** — API Gateway 10 MB request/response; Lambda 6 MB sync / 256 KB async.
  Use presigned S3 URLs for uploads/downloads instead of proxying through the API.
- **Recursive invocation** — filter S3 triggers by prefix, write results to a different
  bucket/prefix, add idempotency checks, set `ReservedConcurrentExecutions` as a circuit
  breaker, and alarm on invocation rate.

## Observability

- Enable X-Ray tracing (`tracing: ACTIVE`) and Lambda Powertools
  (`POWERTOOLS_SERVICE_NAME`, `POWERTOOLS_METRICS_NAMESPACE`, `LOG_LEVEL`).
- Alarm on DLQ depth (`metricApproximateNumberOfMessagesVisible`, threshold 1).
- Structured logs → CloudWatch Logs Insights.

## Source

`aws-serverless` (vibeship-spawner-skills), `aws-serverless-eda` (zxkane/aws-skills,
MIT). EDA reference files (patterns, security, observability, deployment) from the latter
are summarized here; full Well-Architected serverless lens:
https://docs.aws.amazon.com/wellarchitected/latest/serverless-applications-lens/
