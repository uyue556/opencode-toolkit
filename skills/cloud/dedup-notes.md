# Deduplication & Merge Notes — `cloud`

Source library: `/home/administrator/.config/opencode/skill-libraries/cloud/` — **144
SKILL.md files** scanned (13 deep-read in full, all others skimmed via frontmatter +
headings). Output: `/home/administrator/.config/opencode/skills/cloud/`.

## What was merged

- **AWS serverless + EDA** → `references/aws-serverless.md`. `aws-serverless` contributed
  Lambda/API Gateway/SQS/DynamoDB-stream patterns, cold-start optimizations, and sharp
  edges; `aws-serverless-eda` contributed the Well-Architected serverless lens (speedy
  simple singular, concurrency thinking, state machines, idempotency, DLQ/observability).
  Cold-start content overlapped heavily — kept one merged priority list.
- **AWS IaC** → `references/aws-iac.md`. Merged `aws-cdk-development` (naming rule,
  cdk-nag validation, Lambda constructs), `cdk-patterns` (L2-over-L1, stack separation),
  `cloudformation-best-practices` (DeletionPolicy, Conditions, `!Sub`), and
  `aws-sst-development` (SST v4/Ion conventions, `$interpolate` trap, two-PR migrations).
  Several duplicate "least privilege / RemovalPolicy / cdk diff" bullets collapsed.
- **AWS cost** → `references/aws-cost-ops.md`. Merged `aws-cost-optimizer` (CLI analysis
  commands), `aws-cost-cleanup` (cleanup workflow, safety checklist, scripts), and
  `aws-cost-operations` (MCP servers, observability/audit). Overlapping "delete unattached
  EBS / old snapshots / idle EC2 / EIPs" lists merged into one quick-wins list; duplicate
  "test in non-prod / verify before deletion" safety advice merged.
- **AWS context & MCP** → same file, `hf-cloud-aws-context-discovery` (run-first identity
  resolution, SSO warning) + `aws-mcp-setup` (server config) + `aws-agentic-ai`
  (Bedrock AgentCore summary).
- **GCP** → `references/gcp.md`. `gcp-cloud-run` full deep content; `firebase` deep content
  (rules, data modeling, auth, functions v2). The two are unrelated services; kept as
  sections of one GCP file.
- **Azure** → `references/azure.md`. `azure-functions` + `azd-deployment` merged; the ~100
  Azure SDK cookbooks condensed into the shared-patterns section + one index table (they
  are near-identical templates: install → env vars → auth → client → workflow → practices).
- **Multi-cloud / hybrid / cost / networking / mesh** → `references/multi-cloud.md`.
  Merged `cloud-architect` + `multi-cloud-architecture` (service comparison, patterns),
  `hybrid-cloud-architect` (private clouds, placement), `cost-optimization` (FinOps
  framework by provider), `hybrid-cloud-networking` (VPN/Direct Connect/ExpressRoute), and
  `istio-traffic-management` (templates). Heavy overlap between `cost-optimization` and
  `aws-cost-*` — the AWS-specific savings numbers live in `aws-cost-ops.md`, the
  cross-provider framework in `multi-cloud.md`.
- **rclone** → `references/rclone.md`. Condensed `rclone-cli` SKILL.md (its 2.3 MB
  references/ are converted official docs; not copied, linked to rclone.org instead).

## Notable duplicates dropped

- `aws-skills` — 28-line stub pointing back to its GitHub repo; no unique content. Dropped.
- `azure-communication-callingserver-java` — self-marked **DEPRECATED**, renamed to Call
  Automation; index notes the rename instead of carrying the old skill.
- ~100 Azure SDK skills are high-duplication templates (same auth/`DefaultAzureCredential`
  guidance, same "env vars" and "best practices" structure across languages). Merged into
  shared patterns + index; per-language detail remains in the source library.
- `aws-cost-optimizer` vs `aws-cost-operations` vs `cost-optimization` vs `aws-cost-cleanup`
  — four cost skills with overlapping lists; consolidated to two files by scope (AWS vs
  cross-cloud).
- `cloud-architect` vs `hybrid-cloud-architect` — largely overlapping capability lists
  (both cover multi-cloud IaC/FinOps/DR); merged, kept hybrid-specific extras (OpenStack,
  workload placement).
- `azure-ai-formrecognizer-java` = older name of Document Intelligence; indexed under it.
- Marketing preamble, "You are an expert in…" role text, and repeated
  "When to Use / Limitations" boilerplate stripped from all merged content.

## Scripts carried over

`scripts/` created from inline snippets in `aws-cost-cleanup` (the only source with
reusable deterministic code; no `scripts/` directories existed anywhere in the library):
- `cleanup-unused-ebs.sh`, `cleanup-old-snapshots.sh`, `release-unused-eips.sh`,
  `calculate-savings.py`. All default to dry-run/list; destructive lines commented out.

## Gaps / doubts

- **Azure SDK detail depth**: only headings + representative samples of ~15 SDK skills
  were read; the consolidated index maps every one of the ~100 but the per-service code
  examples live in the source library, not here. If a user needs deep SDK code, point them
  to `/home/administrator/.config/opencode/skill-libraries/cloud/`.
- **amazon-alexa** (18 KB, Portuguese) is a niche "build an Alexa skill whose backend is a
  Claude assistant" walkthrough — included as a source-skill link in dedup notes but not
  summarized; it does not fit the cloud-engineering theme. Could be a separate skill.
- **rclone references/** (~2.3 MB converted official docs) intentionally not copied per the
  "ignore bloated assets" rule; official URLs provided instead.
- **aws-cost-ops / azure** pricing figures (SnapStart init billing, Savings Plan
  percentages, RI savings) come from source skills and are subject to change — verify
  current numbers against provider docs before quoting them to users.
- `aws-agentic-ai` had references/scripts not present in the repo dump; summarized from its
  SKILL.md headings only.
