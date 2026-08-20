# Offensive Testing & Red Team Reference

> Consolidated methodology, tooling, and command references for authorized penetration testing and red team operations.
> Sources: ethical-hacking-methodology, pentest-checklist, pentest-commands, red-team-tools, red-team-tactics, metasploit-framework, ffuf-web-fuzzing, burp-suite-testing, burpsuite-project-parser, shodan-reconnaissance, smtp-penetration-testing, ssh-penetration-testing, linux-privilege-escalation, scanning-tools, vulnerability-scanner.

> **AUTHORIZED USE ONLY. This section is for offensive playbooks and MUST NOT be executed against systems you do not have explicit written authorization to test.**

## Mandatory Gate Before Any Offensive Action

Before running any probe/scan/exploit against a real target:
1. State the exact target URL/IP/account and your authorization to test it.
2. Confirm written authorization and scope (IPs, domains, hosts, in-scope accounts).
3. Show the exact command and its expected effect.
4. Wait for explicit user confirmation. Until then, keep work read-only and defensive.

## Table of Contents

- [Methodology](#methodology)
- [Reconnaissance](#reconnaissance)
- [Scanning & Enumeration](#scanning--enumeration)
- [Web Fuzzing (ffuf / Burp)](#web-fuzzing-ffuf--burp)
- [Common Exploitation & Post-Exploitation](#common-exploitation--post-exploitation)
- [Linux Privilege Escalation](#linux-privilege-escalation)
- [SMTP & SSH Testing](#smtp--ssh-testing)
- [Reporting](#reporting)

---

## Methodology

- Follow a disciplined lifecycle: scope → recon → scan → enumerate → exploit → post-exploit → report.
- Re-verify scope continuously; stop and ask if a target falls outside authorization.
- Log everything: commands, timestamps, findings, evidence (screenshots/raw output).
- Exploitation only after a finding is confirmed; prefer proof-of-concept over destructive actions.
- Maintain a clean exit: remove artifacts, note persistence if discovered, restore state.

## Reconnaissance

- Passive OSINT: DNS (dig/`dig +short`), subdomain enumeration, certificate transparency (crt.sh), search-engine dorks (Google/GitHub), archived pages, tech fingerprinting (Wappalyzer/httpx).
- Shodan: query by product, port, org, `http.title:`, `product:`, `net:` ranges; identify exposed services and misconfigurations. Map assets before touching them.
- GitHub dorking: search for secrets, internal endpoints, config files in public repos.

## Scanning & Enumeration

- Port scan: `nmap -sS -sV -O <target>`; service scan `nmap -sV -sC`; use `-Pn` where ICMP blocked. Consider timing `-T3/4`.
- Enumerate services aggressively once identified (banner, version, default creds, known CVEs).
- Web enumeration: directories/files via ffuf; tech stack via headers/robots; APIs via OpenAPI/Postman.
- Credential/data leak checks: search public datasets/buckets (`cloud storage` dorking), exposed `.env`, `/backup`, `/git` paths.
- Use vulnerability scanners (e.g., nuclei, nikto, custom checklists) as a supplement, then manually confirm every reported finding — scanners produce false positives.

## Web Fuzzing (ffuf / Burp)

- ffuf for content/parameter discovery:
  - `ffuf -u http://target/FUZZ -w wordlist.txt -mc 200,204,301`
  - `ffuf -u http://target/page?FUZZ=value -w params.txt` for parameter discovery.
  - Use `-recursion` for directory trees; filter noise with `-fs/-fc`.
- Burp Suite: manual fuzzing via Intruder, repeater for manual verification; parse existing project files (`.burp`) to extract findings/sites.
- Confirm each discovery manually; a 200 on a fuzz hit is not a vulnerability — check for auth bypass, sensitive data, or content that should not be public.

## Common Exploitation & Post-Exploitation

- Web: SQLi, XSS, IDOR, SSRF, file upload/`path traversal`, auth bypass — see `web-appsec.md`.
- Service exploitation: verify service versions against CVE databases; use Metasploit modules only after manual confirmation.
- Metasploit: `search <cve>` → `use module` → `set RHOSTS/LHOST/PAYLOAD` → `check` (safe) before `exploit`. Use `setg` for session persistence; `sessions` to manage.
- Post-exploitation: enumerate (users, creds, network, services, secrets), pivot carefully, maintain evidence; do not run destructive `exploit` variants without authorization.

## Linux Privilege Escalation

- Enumerate: kernel/OS version, `sudo -l`, SUID/sgid binaries, world-writable files, cron jobs, services, environment, history, `/etc/passwd`/`shadow` readability, capabilities, `docker`/`lxd` group membership.
- Look for: misconfigured sudoers, writable scripts run by root cron, weak file perms on configs/keys, exposed credentials in shell history/env, kernel CVEs (only after confirming patch level).
- Confirm each vector with a PoC; document evidence; never damage the system.
- Defensive countermeasure (for hardening): keep system patched, remove SUID where not needed, restrict sudo, protect cron/scripts, scan history/env for secrets.

## SMTP & SSH Testing

- SMTP: banner/version detection (`nmap -p25 --script smtp-*`), open relay test, user enumeration via VRFY/EXPN/RCPT, STARTTLS presence/version, header injection. Defensive: disable open relay, restrict to authorized users, enforce STARTTLS.
- SSH: version/cipher scan (`ssh-audit`, `nmap --script ssh2-enum-algos`), weak auth methods (`ssh -vvv`), password brute-force only within scope/rate limits, key trust issues. Defensive: disable password auth for prod, key-only with passphrases, restrict by IP/firewall, fail2ban.

## Reporting

- Report format: executive summary, scope, methodology, findings (severity-ranked, with reproduction steps and evidence), remediation guidance, and re-test results.
- Include both confirmed findings and items checked-and-clean (shows coverage).
- Attach only sanitized evidence; remove secrets from any attached output.
