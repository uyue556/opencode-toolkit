# Threat Modeling: Requirements & Mitigation Mapping Reference

> Complement to `stride-pasta-guide.md` (STRIDE/PASTA/attack trees). Covers turning threats into testable security requirements and mapping mitigations to specific threats.
> Sources: security-requirement-extraction, threat-mitigation-mapping, threat-modeling-expert, attack-tree-construction.

## Table of Contents

- [Workflow Overview](#workflow-overview)
- [Extracting Security Requirements](#extracting-security-requirements)
- [Mapping Threats to Mitigations](#mapping-threats-to-mitigations)
- [Requirement & Mitigation Templates](#requirement--mitigation-templates)
- [Common Pitfalls](#common-pitfalls)

---

## Workflow Overview

1. Model the system (STRIDE/PASTA per `stride-pasta-guide.md`; build attack trees for high-risk components).
2. For each identified threat, extract a **testable security requirement**.
3. For each requirement, map one or more **mitigation controls** (architectural, code, config, detection).
4. Record every mapping so audits can trace threat → requirement → control → evidence.
5. Re-run when the system changes (new endpoints, new data flows, new trust boundaries).

## Extracting Security Requirements

- A good requirement is **specific, testable, and attributed to a threat**. Avoid vague demands like "be secure."
  - Bad: "The API must be secure."
  - Good: "Requirement REQ-AUTH-01: Every object-access endpoint MUST verify the caller owns the target object (or holds an explicit role granting access), enforced server-side, with an automated test for cross-tenant access."
- Derive requirements from each STRIDE element and each attack-tree leaf:
  - Spoofing → authentication + identity-binding requirement.
  - Tampering → integrity protection + signing + FIM requirement.
  - Repudiation → audit logging requirement.
  - Information disclosure → encryption + access control + redaction requirement.
  - DoS → rate limiting + quota + resource limits requirement.
  - Elevation of privilege → authorization + least privilege + input validation requirement.
- Add non-functional requirements: logging retention, key rotation cadence, incident-response triggers.

## Mapping Threats to Mitigations

- Each threat should map to a **primary mitigation** (prevents or blocks) and, where valuable, a **secondary/defense-in-depth** control (detects or reduces impact).
- Apply the STRIDE → mitigation pattern:
  - **Spoofing** → strong authN, mTLS, session integrity, WebAuthn.
  - **Tampering** → signatures/HMAC, integrity hashes, immutable storage, FIM.
  - **Repudiation** → tamper-evident audit logs, non-repudiation signing.
  - **Information disclosure** → encryption at rest/in transit, RBAC, data minimization, output encoding.
  - **DoS** → rate limiting, quotas, pagination, WAF, autoscaling limits, ReDoS-safe regex.
  - **Elevation of privilege** → least privilege, authorization checks, input validation, sandboxing.
- When a mitigation already exists, verify coverage and note gaps; do not duplicate the same control across many threats without confirming it actually applies.

## Requirement & Mitigation Templates

**Requirement register entry**

```
REQ-{ID}: {component} MUST {behavior} when {condition}.
Threat: {STRIDE element / attack-tree path}
Rationale: {why; tied to data flow or trust boundary}
Test: {automated test or manual check}
Owner: {team}
Priority: {Critical/High/Medium/Low}
Status: Proposed / Implemented / Verified / Accepted risk
```

**Mitigation mapping entry**

```
THREAT-{ID}: {description}
Primary mitigation: {control; where implemented; config/code ref}
Defense-in-depth: {detection control; monitoring/alert}
Evidence: {test result, config snapshot, code path}
Residual risk: {accepted or needs closure; owner; due date}
```

## Common Pitfalls

- Threat lists without requirements → nothing testable, nothing enforced.
- Mitigations documented but never implemented/verified → treat as absent.
- Copy-pasting controls across threats without confirming applicability.
- Ignoring new/changed trust boundaries after feature changes.
- No owner or due date on residual risk → accepted risk becomes forgotten risk.
