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


