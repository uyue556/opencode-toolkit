# Deduplication Notes — Security Skill Consolidation

Records how the 72 source skills under `/home/administrator/.config/opencode/skill-libraries/security/` were
merged into the single consolidated `security` skill.

## Merged Topics (source → consolidated reference)

| Consolidated reference | Merged source skills |
|------------------------|----------------------|
| `references/web-appsec.md` | top-web-vulnerabilities, sql-injection-testing, xss-html-injection, html-injection-testing, file-path-traversal, file-uploads, idor-testing, broken-authentication, constant-time-analysis |
| `references/authn-authz.md` | auth-implementation-patterns, mtls-configuration, secrets-management, broken-authentication |
| `references/offensive-testing.md` | ethical-hacking-methodology, pentest-checklist, pentest-commands, red-team-tools, red-team-tactics, metasploit-framework, ffuf-web-fuzzing, burp-suite-testing, burpsuite-project-parser, shodan-reconnaissance, smtp-penetration-testing, ssh-penetration-testing, linux-privilege-escalation, scanning-tools, vulnerability-scanner |
| `references/sast-supply-chain.md` | sast-configuration, semgrep-rule-creator, semgrep-rule-variant-creator, security-scanning-security-sast, security-scanning-security-dependencies, dependency-management-deps-audit, gha-security-review |
| `references/container-security.md` | container-security-hardening, security-and-hardening (container parts) |
| `references/malware-forensics.md` | malware-analyst, reverse-engineer, binary-analysis-patterns, anti-reversing-techniques, protocol-reverse-engineering, firmware-analyst, bumblebee, varlock, memory-forensics, wireshark-analysis |
| `references/frontend-security.md` | frontend-security-coder, developer-signup-flow |
| `references/compliance-audit.md` | pci-compliance, gdpr-data-handling, security-compliance-compliance-check, privacy-by-design, audit-skills, cyber-audit, security-auditor, production-audit, skill-audit, security-bluebook-builder, fsi-compliance-checker (controls), security-and-hardening (review checklist) |
| `references/threat-modeling.md` | security-requirement-extraction, threat-mitigation-mapping, threat-modeling-expert, attack-tree-construction |
| `references/stride-pasta-guide.md` | 007 (threat modeling parts), stride-analysis-patterns, threat-modeling-expert (STRIDE/PASTA content) |
| `references/ai-agent-security.md` | 007 (AI agent reference), ai-agent-security content |
| `references/api-security-patterns.md` | 007 (API reference), api security content |
| `references/incident-playbooks.md` | 007 (incident reference), incident response content |

## Notable Duplicates Identified

- **ffuf-claude-skill vs ffuf-web-fuzzing**: `ffuf-claude-skill` is a near-empty shell that only
  links an external GitHub repo (`github.com/jthack/ffuf_claude_skill`). Content covered by
  `ffuf-web-fuzzing`. Dropped the shell; merged ffuf usage into `offensive-testing.md`.
- **varlock-claude-skill vs varlock**: `varlock-claude-skill` is a near-empty shell linking an
  external repo (`github.com/wrsmith108/varlock-claude-skill`). Merged malware-profile content into
  `malware-forensics.md`; dropped the shell.
- **pentest-checklist / pentest-commands / red-team-tools / red-team-tactics**: heavy overlap on
  methodology, tooling, and command lists. Merged into one `offensive-testing.md` reference.
- **threat-modeling-expert / stride-analysis-patterns / attack-tree-construction / threat-mitigation-mapping / security-requirement-extraction / 007**: overlapping threat-modeling guidance. Consolidated STRIDE/PASTA into `stride-pasta-guide.md`, and requirement/mitigation mapping into `threat-modeling.md`.
- **security-scanning-security-sast vs sast-configuration**: both SAST configuration; merged.
- **security-scanning-security-dependencies vs dependency-management-deps-audit**: both dependency
  auditing; merged into `sast-supply-chain.md`.
- **security-and-hardening vs container-security-hardening / web-appsec**: three-tier boundary and
  OWASP patterns overlap with container and web references; merged by topic.
- **security-bluebook-builder**: unique enough (living evidence register) but small; folded into
  `compliance-audit.md` as the bluebook workflow.
- **burp-suite-testing vs burpsuite-project-parser**: overlap on Burp usage; merged, including
  project-file parsing note.
- **audit-skills / cyber-audit / security-auditor / production-audit / skill-audit**: all audit
  methodology; merged into `compliance-audit.md` audit methodology section.
- **memory-forensics / wireshark-analysis / malware-analyst / reverse-engineer / binary-analysis-patterns / firmware-analyst**: adjacent forensics/RE topics; merged into `malware-forensics.md`.

## Skills Dropped

- `ffuf-claude-skill` — empty shell pointing to external repo; content fully covered by `ffuf-web-fuzzing`.
- `varlock-claude-skill` — empty shell pointing to external repo; content fully covered by `varlock`.
- `xss-html-injection` / `html-injection-testing` — distinct-sounding but near-duplicate XSS/HTML-injection guidance; both merged into `web-appsec.md` (no loss).

## Scripts

- **No `scripts/` carried over.** A `find` across the entire source library found zero `scripts/`
  directories and no deterministic script files (only `.md` and `.json` assets). The source skills
  were documentation-only, so `scripts/` is intentionally empty in the consolidated skill.

## Notes

- Seccomp profile template (`seccomp-profile-template.json`) is kept as a JSON asset reference, not
  a script.
- All 007 reference files were kept near-verbatim (they are already high-quality deep guides) with a
  Table of Contents added where they exceed ~300 lines.
