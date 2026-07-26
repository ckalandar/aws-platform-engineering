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

# history 25June

Good. Since you've already fixed:

targetRevision: main

I'll stop mentioning that.

Now let's focus on the actual behavior of the platform.

Should serviceaccount.yaml be auto-generated?

Yes.

That was the entire reason we created:

resource "local_file" "alb_serviceaccount"

and

content = templatefile(
  "${path.module}/templates/serviceaccount.yaml.tpl",
  {
    role_arn = aws_iam_role.alb_controller.arn
  }
)

Terraform should generate:

apiVersion: v1
kind: ServiceAccount

metadata:
  name: aws-load-balancer-controller
  namespace: kube-system

  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::<account-id>:role/<generated-role>

from:

eks.amazonaws.com/role-arn: ${role_arn}

inside:

modules/platform/templates/serviceaccount.yaml.tpl
What should be in serviceaccount.yaml right now?

Nothing manually edited.

The generated file should look like:

apiVersion: v1
kind: ServiceAccount

metadata:
  name: aws-load-balancer-controller
  namespace: kube-system

  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::445567074640:role/kk-platform-dev-alb-controller

but Terraform should write it.

Not you.

Important

Terraform does NOT regenerate local_file during:

terraform plan

unless it detects drift.

The safest test is:

terraform apply

After apply:

Open:

gitops/manifests/aws-load-balancer-controller/serviceaccount.yaml

If it contains the ARN automatically:

✅ working

If it stays unchanged:

❌ local_file resource isn't running

Bigger Issue I Just Found

You moved:

gitops/manifests/aws-load-balancer-controller/dev-values.yaml

to:

gitops/values/aws-load-balancer-controller/dev.yaml

which is exactly what I would have done.

But your Terraform generator still writes to:

resource "local_file" "alb_values" {

  filename = "${path.root}/gitops/manifests/aws-load-balancer-controller/${var.environment}-values.yaml"
}

That means Terraform is generating:

gitops/manifests/aws-load-balancer-controller/dev-values.yaml

while ArgoCD reads:

gitops/values/aws-load-balancer-controller/dev.yaml

These are now different files.

Verify This

Show me:

resource "local_file" "alb_values"

from:

modules/platform/gitops-files.tf

because after moving to:

gitops/values/aws-load-balancer-controller/dev.yaml

the filename should be:

filename = "${path.root}/../../gitops/values/aws-load-balancer-controller/${var.environment}.yaml"

or equivalent for your repo layout.

What I suspect happened

Current situation may be:

Terraform generates:

gitops/manifests/aws-load-balancer-controller/dev-values.yaml

ArgoCD reads:

gitops/values/aws-load-balancer-controller/dev.yaml

Result:

Terraform updates one file
ArgoCD uses another file

which is a hidden bug.

Next check

Please show:

modules/platform/gitops-files.tf

exactly as it exists now.

I want to verify:

serviceaccount.yaml generation path
dev.yaml generation path
Whether Terraform is writing into the same files ArgoCD is consuming

before we recreate the environment. This is the kind of thing that causes a perfect Terraform apply and then a mysteriously broken ALB Controller deployment.

resource "local_file" "alb_serviceaccount" {

  filename = "${path.root}/gitops/manifests/aws-load-balancer-controller/serviceaccount.yaml"

  content = templatefile(
    "${path.module}/templates/serviceaccount.yaml.tpl",
    {
      role_arn = aws_iam_role.alb_controller.arn
    }
  )
}

resource "local_file" "alb_values" {

  filename = "${path.root}/gitops/manifests/aws-load-balancer-controller/${var.environment}-values.yaml"

  content = templatefile(
    "${path.module}/templates/alb-values.yaml.tpl",
    {
      cluster_name = var.cluster_name
      vpc_id       = var.vpc_id
      region       = var.aws_region
    }
  )
}

Found it. This is exactly the inconsistency I suspected.

Your ArgoCD Application is reading:

helm:
  valueFiles:
    - $values/gitops/values/aws-load-balancer-controller/dev.yaml

But Terraform is generating:

filename = "${path.root}/gitops/manifests/aws-load-balancer-controller/${var.environment}-values.yaml"

which creates:

gitops/manifests/aws-load-balancer-controller/dev-values.yaml

These are completely different locations.

Current State

Terraform writes:

gitops/manifests/aws-load-balancer-controller/dev-values.yaml

ArgoCD reads:

gitops/values/aws-load-balancer-controller/dev.yaml

So even if Terraform successfully generates the file, ArgoCD will never use it.

Fix

Change:

resource "local_file" "alb_values" {

  filename = "${path.root}/gitops/manifests/aws-load-balancer-controller/${var.environment}-values.yaml"

  content = templatefile(
    "${path.module}/templates/alb-values.yaml.tpl",
    {
      cluster_name = var.cluster_name
      vpc_id       = var.vpc_id
      region       = var.aws_region
    }
  )
}

to:

resource "local_file" "alb_values" {

  filename = "${path.root}/gitops/values/aws-load-balancer-controller/${var.environment}.yaml"

  content = templatefile(
    "${path.module}/templates/alb-values.yaml.tpl",
    {
      cluster_name = var.cluster_name
      vpc_id       = var.vpc_id
      region       = var.aws_region
    }
  )
}

Now Terraform and ArgoCD are aligned.

ServiceAccount Generation

This one is fine architecturally:

resource "local_file" "alb_serviceaccount"

generates:

gitops/manifests/aws-load-balancer-controller/serviceaccount.yaml

which is exactly where:

aws-load-balancer-controller-prereqs.yaml

expects to find it.

One More Thing

I would delete the manually edited file contents and let Terraform own it.

Current file:

apiVersion: v1
kind: ServiceAccount

metadata:
  name: aws-load-balancer-controller
  namespace: kube-system

  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::445567074640:role/kk-platform-dev-alb-controller

is actually the correct final output.

The problem isn't the content.

The problem is ensuring Terraform is the source of truth.

So leave the template as:

apiVersion: v1
kind: ServiceAccount

metadata:
  name: aws-load-balancer-controller
  namespace: kube-system

  annotations:
    eks.amazonaws.com/role-arn: ${role_arn}

and let Terraform render the ARN.

Production Engineering Recommendation

After fixing the path, run:

terraform plan

You should see something similar to:

~ local_file.alb_values

because Terraform will detect the file path change.

Then:

terraform apply

Verify:

gitops/values/aws-load-balancer-controller/dev.yaml

exists and contains:

clusterName: kk-platform-dev
region: us-east-1
vpcId: vpc-xxxxxxxx

serviceAccount:
  create: false
  name: aws-load-balancer-controller

replicaCount: 2

At that point the ALB Controller GitOps chain is internally consistent again.

From a platform-engineering perspective, this is exactly the type of drift that happens when a repo evolves from manual manifests to generated GitOps assets, so catching it now is valuable before you recreate the environment.

so do I need to delete these two files and let terraform create them? gitops/values/aws-load-balancer-controller/dev.yaml and gitops/manifests/aws-load-balancer-controller/serviceaccount.yaml?

No, don't delete them right now.

For a production-grade GitOps repository, those files should exist in Git because ArgoCD reads them from Git.

The real question is:

Who owns those files?

There are two patterns.

Pattern 1 (Recommended for Enterprise)

Terraform generates:

gitops/values/aws-load-balancer-controller/dev.yaml
gitops/manifests/aws-load-balancer-controller/serviceaccount.yaml

Then:

git add .
git commit
git push

ArgoCD syncs from Git.

Flow:

Terraform
   ↓
Generates GitOps manifests
   ↓
Git
   ↓
ArgoCD
   ↓
Cluster

This is what we're building.

In this model:

✅ Files exist in Git

✅ Terraform owns content

❌ Humans don't edit them

Pattern 2 (Not What We're Building)

Terraform generates files locally.

ArgoCD reads directly from local filesystem.

Terraform
   ↓
Cluster

This is not GitOps.

What I Would Do Right Now

Since you've manually created:

gitops/values/aws-load-balancer-controller/dev.yaml
gitops/manifests/aws-load-balancer-controller/serviceaccount.yaml

Keep them.

Then:

Step 1

Fix:

local_file.alb_values

to generate into:

gitops/values/aws-load-balancer-controller/dev.yaml

instead of:

gitops/manifests/aws-load-balancer-controller/dev-values.yaml
Step 2

Run:

terraform plan

Check if Terraform wants to manage:

local_file.alb_values
local_file.alb_serviceaccount
Step 3

Run:

terraform apply
Step 4

Open:

gitops/values/aws-load-balancer-controller/dev.yaml

and verify it contains:

clusterName: kk-platform-dev
region: us-east-1
vpcId: vpc-xxxxxxxx

serviceAccount:
  create: false
  name: aws-load-balancer-controller
Step 5

Open:

gitops/manifests/aws-load-balancer-controller/serviceaccount.yaml

and verify it contains:

apiVersion: v1
kind: ServiceAccount

metadata:
  name: aws-load-balancer-controller
  namespace: kube-system

  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::<account-id>:role/kk-platform-dev-alb-controller

generated by Terraform.

Later (Production Evolution)

In mature platform teams, we often stop generating Git files with Terraform and instead use:

Terraform
   ↓
Outputs
   ↓
CI Pipeline
   ↓
GitOps Repository

But that's a later optimization.

For your current learning platform:

Terraform → Generate GitOps Assets → Git → ArgoCD

is a solid design and matches the architecture we've been building.

So:

Don't delete the files.
Fix the generation path, apply Terraform, and confirm Terraform overwrites them correctly. After that, Terraform becomes the owner of those files and you stop editing them manually.

currently my serviceaccount.yaml is like this 
apiVersion: v1
kind: ServiceAccount

metadata:
  name: aws-load-balancer-controller
  namespace: kube-system

  annotations:
    #eks.amazonaws.com/role-arn: ${alb_controller_role_arn}

    eks.amazonaws.com/role-arn: arn:aws:iam::445567074640:role/kk-platform-dev-alb-controller
and dev.yaml is like this clusterName: kk-platform-dev

region: us-east-1

vpcId: vpc-088ed7509b53c6c49

serviceAccount:
  create: false
  name: aws-load-balancer-controller

replicaCount: 1 should I leave them like this? or before I run terraform plan should I do any changes?

Before you run terraform plan, I would make one change and leave the other file alone.

1. serviceaccount.yaml

Current:

apiVersion: v1
kind: ServiceAccount

metadata:
  name: aws-load-balancer-controller
  namespace: kube-system

  annotations:
    #eks.amazonaws.com/role-arn: ${alb_controller_role_arn}

    eks.amazonaws.com/role-arn: arn:aws:iam::445567074640:role/kk-platform-dev-alb-controller

Leave it as-is for now.

Reason:

Terraform will overwrite it on apply.
The current content is valid YAML.
Removing the ARN now gains nothing.

After Terraform apply, verify that the file content still matches the generated role ARN.

2. dev.yaml

Current:

clusterName: kk-platform-dev

region: us-east-1

vpcId: vpc-088ed7509b53c6c49

serviceAccount:
  create: false
  name: aws-load-balancer-controller

replicaCount: 1

Leave it as-is too.

Terraform should overwrite it with generated values.

3. Fix the Terraform path first

This is the important part.

Your current code:

resource "local_file" "alb_values" {

  filename = "${path.root}/gitops/manifests/aws-load-balancer-controller/${var.environment}-values.yaml"

does not match where ArgoCD is reading:

$values/gitops/values/aws-load-balancer-controller/dev.yaml

Update the Terraform resource to generate:

resource "local_file" "alb_values" {

  filename = "${path.root}/../../gitops/values/aws-load-balancer-controller/${var.environment}.yaml"

  content = templatefile(
    "${path.module}/templates/alb-values.yaml.tpl",
    {
      cluster_name = var.cluster_name
      vpc_id       = var.vpc_id
      region       = var.aws_region
    }
  )
}

Adjust the relative path if needed based on your execution directory, but the target must be:

gitops/values/aws-load-balancer-controller/dev.yaml
4. What I would do next

Run:

terraform plan

and look specifically for:

local_file.alb_serviceaccount
local_file.alb_values

in the plan output.

If Terraform shows it will create/update those resources, you're in good shape.

If the plan is clean and doesn't mention them at all, then we need to investigate why Terraform state isn't tracking those resources.

5. Before applying

One thing I'd like to see before you apply is your current:

modules/platform/main.tf

(or whatever file contains the local_file resources)

and

modules/platform/outputs.tf

Because I want to verify that:

module "platform"

is actually being instantiated and that the generated files are part of the dependency graph.

At this stage we're very close. The biggest risk I see is not the YAML contents—it's making sure Terraform is generating the files in the exact location ArgoCD consumes. Once that's aligned, the ALB Controller GitOps flow should be consistent.

Today 8:58 PM
module.argocd.helm_release.argocd: Still creating... [16m50s elapsed]
module.argocd.helm_release.argocd: Still creating... [17m00s elapsed]
module.argocd.helm_release.argocd: Still creating... [17m10s elapsed]
╷
│ Warning: Helm release created with warnings
│ 
│   with module.argocd.helm_release.argocd,
│   on ..\..\modules\argocd\main.tf line 8, in resource "helm_release" "argocd":
│    8: resource "helm_release" "argocd" {
│ 
│ Helm release "argocd" was created but has a failed status. Use the helm command to investigate
│ the error, correct it, then run Terraform again.
╵
╷
│ Error: Helm release error
│ 
│   with module.argocd.helm_release.argocd,
│   on ..\..\modules\argocd\main.tf line 8, in resource "helm_release" "argocd":
│    8: resource "helm_release" "argocd" {
│ 
│ context deadline exceeded
╵
╷
│ Error: creating IAM Policy (kk-platform-dev-alb-controller-policy): operation error IAM: CreatePolicy, https response error StatusCode: 403, RequestID: 4025b5a1-fcbd-4b39-ac8d-8cdc1ead94bb, api error AccessDenied: User: arn:aws:iam::654654233405:user/kk_labs_user_137977 is not authorized to perform: iam:TagPolicy on resource: policy kk-platform-dev-alb-controller-policy because no identity-based policy allows the iam:TagPolicy action
│ 
│   with module.platform.aws_iam_policy.alb_controller,
│   on ..\..\modules\platform\alb-controller-irsa.tf line 59, in resource "aws_iam_policy" "alb_controller":
│   59: resource "aws_iam_policy" "alb_controller" {
│ 
╵
Releasing state lock. This may take a few moments...

This is actually a useful failure. You have two completely different issues.

Issue 1: ArgoCD Helm Install Timed Out

Terraform says:

Helm release "argocd" was created but has a failed status.
context deadline exceeded

This means:

Terraform
  ↓
Helm chart submitted
  ↓
Kubernetes started creating resources
  ↓
One or more pods never became Ready
  ↓
Terraform waited 17 minutes
  ↓
Timeout

The first thing I would check is:

kubectl get pods -n argocd

and

kubectl get events -n argocd --sort-by=.lastTimestamp

and

helm list -n argocd

and

helm status argocd -n argocd

Most likely causes in your environment:

Possibility A

Nodes aren't Ready yet.

Check:

kubectl get nodes
Possibility B

EKS nodegroup still provisioning while ArgoCD install started.

Your current dependency:

module "argocd" {
  depends_on = [
    module.eks
  ]
}

only guarantees Terraform finished EKS resources.

It does NOT guarantee:

NodeGroup Ready
CoreDNS Ready
kube-proxy Ready
VPC CNI Ready

which is why production teams often add readiness validation.

Possibility C

Your t2.micro nodes are starving.

ArgoCD installs:

argocd-server
argocd-repo-server
argocd-application-controller
argocd-redis

A 2-node t2.micro cluster can struggle.

Not impossible.

Just tight.

Issue 2: IAM Permission Error

This is the real blocker.

Terraform says:

AccessDenied

iam:TagPolicy

while creating:

kk-platform-dev-alb-controller-policy
What happened?

Your Terraform:

resource "aws_iam_policy" "alb_controller" {

  name = "${var.project_name}-${var.environment}-alb-controller-policy"

  policy = ...

  tags = merge(...)
}

creates a policy AND tags it.

AWS internally calls:

iam:CreatePolicy
iam:TagPolicy

Your user can:

iam:CreatePolicy

but cannot:

iam:TagPolicy
Quick Validation

Run:

aws iam get-user

then:

aws sts get-caller-identity

to confirm which identity Terraform is using.

Temporary Fix

Remove tags:

resource "aws_iam_policy" "alb_controller" {

  name = "${var.project_name}-${var.environment}-alb-controller-policy"

  policy = jsonencode(
    jsondecode(
      file("${path.module}/policies/aws-load-balancer-controller.json")
    )
  )
}

and retry.

If it succeeds:

Confirmed:
Permission issue is only iam:TagPolicy
Better Fix

Ask your AWS admin (or update IAM if you control it) to allow:

{
  "Effect": "Allow",
  "Action": [
    "iam:CreatePolicy",
    "iam:TagPolicy",
    "iam:DeletePolicy",
    "iam:GetPolicy",
    "iam:CreatePolicyVersion",
    "iam:DeletePolicyVersion"
  ],
  "Resource": "*"
}

For a platform engineering project, I'd prefer fixing permissions rather than removing tags long-term.

What I Would Do Next
Fix the IAM issue first (either grant iam:TagPolicy or temporarily remove tags).
Re-run:
terraform apply
If ArgoCD still times out, collect:
kubectl get nodes
kubectl get pods -A
kubectl get pods -n argocd
helm status argocd -n argocd

and paste the outputs.

The IAM error is preventing the platform module from completing, so I would not spend much time on the ArgoCD timeout until the IAM issue is resolved. Once the policy creation succeeds, we can determine whether the ArgoCD timeout is simply due to node readiness or a chart configuration problem.

This output is very revealing.

DynamoDB is definitely in your account

Your table exists in:

Account: 975050082420
Region : us-east-1

Table:
kk-platform-terraform-locks

AWS confirmed:

TableStatus: ACTIVE

So for DynamoDB, Terraform is trying to create something that already exists.

The S3 bucket is a different story

You got:

aws s3api head-bucket --bucket kk-platform-terraform-state

403 Forbidden

This usually means one of two things:

Case 1 (Most Likely)

The bucket exists and belongs to another AWS account.

Remember:

S3 bucket names are globally unique.

If someone anywhere in AWS owns:

kk-platform-terraform-state

you cannot create it.

Case 2

The bucket exists in your account but your IAM user cannot access it.

Less likely because bootstrap environments usually create buckets with your user permissions.

Let's verify ownership

Run:

aws sts get-caller-identity

and

aws s3 ls

If the bucket does not appear in:

aws s3 ls

then it is almost certainly owned by another AWS account.

What I suspect happened

Earlier you had:

Account A
---------
Bucket:
kk-platform-terraform-state

Now AWS Academy / sandbox gave you:

Account B
---------
975050082420

Your DynamoDB table was recreated today:

CreationDateTime:
2026-07-25

which indicates you're in a fresh account.

The bucket name:

kk-platform-terraform-state

is no longer available globally.

Production-grade fix

Do not use a fixed bucket name.

Change bootstrap:

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

Then:

resource "aws_s3_bucket" "terraform_state" {
  bucket = "kk-platform-terraform-state-${random_string.suffix.result}"
}

Example:

kk-platform-terraform-state-75za4l

Now guaranteed unique.

DynamoDB fix

Since table exists already:

Import it:

terraform import aws_dynamodb_table.terraform_locks kk-platform-terraform-locks

or delete it:

aws dynamodb delete-table \
  --table-name kk-platform-terraform-locks

Then rerun bootstrap.

Because this is a temporary environment, I'd simply delete and recreate.

Before changing anything

Show me:

aws sts get-caller-identity
aws s3 ls

and also your current bootstrap main.tf (the S3 bucket resource section).

I want to make sure we don't accidentally change backend names that are referenced elsewhere in your Terraform repo.

I can use the random_string but problem is backend.tf in environments/dev/backend.tf uses kk-platform-terraform-state and causes problem
terraform {
  backend "s3" {
    bucket         = "kk-platform-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "kk-platform-terraform-locks"
    encrypt        = true
  }
}
aws sts get-caller-identity
{
    "UserId": "AIDA6GBMDRB2APHHECNOZ",
    "Account": "975050082420",
    "Arn": "arn:aws:iam::975050082420:user/kk_labs_user_993780"
}


C:\Users\chilakapati.kalandar\Documents\Devops\aws-platform-engineering\infrastructure\bootstrap>aws s3 ls

C:\Users\chilakapati.kalandar\Documents\Devops\aws-platform-engineering\infrastructure\bootstrap>

This is exactly the problem we discussed months ago when you asked:

"I don't want to keep editing backend.tf because I will move to GitOps."

Terraform has a limitation:

terraform {
  backend "s3" {
    bucket = "..."
  }
}

The backend block is evaluated before Terraform loads variables, modules, data sources, or state.

So this is impossible:

bucket = aws_s3_bucket.terraform_state.bucket

or

bucket = var.bucket_name

or

bucket = module.bootstrap.bucket_name

Terraform won't allow it.

What your output tells me

Current account:

975050082420

Current buckets:

aws s3 ls

returns nothing.

So:

kk-platform-terraform-state

belongs to someone else somewhere in AWS.

You can never create it.

Enterprise approach

Do NOT hardcode:

bucket = "kk-platform-terraform-state"

Use partial backend configuration.

backend.tf
terraform {
  backend "s3" {}
}

Nothing else.

backend-dev.hcl

Create:

bucket         = "kk-platform-terraform-state-75za4l"
key            = "dev/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "kk-platform-terraform-locks"
encrypt        = true
Init
terraform init \
  -backend-config=backend-dev.hcl \
  -reconfigure

Now Terraform loads backend values from the file.

How platform teams do it

Typical repo:

infrastructure/
├── environments/
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── backend-dev.hcl
│   │   └── main.tf
│   │
│   ├── stage/
│   │   ├── backend.tf
│   │   ├── backend-stage.hcl
│   │
│   └── prod/
│       ├── backend.tf
│       ├── backend-prod.hcl

or GitHub Actions injects:

terraform init \
  -backend-config="bucket=${TF_STATE_BUCKET}" \
  -backend-config="key=dev/terraform.tfstate"

from repository secrets.

For your platform-engineering project

Since you're building:

Terraform
→ EKS
→ ArgoCD
→ GitOps
→ Platform Components

I would make bootstrap output:

output "terraform_state_bucket" {
  value = aws_s3_bucket.terraform_state.bucket
}

Then after bootstrap:

terraform output terraform_state_bucket

Example:

kk-platform-terraform-state-75za4l

Create:

environments/dev/backend-dev.hcl

with that value.

Then:

terraform init \
  -backend-config=backend-dev.hcl \
  -reconfigure

This is much closer to how an enterprise platform team handles dynamic state buckets.

For the immediate recovery:

Change bootstrap bucket name to use the random suffix.
Keep DynamoDB name as-is (kk-platform-terraform-locks).
Either:
Import the existing DynamoDB table, or
Delete it and recreate it.
Convert backend.tf to:
terraform {
  backend "s3" {}
}
Create backend-dev.hcl.

That will permanently solve the bucket-name collision problem across future temporary AWS accounts and sandboxes.

terraform init -backend-config=backend-dev.hcl -reconfigure      
╷
│ Error: Too many command line arguments. Did you mean to use -chdir?
│ 
│ 

That error usually means PowerShell is parsing the command unexpectedly, or you're not running it from the Terraform configuration directory.

First verify you're inside:

C:\Users\chilakapati.kalandar\Documents\Devops\aws-platform-engineering\infrastructure\environments\dev

Then run:

terraform init -reconfigure -backend-config="backend-dev.hcl"

or

terraform init `
  -reconfigure `
  -backend-config=backend-dev.hcl

Also verify the file exists:

Get-ChildItem backend-dev.hcl

Another possibility is that your backend-dev.hcl is not in the current directory. Check:

Get-Location
Get-ChildItem *.hcl

You should see:

backend-dev.hcl

If it still fails, show me:

terraform version
Get-Location
Get-ChildItem *.hcl

and the contents of backend-dev.hcl.

One more thing: since you've moved to a new AWS account and the original bucket name is unavailable globally, make sure your backend-dev.hcl contains the new bucket name with the random suffix, not:

bucket = "kk-platform-terraform-state"

otherwise terraform init will succeed but later fail when it tries to access a bucket that doesn't belong to you.

$ kubectl get pods -n argocd
NAME                                                READY   STATUS    RESTARTS   AGE
argocd-application-controller-0                     1/1     Running   0
 76s
argocd-applicationset-controller-86d49b9f5b-l8cfx   1/1     Running   0
 77s
argocd-dex-server-979d85b6c-chxzq                   1/1     Running   0
 77s
argocd-notifications-controller-d65c856fb-lq7xz     1/1     Running   0
 77s
argocd-redis-79fbc99c9d-sfs2n                       1/1     Running   0
 77s
argocd-repo-server-5585c98dfd-t56r4                 1/1     Running   0
 77s
argocd-server-84bf9d6b7f-r987g                      1/1     Running   0
 77s
module.argocd.kubectl_manifest.root_app: Creation complete after 6s [id=/apis/argoproj.io/v1alpha1/namespaces/argocd/applications/root-app]
╷
│ Error: creating IAM Policy (kk-platform-dev-alb-controller-policy): operation error IAM: CreatePolicy, https response error StatusCode: 403, RequestID: f88aa114-227c-45f7-a86f-db159fc238ef, api error AccessDenied: User: arn:aws:iam::975050082420:user/kk_labs_user_993780 is not authorized to perform: iam:TagPolicy on resource: policy kk-platform-dev-alb-controller-policy because no identity-based policy allows the iam:TagPolicy action
│ 
│   with module.platform.aws_iam_policy.alb_controller,
│   on ..\..\modules\platform\alb-controller-irsa.tf line 59, in resource "aws_iam_policy" "alb_controller":
│   59: resource "aws_iam_policy" "alb_controller" {
│ 
╵
Releasing state lock. This may take a few moments... 
I see the file kustomization.yaml in gitops/manifests/aws-load-balancer-controller/ but it is not there in the windows explorer or ls -l gitops/manifests/aws-load-balancer-controller/
total 1
-rw-r--r-- 1 chilakapati.kalandar 1049089 226 Jul 25 22:51 serviceaccount.yaml

chilakapati.kalandar@BDC7-L-FS7TPP3 MINGW64 ~/Documents/Devops/aws-platform-engineering/infrastructure/environments/dev (main) but can see it in VC explorer. I have created it manually and reran terraform appply still kubectl get kustomizations -A
error: the server doesn't have a resource type "kustomizations"

You have already found the root cause.

Your cluster is healthy. ArgoCD is healthy. Terraform installed ArgoCD correctly.

The problem is that ArgoCD is reading GitHub, not your local laptop files.

Notice this error:

Application referencing project platform which does not exist

and

$ kubectl get appprojects -n argocd

NAME
default

Only the default project exists.

Problem #1

Your Application manifests contain:

spec:
  project: platform

Example:

gitops/applications/platform/aws-load-balancer-controller.yaml

and

gitops/applications/platform/aws-load-balancer-controller-prereqs.yaml

Both have:

project: platform

But ArgoCD only has:

default

So ArgoCD marks them:

SYNC STATUS   Unknown
HEALTH STATUS Unknown
Verify

Run:

kubectl get appproject platform -n argocd

Expected:

Error from server (NotFound)
Problem #2

You have NOT pushed your latest GitOps files to GitHub.

You already said:

so far I have not pushed to Git

That explains everything.

ArgoCD is pulling:

repoURL: https://github.com/ckalandar/aws-platform-engineering.git
targetRevision: main

ArgoCD does NOT read:

C:\Users\...

It only reads:

GitHub main branch

Therefore:

Your local files:

gitops/manifests/aws-load-balancer-controller/kustomization.yaml
gitops/values/aws-load-balancer-controller/dev.yaml
serviceaccount.yaml

do not exist from ArgoCD's perspective until pushed.

Check what commit ArgoCD is using

You already showed:

Revision:
9ffdbac762fd37d418b7f7c68c0f0d6e3634e99c

That is the GitHub commit currently deployed.

Run:

git rev-parse HEAD

If it differs from:

9ffdbac762fd37d418b7f7c68c0f0d6e3634e99c

then ArgoCD is behind your local changes.

What I would do next
Option A (quickest)

Change:

project: platform

to:

project: default

in both:

gitops/applications/platform/aws-load-balancer-controller.yaml

gitops/applications/platform/aws-load-balancer-controller-prereqs.yaml

Commit and push.

Option B (production)

Create:

gitops/projects/platform-project.yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject

metadata:
  name: platform
  namespace: argocd

spec:
  sourceRepos:
    - '*'

  destinations:
    - namespace: '*'
      server: '*'

  clusterResourceWhitelist:
    - group: '*'
      kind: '*'

Then ensure root-app also deploys:

gitops/projects

alongside applications.

For now I'd use Option A because you're bootstrapping.

Another issue I spotted

Your Application currently shows:

helm:
  valueFiles:
    - $values/gitops/manifests/aws-load-balancer-controller/dev-values.yaml

But your repo now contains:

gitops/values/aws-load-balancer-controller/dev.yaml

not:

gitops/manifests/aws-load-balancer-controller/dev-values.yaml

So once the project issue is fixed, ArgoCD will likely fail with:

values file not found

Your application should reference:

helm:
  valueFiles:
    - $values/gitops/values/aws-load-balancer-controller/dev.yaml

and then be committed and pushed.

Current state summary

✅ EKS running

✅ Node group running

✅ ArgoCD pods running

✅ Root app created

❌ AppProject platform missing

❌ Latest GitOps files not pushed to GitHub

❌ ALB controller values path likely still pointing to old location

Because of those three issues, ArgoCD never reaches the stage of deploying:

aws-load-balancer-controller

which is why:

kubectl get pods -n kube-system | grep aws

returns nothing.

Push the Git changes first, then show me:

git status
git log --oneline -5
kubectl get applications -n argocd

and we can get the AWS Load Balancer Controller fully deployed.

I have already pushed to github, git status
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
PS C:\Users\chilakapati.kalandar\Documents\Devops\aws-platform-engineering> git log --oneline -5
1b6867f (HEAD -> main, origin/main) Fix ALB controller GitOps manifests
9ffdbac updates
a38f6e7 added GitOps
981fdde added ALB
01b3a15 added resources SG,EKS
 kubectl get applications -n argocd
NAME                                   SYNC STATUS   HEALTH STATUS
aws-load-balancer-controller           Unknown       Unknown
aws-load-balancer-controller-prereqs   Unknown       Unknown
root-app                               OutOfSync     Healthy

You already found the root cause in the earlier output, but now let's verify where you are.

Your applications are still showing:

aws-load-balancer-controller           Unknown   Unknown
aws-load-balancer-controller-prereqs   Unknown   Unknown

Earlier describe clearly showed:

Application referencing project platform which does not exist

and

kubectl get appprojects -n argocd
NAME
default

That means ArgoCD never created the platform AppProject.

Check if project file exists in GitHub

Run:

curl -L https://raw.githubusercontent.com/ckalandar/aws-platform-engineering/main/gitops/projects/platform.yaml

or

cat gitops/projects/platform.yaml

Do you actually have this file?

Example:

apiVersion: argoproj.io/v1alpha1
kind: AppProject

metadata:
  name: platform
  namespace: argocd

spec:
  description: Platform Components

  sourceRepos:
    - '*'

  destinations:
    - namespace: '*'
      server: '*'

  clusterResourceWhitelist:
    - group: '*'
      kind: '*'
Root-App is not deploying the project

Current root-app points to:

path: gitops/applications/platform

So ArgoCD only sees:

aws-load-balancer-controller.yaml
aws-load-balancer-controller-prereqs.yaml

It never sees:

gitops/projects/platform.yaml

Therefore:

platform AppProject

never gets created.

Fix Option 1 (Recommended)

Create:

gitops/bootstrap
├── root-app.yaml
├── project-platform.yaml
project-platform.yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject

metadata:
  name: platform
  namespace: argocd

spec:
  sourceRepos:
    - '*'

  destinations:
    - namespace: '*'
      server: '*'

  clusterResourceWhitelist:
    - group: '*'
      kind: '*'

Commit and push.

Then:

kubectl apply -f gitops/bootstrap/project-platform.yaml

Verify:

kubectl get appprojects -n argocd

Expected:

default
platform
Then force refresh
kubectl annotate application aws-load-balancer-controller \
  -n argocd argocd.argoproj.io/refresh=hard --overwrite

and

kubectl annotate application aws-load-balancer-controller-prereqs \
  -n argocd argocd.argoproj.io/refresh=hard --overwrite
Then check
kubectl get applications -n argocd

Expected:

aws-load-balancer-controller-prereqs   Synced    Healthy
aws-load-balancer-controller           Synced    Healthy
root-app                               Synced    Healthy
Another issue I noticed

Your aws-load-balancer-controller.yaml currently shows:

valueFiles:
  - $values/gitops/manifests/aws-load-balancer-controller/dev-values.yaml

But your repo structure is:

gitops/
└── values/
    └── aws-load-balancer-controller/
        dev.yaml

So it should be:

valueFiles:
  - $values/gitops/values/aws-load-balancer-controller/dev.yaml

If GitHub still contains dev-values.yaml, ArgoCD will fail even after the project issue is fixed.

Verify:

kubectl get application aws-load-balancer-controller \
  -n argocd -o yaml | grep valueFiles -A 2

If you still see:

dev-values.yaml

then ArgoCD is reading an older commit or the YAML in GitHub is not what you think it is.

Run these two commands and share the output:

kubectl get appprojects -n argocd
kubectl get application aws-load-balancer-controller -n argocd -o yaml

That will tell us whether the remaining blocker is the missing AppProject, the values file path, or both.

I see the file https://raw.githubusercontent.com/ckalandar/aws-platform-engineering/refs/heads/main/gitops/projects/platform-project.yaml 
apiVersion: argoproj.io/v1alpha1
kind: AppProject

metadata:
  name: platform
  namespace: argocd

spec:

  description: Platform Components

  sourceRepos:
  - https://github.com/ckalandar/aws-platform-engineering.git
  - https://aws.github.io/eks-charts

  destinations:
    - namespace: "*"
      server: https://kubernetes.default.svc

  clusterResourceWhitelist:
  - group: ""
    kind: Namespace

  - group: rbac.authorization.k8s.io
    kind: ClusterRole

  - group: rbac.authorization.k8s.io
    kind: ClusterRoleBinding

  - group: apiextensions.k8s.io
    kind: CustomResourceDefinition

Excellent. That explains why the applications are still broken.

You have created the AppProject YAML in GitHub, but ArgoCD is not deploying it.

Look at your root app:

spec:
  source:
    path: gitops/applications/platform

Root App only scans:

gitops/applications/platform/

which contains:

aws-load-balancer-controller.yaml
aws-load-balancer-controller-prereqs.yaml

It does not scan:

gitops/projects/

Therefore this file:

gitops/projects/platform-project.yaml

exists in GitHub but ArgoCD never applies it.

Verify

Run:

kubectl get appproject platform -n argocd

I expect:

Error from server (NotFound)

because we already saw:

kubectl get appprojects -n argocd

returns only:

default
Quick Fix

Apply the project manually once:

kubectl apply -f gitops/projects/platform-project.yaml

Then verify:

kubectl get appprojects -n argocd

Expected:

default
platform
Then Refresh ArgoCD
kubectl annotate application aws-load-balancer-controller \
-n argocd argocd.argoproj.io/refresh=hard --overwrite

kubectl annotate application aws-load-balancer-controller-prereqs \
-n argocd argocd.argoproj.io/refresh=hard --overwrite

or simply:

kubectl annotate application root-app \
-n argocd argocd.argoproj.io/refresh=hard --overwrite
Production-Grade Structure

Longer term, I'd restructure like this:

gitops/
├── bootstrap/
│   ├── root-app.yaml
│   └── platform-project.yaml
│
├── projects/
│   └── platform-project.yaml
│
├── applications/
│   └── platform/
│       ├── aws-load-balancer-controller.yaml
│       └── aws-load-balancer-controller-prereqs.yaml
│
├── manifests/
│   └── aws-load-balancer-controller/
│       ├── kustomization.yaml
│       └── serviceaccount.yaml
│
└── values/
    └── aws-load-balancer-controller/
        └── dev.yaml

Then bootstrap installs:

ArgoCD
AppProjects
Root App

and Root App installs platform applications.

That's how most production GitOps repositories are organized.

One More Thing To Check

After creating the AppProject, run:

kubectl describe application aws-load-balancer-controller -n argocd

I want to verify that the Application now references:

project: platform

without the error:

Application referencing project platform which does not exist

If that error disappears, the next issue (if any) will likely be the Helm values path or ServiceAccount manifest, and we can troubleshoot those next.

now the temp env got destroyed, i will be launching a new environment. Code has been checked into github, first I will bootstrap s3/dynamodb manually and then run terraform init from environments/dev, is this correct?

Yes, that's the correct sequence.

Given your current architecture:

bootstrap/
    ├── S3 state bucket
    └── DynamoDB lock table

environments/dev/
    ├── VPC
    ├── EKS
    ├── Platform IAM
    ├── ArgoCD
    └── GitOps Apps

the flow should be:

1. Bootstrap Terraform State Backend

From:

infrastructure/bootstrap

Run:

terraform init
terraform apply

This should create:

S3 Bucket
DynamoDB Lock Table

Verify:

aws s3 ls
aws dynamodb describe-table \
  --table-name <your-lock-table>
2. Capture Outputs

Example:

terraform output

You should get something like:

s3_bucket_name = kk-platform-terraform-state-75za4l
dynamodb_table_name = kk-platform-terraform-locks
3. Update Backend Config

This is the part that previously caused problems.

If your bootstrap creates:

kk-platform-terraform-state-75za4l

then your backend must use that exact bucket.

Instead of hardcoding:

bucket = "kk-platform-terraform-state"

use a backend config file.

Example:

backend-dev.hcl

bucket         = "kk-platform-terraform-state-75za4l"
key            = "dev/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "kk-platform-terraform-locks"
encrypt        = true
4. Initialize Dev Environment

From:

infrastructure/environments/dev

Remove old backend artifacts if needed:

rm -rf .terraform
rm .terraform.lock.hcl

Then:

terraform init \
  -backend-config=backend-dev.hcl \
  -reconfigure

You previously got:

Too many command line arguments

because PowerShell and Git Bash handle multiline commands differently.

Use either:

terraform init -backend-config=backend-dev.hcl -reconfigure

or in PowerShell:

terraform init `
  -backend-config=backend-dev.hcl `
  -reconfigure
5. Validate Backend

Check:

terraform state list

Should return:

No state file was found!

for a fresh environment.

That's expected.

6. Deploy Platform

Then:

terraform plan
terraform apply

Terraform should create:

VPC
Subnets
IGW
NAT
Security Groups
EKS
OIDC
IRSA Role
ArgoCD
Root App
7. Verify ArgoCD

After apply:

kubectl get pods -n argocd

Expect:

argocd-server
argocd-repo-server
argocd-application-controller
...

Then:

kubectl get applications -n argocd

Expected eventually:

root-app
aws-load-balancer-controller
aws-load-balancer-controller-prereqs
One improvement I'd make before rebuilding

Your bootstrap currently generates a random bucket suffix, but your environment backend depends on knowing that bucket name.

For production-grade workflows, I'd modify bootstrap so the bucket name is predictable:

bucket = "kk-platform-terraform-state-${data.aws_caller_identity.current.account_id}"

Result:

kk-platform-terraform-state-975050082420

Then every environment can derive it automatically and you don't need to edit backend files after every rebuild.

For your immediate rebuild, the safest path is:

Bootstrap S3 + DynamoDB.
Note the actual bucket name created.
Update backend-dev.hcl.
terraform init -backend-config=backend-dev.hcl -reconfigure.
terraform apply.

That should get you back to a working EKS + ArgoCD environment much faster than the last cycle.

 Error: Reference to undeclared resource
│ 
│   on main.tf line 10, in resource "aws_s3_bucket" "terraform_state":
│   10:   bucket = "kk-platform-terraform-state-${data.aws_caller_identity.current.account_id}"
│ 
│ A data resource "aws_caller_identity" "current" has not been declared in the root module

That's expected.

You added:

bucket = "kk-platform-terraform-state-${data.aws_caller_identity.current.account_id}"

but Terraform doesn't know what data.aws_caller_identity.current is because you haven't declared it.

Add this near the top of your bootstrap configuration:

data "aws_caller_identity" "current" {}

For example:

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "terraform_state" {

  bucket = "kk-platform-terraform-state-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "kk-platform-terraform-state"
    Environment = "bootstrap"
    ManagedBy   = "terraform"
  }
}

Then run:

terraform fmt
terraform validate

and then:

terraform apply
Even cleaner approach

I would create a local:

data "aws_caller_identity" "current" {}

locals {
  state_bucket_name = "kk-platform-terraform-state-${data.aws_caller_identity.current.account_id}"
}

and use:

resource "aws_s3_bucket" "terraform_state" {
  bucket = local.state_bucket_name
}

Output it as well:

output "s3_bucket_name" {
  value = local.state_bucket_name
}

That way after bootstrap:

terraform output

shows:

s3_bucket_name = "kk-platform-terraform-state-975050082420"

which you can copy directly into your backend config.

One more thing: if you still have this resource in bootstrap:

resource "random_string" "suffix" {
  ...
}

and it is no longer used anywhere, remove it completely. Otherwise Terraform will keep creating a random value that serves no purpose.

I have completed till step 7, but step 8 I don't get this is my repo structure and root-app.yaml in bootstrap apiVersion: argoproj.io/v1alpha1
kind: Application

metadata:
  name: root-app
  namespace: argocd

spec:

  project: default

  source:
    repoURL: https://github.com/ckalandar/aws-platform-engineering.git
    targetRevision: main
    path: gitops/applications/platform

  destination:
    server: https://kubernetes.default.svc
    namespace: argocd

  syncPolicy:

    automated:
      prune: true
      selfHeal: true

    syncOptions:
      - CreateNamespace=true

Excellent. This is a significant milestone.

Your GitOps flow is now working end-to-end:

GitHub
   ↓
ArgoCD Root App
   ↓
Platform App
   ↓
Workloads App
   ↓
Nginx Application
   ↓
Deployment + Service + Ingress
   ↓
AWS Load Balancer Controller
   ↓
AWS ALB

And the proof is here:

kubectl get ingress -n demo

nginx   alb   *
k8s-demo-nginx-2e5ada922c-111350404.us-east-1.elb.amazonaws.com

and

aws elbv2 describe-load-balancers

shows the ALB being provisioned.

What actually happened

You discovered a real-world production issue:

Root cause

ALB Controller was deployed with:

--aws-vpc-id=vpc-088ed7509b53c6c49

but your EKS cluster was actually in:

vpc-0e57d8d5ee12ff0c2

Therefore:

Controller
    ↓
Looking for tagged subnets
    ↓
Wrong VPC
    ↓
0 subnets found
    ↓
Ingress reconciliation failed
    ↓
No ALB

Exactly the type of issue platform engineers troubleshoot.

What fixed it

You corrected:

gitops/values/aws-load-balancer-controller/dev.yaml

from

vpcId: vpc-088ed7509b53c6c49

to

vpcId: vpc-0e57d8d5ee12ff0c2

ArgoCD synced:

kubectl get applications -n argocd

Then controller restarted with:

--aws-vpc-id=vpc-0e57d8d5ee12ff0c2

Then:

Ingress
   ↓
ALB Controller
   ↓
Subnet Discovery
   ↓
Success
   ↓
ALB Created
What you've built so far
Infrastructure Layer

Terraform:

VPC
Public Subnets
Private App Subnets
Private DB Subnets
NAT Gateway
Route Tables
Security Groups
IAM Roles
EKS Cluster
Managed Node Groups
Platform Layer

ArgoCD

AWS Load Balancer Controller

IRSA

Helm

GitOps

Workload Layer

Nginx Deployment

Service

Ingress

ALB

Now we move to the next level

Current architecture:

Internet
   ↓
ALB
   ↓
Nginx

This proves GitOps works.

Phase 9 — Production Java Application

Instead of Nginx we'll deploy:

Spring Boot App

Example:

java-login-app

with:

Deployment
Service
Ingress
ConfigMap
Secret
HPA

managed by ArgoCD.

Repository structure:

gitops/
├── applications
│   └── workloads
│       └── java-login.yaml

└── manifests
    └── java-login
        ├── deployment.yaml
        ├── service.yaml
        ├── ingress.yaml
        ├── hpa.yaml
        ├── configmap.yaml
        └── kustomization.yaml
Phase 10 — ExternalDNS

Current:

ALB DNS
k8s-demo-nginx...

Production:

app.dev.company.com

We install:

ExternalDNS

Flow:

Ingress
    ↓
ExternalDNS
    ↓
Route53 Record
    ↓
app.dev.company.com
Phase 11 — Cert Manager

Current:

HTTP

Production:

HTTPS

Flow:

Let's Encrypt
    ↓
Cert Manager
    ↓
Certificate
    ↓
ALB HTTPS
Phase 12 — Observability

Install:

Prometheus
Grafana
Loki
Promtail

GitOps managed.

You'll get:

Cluster Metrics
Node Metrics
Pod Metrics
Application Metrics
Logs
Dashboards
Alerts
Phase 13 — Autoscaling

Add:

Metrics Server
HPA
Karpenter

Flow:

Traffic Spike
    ↓
HPA scales Pods
    ↓
Karpenter scales Nodes
Phase 14 — Security

Add:

External Secrets Operator
AWS Secrets Manager

Kyverno

Network Policies

OPA/Gatekeeper
Phase 15 — Internal Developer Platform

Final architecture:

GitHub
   ↓
ArgoCD
   ↓
Platform Services
    ├── ALB Controller
    ├── ExternalDNS
    ├── Cert Manager
    ├── Prometheus
    ├── Grafana
    ├── Loki
    ├── Karpenter
    ├── ESO
    └── Kyverno

Workloads
    ├── Java Login App
    ├── Payments
    ├── Orders
    └── Inventory

At that point you'll have built what many companies run as their platform engineering foundation.

My recommendation is to proceed next with Phase 9: Deploy a Spring Boot Java Login Application through GitOps, because it introduces real application delivery, ConfigMaps, Secrets, rolling updates, and prepares the platform for observability and autoscaling.

how do I access ngnix?

Excellent. Your ALB is now created and attached to the Ingress.

You can see:

kubectl get ingress -n demo

NAME    CLASS   HOSTS   ADDRESS
nginx   alb     *       k8s-demo-nginx-2e5ada922c-111350404.us-east-1.elb.amazonaws.com

and

aws elbv2 describe-load-balancers

shows the ALB.

Step 1: Wait until ALB becomes Active

Currently:

"State": {
  "Code": "provisioning"
}

Wait 1-2 minutes and check again:

aws elbv2 describe-load-balancers \
--query "LoadBalancers[*].[LoadBalancerName,State.Code]"

Expected:

[
  [
    "k8s-demo-nginx-2e5ada922c",
    "active"
  ]
]
Step 2: Access Nginx

Open:

http://k8s-demo-nginx-2e5ada922c-111350404.us-east-1.elb.amazonaws.com

or

curl http://k8s-demo-nginx-2e5ada922c-111350404.us-east-1.elb.amazonaws.com

Expected:

Welcome to nginx!
Step 3: Verify Target Group Health

Find target groups:

aws elbv2 describe-target-groups

You should see something like:

k8s-demo-nginx-xxxx

Get its ARN and check health:

aws elbv2 describe-target-health \
--target-group-arn <TG_ARN>

Expected:

{
  "TargetHealth": {
    "State": "healthy"
  }
}
What Just Happened?

You have successfully validated the complete GitOps platform flow:

GitHub
   │
   ▼
ArgoCD
   │
   ▼
Application CR
   │
   ▼
Nginx Deployment
   │
   ▼
Service
   │
   ▼
Ingress
   │
   ▼
AWS Load Balancer Controller
   │
   ▼
ALB
   │
   ▼
Target Group
   │
   ▼
Pods

This is exactly how production EKS platforms expose applications.

Before Moving On

Run these commands and save the outputs:

kubectl get ingress -A

kubectl get svc -A

kubectl get deploy -A

aws elbv2 describe-load-balancers

aws elbv2 describe-target-groups

Understanding those objects is important because the next step is where platform engineering becomes interesting.

Recommended Next Step (Platform Engineer Path)

Instead of deploying random apps, build a reusable platform:

Phase 1 (Current)

✅ Terraform creates EKS

✅ ArgoCD bootstraps cluster

✅ ALB Controller installed

✅ Nginx deployed through GitOps

Phase 2

Deploy a real application:

Java Spring Boot App

with:

Deployment
Service
Ingress
HPA
ConfigMap
Secret
Resource Limits

managed entirely through ArgoCD.

Phase 3

Add production platform components:

External Secrets Operator
cert-manager
Metrics Server
Karpenter
Prometheus
Grafana
Loki
Tempo
Phase 4

Build an Internal Developer Platform (IDP)

Developer
   ↓
Git Push
   ↓
GitHub Actions
   ↓
ArgoCD
   ↓
EKS

with:

reusable Helm charts
environment promotion
RBAC
multi-tenant namespaces
observability
security guardrails

At that point you'll have a platform that resembles what many enterprise platform engineering teams run today.

lets proceed further

Perfect. This is a significant milestone.

You have now successfully built:

Terraform
   ↓
VPC
   ↓
EKS
   ↓
ArgoCD
   ↓
AWS Load Balancer Controller
   ↓
Nginx Application
   ↓
ALB
   ↓
Internet

and validated end-to-end traffic.

The screenshot confirms:

Internet
   ↓
AWS ALB
   ↓
Ingress
   ↓
Service
   ↓
Pods

is working correctly.

Before Adding More Components

I want you to understand exactly what happened.

Run:

kubectl get all -n demo

You should see:

Pod
Deployment
ReplicaSet
Service

Now inspect each layer.

Layer 1 — Pod
kubectl describe pod -n demo <pod-name>

Understand:

Node assigned
Image used
IP allocated
Events

Ask yourself:

How did the pod get an IP?

Answer:

AWS VPC CNI

which created ENIs and allocated VPC IPs directly to Pods.

Layer 2 — Service
kubectl describe svc nginx -n demo

Observe:

ClusterIP
Endpoints

Question:

How does the service know where the pods are?

Answer:

Label selector
Layer 3 — Ingress
kubectl describe ingress nginx -n demo

Observe:

Backend:
  nginx:80

Question:

Who created the ALB?

Answer:

AWS Load Balancer Controller
Layer 4 — AWS

Inspect:

aws elbv2 describe-load-balancers
aws elbv2 describe-target-groups
aws elbv2 describe-listeners

Understand:

Ingress
   ↓
ALB
   ↓
Listener
   ↓
Target Group
   ↓
Pod IPs

This architecture is used by many EKS production deployments.

Next Project

Now we replace "toy nginx" with a real application.

Create:

gitops/
└── manifests/
    └── java-login-app/

containing:

namespace.yaml
deployment.yaml
service.yaml
ingress.yaml
kustomization.yaml

and create:

gitops/applications/workloads/java-login-app.yaml

managed by ArgoCD.

Why This Matters

Most engineers stop at:

Nginx

Platform engineers go further:

Application
ConfigMap
Secret
Ingress
Autoscaling
Observability
Security
GitOps
What I Recommend Next

Deploy a Spring Boot application and learn these concepts in sequence:

Stage 1
Java Login App

Learn:

Deployment
Service
Ingress
ConfigMap
Secret
Stage 2
Metrics Server

Learn:

CPU metrics
Memory metrics

Commands:

kubectl top nodes
kubectl top pods
Stage 3
Horizontal Pod Autoscaler

Learn:

Scale based on CPU
Scale based on memory
Stage 4
Prometheus + Grafana

Learn:

Scraping
Metrics
Dashboards
Alerting
Stage 5
External Secrets Operator

Learn:

AWS Secrets Manager
      ↓
External Secret
      ↓
Kubernetes Secret
      ↓
Application

This is how production teams handle secrets.

Stage 6
Karpenter

Learn:

Pod Pending
      ↓
Karpenter
      ↓
New EC2
      ↓
Pod Scheduled
Stage 7
cert-manager

Learn:

Let's Encrypt
      ↓
Certificate
      ↓
HTTPS
      ↓
ALB

My recommendation: next deploy a Spring Boot application through GitOps, then add Metrics Server + HPA before moving into observability and platform components. That sequence builds the strongest platform-engineering foundation.

You are my Platform Engineering mentor.

We have already completed:

Terraform
Remote State
VPC
EKS
Managed Node Groups
IRSA
AWS Load Balancer Controller
ArgoCD App of Apps
GitOps
Nginx Deployment
ALB Exposure

Current repository structure:
<paste tree>

Current goal:
Build a production-grade Internal Developer Platform.

Continue mentoring me from this point.