---
name: security
description: >-
  Consolidated security engineering skill. Use when asked to audit, review, harden, threat-model, or
  test any application, API, container, Kubernetes deployment, CI/CD pipeline, or AI/LLM agent for
  security. Triggers: security review, security audit, penetration test, pentest, threat modeling,
  threat model, vulnerability assessment, hardening, secure coding, authentication, authorization,
  secrets management, SAST, dependency audit, supply chain security, container security, Kubernetes
  security, malware analysis, reverse engineering, incident response, security compliance, PCI,
  GDPR, privacy, OWASP, CWE, CVE, XSS, SQL injection, SSRF, IDOR, CSRF, security 安全, 漏洞, 渗透, 安全审计,
  威胁建模, 加固, 等保, 合规.
  Use only for defensive security work or for authorized offensive testing (see AUTH GATE below).
---

# Security Engineering Skill

Consolidated security guidance for auditing, hardening, threat modeling, and (only when authorized)
offensive testing of applications, APIs, infrastructure, and AI/LLM systems.

## When to Use

Use this skill for any security task, including:

- **Code review / security audit** — find vulnerabilities in app code, configs, IaC, CI/CD.
- **Threat modeling** — structured analysis (STRIDE/PASTA), attack trees, requirements.
- **Hardening** — Docker/Kubernetes, servers, frontends, authn/authz, secrets.
- **Vulnerability assessment** — scanning, dependency/SAST triage, exploitation planning (authorized only).
- **Incident response & forensics** — containment playbooks, malware/memory/network analysis.
- **Compliance** — PCI-DSS, GDPR, MAS-TRM, privacy by design, security audit evidence.
- **AI/LLM security** — prompt injection, agent isolation, tool security, supply chain.

## How to Use This Skill

1. Identify the security task type from the request (audit / threat-model / harden / test / respond / comply).
2. Load the matching reference file below for deep guidance.
3. Follow the task-type workflow; always apply the AUTH GATE before any offensive action.
4. Return findings with severity, evidence, reproduction steps, and remediation.

## Reference Library (route by task)

| Task | Reference |
|------|-----------|
| Web app review / SQLi / XSS / IDOR / file uploads / path traversal / broken auth | `references/web-appsec.md` |
| Authn / authz / mTLS / passwords / sessions / secrets management | `references/authn-authz.md` |
| Threat modeling (STRIDE/PASTA/attack trees) | `references/stride-pasta-guide.md` |
| Threat → requirements & mitigation mapping | `references/threat-modeling.md` |
| API security / webhooks / rate limiting / CORS / BOLA | `references/api-security-patterns.md` |
| Offensive / pentest / red team / nmap / ffuf / Burp / privesc | `references/offensive-testing.md` |
| SAST / Semgrep / dependency audit / GitHub Actions | `references/sast-supply-chain.md` |
| Container / Dockerfile / runtime / Kubernetes security | `references/container-security.md` |
| Kubernetes pod security deep dive | `references/kubernetes-pod-security.md` |
| Base image selection matrix | `references/base-image-comparison.md` |
| Seccomp profile template | `references/seccomp-profile-template.json` |
| Malware / reverse engineering / firmware / memory & network forensics | `references/malware-forensics.md` |
| AI/LLM agents — prompt injection, isolation, tools, guardrails | `references/ai-agent-security.md` |
| Frontend security / signup / OAuth / API key UX | `references/frontend-security.md` |
| Compliance — PCI-DSS / GDPR / MAS-TRM / privacy / audit methodology | `references/compliance-audit.md` |
| PCI-DSS engineering controls | `references/pci-dss.md` |
| MAS-TRM engineering controls | `references/mas-trm.md` |
| OWASP Top 10 checklists | `references/owasp-checklists.md` |
| General security checklists | `references/checklists.md` |
| Incident response playbooks | `references/incident-playbooks.md` |

## Core Working Rules

- **Default deny**: when unsure whether an action is safe or authorized, do the safe/read-only thing.
- **Never** log, print, or commit secrets; redact them in output.
- **Never** execute suspicious binaries or run scans against systems you lack written authorization for.
- **Evidence over assertions**: every finding needs a code/config/run reference that reproduces it.
- **Fix the root cause**, not the symptom; propose remediation with the codebase's conventions.
- When audit findings conflict, verify against the actual system before reporting.

## Offensive Playbooks — Mandatory Auth Gate

Applies to ANY probe, scan, or exploit in `references/offensive-testing.md` and any exploitation step elsewhere:

> **⚠️ AUTHORIZED USE ONLY.** Offensive playbooks MUST NOT be executed against systems you do not have
> explicit written authorization to test.

Before running any offensive action against a real target:
1. State the exact target URL/IP/account and the authorization you hold for it.
2. Confirm written authorization and scope (IPs, domains, hosts, in-scope accounts).
3. Show the exact command and its expected effect.
4. Wait for explicit user confirmation. Until confirmed, keep work read-only and defensive.

Never run `--privileged`, destructive exploits, or persistence against targets without explicit authorization.

## Task Workflows

### 1. Security Audit / Code Review

1. Map the scope: what is in scope (repo, endpoints, data flows, trust boundaries).
2. Follow `references/web-appsec.md` (injection, XSS, IDOR, uploads, auth) and `references/api-security-patterns.md` for APIs.
3. Check authn/authz per `references/authn-authz.md`; secrets in code; SAST + dependency status per `references/sast-supply-chain.md`.
4. Report: severity-ranked findings with evidence and remediation; include items checked-and-clean.

### 2. Threat Modeling

1. Run STRIDE/PASTA per `references/stride-pasta-guide.md`; build attack trees for high-risk components.
2. Extract testable requirements and map mitigations per `references/threat-modeling.md`.
3. For AI/LLM systems, add the agent-specific checklist in `references/ai-agent-security.md`.
4. Output: threat register with threat → requirement → control → evidence.

### 3. Hardening

- Containers/K8s: `references/container-security.md` + `kubernetes-pod-security.md` + `base-image-comparison.md` + `seccomp-profile-template.json`.
- Authn/z, passwords, sessions, mTLS, secrets: `references/authn-authz.md`.
- Frontend: `references/frontend-security.md`.
- Always verify: least privilege, non-root, immutable/pinned, default-deny, monitoring.

### 4. Vulnerability Assessment (authorized)

1. Apply the AUTH GATE.
2. Recon → scan → enumerate → verify per `references/offensive-testing.md`.
3. Confirm every scanner finding manually before reporting.

### 5. Incident Response & Forensics

1. Follow the relevant playbook in `references/incident-playbooks.md` (Contain → Assess → Remediate → Prevent → Document).
2. Collect evidence via `references/malware-forensics.md` (memory, disk, network).
3. Notify per compliance requirements (e.g., GDPR 72h) per `references/compliance-audit.md`.

### 6. Compliance

1. Identify applicable framework(s) — PCI-DSS / GDPR / MAS-TRM per `references/compliance-audit.md`.
2. Map to engineering controls (`pci-dss.md`, `mas-trm.md`) and verify with evidence.
3. Maintain a traceable requirement→control→evidence register.

## Do NOT Use This Skill When

- The user wants product features unrelated to security (route to the relevant domain skill).
- Only general coding help is requested with no security intent.
- The task is illegal or violates user's organization policy (harmless defensive work and authorized testing are fine).

## Final Output Conventions

- Findings: `[SEVERITY] title — file:line — evidence — remediation`.
- Include a "checked and clean" section so reviewers see coverage.
- Offensive work: always include scope, authorization status, and reproduction evidence.
- Compliance work: always include the requirement mapping and evidence references.
