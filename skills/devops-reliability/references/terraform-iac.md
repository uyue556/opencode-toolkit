# Terraform / OpenTofu (IaC)

Source: `terraform-skill` (devops), `terraform-specialist` (devops),
`terraform-module-library` (devops), `terraform-aws-modules` (devops), `aegisops-ai` (devops,
FinOps/policy audit angles).

## When to use
Writing or reviewing Terraform/OpenTofu modules or configs, structuring multi-environment
deployments, choosing testing/state approaches, or implementing IaC CI/CD. Not for provider API
reference or plain cloud questions.

## Code structure

- Hierarchy: **Resource → Resource Module → Infrastructure Module → Composition**.
- Directory layout: `environments/{prod,staging,dev}/`, `modules/{networking,compute,data}/`,
  `examples/{complete,minimal}/`. `examples/` doubles as documentation and integration test
  fixtures. Keep modules small and single-responsibility.
- Files: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, optional `data.tf`.

## Naming & ordering

- Resources: descriptive (`aws_instance.web_server`); use `"this"` only for singletons
  (`aws_vpc.this`). Variables: prefix context (`vpc_cidr_block`, not `cidr`).
- Resource block order: `count`/`for_each` first → args → `tags` last → `depends_on` →
  `lifecycle` last.
- Variable block order: `description` (always) → `type` → `default` → `validation` →
  `nullable`.

## count vs for_each

| Scenario | Use |
|---|---|
| Boolean create-or-not | `count = condition ? 1 : 0` |
| Fixed identical replication | `count = 3` |
| Items may be reordered/removed | `for_each = toset(list)` |
| Keyed/named access | `for_each = map` |

`for_each` gives stable addresses (removing one AZ only touches that subnet); `count` on an
indexed list recreates everything downstream when the middle is removed.

## Module development

- Standard layout: `README.md`, `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`,
  `examples/{minimal,complete}`, `tests/`.
- Variables: always `description`; explicit `type`; sensible `default`; `validation` for
  complex constraints; `sensitive = true` for secrets; `nullable = false` where null is invalid.
- Outputs: always `description`; mark `sensitive`; return objects for related values.
- Locals trick for safe teardown order: reference the more-deeply-nested resource first via
  `try(...)` so Terraform deletes subnets before CIDR associations.

## Testing strategy

| Situation | Approach | Cost |
|---|---|---|
| Quick syntax | `terraform validate`, `fmt` | Free |
| Pre-commit | + `tflint`, `trivy`, `checkov` | Free |
| Terraform 1.6+, simple logic | built-in `terraform test` | Free–Low |
| Deep integration | Terratest | Low–Med |
| Security/compliance | OPA / Sentinel policy-as-code | Free |
| Cost-sensitive PRs | mock providers (1.7+) | Free |

Testing pyramid: static analysis (cheap) → integration (moderate) → E2E (expensive). For native
tests: `command = apply` when outputs/set-blocks are needed; set-type blocks must use `for`
expressions, not `[0]`.

## CI/CD for IaC

Stage: **Validate → Test → Plan → Apply** (approval for prod). Cost controls: mock providers on
PRs, integration tests only on main, auto-cleanup of test resources, tag all test resources.
Security scanning: `trivy config .` and `checkov -d .` in CI. Never store secrets in variables
(state or vars) — use Secrets Manager/Parameter Store.

## Version management

- Terraform: pin minor `required_version = "~> 1.9"`; providers: pin major `version = "~> 5.0"`;
  modules: exact in prod (`5.1.2`), `~> 5.1` in dev.
- Commit `.terraform.lock.hcl`; update with `terraform init -upgrade` + `plan` review.

## Modern features by version

- 0.13 `try()` — safe fallbacks; 1.1 `nullable=false`, `moved` blocks (refactor w/o destroy);
  1.3 `optional()` defaults; 1.6 native tests; 1.7 mock providers; 1.8 provider functions;
  1.9 cross-variable validation; 1.11 write-only arguments (secrets never in state).

## State management & safety

- Use remote state with locking (S3 + DynamoDB / GCS / Terraform Cloud); never share a state
  file across envs; restrict state access via backend IAM.
- Before `terraform destroy` or state surgery, confirm blast radius and take a state backup;
  prefer `moved`/`import` over manual `state rm` + re-apply.

## FinOps / policy guardrails (aegisops-ai angle)

- Audit for cost drift: tag everything, alert on untagged resources and oversized instances.
- Policy checks (checkov/OPA) for: no default VPC, no `0.0.0.0/0` ingress, encryption enabled,
  least-privilege SG rules. Review resource lifetimes and auto-schedule idle environments off.

## Troubleshooting

- `apply` errors: run `terraform plan -detailed-exitcode`, inspect state for moved resources,
  check provider version constraints, use `terraform refresh` sparingly (v0.15+ = read).
- Drift: `terraform plan` shows unexpected diffs → inspect with `terraform state list` +
  `terraform state show <addr>`; use `terraform import` for existing infra.
