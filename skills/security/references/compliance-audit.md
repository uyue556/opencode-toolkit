# Compliance & Security Audit Reference

> Consolidated guidance for regulatory compliance engineering (PCI-DSS, GDPR, FSI/MAS-TRM), privacy by design, and security auditing.
> Sources: pci-compliance, fsi-compliance-checker, gdpr-data-handling, security-compliance-compliance-check, privacy-by-design, audit-skills, cyber-audit, security-auditor, production-audit, skill-audit, security-bluebook-builder, frontend-security-coder, developer-signup-flow.

## Table of Contents

- [Framework Cheat-Sheet](#framework-cheat-sheet)
- [PCI-DSS Engineering Controls](#pci-dss-engineering-controls)
- [GDPR / Data Handling](#gdpr--data-handling)
- [Privacy by Design](#privacy-by-design)
- [FSI / MAS-TRM](#fsi--mas-trm)
- [Security Audit Methodology](#security-audit-methodology)
- [Compliance-to-Code Workflow](#compliance-to-code-workflow)

---

## Framework Cheat-Sheet

- **PCI-DSS**: payment card data (PAN, expiry, CVV2). Scope: any system storing/processing/transmitting cardholder data or affecting its security.
- **GDPR**: personal data of EU residents. Core duties: lawful basis, DPIA for high-risk, data minimization, breach notification (72h), DPO where applicable, cross-border transfer safeguards.
- **MAS-TRM (FSI)**: Singapore MAS technology risk management — cybersecurity, data integrity, outsourcing, business continuity for financial institutions.
- Map requirements to *engineering controls* (config, code, tests) — compliance is satisfied by implementation, not documentation alone.

## PCI-DSS Engineering Controls

- **Encryption**: encrypt PAN at rest (strong crypto, key mgmt) and in transit (TLS 1.2+, strong ciphers). Never store CVV2 or PIN.
- **Access control**: least privilege, unique IDs, MFA for admin, revoke on termination; audit logging of access to cardholder data.
- **Network**: firewall default-deny, restrict cardholder-data environments (CDE) with segmentation; no default passwords.
- **Vulnerability management**: maintain inventory, patching schedule, authenticated/internal + external scans, penetration tests.
- **Monitoring**: FIM on critical files, alerting on anomalies, log retention (12 months active + 18 months archived typical).
- See `pci-dss.md` for a full engineering control reference.

## GDPR / Data Handling

- **Identify personal data flows**: what is collected, stored, processed, shared, retained, deleted.
- **Data minimization**: collect only what is necessary; pseudonymize/anonymize where feasible; define retention and deletion schedules and implement them (automated cleanup).
- **DPIA**: run for high-risk processing (large scale, sensitive data, profiling, tracking).
- **Breach readiness**: 72-hour notification workflow with internal contact list and template (see `incident-playbooks.md`).
- **Cross-border transfers**: verify safeguards (SCCs, adequacy) before transferring personal data.
- **Engineering**: audit logs, access controls, encryption at rest/in transit, secure deletion (not just `rm`), logging minimization (don't log raw personal data).

## Privacy by Design

- Embed privacy at architecture time: data minimization, purpose limitation, user control, default-privacy settings.
- Consent: explicit, informed, revocable; treat "opt-out" equally.
- Avoid: collecting data "just in case"; storing more than needed; tracking by default.
- Provide clear user-facing transparency (notices) and deletion/export (right-to-erasure/portability) mechanisms implemented as features, not afterthoughts.

## FSI / MAS-TRM

- Engineering controls mapped from `mas-trm.md`: secure SDLC, security monitoring/SoC, data encryption, BCM (backup/DR tested), vendor/outsourcing security, access management.
- For financial institutions: strong authentication for customer-facing and admin access; anomaly detection; periodic independent security testing.
- BCM: documented RPO/RTO, tested recovery, risk acceptance by management.

## Security Audit Methodology

- **Audit scope**: define in-scope systems/data (from inventory), controls, and framework requirements.
- **Evidence-based**: every claim backed by configs, logs, code, tests, or interviews; note evidence for each control.
- **Gap analysis**: map controls → requirements → status (implemented / partial / missing) with severity.
- **Test controls, don't just read them**: spot-check configs against running systems, review actual code paths.
- **Production audit**: review deployment/config drift, secrets in prod, runtime permissions, backup/DR validity, dependency status, and public exposure (see `offensive-testing.md` for safe checks; only with authorization).
- **Skill/agent audit**: verify an agent or skill does not exfiltrate data, run arbitrary code outside scope, or misuse credentials; check its scripts for unsafe shell interpolation and secret handling.
- **Output**: risk register with owner, due date, and severity; executive summary; evidence appendix; re-audit plan.

## Compliance-to-Code Workflow

1. Extract the specific requirement from the framework (e.g., "encrypt PAN at rest").
2. Translate to a testable engineering control (e.g., "AES-256 at rest via KMS; assert in deployment pipeline").
3. Implement control + automated test + monitoring alert.
4. Document the mapping in the security bluebook so auditors can trace requirement → control → evidence.
5. Maintain a living security bluebook (architecture, data flows, control inventory, accepted risks) as the single source of truth for compliance evidence.
