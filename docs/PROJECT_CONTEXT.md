# AWS Platform Engineering Project Context

## Goal

Build a production-grade Platform Engineering environment on AWS using modern cloud-native practices.

This is **NOT** a tutorial project.

The objective is to simulate how a real Platform Engineering team would build and operate a secure internal platform.

---

## Current Architecture

```text
GitHub
│
├── Infrastructure (Terraform)
│
├── GitOps (ArgoCD)
│
└── Applications
      │
      └── Java Spring Boot
```

---

## Platform Flow

```text
Developer
    ↓
Git Commit
    ↓
GitHub Actions
    ↓
Build Docker Image
    ↓
Push to ECR
    ↓
Update GitOps Manifests
    ↓
ArgoCD Sync
    ↓
Deploy to EKS
```

No direct kubectl deployment.

No direct helm upgrade from CI/CD.

GitOps owns deployments.

---

## Infrastructure Built

### Bootstrap

Completed.

```text
S3 Backend
DynamoDB Locking
GitHub OIDC
GitHub Actions IAM Role
```

---

### Networking

Completed.

```text
VPC
Public Subnets
Private App Subnets
Private DB Subnets
Internet Gateway
NAT Gateway
Route Tables
```

---

### Security

Completed.

```text
ALB Security Group
EKS Node Security Group
RDS Security Group
```

---

### EKS

Completed.

```text
EKS Cluster
Managed Node Group
OIDC
IRSA
```

---

### EKS Addons

Completed.

```text
VPC CNI
CoreDNS
Kube Proxy
```

---

## GitOps Structure

```text
gitops/
├── bootstrap
│   └── root-app.yaml
│
├── projects
│   └── platform-project.yaml
│
├── applications
│   ├── platform
│   │   └── aws-load-balancer-controller.yaml
│   │
│   └── workloads
│
└── manifests
    ├── aws-load-balancer-controller
    ├── cert-manager
    └── external-dns
```

---

## Current Status

### AWS Load Balancer Controller

Terraform:
- IAM Role
- IRSA
- IAM Permissions

GitOps:
- ArgoCD Application created

Manual ALB test completed successfully.

Currently moving ALB Controller fully under GitOps management.

---

## Architecture Decisions

### ADR-001 — GitOps First

Use GitOps as the deployment model.

```text
Terraform
    ↓
Infrastructure

ArgoCD
    ↓
Platform Components

ArgoCD
    ↓
Applications
```

---

### ADR-002 — Ingress Strategy

```text
ALB
 ↓
AWS Load Balancer Controller
 ↓
Target Group (target-type=ip)
 ↓
Pods
```

Do **NOT** use NodePort architecture.

---

### ADR-003 — Authentication

Use:

```text
OIDC
IRSA
```

Do not use node IAM permissions for workloads.

---

### ADR-004 — Secrets Management

Future architecture:

```text
AWS Secrets Manager
↓
External Secrets Operator
↓
Pods
```

Do not store secrets in Git.

---

### ADR-005 — Networking

Application workloads run in:

```text
Private App Subnets
```

No public worker nodes.

---

## Production Architecture Vision

### Networking

```text
Internet
    ↓
Route53
    ↓
AWS ALB
    ↓
EKS Pods
```

Private workloads only.

---

### Identity

```text
GitHub OIDC
        ↓
Terraform

IRSA
        ↓
Kubernetes Workloads
```

No static AWS credentials.

---

### GitOps

```text
Git Repository
        ↓
ArgoCD
        ↓
Cluster State
```

Git is the source of truth.

---

## Future Roadmap

### Phase 1 — Platform Foundation

Complete:

```text
AWS Load Balancer Controller
Cert Manager
External DNS
Metrics Server
External Secrets Operator
```

---

### Phase 2 — Application Platform

```text
Java Spring Boot Application
Helm Chart
Namespaces
Ingress
GitOps Deployment
```

---

### Phase 3 — Observability

```text
Prometheus
Grafana
Loki
Tempo
AlertManager
```

---

### Phase 4 — Security Platform

```text
Cilium
Network Policies
External Secrets
Kyverno
OPA Gatekeeper
Falco
Trivy
```

Focus Areas:

- Pod Security
- Runtime Security
- Image Scanning
- Policy Enforcement
- East-West Traffic Security

---

### Phase 5 — Service Mesh

Evaluate:

```text
Istio
or
Linkerd
```

Capabilities:

- mTLS
- Traffic Shaping
- Service Identity
- Zero Trust Networking

---

### Phase 6 — Enterprise Platform Engineering

```text
Karpenter
Backstage
Golden Paths
Self-Service Infrastructure
Developer Portals
Software Catalog
Platform APIs
```

---

## Kubernetes Security Strategy

### Layer 1 — Infrastructure

```text
Private Subnets
Security Groups
IAM
IRSA
KMS
```

---

### Layer 2 — Cluster

```text
EKS Control Plane Logs
Audit Logs
OIDC
RBAC
```

---

### Layer 3 — Network

```text
Cilium
Network Policies
Egress Restrictions
Ingress Restrictions
```

---

### Layer 4 — Workload

```text
Pod Security Standards
ReadOnly Root Filesystem
Non-Root Containers
Resource Limits
```

---

### Layer 5 — Secrets

```text
AWS Secrets Manager
External Secrets Operator
```

---

### Layer 6 — Runtime

```text
Falco
Runtime Detection
Threat Monitoring
```

---

### Layer 7 — Governance

```text
Kyverno
OPA Gatekeeper
Admission Controls
```

---

## Important Mentoring Notes

- Treat this as a real Platform Engineering implementation.
- Prefer production-grade architecture over tutorial shortcuts.
- Explain WHY decisions are made.
- Focus on scalability, security, operability, and maintainability.
- Avoid unnecessary refactoring unless it materially improves the platform.
- Build incrementally and validate each layer before adding the next one.
- Follow GitOps principles wherever possible.
- Security is designed into the platform, not added later.

---

## Current Repo Structure

```text
aws-platform-engineering/
│
├── .github/
│
├── applications/
│
├── docs/
│
├── gitops/
│   ├── applications/
│   ├── bootstrap/
│   ├── manifests/
│   └── projects/
│
├── infrastructure/
│   ├── bootstrap/
│   ├── environments/
│   │   ├── dev/
│   │   ├── stage/
│   │   └── prod/
│   │
│   └── modules/
│       ├── vpc/
│       ├── security_groups/
│       ├── eks/
│       ├── ecr/
│       ├── rds/
│       ├── monitoring/
│       └── platform/
│
├── monitoring/
│
├── runbooks/
│
└── README.md
```

---

## Next Immediate Steps

### Platform Layer

1. Deploy ArgoCD into EKS
2. Bootstrap Root Application
3. Deploy AWS Load Balancer Controller through ArgoCD
4. Deploy Metrics Server
5. Deploy Cert Manager
6. Deploy External DNS
7. Deploy External Secrets Operator

---

### Application Layer

1. Create Java Spring Boot Application
2. Create Dockerfile
3. Create ECR Repository
4. Create Helm Chart
5. Create GitHub Actions CI Pipeline
6. Deploy through ArgoCD

---

### Observability Layer

1. Prometheus
2. Grafana
3. Loki
4. Tempo
5. AlertManager

---

### Security Layer

1. Cilium
2. Network Policies
3. Kyverno
4. Falco
5. Trivy

---

### Platform Engineering Layer

1. Karpenter
2. Backstage
3. Golden Paths
4. Internal Developer Platform (IDP)
