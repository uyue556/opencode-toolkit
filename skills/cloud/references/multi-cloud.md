# Multi-Cloud, Hybrid, Networking & Service Mesh

Merges `cloud-architect`, `multi-cloud-architecture`, `hybrid-cloud-architect`,
`cost-optimization`, `hybrid-cloud-networking`, and `istio-traffic-management`. Use for
cross-cloud decisions, hybrid connectivity, FinOps, and mesh traffic control.

## Table of contents

1. [Multi-cloud architecture](#multi-cloud-architecture)
2. [FinOps & cost optimization (all clouds)](#finops--cost-optimization-all-clouds)
3. [Hybrid cloud](#hybrid-cloud)
4. [Hybrid networking](#hybrid-networking)
5. [Istio traffic management](#istio-traffic-management)

## Multi-cloud architecture

### Service comparison cheat-sheet

| Use case | AWS | Azure | GCP |
|---|---|---|---|
| IaaS VMs | EC2 | Virtual Machines | Compute Engine |
| Kubernetes | EKS | AKS | GKE |
| Serverless | Lambda | Functions | Cloud Functions |
| Managed containers | Fargate / Container Apps | Container Apps | Cloud Run |
| Object storage | S3 | Blob Storage | Cloud Storage |
| Block storage | EBS | Managed Disks | Persistent Disk |
| Managed SQL | RDS | SQL Database | Cloud SQL |
| NoSQL | DynamoDB | Cosmos DB | Firestore |
| Distributed SQL | Aurora | PostgreSQL/MySQL | Cloud Spanner |
| Cache | ElastiCache | Cache for Redis | Memorystore |
| Message queue | SQS | Service Bus | Pub/Sub |
| Streams | Kinesis | Event Hubs | Pub/Sub/Dataflow |

### Multi-cloud patterns

1. **Single provider + DR**: primary in one cloud, DR in another; replicate DB, automate
   failover.
2. **Best-of-breed**: pick the best service per provider (AI/ML on GCP, enterprise apps on
   Azure, general compute on AWS).
3. **Geographic distribution**: serve from nearest region; data-sovereignty compliance;
   global load balancing; regional failover.
4. **Cloud-agnostic abstraction**: Kubernetes for compute, PostgreSQL for DB, S3-compatible
   storage (MinIO), Kafka, Redis, Prometheus/Grafana, Istio — standardized open stack.

### Design principles (cloud-architect)

- Clarify goals/constraints first; recommend services from workload characteristics
  (scalability, cost, security, compliance).
- Design for failure: multi-AZ/region resilience, graceful degradation, chaos testing.
- Security by default: zero-trust, least privilege, encryption everywhere, secrets
  management (Vault / cloud-native).
- Observability from day one: metrics + logs + traces (Prometheus/Grafana, OpenTelemetry).
- Consider vendor lock-in and portability; value simplicity over complexity.
- DR: define RPO/RTO, active-active vs active-passive, test recovery.

### Hybrid-cloud architect additions

- Private clouds: OpenStack (Nova/Neutron/Cinder/Swift/Keystone/Heat), VMware vSphere,
  OpenShift. Hybrid platforms: Azure Arc, AWS Outposts, Anthos.
- Workload placement by data gravity, latency, compliance, and TCO; identity federation
  (AD/LDAP/SAML/OAuth); cross-cloud backups and SIEM.
- Migration ladder: lift-and-shift → re-platform → re-architect; phase it with rollback.

## FinOps & cost optimization (all clouds)

### Framework

1. **Visibility** — cost allocation tags everywhere; budget alerts; cost dashboards.
2. **Right-size** — analyze utilization; downsize over-provisioned; auto-scale; remove idle.
3. **Pricing models** — reserved/committed capacity (30-70% savings), spot/preemptible
   (up to 90%), savings plans.
4. **Architecture** — managed services, caching, minimize data transfer, lifecycle policies.

### By provider

- **AWS**: Reserved Instances (30-72%), Compute Savings Plans (66%) / EC2 Instance Savings
  Plans (72%) apply to EC2+Fargate+Lambda, Spot (up to 90%, 2-min notice — mix with
  on-demand). Tools: Cost Explorer, Cost Anomaly Detection, Compute Optimizer, Trusted
  Advisor.
- **Azure**: Reserved VM instances (up to 72%), **Azure Hybrid Benefit** (existing Windows
  Server/SQL licenses → up to 80%), Advisor recommendations. Tools: Cost Management.
- **GCP**: Committed Use Discounts (up to 57%, 1/3-yr), **Sustained Use** (automatic up to
  30% on Compute Engine/GKE), Preemptible (up to 80%, 24-h max). Tools: Cost Management,
  Recommender.
- **Multi-cloud**: CloudHealth, Cloudability, Kubecost for cross-provider TCO.

### Storage & tagging

- Tier: hot (S3 Standard) → warm (Standard-IA @30d) → cold (Glacier @90d) → archive
  (Deep Archive @365d).
- Tagging standard: `Environment`, `Project`, `CostCenter`, `Owner`, `ManagedBy`; merge
  common tags in Terraform (`merge(local.common_tags, {Name=…})`).
- AWS budget via Terraform: `aws_budgets_budget` with `notification { threshold = 80 }`.

### Checklist

Cost allocation tags · delete unused (EBS/EIP/snapshots) · right-size · reserved for steady
load · auto-scaling · storage lifecycle · anomaly detection · budget alerts · weekly review
· spot/preemptible · data-transfer optimization · caching · managed services.

## Hybrid networking

### Options per provider

| Provider | VPN | Dedicated |
|---|---|---|
| AWS | Site-to-Site (IPSec, ≤1.25 Gbps/tunnel) | Direct Connect (1-100 Gbps) |
| Azure | VPN Gateway (RouteBased, VpnGw1+) | ExpressRoute (≤100 Gbps) |
| GCP | Cloud VPN / HA VPN (99.99% SLA, ≤3 Gbps) | Cloud Interconnect (dedicated 10/100 Gbps, partner 50 Mbps-50 Gbps) |

Choose VPN for cost-effective moderate bandwidth; dedicated for low latency + consistent
bandwidth + high reliability.

### Patterns

- **Hub-and-spoke**: on-prem → VPN/DC → Transit Gateway (AWS) / vWAN (Azure) → spoke VPC/VNets.
- **Multi-region hybrid**: dedicated links per region + cross-region peering.
- **Multi-cloud hybrid**: Direct Connect → AWS, ExpressRoute → Azure, Interconnect → GCP
  from one DC.

### Routing & HA

- BGP: on-prem AS 65000 advertising LAN CIDRs; cloud AS 64512 (AWS) / 65515 (Azure);
  dynamic routing with route filtering and propagation.
- Redundancy: **dual tunnels** (two customer gateways / connections); active-active with
  ECMP; monitor BGP session status.

### Security & operations

- Prefer private connectivity; encrypt VPN tunnels; use VPC endpoints/PrivateLink instead
  of internet; network ACLs + security groups; VPC Flow Logs; DDoS protection; redundancy;
  regular audits.
- Monitor: tunnel up/down, bytes in/out, packet loss, latency, BGP status.
- Troubleshoot: `aws ec2 describe-vpn-connections`,
  `aws ec2 get-vpn-connection-telemetry`, `az network vpn-connection show`.
- Cost: right-size connections, VPN for low bandwidth, consolidate traffic, minimize data
  transfer, Direct Connect for high bandwidth, cache to reduce traffic.

## Istio traffic management

### Core resources

| Resource | Purpose |
|---|---|
| **VirtualService** | Host-based routing to destinations (weights, matches, retries, faults, mirroring) |
| **DestinationRule** | Post-routing policies (subsets, connection pools, circuit breaking, load balancing) |
| **Gateway** | Ingress/egress at the cluster edge |
| **ServiceEntry** | Add external services to the mesh |

### Templates (networking.istio.io/v1beta1)

- **Canary**: VirtualService weights `stable: 90 / canary: 10`; DestinationRule defines
  `stable`/`canary` subsets by pod label `version`.
- **Circuit breaker**: DestinationRule `trafficPolicy.outlierDetection`
  (`consecutive5xxErrors: 5, interval: 30s, baseEjectionTime: 30s, maxEjectionPercent: 50`)
  + connection pool limits.
- **Retry & timeout**: VirtualService `timeout: 10s`, `retries {attempts: 3,
  perTryTimeout: 3s, retryOn: connect-failure,refused-stream,unavailable,cancelled,
  retriable-4xx,503}`.
- **Traffic mirroring**: `mirror: {host, subset}` + `mirrorPercentage` (mirror to test env,
  never production).
- **Fault injection**: `fault.delay {percentage 10, fixedDelay 5s}` +
  `fault.abort {percentage 5, httpStatus 503}` for chaos testing.
- **Ingress gateway**: Gateway with TLS `credentialName` + VirtualService bound via
  `gateways:` list.
- **Sticky sessions**: `loadBalancer.consistentHash {httpHeaderName: x-user-id}`.

### Do's & don'ts

- Start simple; version services with subsets; always set timeouts; enable retries with
  backoff + limits; monitor with Kiali/Jaeger.
- Don't over-retry (cascading failure); don't skip outlier detection; don't mirror to prod;
  don't skip canary.
- Debug: `istioctl analyze`, `istioctl proxy-config routes deploy/app`,
  `istioctl proxy-config endpoints deploy/app`, `istioctl proxy-config log ... --level debug`.

## Source

`cloud-architect`, `multi-cloud-architecture`, `hybrid-cloud-architect`,
`hybrid-cloud-networking`, `istio-traffic-management`, `cost-optimization` (all community).
