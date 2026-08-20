# Container Security Reference

> Consolidated container/Docker/Kubernetes hardening guidance.
> Sources: container-security-hardening, security-and-hardening (three-tier boundary).
> Deep dives: `kubernetes-pod-security.md`, `base-image-comparison.md`, `seccomp-profile-template.json`.

## Table of Contents

- [Five Layers of Container Security](#five-layers-of-container-security)
- [Dockerfile Hardening](#dockerfile-hardening)
- [Image Scanning & Supply Chain](#image-scanning--supply-chain)
- [Runtime Security](#runtime-security)
- [Kubernetes Pod Security](#kubernetes-pod-security)
- [Base Image Decision](#base-image-decision)

---

## Five Layers of Container Security

1. Dockerfile hardening (attack surface reduction).
2. Image scanning (CVE/secret/misconfig).
3. Supply chain integrity (immutable, signed images).
4. Runtime security (seccomp, capabilities, nonroot, read-only fs).
5. Kubernetes controls (PSA, NetworkPolicy, RBAC, admission).

## Dockerfile Hardening

- **Base image**: prefer slim/distroless/alpine over full OS images — a `latest` full image typically carries ~100–200 CVEs. See `base-image-comparison.md` for a decision matrix (scratch for fully static binaries, distroless for runtimes, alpine when musl is compatible, slim for glibc fallback).
- **Multi-stage builds**: build in one stage (with toolchain), copy only artifacts into a minimal runtime stage (no build tools, no shell where avoidable).
- **Non-root user**: create a dedicated user at runtime stage. Debian/Ubuntu: `RUN groupadd -r app && useradd -r -g app app && USER app`. Alpine: `addgroup`/`adduser`. Distroless: `USER nonroot` (UID 65532) is built in.
- **Immutable tags**: never `FROM image:latest` or mutable tags — pin by SHA256 digest; mutable tags enable silent supply-chain replacement.
- **No secrets in layers**: never `ENV SECRET=...` or `RUN export SECRET` — visible in `docker history` and layer cache. Use BuildKit secret mounts:
  ```dockerfile
  # syntax=docker/dockerfile:1
  RUN --mount=type=secret,id=token,required=true \
      sh -c 'cat /run/secrets/token > /target/usage-only'
  ```
- **Exec form**: use `ENTRYPOINT ["cmd","arg"]`, not shell form (`/bin/sh -c` spawns an extra process, loses signals).
- **HEALTHCHECK**: define one so orchestrators can detect failure.
- **`.dockerignore`**: exclude `.git`, `node_modules`, secrets, build caches from build context.
- **Do not** install unnecessary packages, package managers at runtime, or debug shells in prod images.

## Image Scanning & Supply Chain

- Scan images for CVEs in CI and fail on HIGH/CRITICAL:
  - Trivy: `trivy image <image>` (CVE scan), `trivy config .` (Dockerfile misconfig), `trivy fs .` (repo: vulns + secrets + misconfigs), `trivy repo` for Git repos.
  - Grype/Snyk alternatives; integrate into CI and fail the pipeline on new high/critical.
- Enforce: signed images (cosign/notary) where practical; registry access control; provenance metadata.
- Keep base images updated; rebuild on upstream security releases.

## Runtime Security

- Drop capabilities: `docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE ...`; avoid `--privileged`.
- Read-only rootfs: `--read-only` with tmpfs for writable runtime dirs.
- Seccomp: apply a restrictive profile (default Docker/containerd profile or `seccomp-profile-template.json`) to block dangerous syscalls; never `--security-opt seccomp=unconfined`.
- User namespace remapping; resource limits (CPU/mem) to prevent DoS; no `--pid=host`, `--network=host`, or host mounts in prod unless justified.

## Kubernetes Pod Security

- See `kubernetes-pod-security.md` for the full reference: Pod Security Admission (baseline/restricted), NetworkPolicy default-deny, RBAC least privilege, admission controllers (OPA/Gatekeeper), secrets, resource limits, and audit logging.
- Quick wins: run pods as non-root, `readOnlyRootFilesystem: true`, `allowPrivilegeEscalation: false`, drop ALL capabilities, enforce restricted PSA, default-deny NetworkPolicy, service accounts with minimal roles.

## Base Image Decision

- **scratch**: only for fully static binaries; zero attack surface but no shell/debug tooling.
- **distroless**: runtime-only, nonroot built in, no shell/package manager; best for glibc apps (Java, Go, Python runtimes).
- **alpine**: tiny (musl); verify app compatibility first (native deps may break).
- **slim**: full glibc but trimmed; fallback when musl incompatible.
- Always pin by digest and keep a signed base-image allowlist.
