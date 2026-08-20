# Kubernetes & GitOps

Source: `kubernetes-architect` (devops), `k8s-manifest-generator` (devops),
`helm-chart-scaffolding` (devops), `k8s-security-policies` (devops), `gitops-workflow` (devops),
`service-mesh-observability` (devops), `service-mesh-expert` (reliability).

## When to use
Writing Kubernetes manifests or Helm charts, securing a cluster, setting up GitOps
(ArgoCD/Flux), progressive delivery, or operating a service mesh.

## Manifest essentials (k8s-manifest-generator)

Production-ready manifests cover Deployments (with `strategy`, resource `requests`/`limits`,
`livenessProbe`/`readinessProbe`, `terminationGracePeriodSeconds`), Services, ConfigMaps,
Secrets, and Ingress. Pair every workload with:
- Readiness + liveness probes (probes that are too strict cause rolling restarts).
- Resource requests (scheduling) and limits (protection) — never set one without the other.
- `securityContext` (non-root, read-only root FS, drop caps) — see security section.
- Labels used by both selectors and network policies.

## Helm chart scaffolding

Standard layout: `Chart.yaml`, `values.yaml`, `templates/` (`deployment.yaml`, `service.yaml`,
`_helpers.tpl`), `.helmignore`. Conventions:
- Default everything in `values.yaml`; reference via `{{ .Values.* }}`.
- Use `{{ .Release.Name }}` and `{{ .Release.Namespace }}`, not hardcoded names.
- Template labels/annotations from `_helpers.tpl` for consistency; add `app.kubernetes.io/*`
  standard labels.
- Provide an examples/ or values-*.yaml per environment; run `helm lint` + `helm template` in CI.

## Security policies (defense in depth)

### Pod Security Standards (namespace-level)
Labels enforce tiers: `privileged` (unrestricted), `baseline` (minimally restrictive), `restricted`
(most restrictive — use for normal workloads):
```yaml
metadata:
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/warn: restricted
```

### NetworkPolicy — default deny, then allow
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata: { name: default-deny-all, namespace: production }
spec:
  podSelector: {}
  policyTypes: [Ingress, Egress]
```
Then allow frontend→backend on 8080 (podSelector in `from`), and allow egress DNS to kube-system
UDP 53. Verify your CNI supports NetworkPolicy before relying on it.

### RBAC least privilege
- `Role` (namespace-scoped) / `ClusterRole` (cluster-wide) with minimal `verbs`
  (`get/watch/list`). Bind with `RoleBinding`/`ClusterRoleBinding` to users, groups, or
  ServiceAccounts. Debug with `kubectl auth can-i list pods --as system:serviceaccount:ns:name`.

### Pod security context
```yaml
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    fsGroup: 1000
    seccompProfile: { type: RuntimeDefault }
  containers:
  - name: app
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities: { drop: [ALL] }
```

### Admission control (OPA Gatekeeper / Kyverno)
Enforce policies like "every Deployment must have app + environment labels" via
`ConstraintTemplate` (REGO) + `Constraint`. Also enforce the CIS Kubernetes Benchmark basics:
RBAC authz, audit logging, PSS, network policies, secrets encryption at rest.

## GitOps (OpenGitOps)

Principles: **declarative**, **versioned & immutable** (desired state in Git), **pulled
automatically**, **continuously reconciled**.

### Repo layout
```
gitops-repo/
├── apps/production/<app>/   # kustomization.yaml + deployment.yaml
├── apps/staging/...
├── infrastructure/          # ingress-nginx, cert-manager, monitoring
└── argocd/applications/
```

### ArgoCD
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
Application CR with `syncPolicy.automated.{prune, selfHeal}`, `syncOptions:
[CreateNamespace=true]`. Use the **App-of-Apps** pattern (an Application whose source is the
`argocd/applications/` directory) for organization. Troubleshoot: `argocd app get|sync|diff`.

### Flux
```bash
flux bootstrap github --owner=org --repository=gitops-repo --branch=main --path=clusters/production
```
`GitRepository` (interval: 1m) + `Kustomization` (interval: 5m, prune: true, sourceRef).

### Sync policies & safety
- Auto-sync to production needs approval gates; `selfHeal` reconciles manual drift but makes
  deliberate temp changes hard — scope carefully.
- Tag releases for easy rollback; enable notifications for sync failures; use health checks for
  custom resources.

### Secrets in GitOps
Keep secrets out of Git: External Secrets Operator (Sync a `SecretStore` + `ExternalSecret`
from AWS SM/Parameter Store etc.) or Sealed Secrets (`kubeseal --format yaml < secret.yaml`).
Never commit plaintext secrets.

## Progressive delivery (Argo Rollouts)

- Canary: `setWeight 20 → pause 1m → 50 → pause 2m → 100`.
- Blue-green: `activeService` + `previewService`, `autoPromotionEnabled: false` (manual promote
  after analysis).

## Service mesh (Istio / Linkerd)

- **When to use:** you need fine-grained traffic control, mTLS, per-route metrics, or canary by
  header/cookie, not just default LB. Adding a mesh is operational cost — don't add one for a
  handful of services.
- mTLS: `PeerAuthentication` with `mode: STRICT`; AuthorizationPolicy with source principals
  (`cluster.local/ns/<ns>/sa/<sa>`).
- Observability: mesh provides per-service RED metrics "for free":
  - request rate: `sum(rate(istio_requests_total{reporter="destination"}[5m])) by (destination_service_name)`
  - error rate: 5xx rate / total
  - p99: `histogram_quantile(0.99, sum(rate(istio_request_duration_milliseconds_bucket{...}[5m])) by (le, destination_service_name))`
- Linkerd: `linkerd viz top|routes|tap|edges` for live traffic, per-route metrics, topology.
- Kiali for topology visualization; OpenTelemetry collector as a vendor-neutral pipeline
  (receivers otlp/zipkin → processors batch → exporters jaeger/prometheus).

## Cluster-level ops (kubernetes-architect highlights)

- Multi-tenancy: namespaces + ResourceQuota + LimitRange + RBAC + NetworkPolicy per tenant.
- FinOps: right-size requests/limits, cluster autoscaler, spot for stateless, cleanup
  abandoned resources.
- DR: etcd backups, PDBs (PodDisruptionBudget) for voluntary disruptions, multi-region
  strategy, restore drill.
- Version upgrade path: one minor version at a time, check deprecated APIs
  (`kubectl convert`), drain nodes with PDBs respected.
