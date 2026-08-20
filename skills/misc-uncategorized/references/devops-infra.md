# DevOps, Infra & Security

Consolidates: ci-cd-and-automation, prometheus-configuration, linkerd-patterns, network-engineer,
cloudflare-security-audit, supply-chain-risk-auditor, repo-maintainer, resolving-merge-conflicts,
github, debug-buttercup, monte-carlo (see ml-media-tools).

## 0. Routing

- CI/CD pipelines & quality gates → §1. Monitoring → §2 (Prometheus). Service mesh → §3.
- Networking → §4. Security audits → §5-6. Repo hygiene → §7. Git conflicts → §8. GitHub CLI → §9.
- Kubernetes debugging → §10.

## 1. CI/CD & Automation

Build the quality-gate pipeline: lint → typecheck → unit tests → integration (DB-backed) → E2E →
deploy preview. GitHub Actions basics: `ci.yml` with jobs (checkout, setup, install, run checks);
DB-backed integration tests (services containers); E2E jobs.
Feeding CI failures back to agents: structured failure output so an agent can fix. Deployment
strategies: preview deployments on PR (Vercel/Netlify), feature flags, staged rollouts, rollback
plan (manual rollback workflow). Environment management: per-env secrets, env-specific config.

## 2. Prometheus Configuration

Architecture: apps instrumented with client libs → `/metrics` → Prometheus scrapes → AlertManager/
Grafana/Thanos. Install: Helm (`kube-prometheus-stack`), Docker Compose. `prometheus.yml`:
`scrape_interval`, `evaluation_interval`, `external_labels`, alertmanager targets, rule_files,
scrape configs (static targets, file-based SD, Kubernetes SD). Recording rules for
precomputation. Retention + storage sizing.

## 3. Linkerd Patterns

Lightweight security-first service mesh for Kubernetes. Core concepts: architecture (data plane +
control plane), key resources (ServiceProfiles, policies). Templates: mesh installation
(`linkerd install`, CRDs, control plane, viz extension), namespace injection (automatic), mTLS,
traffic split. Validate cluster before install.

## 4. Network Engineer

Modern cloud networking, security architectures, performance optimization. Capabilities: cloud
networking, modern load balancing, DNS & service discovery, SSL/TLS & PKI, network security,
service mesh & container networking, performance optimization, advanced protocols, troubleshooting
& analysis, infrastructure integration, monitoring/observability, compliance, DR/BC.

## 5. Cloudflare Security Audit

Audit authorized codebases for exploitable vulnerabilities. Core principles: only report what you
can exploit; confirm dynamically when you can; determine baseline dynamically; defense-in-depth
gaps are not vulnerabilities; severity requires impact. Workflow: platform terminology, setup,
coverage and prior runs, exploit-first reporting. Anti-patterns to avoid: unverified claims,
reporting out of scope, severity inflation.

## 6. Supply Chain Risk Auditor

Identify dependencies at heightened risk of exploitation or takeover. Risk criteria (abandoned
projects, single-maintainer, unmaintained, history of CVEs, typo-squatting potential). Workflow:
initial setup → dependency audit (manifest lockfiles, transitive deps, registry metadata) →
post-audit (prioritized findings, remediation suggestions, monitoring).

## 7. Repository Maintainer

Audit and repair repo hygiene: artifacts & git hygiene, dependencies & packaging, CI & release
health, docs & repository metadata, code-quality signals. Workflow: establish baseline → audit
independent lanes → produce prioritized decision set → apply authorized repairs → validate and
publish safely. Stop condition + repository policy gate.

## 8. Resolving Merge Conflicts

Use when resolving an in-progress git merge/rebase conflict: identify conflict markers, understand
both sides, choose the correct resolution, verify with tests. Keep changes minimal; do not
blindly accept either side.

## 9. GitHub CLI (gh)

- PR checks: `gh pr checks <n> --repo owner/repo`.
- CI debugging sequence: check failing checks → `gh run list --limit 10` → `gh run view <id>` →
  `gh run view <id> --log-failed`.
- Advanced: `gh api repos/o/r/pulls/55 --jq '.title,.state,.user.login'`; JSON output + `--jq`
  filtering (`gh issue list --json number,title --jq ...`).

## 10. Debug Buttercup (Kubernetes pods)

Triage pods in namespace `crs` in CrashLoopBackOff/OOMKilled/restarting. Triage workflow: pod
status (restarts, CrashLoopBackOff, OOMKilled) → events (the timeline) → warnings only (filter
noise) → why did a pod restart (Last State Reason) → actual resource limits vs intended →
crashed container logs (`--previous`) → current logs. Historical vs ongoing issues; cascade
detection.
