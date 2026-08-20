# AWS Infrastructure as Code (CDK · CloudFormation · SST)

Merges `aws-cdk-development`, `cdk-patterns`, `cloudformation-best-practices`, and
`aws-sst-development` (SST v4 / Ion, Pulumi-backed). Use when writing or reviewing AWS IaC.

## AWS CDK

### Core rules

- **Never set optional explicit resource names** (`functionName`, `restApiName`,
  `eventBusName`, …). Let CDK generate unique names → patterns stay reusable, parallel
  deployments don't collide, stack isolation is free. Use separate AWS accounts per
  environment for security boundaries (Security Pillar), not naming tricks.
- **Prefer L2/L3 constructs over L1 `Cfn*`** — safer defaults, less boilerplate.
- Use the right Lambda construct: `NodejsFunction` (bundling/transpilation automatic) for
  TS/JS, `PythonFunction` for Python.
- `RemovalPolicy` + `Tags` on everything; `RemovalPolicy.RETAIN` for stateful resources.
- Separate stateful (DBs, buckets) from stateless (compute/API) stacks; use `cdk diff`
  before every deploy; `cdk.Aws.ACCOUNT_ID`/`REGION` instead of hardcoding.

### Pre-deployment validation (3 layers)

1. **cdk-nag** (`Aspects.of(app).add(new AwsSolutionsChecks())`) for synthesis-time
   checks; suppress only with a documented `reason`.
2. **`cdk synth`** then review the generated template; run build + unit/snapshot tests.
3. **`cdk diff`** review before `cdk deploy`.

### Stack organization & troubleshooting

- Nested stacks for complex apps; export shared values via `Outputs`; use CDK context for
  per-environment config.
- Circular dependency between stacks → extract shared resources into a base stack and pass
  references via constructor props.

## CloudFormation (raw templates)

- YAML over JSON; `Parameters` for env-specific values, `Mappings` for static lookups,
  `Conditions` for multi-environment templates.
- `DeletionPolicy: Retain` + `UpdateReplacePolicy` on stateful resources (RDS, S3,
  DynamoDB).
- Use `!Sub` over `!Join`; use `!Sub` with pseudo-parameters instead of hardcoded ARNs /
  account IDs.
- Validate with `aws cloudformation validate-template`; run `cfn-lint` and `cfn-nag` in CI.
- Use `Outputs` + `Export` for cross-stack references; avoid one monolithic template.
- `UPDATE_ROLLBACK_FAILED` → `aws cloudformation continue-update-rollback
  --resources-to-skip <failing resource>`, fix root cause, retry.

## SST v4 (Ion)

SST v4 is a Pulumi-backed framework: `sst.aws.*` components (Function, Bucket, Dynamo,
Cron, Service, Router), `sst.Secret`, `sst.Linkable`, plus raw Pulumi `aws.*` resources as
the escape hatch. Verify SST/Pulumi syntax with Context7 and AWS-side facts with docs MCP —
never from memory.

### House conventions (universal for SST v4 + AWS)

- **Control Node runtime in one place** via a global transform in `run()`:
  `$transform(sst.aws.Function, (args) => { args.runtime ??= "nodejs24.x" })`.
- **Never interpolate a Pulumi `Output<T>` into a plain JS template literal** — it
  stringifies to `[Output<T>]` and produces a broken ARN that only fails at deploy. Use
  `$interpolate`/`pulumi.interpolate`.
- **Type migrations = two PRs.** Pulumi creates-before-destroys, so a uniqueness-constrained
  name blocks the create with `ConflictException`; teardown then recreate is the safe
  default (`aliases:`/`pulumi import` only with a reviewed plan).
- Prefer typed `sst.aws.*`/`aws.*` over `aws.cloudcontrol.Resource` (stringly-typed, poor
  `oneOf` patching).

### Project-specific defaults (confirm per repo)

- Region ap-northeast-1, `home: "aws"`, `defaultTags` (Project/Stage/ManagedBy).
- Stage-gated lifecycle: `removal: stage === "prod" ? "retain" : "remove"`,
  `protect: stage === "prod"`.
- Same-app sharing via `link:` (real dependency edge + IAM); SSM Parameter Store
  (`/{app}/{stage}/{domain}/...`) only for consumers outside the Pulumi graph (CI, sibling
  apps).
- Lazy `await import("./infra/<module>")` inside `run()`; source-level Vitest assertions in
  `infra/tests/`; observability gate (alarm + structured logging) on every new
  function/queue/schedule.
- Confirm account with `aws sts get-caller-identity` before `sst deploy`; `npx sst diff`
  and `tsc --noEmit` before deploying; clean up exported state files (they contain account
  IDs/ARNs).

## Source

`aws-cdk-development` (zxkane/aws-skills, MIT), `cdk-patterns` (community),
`cloudformation-best-practices` (community), `aws-sst-development` (zxkane/aws-skills, MIT).
