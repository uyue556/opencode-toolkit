# Docker & Containers

Source: `docker-expert` (devops), `apple-container` (devops, macOS-only note).

## When to use
Writing or reviewing Dockerfiles, optimizing image size, hardening container security, wiring
Docker Compose for dev/prod, debugging slow builds or networking issues.

## Dockerfile optimization & multi-stage builds

Core pattern — dependencies before source (layer caching), build stage separate from runtime,
production stage copies only what runs:

```dockerfile
FROM node:18-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build && npm prune --production

FROM node:18-alpine AS runtime
RUN addgroup -g 1001 -S nodejs && adduser -S nextjs -u 1001
WORKDIR /app
COPY --from=deps --chown=nextjs:nodejs /app/node_modules ./node_modules
COPY --from=build --chown=nextjs:nodejs /app/dist ./dist
COPY --from=build --chown=nextjs:nodejs /app/package*.json ./
USER nextjs
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
CMD ["node", "dist/index.js"]
```

Rules:
- Combine RUN commands that install + clean up in the same layer (`npm ci ... && npm cache
  clean --force`) to keep the layer small.
- Use a comprehensive `.dockerignore` (node_modules, .git, build caches) — the build context is
  a hidden image-size and build-speed cost.
- Base image: Alpine for size, distroless/scratch for minimal attack surface, glibc distros when
  you need full compatibility. Distroless example:
  ```dockerfile
  FROM gcr.io/distroless/nodejs18-debian11
  COPY --from=build /app/dist /app
  WORKDIR /app
  EXPOSE 3000
  CMD ["index.js"]
  ```

## Security hardening

- Run as non-root with a fixed UID/GID:
  ```dockerfile
  RUN addgroup -g 1001 -S appgroup && adduser -S appuser -u 1001 -G appgroup
  ...
  USER 1001
  ```
- Drop capabilities, read-only root filesystem, no privilege escalation.
- Secrets: use Docker secrets (`POSTGRES_PASSWORD_FILE: /run/secrets/...`) or BuildKit build
  secrets (`RUN --mount=type=secret,id=api_key`); never bake into ENV or image layers.
- Keep base images current and scanned (`docker scout quickview`, Trivy).

## Docker Compose (production-ish)

```yaml
services:
  app:
    build: { context: ., target: production }
    depends_on:
      db: { condition: service_healthy }
    networks: [frontend, backend]
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    deploy:
      resources:
        limits: { cpus: '0.5', memory: 512M }
        reservations: { cpus: '0.25', memory: 256M }
      restart_policy: { condition: on-failure, delay: 5s, max_attempts: 3 }

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password
    secrets: [db_password]
    volumes: [postgres_data:/var/lib/postgresql/data]
    networks: [backend]            # backend network: internal: true → DB not exposed
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5

networks:
  frontend: { driver: bridge }
  backend: { driver: bridge, internal: true }

volumes:
  postgres_data:

secrets:
  db_password: { external: true }
```

## Development workflow

- Separate `target: development` build; bind-mount source with anonymous volumes over
  `node_modules`/`dist`; `NODE_ENV=development`; expose a debug port (9229); run the dev command.
- Test containers isolated from production builds.

## Image size & performance

- Symptoms: image > 1GB, slow deploy. Causes: unnecessary files, build tools in prod image, poor
  base selection. Fix: distroless, multi-stage, selective artifact copying.
- Multi-arch builds:
  ```bash
  docker buildx create --name multiarch-builder --use
  docker buildx build --platform linux/amd64,linux/arm64 -t myapp:latest --push .
  ```
- Build cache mount for package managers:
  ```dockerfile
  RUN --mount=type=cache,target=/root/.npm npm ci --only=production
  ```
- Set resource limits (`cpus`, `memory`, reservations) to prevent a runaway container from
  taking down the host.

## Networking & diagnostics

- Limit exposed ports; internal networks for backend services; health-check endpoints tested.
- Slow builds: layer ordering, large context, no caching. Networking issues: missing networks,
  port conflicts, service naming → use custom networks + health checks + service discovery.

## macOS-specific note (apple-container)

On Apple-silicon macOS you can run OCI/Linux containers as lightweight per-container VMs via
Apple's `container` (container-apiserver + helpers, launchd-managed). First run offers to install
the default Linux kernel; services verified via `container ps`-style health checks. This is an
alternative to Docker Desktop for local Linux-container workloads; all Dockerfile/compose
practices above still apply. (Niche; skip unless the user is on Apple silicon and asks.)
