# AWS Cost, Operations, MCP & Context

Merges `aws-cost-operations`, `aws-cost-optimizer`, `aws-cost-cleanup`, `aws-mcp-setup`,
`hf-cloud-aws-context-discovery`, and `aws-agentic-ai` (Bedrock AgentCore). Use for bills,
budgets, cleanup, observability, and before any AWS work.

## 1. Context discovery — run this first on any AWS task

Resolve the effective profile, region, account, and caller identity using masked CLI
metadata only. Never open/print `~/.aws/credentials`, credential-process output, secret env
vars, access keys, session tokens, or SSO caches.

```bash
aws configure list-profiles
aws configure list --profile "$profile"          # masked metadata + source
aws configure get region --profile "$profile"
aws sts get-caller-identity --profile "$profile" --region "$region"   # validates + Account + Arn
```

- **Region resolution order**: user-named → `aws configure list` → `aws configure get
  region` → ask. Never fall back to a hardcoded default like us-east-1.
- **ARN pattern tells you the principal**: `...user/<name>` = IAM user; `...assumed-role/
  AWSReservedSSO_<...>/<email>` = **SSO** (usually *cannot* create IAM roles — surface this
  immediately so a later `iam:CreateRole` failure becomes a 5-second conversation);
  other assumed-role = depends on the role.
- Report in one or two lines: *"Working with profile `p` in `eu-west-1`, account
  `1234…`. Authenticated via SSO, so we'll reuse an existing IAM role."* Stop on
  credential/profile/region errors.

## 2. Cost optimization workflow

1. **Estimate before deploying** — use AWS Pricing MCP (or `aws ce` data) to estimate
   monthly cost of proposed resources; compare regions; compute TCO.
2. **Baseline** — pull 3-6 months of Cost Explorer data; identify top-5 spend services and
   growth rate.
3. **Quick wins** — delete unattached EBS volumes, release unused Elastic IPs, stop/delete
   idle EC2, delete snapshots > 90 days, abort incomplete multipart uploads.
4. **Strategic** — Reserved Instances / Savings Plans for steady load, Spot for batch/CI,
   rightsize instances from CloudWatch CPU, S3 lifecycle policies, multi-region cost review.
5. **Ongoing** — AWS Budgets + alerts, Cost Anomaly Detection, cost allocation tags, weekly
   review.

### Key CLI commands

```bash
# Cost by service (last 30 days)
aws ce get-cost-and-usage --time-period Start=$(date -d '30 days ago' +%Y-%m-%d),End=$(date +%Y-%m-%d) \
  --granularity MONTHLY --metrics BlendedCost --group-by Type=DIMENSION,Key=SERVICE

# Unattached EBS volumes
aws ec2 describe-volumes --filters Name=status,Values=available \
  --query 'Volumes[*].[VolumeId,Size,VolumeType,CreateTime]' --output table

# Unused Elastic IPs
aws ec2 describe-addresses --query 'Addresses[?AssociationId==null].[PublicIp,AllocationId]' --output table

# Old snapshots (>90 days)
aws ec2 describe-snapshots --owner-ids self \
  --query "Snapshots[?StartTime<='$(date -d '90 days ago' --iso-8601)'].[SnapshotId,StartTime,VolumeSize]" --output table

# Idle EC2 (7-day avg CPU)
aws cloudwatch get-metric-statistics --namespace AWS/EC2 --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value=i-xxx \
  --start-time $(date -u -d '7 days ago' +%Y-%m-%dT%H:%M:%S) --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 86400 --statistics Average

# Budget alert (daily cost > $100)
aws cloudwatch put-metric-alarm --alarm-name high-cost-alert --namespace AWS/Billing \
  --metric-name EstimatedCharges --statistic Maximum --period 86400 --evaluation-periods 1 \
  --threshold 100 --comparison-operator GreaterThanThreshold
```

### Cleanup discipline

- Discovery (read-only) → validation (dependencies, tags, ownership) → execution
  (**dry-run first**) → verification + documentation.
- Safety checklist: dry-run, verify no dependencies, check ownership tags, notify
  stakeholders, snapshot critical data, test in non-prod, rollback plan, log every delete.
- Use S3 lifecycle rules for the rest: 90d → STANDARD_IA, 180d → GLACIER, expire
  noncurrent versions at 30d, `AbortIncompleteMultipartUpload` at 7 days.
- Reusable scripts live in `scripts/` (EBS/snapshot/EIP cleanup + savings calculator).
  Schedule weekly cleanup via Lambda on a cron.

### Operations & observability

- **CloudWatch alarms** on: Lambda error rate > 1%, EC2 CPU > 80%, API Gateway 4xx/5xx
  spikes, DynamoDB throttled requests, ECS task failures, DLQ depth.
- **CloudTrail** for audit: "who deleted this bucket", IAM role changes, failed logins,
  security-group modifications.
- **MCP servers** (see §4) cover Pricing, Cost Explorer, CloudWatch, Billing, Application
  Signals (SLOs/APM), Managed Prometheus, CloudTrail, Well-Architected Security Assessment.

## 3. Bedrock AgentCore (aws-agentic-ai)

Deploy/manage AI agents via AWS Bedrock AgentCore: deploy a **gateway target**, manage
credentials, discover agents/tools through the **Agent Registry**, evaluate agent quality,
and monitor agents. Verify model/region availability with the AWS docs MCP. (See source
skill for the full workflow and runnable templates.)

## 4. AWS MCP servers

Two options:

| Option | Requirements | Capabilities |
|---|---|---|
| **Full AWS MCP Server** | Python 3.10+, `uvx`, valid AWS creds | Execute AWS API calls + docs search |
| **AWS Documentation MCP** | none | docs search only |

- Full server: `uvx mcp-proxy-for-aws@latest https://aws-mcp.us-east-1.api.aws/mcp
  --profile <profile> --metadata AWS_REGION=…` (or `--region`, `--read-only`). IAM
  permissions: `aws-mcp:InvokeMCP`, `aws-mcp:CallReadOnlyTool`, `aws-mcp:CallReadWriteTool`.
- Docs-only: `{"type":"http","url":"https://knowledge-mcp.global.api.aws"}`.
- Check existing config with `/mcp` or `claude mcp list`; verify tools appear
  (`mcp__aws-mcp__*` / `mcp__awsdocs__*`) after a restart.
- Troubleshooting: `uvx not found` → `pip install uv`; `AccessDenied` → IAM policy;
  `InvalidSignatureException` → check `aws sts get-caller-identity`.
- AWS Labs replaced the dedicated CDK MCP server with `awslabs.aws-iac-mcp-server`
  (`claude mcp add aws-iac uvx awslabs.aws-iac-mcp-server@latest`) — covers CDK +
  CloudFormation + IaC patterns.

## Source

`aws-cost-operations`, `aws-cost-optimizer`, `aws-cost-cleanup` (community),
`aws-mcp-setup` (zxkane/aws-skills, MIT), `hf-cloud-aws-context-discovery` (Hugging Face,
Apache-2.0), `aws-agentic-ai` (zxkane/aws-skills, MIT).
