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

-- History 24july
how can I move manifests to platform? platform is already there in repo structure check the snap attached 
main(4).tf
File
oidc(1).tf
File
outputs(4).tf
File
variables(4).tf
File
addons(2).tf
File
alb-controller-irsa(2).tf
File
variables(5).tf
File
main(5).tf
File
outputs(5).tf
File

here are the VPC/SG/EKS files attached

Good catch. Looking at what you pasted, I see a few issues that we should fix before recreating the environment.

Issue 1: File Placement Looks Wrong

You showed:

gitops/manifests/aws-load-balancer-controller/

containing:

apiVersion: argoproj.io/v1alpha1
kind: Application
...

That is an ArgoCD Application resource, not a Kubernetes manifest.

Your structure should be:

gitops/
├── applications/
│   └── platform/
│       ├── aws-load-balancer-controller-prereqs.yaml
│       └── aws-load-balancer-controller.yaml
│
└── manifests/
    └── aws-load-balancer-controller/
        ├── serviceaccount.yaml
        └── dev-values.yaml

The manifests folder should contain Kubernetes resources.

The applications folder should contain ArgoCD Applications.

Issue 2: Indentation Error

Current:

syncPolicy:

automated:
  prune: true
  selfHeal: true

This is invalid YAML.

Should be:

syncPolicy:
  automated:
    prune: true
    selfHeal: true

  syncOptions:
    - CreateNamespace=true
Issue 3: Missing Service Account Reference

ALB Controller Application:

helm:
  valueFiles:
    - $values/gitops/manifests/aws-load-balancer-controller/dev-values.yaml

Good.

Now let's verify dev-values.yaml contains:

serviceAccount:
  create: false
  name: aws-load-balancer-controller

because ArgoCD should not create the ServiceAccount.

IRSA ServiceAccount should come from:

aws-load-balancer-controller-prereqs
Issue 4: Missing Kustomization

Your prereqs app points to:

path: gitops/manifests/aws-load-balancer-controller

ArgoCD needs something to render.

Inside:

gitops/manifests/aws-load-balancer-controller/

I would expect:

serviceaccount.yaml
kustomization.yaml
dev-values.yaml

Example:

# kustomization.yaml

resources:
  - serviceaccount.yaml

Without this, ArgoCD may not know what to apply.

Issue 5: Hardcoded IAM Role ARN

Earlier you had:

annotations:
  eks.amazonaws.com/role-arn: arn:aws:iam::<account>:role/...

This is acceptable temporarily.

Long term we want:

Terraform Output
↓
GitHub Action
↓
Generate Values
↓
GitOps

But don't solve that today.

What I Think the Final Flow Should Be
Terraform
│
├── VPC
├── Security Groups
├── EKS
├── Node Group
├── OIDC
└── ALB Controller IRSA
        │
        ▼
ArgoCD
        │
        ▼
root-app
        │
        ▼
aws-load-balancer-controller-prereqs
        │
        └── ServiceAccount
             with IRSA annotation
        │
        ▼
aws-load-balancer-controller
        │
        ▼
AWS Load Balancer Controller Pod
        │
        ▼
Ingress
        │
        ▼
ALB

That's exactly the architecture I'd expect in a production platform.

Before We Continue

Show me these two files:

gitops/manifests/aws-load-balancer-controller/serviceaccount.yaml

gitops/manifests/aws-load-balancer-controller/dev-values.yaml

I want to verify:

IRSA annotation is correct.
Service account name matches Helm values.
ALB controller chart values are correct.
No hidden hardcoding remains.

After that, we can rebuild the environment with confidence and move to the Java application deployment phase.

dev-values.yaml
clusterName: kk-platform-dev

region: us-east-1

vpcId: vpc-088ed7509b53c6c49

serviceAccount:
  create: false
  name: aws-load-balancer-controller

replicaCount: 1
serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount

metadata:
  name: aws-load-balancer-controller
  namespace: kube-system

  annotations:
    eks.amazonaws.com/role-arn: ${alb_controller_role_arn}

Excellent. This is exactly the kind of review we should be doing before rebuilding.

I see one major issue and two architecture improvements.

🚨 Issue 1: This Will NOT Work

Current:

annotations:
  eks.amazonaws.com/role-arn: ${alb_controller_role_arn}

This is not Helm.

This is not Terraform.

This is a plain Kubernetes manifest.

ArgoCD will apply it literally as:

annotations:
  eks.amazonaws.com/role-arn: ${alb_controller_role_arn}

and Kubernetes will happily accept it.

Then IRSA will fail because AWS expects:

annotations:
  eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/kk-platform-dev-alb-controller
For now

Replace with the actual role ARN after Terraform creates it:

annotations:
  eks.amazonaws.com/role-arn: arn:aws:iam::<account-id>:role/kk-platform-dev-alb-controller

Since you're rebuilding anyway, get the value from:

terraform output

or

aws iam get-role

after apply.

🚨 Issue 2: Hardcoded VPC

Current:

vpcId: vpc-088ed7509b53c6c49

This VPC no longer exists.

The environment was destroyed.

When recreated you'll get:

vpc-xxxxxxxx

new ID.

For now

After Terraform apply:

terraform output vpc_id

Update:

vpcId: <new-vpc-id>

manually.

Long Term

Eventually we'll automate:

Terraform
↓
Generate values
↓
Commit values
↓
ArgoCD sync

But not today.

⚠️ Issue 3: Hardcoded Cluster Name

Current:

clusterName: kk-platform-dev

This is okay today.

Because your cluster name is:

name = "${var.project_name}-${var.environment}"

which becomes:

kk-platform-dev

When we introduce:

stage
prod

we'll have:

dev-values.yaml
stage-values.yaml
prod-values.yaml

and ArgoCD Applications per environment.

Not necessary yet.

What I Like

This part is correct:

serviceAccount:
  create: false
  name: aws-load-balancer-controller

because:

Prereqs App

Creates:

kind: ServiceAccount
name: aws-load-balancer-controller

with IRSA.

ALB Controller App

Uses:

serviceAccount:
  create: false

and attaches to existing ServiceAccount.

Exactly what we want.

Missing File

I don't see:

gitops/manifests/aws-load-balancer-controller/kustomization.yaml

Do you have one?

Because:

path: gitops/manifests/aws-load-balancer-controller

needs something ArgoCD can render.

I would expect:

apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - serviceaccount.yaml

Without it, prereqs may not deploy correctly.

Another Important Bug

Earlier you showed:

gitops/manifests/aws-load-balancer-controller/

containing an ArgoCD Application.

That Application should actually live in:

gitops/applications/platform/aws-load-balancer-controller.yaml

Verify you don't have duplicated Application manifests.

The structure should be:

gitops/
├── applications/
│   └── platform/
│       ├── aws-load-balancer-controller.yaml
│       └── aws-load-balancer-controller-prereqs.yaml
│
└── manifests/
    └── aws-load-balancer-controller/
        ├── serviceaccount.yaml
        ├── kustomization.yaml
        └── dev-values.yaml
Current Readiness Assessment
Component	Status
VPC	✅
Subnets	✅
NAT	✅
Route Tables	✅
Security Groups	✅
EKS Cluster	✅
Managed Node Group	✅
OIDC	✅
IRSA	✅
ALB IAM Policy	✅
ArgoCD App-of-Apps	✅
ALB Controller GitOps	⚠️ 95%
Java App	⏳
Ingress	⏳

You're extremely close.

Before recreating the environment, I'd like to see:

gitops/manifests/aws-load-balancer-controller/kustomization.yaml

and confirm the actual file locations for:

aws-load-balancer-controller.yaml
aws-load-balancer-controller-prereqs.yaml

because I suspect there may be a directory placement issue that will prevent ArgoCD from syncing correctly.

There is no gitops/manifests/aws-load-balancer-controller/kustomization.yaml file and file location for  aws-load-balancer-controller.yaml 
aws-load-balancer-controller-prereqs.yaml is gitops/applications/platform

That's actually a significant issue, and I'm glad we caught it now rather than during a cluster rebuild.

Current Problem

Your ArgoCD Application:

path: gitops/manifests/aws-load-balancer-controller

points to:

gitops/manifests/aws-load-balancer-controller/

But inside that directory you only have:

serviceaccount.yaml
dev-values.yaml

ArgoCD needs a way to understand what to deploy from that directory.

Without one of these:

kustomization.yaml
Chart.yaml
plain yaml files auto-discovery (limited)

the behavior becomes inconsistent and fragile.

What I Would Do

Create:

gitops/manifests/aws-load-balancer-controller/kustomization.yaml

Contents:

apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - serviceaccount.yaml

That's it.

Why This Matters

Your flow becomes:

Prereqs App
aws-load-balancer-controller-prereqs.yaml

points to:

gitops/manifests/aws-load-balancer-controller

ArgoCD sees:

kustomization.yaml

and deploys:

ServiceAccount

first.

Main App
aws-load-balancer-controller.yaml

installs:

aws-load-balancer-controller Helm Chart

with:

serviceAccount:
  create: false
  name: aws-load-balancer-controller

so the chart attaches to the ServiceAccount already created by the prereqs app.

Another Issue I Just Noticed

Your current manifest folder contains:

serviceaccount.yaml
dev-values.yaml

This works today.

But conceptually:

serviceaccount.yaml

is a Kubernetes manifest.

dev-values.yaml

is not.

It is a Helm values file.

Long-term I'd separate them.

Example:

gitops/
├── manifests/
│   └── aws-load-balancer-controller/
│       ├── kustomization.yaml
│       └── serviceaccount.yaml
│
└── values/
    └── aws-load-balancer-controller/
        └── dev-values.yaml

But I would not refactor this right now.

We're rebuilding infrastructure, not polishing repo layout.

Fix Service Account

Current:

annotations:
  eks.amazonaws.com/role-arn: ${alb_controller_role_arn}

This will fail.

Replace with actual ARN after Terraform apply.

Example:

annotations:
  eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/kk-platform-dev-alb-controller

We'll automate later.

One More Thing

I would also verify this file:

gitops/applications/platform/aws-load-balancer-controller.yaml

because earlier you pasted:

syncPolicy:

automated:
  prune: true
  selfHeal: true

which is invalid indentation.

It should be:

syncPolicy:
  automated:
    prune: true
    selfHeal: true

  syncOptions:
    - CreateNamespace=true

YAML indentation mistakes are one of the most common reasons ArgoCD apps fail to sync.

My Recommendation

Before recreating the environment:

Fix 1

Create:

gitops/manifests/aws-load-balancer-controller/kustomization.yaml
Fix 2

Replace:

${alb_controller_role_arn}

with real role ARN.

Fix 3

Replace:

vpcId: vpc-088ed7509b53c6c49

after Terraform creates the new VPC.

Fix 4

Validate:

kubectl kustomize gitops/manifests/aws-load-balancer-controller

(or locally with kustomize)

to ensure the prereqs manifest renders correctly.

After these fixes, I'd be comfortable rebuilding the environment and proceeding to:

Terraform
↓
EKS
↓
ArgoCD
↓
ALB Controller
↓
Java App
↓
Ingress
↓
Automatic ALB Creation

which is the first complete end-to-end platform milestone.
