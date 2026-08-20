# SAST, Supply Chain & CI Security Reference

> Consolidated guidance for static analysis (Semgrep/SAST), dependency/supply-chain audit, and CI/CD (GitHub Actions) security.
> Sources: sast-configuration, semgrep-rule-creator, semgrep-rule-variant-creator, security-scanning-security-sast, security-scanning-security-dependencies, dependency-management-deps-audit, gha-security-review.

## Table of Contents

- [SAST Configuration](#sast-configuration)
- [Writing Semgrep Rules](#writing-semgrep-rules)
- [Dependency & Supply Chain Audit](#dependency--supply-chain-audit)
- [GitHub Actions Security](#github-actions-security)
- [Fix-the-Pipeline Order](#fix-the-pipeline-order)

---

## SAST Configuration

- Run SAST on every PR/commit, not just scheduled scans; fail CI on new critical/high findings.
- Configure for the real stack: language, framework, and build tools must match or you get noise.
- Tune rules: baseline existing findings, then fail only on *new* issues (prevent alert fatigue).
- Pair SAST with secret scanning and dependency scanning (below) — SAST alone misses leaked tokens and known CVEs.
- Semgrep: define a baseline (`--baseline-commit`), use rule packs (e.g., `p/default`, `p/security-audit`), and write custom rules for your framework's risky APIs.

## Writing Semgrep Rules

- Rule anatomy: `patterns` (match), `pattern-not` (exclude), `metavariable-regex` (constrain), `message`, `severity`, `fix`.
- Anchor on the **sink** (dangerous call) and require a source (untrusted input) to reduce false positives.
- Example structure:
  ```yaml
  rules:
    - id: no-raw-sql
      languages: [python]
      severity: ERROR
      message: Avoid raw SQL; use parameterized queries.
      patterns:
        - pattern: cursor.execute($SQL, ...)
        - pattern-not: cursor.execute($SQL, ())
      fix: cursor.execute($SQL, ...)  # manual
  ```
- Iterate: run against known-good code, tune `pattern-not`/`metavariable-regex`, then run on a vulnerable sample to confirm it fires.
- Variant creation: derive new rules from an existing one by changing the sink, language, or data-flow pattern (e.g., SQLi → LDAP/NoSQL/XPath injection); keep a shared test corpus.

## Dependency & Supply Chain Audit

- Track all direct and transitive dependencies (lockfiles committed, SBOM generated).
- Scan against known-vulnerability databases (OSV, NVD, advisory feeds) on every change and on schedule.
- Prioritize by exploitability + reachability, not just CVSS: a vulnerable lib never called is lower priority.
- Enforce: no vulnerable critical deps in prod; lockfile pinning; signed/verified packages where possible.
- Detect typo-squatting/name confusion and dependency confusion (private package names leaking to public registries).
- Keep dev/CI tooling patched too — supply chain attacks often hit build-time tools.

## GitHub Actions Security

- Pin actions to full commit SHAs (or verified tags), not `@main`/floating branches — prevent tampered updates.
- Use least-privilege tokens: `permissions: contents: read` minimum; avoid `GITHUB_TOKEN` write scope in pull_request workflows; prefer `pull_request_target` only when explicitly required and safe.
- Never log or echo secrets; use `secrets.*` only in env/args of steps that need them; scrub output.
- Sanitize untrusted inputs (issue/PR title, comments) before shell interpolation — no `${{ }}` directly into `run:` shell without quoting.
- Avoid self-hosted runners for untrusted PRs unless isolated; review third-party action code before adoption.
- Set branch protection and require review/status checks on main.

## Fix-the-Pipeline Order

1. Fix the leak (developer education, gating).
2. Fix the root cause (code), not just the symptom (suppress).
3. Re-scan and confirm no new critical/high findings before merge.
4. Keep a triaged backlog of accepted-risk findings with owners and expiry.
