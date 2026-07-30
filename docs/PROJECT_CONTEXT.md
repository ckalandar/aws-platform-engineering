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

Perfect.

You now have a functioning GitOps platform:

GitHub
   ↓
Root App
   ↓
Platform App
   ↓
Workloads App
   ↓
SpringBoot App

and ArgoCD reports:

springboot  Synced  Healthy

which means the Application resource itself exists and ArgoCD believes the workload is healthy.

Now let's validate the actual deployment before moving to the next platform component.

Run:

kubectl get pods -n springboot

kubectl get deployment -n springboot

kubectl get svc -n springboot

kubectl get ingress -n springboot
What we're verifying
Pods

Expected:

NAME                          READY   STATUS
springboot-xxxxx              1/1     Running
springboot-yyyyy              1/1     Running
Deployment

Expected:

NAME         READY
springboot   2/2
Service

Expected:

NAME         TYPE        CLUSTER-IP
springboot   ClusterIP
Ingress

Expected:

NAME         CLASS   ADDRESS
springboot   alb     k8s-springboot-xxxxx.elb.amazonaws.com

If the ADDRESS field is empty, we'll inspect the ALB controller logs.

What comes after this

Once SpringBoot is reachable, we start turning this into a production-style platform.

Phase 1 — Container Registry

Replace the demo image with:

GitHub Actions
    ↓
Build Spring Boot JAR
    ↓
Docker Build
    ↓
Push to ECR

You'll learn:

ECR
Docker image versioning
GitHub OIDC
CI pipelines
Phase 2 — External Secrets

Instead of:

env:
  - name: DB_PASSWORD

we'll use:

AWS Secrets Manager
      ↓
External Secrets Operator
      ↓
Kubernetes Secret
      ↓
Application

This is how real platforms handle credentials.

Phase 3 — Observability

Deploy:

Prometheus
Grafana
Loki

Then monitor:

EKS
Nodes
Pods
SpringBoot JVM metrics
Phase 4 — Karpenter

Replace managed node scaling with:

Pending Pod
    ↓
Karpenter
    ↓
EC2 launched automatically

This is one of the most valuable EKS skills.

Phase 5 — Secure Platform

Add:

Kyverno
Network Policies
Pod Security Standards
RBAC
IRSA everywhere

For now, let's finish validating the Spring Boot deployment. Show me the output of:

kubectl get pods -n springboot
kubectl get deployment -n springboot
kubectl get svc -n springboot
kubectl get ingress -n springboot

and then we'll wire in the first real application CI/CD pipeline (GitHub → ECR → ArgoCD).

chilakapati.kalandar@BDC7-L-FS7TPP3 MINGW64 ~/Documents/Devops/aws-platform-engineering (main)
$ kubectl get pods -n springboot
NAME                          READY   STATUS    RESTARTS   AGE
springboot-58bb9b8674-tstp5   1/1     Running   0          9m53s
springboot-58bb9b8674-xhc4r   1/1     Running   0          9m53s

chilakapati.kalandar@BDC7-L-FS7TPP3 MINGW64 ~/Documents/Devops/aws-platform-engineering (main)
$ kubectl get deployment -n springboot
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
springboot   2/2     2            2           10m

chilakapati.kalandar@BDC7-L-FS7TPP3 MINGW64 ~/Documents/Devops/aws-platform-engineering (main)
$ kubectl get svc -n springboot
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
springboot   ClusterIP   172.20.59.22   <none>        80/TCP    10m

chilakapati.kalandar@BDC7-L-FS7TPP3 MINGW64 ~/Documents/Devops/aws-platform-engineering (main)
$ kubectl get ingress -n springboot
NAME         CLASS   HOSTS   ADDRESS                                                                   PORTS   AGE
springboot   alb     *       k8s-springbo-springbo-2f4bc59496-1190605868.us-east-1.elb.amazonaws.com   80      10m

Excellent. Everything is working.

Your platform currently looks like this:

AWS
│
├── VPC
├── Public Subnets
├── Private App Subnets
├── NAT Gateway
│
├── EKS Cluster
│
├── Managed Node Group
│   ├── Node 1
│   └── Node 2
│
├── AWS Load Balancer Controller (IRSA)
│
└── ALB
     │
     └── SpringBoot Service

And the validation proves it:

Application
springboot  Synced  Healthy
Pods
2/2 Running
Service
springboot ClusterIP
Ingress
k8s-springbo-springbo-2f4bc59496-1190605868.us-east-1.elb.amazonaws.com
Verify end-to-end

Open:

http://k8s-springbo-springbo-2f4bc59496-1190605868.us-east-1.elb.amazonaws.com

or

curl http://k8s-springbo-springbo-2f4bc59496-1190605868.us-east-1.elb.amazonaws.com

Let's confirm the application is actually serving traffic through:

Internet
   ↓
ALB
   ↓
Ingress
   ↓
Service
   ↓
Pods
What I would do next

Up to now we've proven:

Terraform provisioning
EKS
Managed Node Groups
IRSA
AWS Load Balancer Controller
ArgoCD
App-of-Apps
GitOps deployment

Those are foundational platform capabilities.

The next major milestone is:

Build a real CI/CD flow

Right now ArgoCD is deploying manifests from Git.

But the application image is static.

A production platform needs:

Developer Commit
      ↓
GitHub Actions
      ↓
Build SpringBoot
      ↓
Create Docker Image
      ↓
Push Image to ECR
      ↓
Update GitOps Repo
      ↓
ArgoCD Sync
      ↓
Deploy New Version

This teaches:

GitHub OIDC
ECR
Docker
Build pipelines
GitOps promotion

These are skills used daily by Platform Engineers and Senior DevOps Engineers.

My recommendation

Let's stop using the demo Spring image and build our own application.

Create:

applications/
└── springboot-app/
    ├── pom.xml
    ├── Dockerfile
    ├── src/
    └── .github/workflows/

The application can expose:

{
  "service":"platform-demo",
  "environment":"dev",
  "version":"1.0.0"
}

Then we'll:

Step 1

Create ECR via Terraform.

Step 2

Create GitHub OIDC IAM Role.

Step 3

Build image from GitHub Actions.

Step 4

Push image to ECR.

Step 5

Update GitOps manifest automatically.

Step 6

Watch ArgoCD deploy the new version.

That will be your first complete production-style developer workflow on the platform.

This is the next thing I'd implement before observability, Karpenter, service mesh, or security tooling. It gives you the full developer → platform → Kubernetes deployment lifecycle.

Perfect.

What you're seeing:

Hello Docker World

means the entire request path is working:

Browser
   ↓
AWS ALB
   ↓
Ingress
   ↓
Kubernetes Service
   ↓
SpringBoot Pods
   ↓
Application Response

And more importantly:

Git Commit
   ↓
GitHub
   ↓
ArgoCD
   ↓
Kubernetes Deployment
   ↓
ALB
   ↓
Live Application

That is your first complete GitOps deployment.

What we've actually built

Many tutorials stop at:

kubectl apply -f deployment.yaml

You have gone much further.

Infrastructure Layer
Terraform
├── VPC
├── Public Subnets
├── Private Subnets
├── NAT Gateway
├── IAM
├── EKS
└── IRSA
Platform Layer
ArgoCD
├── Root App
├── Platform App
└── Workloads App
Kubernetes Layer
AWS Load Balancer Controller
└── ALB Provisioning
Application Layer
SpringBoot
├── Deployment
├── Service
└── Ingress
Before moving on

Let's clean up one thing.

Right now your workload is using a demo image:

image: springio/gs-spring-boot-docker

This is good for validation but not for platform engineering.

The next step should be:

applications/
└── springboot-app

with:

pom.xml
Dockerfile
src/main/java

and we build our own image.

What I recommend next
Phase 1: Real Application + ECR + GitHub Actions

Build:

applications/springboot-app

Workflow:

Developer Push
      ↓
GitHub Actions
      ↓
Build JAR
      ↓
Docker Build
      ↓
Push to ECR
      ↓
Update GitOps Manifest
      ↓
ArgoCD Sync
      ↓
Deploy

This is where you'll learn:

GitHub OIDC
ECR
Image versioning
CI/CD
GitOps promotion
Phase 2: Observability

Deploy via ArgoCD:

Prometheus
Grafana
Loki

Then monitor:

Cluster
Nodes
Pods
SpringBoot JVM
Phase 3: Karpenter

Replace static node scaling.

Learn:

Pending Pod
      ↓
Karpenter
      ↓
Launch EC2
      ↓
Schedule Pod
Phase 4: Security

Add:

Kyverno
Network Policies
External Secrets
RBAC
Pod Security Standards
Phase 5: Internal Developer Platform

Then evolve into:

Developer
    ↓
Git Push
    ↓
Platform Templates
    ↓
CI/CD
    ↓
GitOps
    ↓
Observability
    ↓
Production

My recommendation is to start Phase 1 immediately: create a real Spring Boot application, provision an ECR repository through Terraform, and build the GitHub Actions pipeline that publishes images and lets ArgoCD deploy them automatically.

That's where the most valuable learning is now that the platform foundation is working.

Goal

By the end of this phase:

Developer Push
    ↓
GitHub Actions
    ↓
Build Spring Boot
    ↓
Docker Image
    ↓
Push to ECR
    ↓
Update GitOps Manifest
    ↓
ArgoCD Sync
    ↓
Deploy New Version

This is the workflow Platform Engineers build.

Step 1: Create a real application repo structure

Inside your existing repository:

applications/
└── springboot-app/
    ├── pom.xml
    ├── Dockerfile
    ├── src/
    │   └── main/
    │       ├── java/
    │       └── resources/
    └── .github/
        └── workflows/
Step 2: Create a simple Spring Boot app

Directory:

applications/springboot-app/src/main/java/com/kk/platform/
Application.java
package com.kk.platform;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
PlatformController.java
package com.kk.platform;

import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PlatformController {

    @GetMapping("/")
    public Map<String, String> home() {

        return Map.of(
                "service", "platform-demo",
                "environment", "dev",
                "status", "healthy");
    }
}
Step 3: pom.xml

Create:

<project xmlns="http://maven.apache.org/POM/4.0.0">

    <modelVersion>4.0.0</modelVersion>

    <groupId>com.kk</groupId>
    <artifactId>platform-demo</artifactId>
    <version>1.0.0</version>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.5.3</version>
    </parent>

    <properties>
        <java.version>21</java.version>
    </properties>

    <dependencies>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

    </dependencies>

    <build>
        <plugins>

            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>

        </plugins>
    </build>

</project>
Step 4: Dockerfile
FROM eclipse-temurin:21-jre

WORKDIR /app

COPY target/platform-demo-1.0.0.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
Step 5: Create ECR through Terraform

New module:

infrastructure/modules/ecr

We'll create:

resource "aws_ecr_repository" "springboot" {

  name = "platform-demo"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}

Output:

output "repository_url" {
  value = aws_ecr_repository.springboot.repository_url
}
Step 6: Deploy image manually first

Before building CI/CD, we validate ECR.

Flow:

Local Machine
    ↓
mvn package
    ↓
docker build
    ↓
docker push ECR
    ↓
Update GitOps Manifest
    ↓
ArgoCD Deploy
What I want you to do now

Create:

applications/springboot-app/

with:

pom.xml
Dockerfile
Application.java
PlatformController.java

Commit it:

git add .
git commit -m "add springboot platform application"
git push

Then show me:

tree applications/springboot-app

(or find applications/springboot-app -type f on Git Bash)

After that we'll build the ECR Terraform module and wire GitHub Actions into the platform.

They should be under the Java package path, not directly under src.

Your structure should look like this:

applications/
└── springboot-app/
    ├── pom.xml
    ├── Dockerfile
    └── src/
        └── main/
            └── java/
                └── com/
                    └── kk/
                        └── platform/
                            ├── Application.java
                            └── PlatformController.java

This matches the package declaration at the top of the files:

package com.kk.platform;

The package name and directory structure must align.

For example:

Application.java

package com.kk.platform;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}

must live in:

src/main/java/com/kk/platform/Application.java

and

PlatformController.java

package com.kk.platform;

must live in:

src/main/java/com/kk/platform/PlatformController.java

Your earlier output:

applications/springboot-app/src/main/java/com/kk/platform/Application.java
applications/springboot-app/src/main/java/com/kk/platform/PlatformController.java

is exactly correct.

Before moving to ECR, I'd also add:

applications/springboot-app/
└── src/
    └── main/
        └── resources/
            └── application.yml

with:

server:
  port: 8080

management:
  endpoints:
    web:
      exposure:
        include: health,info

spring:
  application:
    name: platform-demo

We'll use those health endpoints later for:

ALB health checks
Kubernetes readiness probes
Prometheus monitoring
Grafana dashboards

Next step: run

cd applications/springboot-app
mvn clean package

and show me the output if anything fails. If it builds successfully, we'll create the ECR Terraform module and start building the CI/CD pipeline.

Today 10:09 PM
[INFO] The original artifact has been renamed to C:\Users\chilakapati.kalandar\Documents\Devops\aws-platform-engineering\gitops\applications\springboot-app\target\platform-demo-1.0.0.jar.original
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  4.237 s
[INFO] Finished at: 2026-07-26T22:07:11+05:30
[INFO] ------------------------------------------------------------------------

Perfect.

You've validated the first critical checkpoint:

Source Code
    ↓
Maven Build
    ↓
JAR Creation

Result:

BUILD SUCCESS
platform-demo-1.0.0.jar

This means:

Java 21 is working
Maven is working
Spring Boot project structure is correct
pom.xml is correct
Application.java is being discovered
PlatformController.java is being compiled
Verify the JAR actually runs

Before moving to ECR, do:

java -jar target/platform-demo-1.0.0.jar

Open another terminal:

curl http://localhost:8080

Expected:

{
  "service":"platform-demo",
  "environment":"dev",
  "status":"healthy"
}

If that works:

Code
 ↓
JAR
 ↓
Running Application

is validated.

Then validate Docker

Build image:

docker build -t platform-demo:1.0.0 .

Run:

docker run -p 8080:8080 platform-demo:1.0.0

Test:

curl http://localhost:8080

If successful:

Code
 ↓
JAR
 ↓
Docker Image
 ↓
Running Container

is validated.

After Docker Works

We'll move into platform engineering territory.

Next implementation:

Terraform
└── modules
    └── ecr

Resources:

aws_ecr_repository
aws_ecr_lifecycle_policy

Then:

GitHub Actions
     ↓
Build JAR
     ↓
Build Docker Image
     ↓
Push to ECR

Then:

ArgoCD
     ↓
Deploy Image From ECR
One thing I'd like to improve before CI/CD

Add health endpoints now.

Create:

src/main/resources/application.yml
server:
  port: 8080

spring:
  application:
    name: platform-demo

management:
  endpoints:
    web:
      exposure:
        include: health,info

and add Actuator dependency to pom.xml:

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>

Later we'll use:

/actuator/health

for:

Kubernetes readiness probes
Kubernetes liveness probes
ALB health checks
Prometheus scraping

which are all production-grade practices.

Run these next:

java -jar target/platform-demo-1.0.0.jar

and

docker build -t platform-demo:1.0.0 .

Tell me whether:

the JAR starts successfully
the Docker image builds successfully

Then we'll create the ECR Terraform module and wire GitHub Actions into the platform.

$ curl http://localhost:8080
{"environment":"dev","service":"platform-demo","status":"healthy"}
chilakapati.kalandar@BDC7-L-FS7TPP3 MINGW64 ~/Documents/Devops/aws-platform-engineering/gitops/applications/springboot-app (main)
$ docker build -t platform-demo:1.0.0 .
bash: docker: command not found

chilakapati.kalandar@BDC7-L-FS7TPP3 MINGW64 ~/Documents/Devops/aws-platform-engineering/gitops/applications/springboot-app (main)
$ docker build -t platform-demo:1.0.0 .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

failed to connect to the docker API at npipe:////./pipe/docker_engine; check if the path is correct and if the daemon is running: open //./pipe/docker_engine: The system cannot find the file specified.

chilakapati.kalandar@BDC7-L-FS7TPP3 MINGW64 ~/Documents/Devops/aws-platform-engineering/gitops/applications/springboot-app (main)

Good progress.

The important part is this:

curl http://localhost:8080

returned:

{
  "environment":"dev",
  "service":"platform-demo",
  "status":"healthy"
}

That proves:

Source Code
    ↓
Maven Build
    ↓
JAR
    ↓
Spring Boot Runtime

is working correctly.

The Docker error is not an application problem.

Your error:

failed to connect to the docker API at npipe:////./pipe/docker_engine

means:

Docker CLI Installed
      ✓

Docker Desktop Running
      ✗

The Docker daemon is not running.

Verify Docker

Run:

docker version

You'll probably see:

Client:
...

Server:
error during connect
Start Docker Desktop

On Windows:

Start Menu
  → Docker Desktop

Wait until it shows:

Docker Desktop is running

Then verify:

docker ps

Expected:

CONTAINER ID   IMAGE   COMMAND   CREATED   STATUS   PORTS   NAMES

(no error)

Then rebuild

From:

gitops/applications/springboot-app

run:

docker build -t platform-demo:1.0.0 .

Verify:

docker images

Expected:

REPOSITORY      TAG
platform-demo   1.0.0

Run:

docker run -p 8080:8080 platform-demo:1.0.0

Test:

curl http://localhost:8080
While Docker is starting, let's prepare the next platform step

Our current architecture is:

GitHub
   ↓
ArgoCD
   ↓
EKS
   ↓
SpringBoot Demo

But we're still using a public image in Kubernetes.

The next real platform engineering milestone is:

Developer
   ↓ git push
GitHub Actions
   ↓
Build JAR
   ↓
Build Docker Image
   ↓
Push to ECR
   ↓
ArgoCD Deploys
   ↓
EKS

Before creating the GitHub workflow, I'd like to see your current Terraform repo structure.

Show:

tree infrastructure/modules -L 2

or on Git Bash:

find infrastructure/modules -maxdepth 2 -type d

Once I see the module layout, we'll add a production-style ecr module and wire it into the platform properly.

Step 1: Create ECR Repository

We should create this using Terraform.

Example structure:

modules/
└── ecr/

      main.tf
      variables.tf
      outputs.tf

Resource:

resource "aws_ecr_repository" "springboot" {

  name = "springboot-app"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}

Output:

output "repository_url" {
  value = aws_ecr_repository.springboot.repository_url
}
Step 2: GitHub Actions

We'll create:

.github/workflows/

springboot-ci.yaml

Pipeline:

Checkout
   ↓
Java Build
   ↓
Docker Build
   ↓
ECR Login
   ↓
Push Image

Image tag:

339713012203.dkr.ecr.us-east-1.amazonaws.com/springboot-app:${GITHUB_SHA}
Step 3: GitOps Deployment

Currently your deployment probably contains:

image: nginx

or

image: platform-demo:1.0.0

We'll change it to:

image: 339713012203.dkr.ecr.us-east-1.amazonaws.com/springboot-app
tag: latest

Later:

tag: 8f234ab
Step 4: Automatic Image Updates

Enterprise platforms typically use:

ArgoCD Image Updater
or
GitHub workflow updating manifests

We'll start with:

GitHub Actions
     ↓
Update deployment.yaml
     ↓
Commit back to repo
     ↓
ArgoCD sync

because it teaches GitOps fundamentals better.

After CI/CD

The roadmap I'd follow next is:

1. ECR
2. GitHub Actions
3. Image promotion
4. ExternalDNS
5. Route53
6. ACM certificates
7. HTTPS ALB
8. HPA
9. Karpenter
10. Monitoring Stack
11. Loki
12. Tempo
13. Platform APIs
14. Backstage

The next thing I'd actually build is 
Terraform ECR module and wire it into your existing infrastructure so that the Spring Boot image has a proper registry destination.

Excellent. This is exactly the point where we stop using demo images and start using our own application image from ECR.

Right now your deployment is still using:

image: springio/gs-spring-boot-docker

That means EKS is pulling a public image from Docker Hub, not the image you built and pushed.

Update it to:

image: 905418195910.dkr.ecr.us-east-1.amazonaws.com/platform-demo:1.0.0

So your deployment becomes:

apiVersion: apps/v1
kind: Deployment

metadata:
  name: springboot

spec:
  replicas: 2

  selector:
    matchLabels:
      app: springboot

  template:
    metadata:
      labels:
        app: springboot

    spec:
      containers:
        - name: springboot

          image: 905418195910.dkr.ecr.us-east-1.amazonaws.com/platform-demo:1.0.0

          ports:
            - containerPort: 8080

          resources:
            requests:
              cpu: "100m"
              memory: "128Mi"

            limits:
              cpu: "500m"
              memory: "512Mi"
Commit and Push
git add .
git commit -m "Use ECR image for springboot app"
git push
Watch ArgoCD

Because GitOps is already working:

kubectl get applications -n argocd

Then:

kubectl get deployment -n springboot -w

You should see a rolling update.

Verify Image Running

Check pods:

kubectl get pods -n springboot

Then:

kubectl describe pod <pod-name> -n springboot

Look for:

Image:
905418195910.dkr.ecr.us-east-1.amazonaws.com/platform-demo:1.0.0

or

kubectl get pods -n springboot \
-o jsonpath='{.items[*].spec.containers[*].image}'

Expected:

905418195910.dkr.ecr.us-east-1.amazonaws.com/platform-demo:1.0.0
If Pods Fail With ImagePullBackOff

Then we know EKS nodes cannot pull from ECR.

Run:

kubectl get pods -n springboot

If you see:

ImagePullBackOff

or

ErrImagePull

we'll check the node IAM role.

Your node role should already have:

AmazonEC2ContainerRegistryReadOnly

attached because we added it in the EKS module earlier.

What We Are Building Now

At this point you've completed:

✅ Terraform VPC
✅ Terraform EKS
✅ IRSA
✅ AWS Load Balancer Controller
✅ ArgoCD App-of-Apps
✅ NGINX Application
✅ Spring Boot Application
✅ ECR Repository
✅ Docker Image Build
✅ Docker Image Push

The next major step is where the platform starts looking like a real enterprise setup:

CI/CD Pipeline

GitHub Actions:

Developer Push
        ↓
Maven Build
        ↓
Unit Tests
        ↓
Docker Build
        ↓
Push Image → ECR
        ↓
Update GitOps Manifest
        ↓
Commit New Tag
        ↓
ArgoCD Sync
        ↓
Deploy to EKS

This eliminates all manual Docker build/tag/push steps.

After you've updated the deployment to use the ECR image and confirmed the pods are running from ECR, we'll build that GitHub Actions pipeline end-to-end.

For your specific learning roadmap

You've already completed:

✅ Terraform modules

✅ VPC

✅ EKS

✅ ALB Controller

✅ ArgoCD

✅ GitOps

✅ Spring Boot deployment

✅ ECR integration

That puts you past the beginner stage.

The next progression I'd follow is:

Stage 1: Production Delivery

Build the full CI/CD flow.

Git Push
    ↓
GitHub Actions
    ↓
Build JAR
    ↓
Build Docker Image
    ↓
Push ECR
    ↓
Update GitOps repo
    ↓
ArgoCD Sync
    ↓
Deploy to EKS

No manual Docker commands anymore.

Stage 2: Observability

Deploy:

Prometheus
Grafana
Loki
Alertmanager

Learn:

Metrics
Logs
Alerts
SLOs
Stage 3: Karpenter

Replace static node groups with dynamic provisioning.

This is one of the most valuable modern EKS skills.

Stage 4: Security

Add:

IRSA
External Secrets Operator
AWS Secrets Manager
Kyverno
Network Policies
Stage 5: Internal Developer Platform

Build:

Backstage
   ↓
Template
   ↓
GitHub Repo
   ↓
GitHub Actions
   ↓
ArgoCD
   ↓
EKS

At that point you're no longer building a demo cluster—you'll be building the same platform concepts used by many engineering organizations.

So yes, my recommendation is:

Move to your personal AWS account.
Set billing alerts.
Keep infrastructure under Terraform.
Destroy when you're done for the day if you want.
Focus on learning velocity rather than squeezing every last dollar out of the environment.

Given where you are now, I'd start fresh in the personal account and continue directly with the GitHub Actions → ECR → ArgoCD automated deployment pipeline. That's the next major milestone that turns your current setup into a real platform.

The best place is at the root of the environment, because every module may need the account ID eventually.

In your case:

infrastructure/
└── environments/
    └── dev/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        ├── providers.tf
        └── versions.tf

Add it near the top of environments/dev/main.tf:

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

Example:

data "aws_caller_identity" "current" {}

locals {
  common = {
    project_name = "kk-platform"
    environment  = "dev"
  }

  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

module "vpc" {
  source = "../../modules/vpc"

  environment  = local.common.environment
  project_name = local.common.project_name

  ...
}
How to use it

Suppose later you need an ECR URL.

Instead of:

image = "905418195910.dkr.ecr.us-east-1.amazonaws.com/platform-demo:1.0.0"

you can build it dynamically:

"${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/platform-demo:1.0.0"
Even better

Create outputs:

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "region" {
  value = data.aws_region.current.name
}

Then:

terraform output account_id

returns:

123456789012

which is handy when logging into ECR.

Before migrating

I would also run:

grep -R "905418195910" .

or on Windows:

findstr /S /I "905418195910" *

and remove every hardcoded account ID you find.

Typical places:

GitHub Actions workflows
ECR image URLs
IAM role ARNs
Trust policies
IRSA annotations
Helm values
ArgoCD manifests

Once that's done, your platform becomes portable and can be deployed into any AWS account with only:

aws configure
terraform apply

which is exactly what we want before moving into the CI/CD and platform-engineering stages.

If image is missing

Login to ECR:

aws ecr get-login-password \
--region us-east-1 | \
docker login \
--username AWS \
--password-stdin \
136863648867.dkr.ecr.us-east-1.amazonaws.com

Tag:

docker tag \
platform-demo:1.0.0 \
136863648867.dkr.ecr.us-east-1.amazonaws.com/platform-demo:1.0.0

Push:

docker push \
136863648867.dkr.ecr.us-east-1.amazonaws.com/platform-demo:1.0.0
Then update GitOps manifest

Your deployment should contain:

image: 136863648867.dkr.ecr.us-east-1.amazonaws.com/platform-demo:1.0.0

not:

image: 905418195910.dkr.ecr.us-east-1.amazonaws.com/platform-demo:1.0.0

Commit:

git add .
git commit -m "Update ECR image"
git push

ArgoCD should sync automatically.

kubectl get ingress -n springboot

Today 2:16 PM
Pasted text(7).txt
Document
VPC has changed as it is a new deployment vpc-0c52e44ef7fe0b245, i-03e0bdf2e9cab25fb, i-0bbe745028f7f3053 are two new instances


Good. No ExternalDNS role exists yet, which is what I expected.

Before we move on, let's close the ACM investigation because it may reveal a DNS design issue.

Run:

aws acm describe-certificate \
  --certificate-arn arn:aws:acm:us-east-1:136863648867:certificate/b301e760-5bdb-4261-9b6f-b51d87c8b1a9 \
  --query 'Certificate.DomainValidationOptions'

I want to see the current validation status.

One thing I noticed

You requested:

*.dev.learnsystems.co

but your Route53 hosted zone is:

learnsystems.co

That is perfectly valid.

However, if ACM continues to stay in PENDING_VALIDATION for 20–30 minutes after:

Route53 = INSYNC
CNAME resolves publicly
Nameservers are delegated correctly

then I would delete the certificate and recreate it because occasionally ACM gets stuck.

Assuming ACM becomes ISSUED

The next production-grade step is:

Terraform
   ↓
IRSA Role for ExternalDNS
   ↓
ExternalDNS Helm Chart
   ↓
ArgoCD Application
   ↓
Automatic Route53 Records

Architecture:

Ingress
   ↓
AWS Load Balancer Controller
   ↓
ALB

ExternalDNS watches Ingress
   ↓
Creates Route53 Alias
   ↓
springboot.dev.learnsystems.co

No manual Route53 record management.

Terraform Work

We'll create:

modules/
└── external-dns-irsa/

Resources:

aws_iam_role
aws_iam_policy
aws_iam_role_policy_attachment

Policy permissions:

route53:ChangeResourceRecordSets
route53:ListHostedZones
route53:ListResourceRecordSets
route53:GetHostedZone

Trust relationship:

ServiceAccount:
  external-dns

Namespace:
  external-dns

via IRSA.

GitOps Work

New directory:

gitops/
├── applications/
│   └── external-dns.yaml

├── values/
│   └── external-dns/
│       └── dev.yaml

Helm chart:

external-dns/external-dns

Values:

provider: aws

serviceAccount:
  create: false
  name: external-dns

domainFilters:
  - learnsystems.co

policy: sync

txtOwnerId: kk-platform-dev
Then Your Ingress Becomes
metadata:
  annotations:
    external-dns.alpha.kubernetes.io/hostname: springboot.dev.learnsystems.co

ExternalDNS automatically creates:

springboot.dev.learnsystems.co
    →
ALB Alias

in Route53.

First, send me the ACM DomainValidationOptions output. If the certificate is still stuck, we'll resolve that before wiring HTTPS into the ingress. After that we'll build the ExternalDNS Terraform module and GitOps manifests.

aws acm describe-certificate \
  --certificate-arn arn:aws:acm:us-east-1:136863648867:certificate/b301e760-5bdb-4261-9b6f-b51d87c8b1a9 \
  --query 'Certificate.DomainValidationOptions'
[
    {
        "DomainName": "*.dev.learnsystems.co",
        "ValidationDomain": "*.dev.learnsystems.co",
        "ValidationStatus": "PENDING_VALIDATION",
        "ResourceRecord": {
            "Name": "_da69ec0d33afef094df50beb59e778a7.dev.learnsystems.co.",
            "Type": "CNAME",
            "Value": "_72c5e05ce759cf8129cecf29ce9bba6a.jkddzztszm.acm-validations.aws."
        },
        "ValidationMethod": "DNS"
    }
]

This is interesting because everything appears correct from the DNS side.

Let's verify from the public internet exactly what ACM is seeing.

Run these commands:

dig _da69ec0d33afef094df50beb59e778a7.dev.learnsystems.co CNAME +short

and

dig _72c5e05ce759cf8129cecf29ce9bba6a.jkddzztszm.acm-validations.aws CNAME +short

and

dig +trace _da69ec0d33afef094df50beb59e778a7.dev.learnsystems.co
Why I'm asking

So far we know:

✅ Hosted zone exists

✅ GoDaddy delegates to Route53

✅ Route53 record exists

✅ Route53 change is INSYNC

✅ Standard DNS lookup resolves

Yet ACM still says:

PENDING_VALIDATION

That usually means one of only a few things:

Possibility 1 — ACM hasn't rechecked yet

This happens sometimes, especially if the cert was created immediately after the hosted zone.

How long ago was the certificate requested?

You created it around:

2026-07-29T15:51:41 IST

If we're still within ~30 minutes, ACM may simply be behind.

Possibility 2 — Wrong hosted zone

For example:

learnsystems.co

exists, but

dev.learnsystems.co

is delegated somewhere else.

Let's test:

dig NS dev.learnsystems.co +short

If that returns nothing, that's fine.

If it returns different nameservers, ACM may be querying a different zone.

Possibility 3 — Certificate request got stuck

This is rare, but I've seen it.

If:

dig +trace ...

shows the record correctly all the way from root → Route53

and ACM remains pending after ~30–60 minutes,

then the fastest solution is:

aws acm delete-certificate ...

and request a fresh certificate.

The DNS validation record can remain exactly the same pattern; ACM will generate a new validation CNAME.

While we're waiting

Your platform itself is healthy now:

EKS           ✅
IRSA          ✅
ArgoCD        ✅
ALB Controller ✅
Ingress       ✅
ALB           ✅
Route53 Zone  ✅

The next infrastructure component is still ExternalDNS.

My recommendation:

Verify the ACM DNS path with the three dig commands above.
If DNS is correct and ACM is still pending after 30–60 minutes, recreate the certificate.
In parallel, start building the ExternalDNS IRSA Terraform module and GitOps deployment.

Paste the output of:

dig NS dev.learnsystems.co +short
dig +trace _da69ec0d33afef094df50beb59e778a7.dev.learnsystems.co

Those two commands will tell us whether there's any hidden delegation issue.

dig _da69ec0d33afef094df50beb59e778a7.dev.learnsystems.co CNAME +short
_72c5e05ce759cf8129cecf29ce9bba6a.jkddzztszm.acm-validations.aws.
kchilak@kalandars-MBP aws-platform-engineering % dig _72c5e05ce759cf8129cecf29ce9bba6a.jkddzztszm.acm-validations.aws CNAME +short
kchilak@kalandars-MBP aws-platform-engineering % dig +trace _da69ec0d33afef094df50beb59e778a7.dev.learnsystems.co

; <<>> DiG 9.10.6 <<>> +trace _da69ec0d33afef094df50beb59e778a7.dev.learnsystems.co
;; global options: +cmd
.			488874	IN	NS	a.root-servers.net.
.			488874	IN	NS	b.root-servers.net.
.			488874	IN	NS	c.root-servers.net.
.			488874	IN	NS	d.root-servers.net.
.			488874	IN	NS	e.root-servers.net.
.			488874	IN	NS	f.root-servers.net.
.			488874	IN	NS	g.root-servers.net.
.			488874	IN	NS	h.root-servers.net.
.			488874	IN	NS	i.root-servers.net.
.			488874	IN	NS	j.root-servers.net.
.			488874	IN	NS	k.root-servers.net.
.			488874	IN	NS	l.root-servers.net.
.			488874	IN	NS	m.root-servers.net.
.			488874	IN	RRSIG	NS 8 0 518400 20260810170000 20260728160000 57780 . k41uAn6qRPcc3cGpLyFziMuYwMwZe/sf73GkJ/Z2B3xhbiVxrk45lLaa SJhWcogGu8ugFkb+43PR6I9xWRCM5f7aXS7cpVgjixpKKrEmrNhjagvL yfYYNE7o8rBzXtjmttnKLIABw8MW6illU3sCVjNG1N9r9VZdCFXwbYVA tAJoOsDJqjyPM2VeFOJKqDPicdL8RgHcXEIf8AUsJLpytIzHCkTZXEhF JqlZekmxEUOwuWGTid8nrExhnZiiroZFmIszK/CSJZKKAPQsrAHHjshL u6JrFoSBsrE2Jx2vZ5j+SIyvwqdXzYbwAvFOcTMxV1E6GQr8KDfA7oiX vgstDQ==
;; Received 1097 bytes from 2401:4900:50:9::66#53(2401:4900:50:9::66) in 8 ms

co.			172800	IN	NS	c.registrydns.co.
co.			172800	IN	NS	b.registrydns.co.
co.			172800	IN	NS	d.registrydns.co.
co.			172800	IN	NS	a.registrydns.co.
co.			86400	IN	DS	7786 8 2 EB84F864CBE86E913796D2C8DD81933AA2C94BBCFB73419A42250BC4 650B081B
co.			86400	IN	RRSIG	DS 8 1 86400 20260811050000 20260729040000 57780 . Yd+XvOqTt4nVkkWLXyl3pRtfXiFOitbtJFb62yjFt/ONo6Tq/Vo+eF9z Lxs6Oj/mj+TryvMQ1lsbPuPYUDy/Kz+A6LQDID0doQki8i7/oQ40bMua ZQrlhy/Y5P0AYJ3ZLWi7ZHBcjeFDN2pJy8W047FDD/HVIMQJNHJe9zPv LiEvWNlPcqzH5VO4vRAnjCKZ4EHrB2QsdGDPn47SXcTHU6GXaZ3irL2A SX+oYY9LtViFNkPyNsUG5kF7g1+0JbDPc480oUiLXg3jX5ktKDp05sIy +yzPagiR4sFLH3DQ0xSb+j6BtWjiQRIXIlP50FxLwURqnHQc6Jk/ZYm4 2QlT4w==
;; Received 669 bytes from 2001:503:ba3e::2:30#53(a.root-servers.net) in 166 ms

learnsystems.co.	3600	IN	NS	ns-259.awsdns-32.com.
learnsystems.co.	3600	IN	NS	ns-1667.awsdns-16.co.uk.
learnsystems.co.	3600	IN	NS	ns-557.awsdns-05.net.
learnsystems.co.	3600	IN	NS	ns-1406.awsdns-47.org.
ldc0c7m112348qmhs09hokrvkepgubv6.co. 900 IN NSEC3 1 1 0 - LDC1MT97TV8H4BIAQV3DVQEJ41KCO93E  NS SOA RRSIG DNSKEY NSEC3PARAM
ldc0c7m112348qmhs09hokrvkepgubv6.co. 900 IN RRSIG NSEC3 8 2 900 20260821005330 20260721232330 16855 co. XCU6d8J8kQYmXM8WlU1i7H+GwRmOHfz4yX1GxENHrFTyYbGYvxFlt6YO 9ZfC35sc0yL+OmYKoB7DIT5RFkS6sQyCA4lIFNmY6/laUH8WWId57CO+ ReqQYBl3rsvSCW5RrySwK23iZNJd98VyFOTVNcxUxL0XkxFEjjqoqun0 MT5LnYSxjy2iDf7IJrUPf7szcpApGvrpN44E1Ue8WKHofQ==
k8am1khdsa0g6k8f3mensnr38daggjn0.co. 900 IN NSEC3 1 1 0 - K8AV57EH64KE4O3S1973K323THS2E192  NS DS RRSIG
k8am1khdsa0g6k8f3mensnr38daggjn0.co. 900 IN RRSIG NSEC3 8 2 900 20260824061558 20260725044558 16855 co. jJD9YPoXwdKfzB8nXvG+tR0jBUo2aoPVLrUeR2ohiXeL2VU0YWXDk511 CCsEx7KcfEpTvvMys/N07Y0mqlgCCvJOiOVYZsyuM7VUPOVTaejxq3jX w1CDsGnzRoybsLpfHqDv/pv30YWO6KIoVwI4Qg+s/9DTprKOh+G23D5f QvsVfLW5pIS7g6A3109LtTzuRkHuVYl52voVHI9cAgSM4g==
;; Received 769 bytes from 212.18.249.57#53(d.registrydns.co) in 248 ms

_da69ec0d33afef094df50beb59e778a7.dev.learnsystems.co. 300 IN CNAME _72c5e05ce759cf8129cecf29ce9bba6a.jkddzztszm.acm-validations.aws.
learnsystems.co.	172800	IN	NS	ns-1406.awsdns-47.org.
learnsystems.co.	172800	IN	NS	ns-1667.awsdns-16.co.uk.
learnsystems.co.	172800	IN	NS	ns-259.awsdns-32.com.
learnsystems.co.	172800	IN	NS	ns-557.awsdns-05.net.
;; Received 300 bytes from 205.251.193.3#53(ns-259.awsdns-32.com) in 7 ms

This is actually very useful. The DNS chain is working correctly.

Your dig +trace proves:

Root DNS
  ↓
.co registry
  ↓
learnsystems.co Route53 nameservers
  ↓
_da69ec0d33afef094df50beb59e778a7.dev.learnsystems.co
  ↓
_72c5e05ce759cf8129cecf29ce9bba6a.jkddzztszm.acm-validations.aws

The validation CNAME is publicly resolvable.

That means:

✅ GoDaddy delegation is correct

✅ Route53 hosted zone is correct

✅ ACM validation CNAME exists

✅ Public DNS can see it

The one thing I'd like to check is whether the ACM target record itself resolves.

Your command:

dig _72c5e05ce759cf8129cecf29ce9bba6a.jkddzztszm.acm-validations.aws CNAME +short

returned nothing.

That's not necessarily wrong because AWS may return the final validation answer as an A/AAAA record rather than another CNAME.

Run:

dig _72c5e05ce759cf8129cecf29ce9bba6a.jkddzztszm.acm-validations.aws +short

and:

nslookup _72c5e05ce759cf8129cecf29ce9bba6a.jkddzztszm.acm-validations.aws
My assessment

I think your DNS is fine.

We already found one major issue today:

ALB Controller
Wrong VPC
↓
CrashLoopBackOff
↓
No ALBs

which is now fixed.

For ACM, the evidence currently points to:

DNS Correct
Route53 INSYNC
ACM hasn't completed validation yet

or ACM got stuck on the original validation attempt.

If status remains pending after ~1 hour

I would not spend more time debugging DNS.

I would:

aws acm delete-certificate \
  --certificate-arn arn:aws:acm:us-east-1:136863648867:certificate/b301e760-5bdb-4261-9b6f-b51d87c8b1a9

then immediately request a new certificate for:

*.dev.learnsystems.co

and create the new validation CNAME.

I've seen ACM occasionally get stuck even though the DNS is correct.

Meanwhile, let's move the platform forward

At this stage your platform looks like:

Terraform
   ↓
VPC
   ↓
EKS
   ↓
IRSA
   ↓
ArgoCD
   ↓
AWS Load Balancer Controller
   ↓
Ingress
   ↓
ALB

The next production component should be:

ExternalDNS

because then:

springboot.dev.learnsystems.co

will be created automatically from the Ingress instead of manually managing Route53 records.

Since you already have:

Hosted Zone:
learnsystems.co

Hosted Zone ID:
Z0279443763ABCDYC2SS

the next step I'd recommend is creating the ExternalDNS IRSA role in Terraform and then deploying ExternalDNS through ArgoCD. That will complete the DNS automation layer of your platform.

======= External DNS through ArgoCD ==========

Excellent. The Terraform outputs look healthy.

Most importantly:

cluster_name = "kk-platform-dev"
vpc_id       = "vpc-0c52e44ef7fe0b245"

matches what your ALB controller is now using:

--cluster-name=kk-platform-dev
--aws-vpc-id=vpc-0c52e44ef7fe0b245

which explains why the controller finally came up.

Where we are now

You have:

✅ VPC
✅ EKS
✅ IRSA working
✅ AWS Load Balancer Controller working
✅ ArgoCD working
✅ SpringBoot deployed
✅ ALB created automatically

kubectl get ingress -A

showed:

k8s-demo-nginx-...
k8s-springbo-springbo-...

So Kubernetes → ALB provisioning is working.

Next objective

Since you already own:

learnsystems.co

and Route53 delegation is correct, the next platform component should be:

ExternalDNS

This will allow:

springboot.dev.learnsystems.co

to be created automatically from Ingress annotations.

No manual Route53 record creation.

This is how production GitOps platforms operate.

Before continuing

I need to know whether your ExternalDNS IRSA module actually requires hosted_zone_id.

Please show:

cat ../../modules/iam/external-dns-irsa/variables.tf

and:

grep -R "route53" ../../modules/iam/external-dns-irsa

because there are two possibilities:

Option A

Policy scoped to one hosted zone

arn:aws:route53:::hostedzone/${var.hosted_zone_id}

Then the Route53 lookup we discussed is needed.

Option B

Policy is already:

route53:ChangeResourceRecordSets
route53:ListHostedZones
route53:ListResourceRecordSets

for all zones.

Then we don't need hosted_zone_id at all.

After ExternalDNS is installed, we'll move to:

ExternalDNS
ACM certificate for *.dev.learnsystems.co
HTTPS listener on ALB
ArgoCD application for SpringBoot
springboot.dev.learnsystems.co
cert-manager
Prometheus
Grafana
Loki
Production-grade observability stack

Let's inspect the ExternalDNS IRSA module first so we wire it correctly rather than guessing.

cat ../../modules/external-dns-irsa/variables.tf
variable "cluster_name" {}
variable "oidc_provider_arn" {}
variable "oidc_provider_url" {}
variable "hosted_zone_id" {}
variable "project_name" {}
variable "environment" {}
kchilak@kalandars-MBP dev % grep -R "route53" ../../modules/external-dns-irsa
../../modules/external-dns-irsa/main.tf:          "route53:ChangeResourceRecordSets"
../../modules/external-dns-irsa/main.tf:          "arn:aws:route53:::hostedzone/${var.hosted_zone_id}"
../../modules/external-dns-irsa/main.tf:          "route53:ListHostedZones",
../../modules/external-dns-irsa/main.tf:          "route53:ListResourceRecordSets",
../../modules/external-dns-irsa/main.tf:          "route53:GetHostedZone"

Perfect. Now we know exactly which path your module is taking.

Your module is scoping Route53 permissions to a specific hosted zone, so hosted_zone_id is required.

The policy is effectively doing something like:

{
  "Action": [
    "route53:ChangeResourceRecordSets"
  ],
  "Resource": [
    "arn:aws:route53:::hostedzone/${var.hosted_zone_id}"
  ]
}

Therefore this is correct:

data "aws_route53_zone" "main" {
  name         = "learnsystems.co"
  private_zone = false
}

and

module "external_dns_irsa" {
  source = "../../modules/external-dns-irsa"

  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url

  hosted_zone_id = data.aws_route53_zone.main.zone_id

  project_name = var.project_name
  environment  = var.environment
}
But first fix the EKS module output

Earlier Terraform failed with:

module.eks.oidc_provider_url
does not exist

You currently only expose:

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

You need another output.

modules/eks/outputs.tf

Add:

output "oidc_provider_url" {
  value = replace(
    aws_iam_openid_connect_provider.eks.url,
    "https://",
    ""
  )
}

The IRSA trust policy usually expects:

oidc.eks.us-east-1.amazonaws.com/id/AF26FC10DEFD4735F4B0A57806441113

without the https://.

Then run
terraform fmt -recursive

terraform validate

terraform plan
Expected result

Terraform should create:

aws_iam_role.external_dns

aws_iam_policy.external_dns

aws_iam_role_policy_attachment.external_dns

(or similarly named resources depending on your module).

Next step after Terraform succeeds

We'll create:

gitops/apps/external-dns

and deploy ExternalDNS via ArgoCD.

Then we'll annotate the SpringBoot ingress:

external-dns.alpha.kubernetes.io/hostname: springboot.dev.learnsystems.co

and watch ExternalDNS automatically create:

springboot.dev.learnsystems.co
      ↓
ALB DNS NAME

inside Route53.

At that point you'll have a fully automated chain:

Git Commit
    ↓
ArgoCD Sync
    ↓
Ingress Created
    ↓
ALB Created
    ↓
ExternalDNS Creates DNS Record
    ↓
springboot.dev.learnsystems.co

which is the foundation of a production GitOps platform.

let me correct you the gitops repo structure is 

Yes, thanks for correcting that. Looking at your screenshot, your GitOps repo structure is actually more mature than what I assumed.

Your structure appears to be:

gitops/
├── applications/
│   ├── platform/
│   │   ├── aws-load-balancer-controller.yaml
│   │   └── aws-load-balancer-controller-prereqs.yaml
│   │
│   ├── springboot-app/
│   └── workloads/
│
├── appsets/
│
├── bootstrap/
│
├── manifests/
│   ├── aws-load-balancer-controller/
│   │   ├── kustomization.yaml
│   │   └── serviceaccount.yaml
│   │
│   ├── nginx/
│   │
│   └── springboot/
│       ├── deployment.yaml
│       ├── service.yaml
│       ├── ingress.yaml
│       └── kustomization.yaml
│
├── projects/
│
└── values/
    └── aws-load-balancer-controller/
        ├── dev.yaml
        ├── stage.yaml
        └── prod.yaml

Which means:

Platform Layer
applications/platform/

contains ArgoCD Applications for cluster-level components:

AWS Load Balancer Controller
ExternalDNS (next)
Cert Manager (later)
Metrics Server
Karpenter
Prometheus
Grafana
Argo Rollouts
Workload Layer
manifests/springboot/

contains raw manifests or kustomize overlays for applications.

Environment Configuration
values/

contains environment-specific values used by Helm applications.

This is exactly where:

values/external-dns/dev.yaml

should live.

Next Component: ExternalDNS

Instead of creating:

gitops/apps/external-dns

like I suggested earlier, it should fit your repo pattern:

gitops/
├── applications/
│   └── platform/
│       └── external-dns.yaml

├── values/
│   └── external-dns/
│       ├── dev.yaml
│       ├── stage.yaml
│       └── prod.yaml

which matches your ALB Controller implementation.

Before we continue

Let's verify Terraform first.

Did you already add:

output "oidc_provider_url" {
  value = replace(
    aws_iam_openid_connect_provider.eks.url,
    "https://",
    ""
  )
}

to:

modules/eks/outputs.tf

and does:

terraform plan

now succeed?

If yes, we'll build the ExternalDNS IRSA role, ArgoCD Application, Helm values, and then automate:

springboot.dev.learnsystems.co
        ↓
Route53
        ↓
ALB
        ↓
SpringBoot

using the same GitOps pattern you're already using for the ALB controller.

these should go under gitops/applications/platform - external-dns-prereqs.yaml
- external-dns.yaml

Yes. Based on the repo structure you showed earlier, these should be peer applications to the ALB controller applications and belong under:

gitops/
└── applications/
    └── platform/
        ├── aws-load-balancer-controller-prereqs.yaml
        ├── aws-load-balancer-controller.yaml
        ├── external-dns-prereqs.yaml
        └── external-dns.yaml

Create them exactly like you did for ALB.

gitops/applications/platform/external-dns-prereqs.yaml

This creates the ServiceAccount with the IRSA role.

apiVersion: argoproj.io/v1alpha1
kind: Application

metadata:
  name: external-dns-prereqs
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "0"

spec:

  project: default

  source:
    repoURL: https://github.com/ckalandar/aws-platform-engineering.git
    targetRevision: main
    path: gitops/manifests/external-dns

  destination:
    server: https://kubernetes.default.svc
    namespace: kube-system

  syncPolicy:
    automated:
      prune: true
      selfHeal: true
gitops/applications/platform/external-dns.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application

metadata:
  name: external-dns
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "1"

spec:

  project: default

  destination:
    namespace: kube-system
    server: https://kubernetes.default.svc

  sources:

    - repoURL: https://kubernetes-sigs.github.io/external-dns
      chart: external-dns
      targetRevision: 1.18.0

      helm:
        valueFiles:
          - $values/gitops/values/external-dns/dev.yaml

    - repoURL: https://github.com/ckalandar/aws-platform-engineering.git
      targetRevision: main
      ref: values

  syncPolicy:
    automated:
      prune: true
      selfHeal: true

    syncOptions:
      - CreateNamespace=true

Now create the manifest directory:

gitops/
└── manifests/
    └── external-dns/
        └── serviceaccount.yaml
gitops/manifests/external-dns/serviceaccount.yaml

Replace the role ARN with the one Terraform created:

apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-dns
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::136863648867:role/kk-platform-dev-external-dns

Create values directory:

gitops/
└── values/
    └── external-dns/
        └── dev.yaml
gitops/values/external-dns/dev.yaml
serviceAccount:
  create: false
  name: external-dns

provider:
  name: aws

policy: sync

registry: txt

txtOwnerId: kk-platform-dev

domainFilters:
  - learnsystems.co

sources:
  - ingress

aws:
  region: us-east-1

logLevel: debug

Then add these two applications to whatever parent ArgoCD app-of-apps directory you're using (likely gitops/applications/platform/kustomization.yaml or equivalent).

After committing and pushing:

git add .
git commit -m "Add external-dns"
git push

Then verify:

kubectl get applications -n argocd

You should see:

external-dns-prereqs
external-dns

Once they are Synced and Healthy, we'll create the first DNS-managed ingress:

springboot.dev.learnsystems.co

and ExternalDNS should automatically create the Route53 record without any manual Route53 changes.

aws-load-balancer-controller           Synced        Healthy
aws-load-balancer-controller-prereqs   Synced        Healthy
external-dns                           Synced        Healthy
external-dns-prereqs                   Synced        Healthy
nginx                                  Synced        Healthy
platform-app                           Synced        Healthy
root-app                               Synced        Healthy

Perfect. ExternalDNS is deployed and healthy.

Next, let's make it actually manage DNS records for your applications.

Step 1: Verify ExternalDNS Pod
kubectl get pods -n kube-system | grep external-dns

Expected:

external-dns-xxxxxxxxxx-xxxxx   1/1 Running
Step 2: Check ExternalDNS Logs
kubectl logs -n kube-system deployment/external-dns --tail=50

Look for something similar to:

Connected to AWS Route53
Using hosted zone: learnsystems.co
All records are already up to date

or

Desired change:
CREATE springboot.dev.learnsystems.co

Paste the output if there are any errors.

Step 3: Add DNS Annotations to SpringBoot Ingress

Show me your current ingress:

kubectl get ingress springboot \
-n springboot \
-o yaml

We're going to add:

metadata:
  annotations:
    external-dns.alpha.kubernetes.io/hostname: springboot.dev.learnsystems.co

and later:

alb.ingress.kubernetes.io/certificate-arn: <ACM ARN>
alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
alb.ingress.kubernetes.io/ssl-redirect: '443'
Step 4: Check ACM Status Again

Before we enable HTTPS:

aws acm describe-certificate \
  --certificate-arn arn:aws:acm:us-east-1:136863648867:certificate/b301e760-5bdb-4261-9b6f-b51d87c8b1a9 \
  --query 'Certificate.Status'

Need:

"ISSUED"

before attaching it to ALB.

Step 5: GitOps Structure

Since your repo already has:

gitops/
├── applications/
│   └── platform/
│       ├── aws-load-balancer-controller.yaml
│       ├── aws-load-balancer-controller-prereqs.yaml
│       ├── external-dns.yaml
│       └── external-dns-prereqs.yaml

the next production-grade platform components we'll add are:

platform/
├── cert-manager.yaml
├── cert-manager-prereqs.yaml
├── external-secrets.yaml
├── external-secrets-prereqs.yaml
├── metrics-server.yaml
├── kube-prometheus-stack.yaml
├── loki.yaml
├── tempo.yaml

But first let's finish the DNS path completely:

ALB → Route53 → springboot.dev.learnsystems.co → HTTPS

Run:

kubectl get ingress springboot \
-n springboot \
-o yaml

and

kubectl logs -n kube-system deployment/external-dns --tail=50

and paste both outputs.
Good. We found the problem immediately.

ExternalDNS is running, but IRSA is broken.

The key error is:

AccessDenied: Not authorized to perform sts:AssumeRoleWithWebIdentity

This means:

ExternalDNS Pod
    ↓
ServiceAccount
    ↓
IAM Role
    ↓
OIDC Trust Policy

is not matching.

Exactly the same class of issue we fixed for the ALB Controller.

First check the ServiceAccount

Run:

kubectl get sa external-dns \
-n kube-system \
-o yaml

I need to see:

annotations:
  eks.amazonaws.com/role-arn: arn:aws:iam::136863648867:role/kk-platform-dev-external-dns
Then check the IAM trust policy

Run:

aws iam get-role \
  --role-name kk-platform-dev-external-dns

Paste the entire AssumeRolePolicyDocument.

I specifically want to verify:

"sub": "system:serviceaccount:kube-system:external-dns"

and

"Federated": "arn:aws:iam::136863648867:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/AF26FC10DEFD4735F4B0A57806441113"
My suspicion

Your Terraform module probably generated something like:

"sub": "system:serviceaccount:external-dns:external-dns"

or

"sub": "system:serviceaccount:default:external-dns"

while the pod actually runs in:

kube-system

That would produce exactly:

sts:AssumeRoleWithWebIdentity
AccessDenied

which is what we are seeing.

Run these two commands:

kubectl get sa external-dns -n kube-system -o yaml
aws iam get-role --role-name kk-platform-dev-external-dns

Paste both outputs and we'll fix the trust relationship. Once that's corrected, ExternalDNS should automatically create:

springboot.dev.learnsystems.co

from the Ingress annotation within about a minute.

kubectl get sa external-dns \
-n kube-system \
-o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    argocd.argoproj.io/tracking-id: external-dns-prereqs:/ServiceAccount:kube-system/external-dns
    eks.amazonaws.com/role-arn: arn:aws:iam::136863648867:role/kk-platform-dev-external-dns
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"ServiceAccount","metadata":{"annotations":{"argocd.argoproj.io/tracking-id":"external-dns-prereqs:/ServiceAccount:kube-system/external-dns","eks.amazonaws.com/role-arn":"arn:aws:iam::136863648867:role/kk-platform-dev-external-dns"},"name":"external-dns","namespace":"kube-system"}}
  creationTimestamp: "2026-07-29T12:19:54Z"
  name: external-dns
  namespace: kube-system
  resourceVersion: "58052"
  uid: c2bbe5f4-cb79-4176-b9bf-666fe8c1be7b
kchilak@kalandars-MBP aws-platform-engineering % aws iam get-role \
  --role-name kk-platform-dev-external-dns
{
    "Role": {
        "Path": "/",
        "RoleName": "kk-platform-dev-external-dns",
        "RoleId": "AROAR7XNVRRR5RSQDK4AM",
        "Arn": "arn:aws:iam::136863648867:role/kk-platform-dev-external-dns",
        "CreateDate": "2026-07-29T11:29:50+00:00",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Federated": "arn:aws:iam::136863648867:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/AF26FC10DEFD4735F4B0A57806441113"
                    },
                    "Action": "sts:AssumeRoleWithWebIdentity",
                    "Condition": {
                        "StringEquals": {
                            "oidc.eks.us-east-1.amazonaws.com/id/AF26FC10DEFD4735F4B0A57806441113:sub": "system:serviceaccount:external-dns:external-dns"
                        }
                    }
                }
            ]
        },
        "MaxSessionDuration": 3600,
        "Tags": [
            {
                "Key": "Environment",
                "Value": "dev"
            },
            {
                "Key": "Project",
                "Value": "kk-platform"
            },
            {
                "Key": "ManagedBy",
                "Value": "terraform"
            }
        ],
        "RoleLastUsed": {}
    }
}

Found it.

Your ServiceAccount is:

system:serviceaccount:kube-system:external-dns

But your IAM trust policy expects:

system:serviceaccount:external-dns:external-dns

Notice the namespace mismatch:

Expected: external-dns
Actual:   kube-system

That is exactly why STS returns:

AccessDenied: Not authorized to perform sts:AssumeRoleWithWebIdentity
Fix in Terraform

Go to your external-dns-irsa module.

You'll find something similar to:

"${var.oidc_provider_url}:sub" = "system:serviceaccount:external-dns:external-dns"

Change it to:

"${var.oidc_provider_url}:sub" = "system:serviceaccount:kube-system:external-dns"

or even better:

variable "namespace" {
  default = "kube-system"
}

variable "service_account_name" {
  default = "external-dns"
}

and:

"${var.oidc_provider_url}:sub" =
  "system:serviceaccount:${var.namespace}:${var.service_account_name}"
Apply
cd infrastructure/environments/dev

terraform plan
terraform apply
Verify Trust Policy

After apply:

aws iam get-role \
  --role-name kk-platform-dev-external-dns

You should see:

"StringEquals": {
  "oidc.eks.us-east-1.amazonaws.com/id/AF26FC10DEFD4735F4B0A57806441113:sub":
  "system:serviceaccount:kube-system:external-dns"
}
Restart ExternalDNS
kubectl rollout restart deployment external-dns -n kube-system

Watch:

kubectl logs -f deployment/external-dns -n kube-system

The error should disappear.

Instead you'll start seeing Route53 activity such as:

Desired change: CREATE springboot.dev.learnsystems.co

or

Applying provider record filter for domain learnsystems.co

One more thing before restarting:

Show me your current springboot ingress manifest (the GitOps YAML, not the live object).

I want to verify that you've added the ExternalDNS hostname annotation, otherwise ExternalDNS will authenticate successfully but still won't create any DNS records.

but the modules/external-dns-irsa/main.tf doesn't have the "${var.oidc_provider_url}:sub" =
  "system:serviceaccount:${var.namespace}:${var.service_account_name}"locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

data "aws_iam_policy_document" "assume_role" {

  statement {

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    effect = "Allow"

    principals {
      type = "Federated"

      identifiers = [
        var.oidc_provider_arn
      ]
    }

    condition {
      test = "StringEquals"

      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:external-dns:external-dns"
      ]
    }
  }
}

resource "aws_iam_role" "external_dns" {

  name = "${var.cluster_name}-external-dns"

  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = local.common_tags
}

resource "aws_iam_policy" "external_dns" {

  name = "${var.cluster_name}-external-dns"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "route53:ChangeResourceRecordSets"
        ]

        Resource = [
          "arn:aws:route53:::hostedzone/${var.hosted_zone_id}"
        ]
      },

      {
        Effect = "Allow"

        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:GetHostedZone"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_dns" {

  role = aws_iam_role.external_dns.name

  policy_arn = aws_iam_policy.external_dns.arn
}

Exactly. The trust policy is being generated from this block:

condition {
  test = "StringEquals"

  variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"

  values = [
    "system:serviceaccount:external-dns:external-dns"
  ]
}

The problem is here:

values = [
  "system:serviceaccount:external-dns:external-dns"
]

Your ServiceAccount actually lives in:

kube-system

So change it to:

condition {
  test = "StringEquals"

  variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"

  values = [
    "system:serviceaccount:kube-system:external-dns"
  ]
}

Then:

terraform plan
terraform apply

Verify:

aws iam get-role \
  --role-name kk-platform-dev-external-dns

You should now see:

"oidc.eks.us-east-1.amazonaws.com/id/AF26FC10DEFD4735F4B0A57806441113:sub":
"system:serviceaccount:kube-system:external-dns"

After that restart ExternalDNS:

kubectl rollout restart deployment external-dns -n kube-system

Then watch logs:

kubectl logs -f deployment/external-dns -n kube-system

The AssumeRoleWithWebIdentity error should disappear.

Since you're building a reusable platform, I'd improve the module immediately:

modules/external-dns-irsa/variables.tf

variable "namespace" {
  type    = string
  default = "kube-system"
}

variable "service_account_name" {
  type    = string
  default = "external-dns"
}

and in main.tf:

values = [
  "system:serviceaccount:${var.namespace}:${var.service_account_name}"
]

This prevents hardcoding namespaces and makes the IRSA module reusable for other controllers.

After ExternalDNS authenticates successfully, the next thing we'll check is whether your Spring Boot Ingress contains:

annotations:
  external-dns.alpha.kubernetes.io/hostname: springboot.dev.learnsystems.co

Without that annotation, ExternalDNS will have AWS access but won't create any Route53 records.

curl -I http://springboot.dev.learnsystems.co
curl: (6) Could not resolve host: springboot.dev.learnsystems.co
kchilak@kalandars-MBP aws-platform-engineering % aws acm list-certificates \
  --region us-east-1
{
    "CertificateSummaryList": [
        {
            "CertificateArn": "arn:aws:acm:us-east-1:136863648867:certificate/b301e760-5bdb-4261-9b6f-b51d87c8b1a9",
            "DomainName": "*.dev.learnsystems.co",
            "SubjectAlternativeNameSummaries": [
                "*.dev.learnsystems.co"
            ],
            "HasAdditionalSubjectAlternativeNames": false,
            "Status": "ISSUED",
            "Type": "AMAZON_ISSUED",
            "KeyAlgorithm": "RSA-2048",
            "KeyUsages": [
                "DIGITAL_SIGNATURE",
                "KEY_ENCIPHERMENT"
            ],
            "ExtendedKeyUsages": [
                "TLS_WEB_SERVER_AUTHENTICATION"
            ],
            "ExportOption": "DISABLED",
            "InUse": false,
            "Exported": false,
            "RenewalEligibility": "INELIGIBLE",
            "NotBefore": "2026-07-29T05:30:00+05:30",
            "NotAfter": "2027-02-12T05:29:59+05:30",
            "CreatedAt": "2026-07-29T15:51:41.900000+05:30",
            "IssuedAt": "2026-07-29T16:24:03.629000+05:30",
            "CertificateKeyPairOrigin": "AWS_MANAGED"
        }
    ]
}
kchilak@kalandars-MBP aws-platform-engineering % aws acm describe-certificate \
  --certificate-arn arn:aws:acm:us-east-1:136863648867:certificate/b301e760-5bdb-4261-9b6f-b51d87c8b1a9 \
> --query 'Certificate.Status'
"ISSUED"

Great. ACM is now ISSUED, so we can move directly to HTTPS.

Before that, let's understand why this happened:

dig springboot.dev.learnsystems.co +short

worked earlier, but

curl -I http://springboot.dev.learnsystems.co

returns:

Could not resolve host

That usually means your local resolver cache hasn't updated yet, or you're using a different DNS resolver than dig.

Check:

nslookup springboot.dev.learnsystems.co

and

dig springboot.dev.learnsystems.co

and

host springboot.dev.learnsystems.co

Let's verify the record still exists:

aws route53 list-resource-record-sets \
  --hosted-zone-id Z0279443763ABCDYC2SS \
  --query "ResourceRecordSets[?contains(Name, 'springboot')]"
Now enable HTTPS on the ALB

Update your ingress:

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: springboot

  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip

    external-dns.alpha.kubernetes.io/hostname: springboot.dev.learnsystems.co

    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:us-east-1:136863648867:certificate/b301e760-5bdb-4261-9b6f-b51d87c8b1a9

    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80},{"HTTPS":443}]'

    alb.ingress.kubernetes.io/ssl-redirect: "443"

spec:
  ingressClassName: alb

  rules:
    - host: springboot.dev.learnsystems.co
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: springboot
                port:
                  number: 80

Commit and push:

git add .
git commit -m "Enable HTTPS for springboot ingress"
git push

Then watch:

kubectl describe ingress springboot -n springboot

You should eventually see:

80
443

instead of just:

80

After ArgoCD syncs:

kubectl get ingress -n springboot

Then test:

curl -k https://springboot.dev.learnsystems.co

and

curl -I https://springboot.dev.learnsystems.co

If HTTPS works, the next step is not another app.

The next platform capability should be:

AWS Secrets Manager
        ↓
External Secrets Operator
        ↓
Kubernetes Secret
        ↓
Spring Boot Application

This is where the platform starts becoming production-grade because we stop storing credentials in Git and start pulling them dynamically into workloads.
Excellent. Your platform is now working end-to-end.

The evidence:

curl -k https://springboot.dev.learnsystems.co

{"status":"healthy","service":"platform-demo","environment":"dev"}

This means:

✅ Route53 record created by ExternalDNS
✅ ExternalDNS IRSA fixed
✅ ACM wildcard certificate issued
✅ ALB Controller working
✅ ALB provisioned
✅ HTTPS listener configured
✅ Target Group healthy
✅ ECR image pushed
✅ ArgoCD deployed application
✅ SpringBoot pods running
✅ DNS resolving correctly
✅ End-to-end traffic flow working

Now let's finish what a real Platform Engineer would do next.

Current Architecture
Internet
    |
Route53
    |
ALB
    |
Target Group
    |
EKS Service
    |
SpringBoot Pods
Before moving forward

Let's verify the deployment pipeline.

You currently have:

terraform-bootstrap.yaml
terraform-apply.yaml
springboot-ci.yaml (empty)

The image was manually built and pushed.

A real platform should do:

Developer Push
      |
GitHub Actions
      |
Maven Build
      |
Docker Build
      |
Push to ECR
      |
Update GitOps Repo
      |
ArgoCD Sync
      |
Deploy New Version
Next Task

Create:

.github/workflows/springboot-ci.yaml

Pipeline stages:

Checkout
↓
Java 21
↓
mvn package
↓
Build Docker Image
↓
Login ECR
↓
Push Image
↓
Update deployment.yaml image tag
↓
Commit back to GitOps repo
Before writing the workflow

Verify GitHub OIDC works.

Run:

aws iam list-attached-role-policies \
  --role-name platform-github-actions-role

Expected:

AdministratorAccess

If yes:

gh variable list

Show me:

AWS_ROLE_TO_ASSUME
AWS_REGION
PROJECT_NAME

Once those are present we'll build the production-grade CI/CD pipeline and remove all manual Docker push operations permanently.

aws iam list-attached-role-policies \
  --role-name platform-github-actions-role
{
    "AttachedPolicies": [
        {
            "PolicyName": "AdministratorAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/AdministratorAccess"
        }
    ]
}
kchilak@kalandars-MBP springboot-app % gh variable list
zsh: command not found: gh
kchilak@kalandars-MBP springboot-app % git variable list
git: 'variable' is not a git command. See 'git --help'.
kchilak@kalandars-MBP springboot-app % github variable list
zsh: command not found: github

Excellent. Your platform is now actually working end-to-end:

✅ EKS deployed
✅ ArgoCD deployed
✅ AWS Load Balancer Controller working
✅ ExternalDNS working
✅ ACM certificate issued
✅ ALB created
✅ Route53 record created automatically
✅ SpringBoot pods healthy
✅ Target group healthy
✅ HTTPS working

And your application responds:

{
  "status":"healthy",
  "service":"platform-demo",
  "environment":"dev"
}

The remaining piece is CI/CD.

First install GitHub CLI

You don't have it:

gh

returns command not found.

Install:

brew install gh

Verify:

gh --version

Login:

gh auth login

Choose:

GitHub.com
HTTPS
Login with browser
Check Repository Variables

Once authenticated:

gh variable list

You should see something similar:

AWS_REGION
AWS_ROLE_TO_ASSUME
PROJECT_NAME

If empty:

gh variable set AWS_REGION --body us-east-1

gh variable set AWS_ROLE_TO_ASSUME \
--body arn:aws:iam::136863648867:role/platform-github-actions-role

gh variable set PROJECT_NAME \
--body kk-platform

Verify:

gh variable list
Check Repository Secrets
gh secret list

For OIDC authentication you may not need AWS keys.

If we use:

aws-actions/configure-aws-credentials

with:

role-to-assume:

then GitHub OIDC is sufficient.

Create SpringBoot CI Workflow

Your file is blank:

.github/workflows/springboot-ci.yaml

Let's make it production-grade.

name: SpringBoot CI

on:
  push:
    branches:
      - main
    paths:
      - "springboot-app/**"

permissions:
  id-token: write
  contents: read

env:
  AWS_REGION: us-east-1
  ECR_REPOSITORY: platform-demo

jobs:

  build-and-push:

    runs-on: ubuntu-latest

    defaults:
      run:
        working-directory: springboot-app

    steps:

      - name: Checkout
        uses: actions/checkout@v4

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ vars.AWS_ROLE_TO_ASSUME }}
          aws-region: ${{ vars.AWS_REGION }}

      - name: Login to ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v2

      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: 21

      - name: Build Jar
        run: mvn clean package

      - name: Build Docker Image
        run: |
          docker build \
            -t $ECR_REPOSITORY:${{ github.sha }} \
            .

      - name: Tag Image
        run: |
          docker tag \
          $ECR_REPOSITORY:${{ github.sha }} \
          ${{ steps.login-ecr.outputs.registry }}/$ECR_REPOSITORY:${{ github.sha }}

      - name: Push Image
        run: |
          docker push \
          ${{ steps.login-ecr.outputs.registry }}/$ECR_REPOSITORY:${{ github.sha }}

      - name: Update GitOps Manifest
        run: |
          sed -i "s|image: .*|image: ${{ steps.login-ecr.outputs.registry }}/$ECR_REPOSITORY:${{ github.sha }}|g" \
          ../gitops/manifests/springboot/deployment.yaml

      - name: Commit Manifest
        run: |
          git config user.email "github-actions@github.com"
          git config user.name "github-actions"

          git add ../gitops/manifests/springboot/deployment.yaml

          git commit -m "Update image to ${{ github.sha }}" || true

          git push
Before running

Verify ECR now contains image:

aws ecr describe-images \
  --repository-name platform-demo

You should now see at least:

"imageTags": [
  "1.0.0"
]

or whatever tag you pushed.

Next step

After you create springboot-ci.yaml, push it to GitHub and run:

git add .
git commit -m "add springboot ci"
git push

Then we'll verify:

GitHub OIDC role assumption works
Image gets pushed to ECR
Deployment manifest updates automatically
ArgoCD syncs automatically
New pod version rolls out without manual kubectl commands

That's the final GitOps flow for this platform.

======== log 30 July ===

Perfect. That confirms the relative path is correct:

gitops/applications/springboot-app
└── ../../manifests/springboot/deployment.yaml ✓

So the workflow should not use:

/Users/kchilak/Documents/Devops/aws-platform-engineering/gitops/manifests/springboot/deployment.yaml

and should instead use:

- name: Update GitOps Manifest
  run: |
    sed -i.bak "s|image: .*|image: ${{ steps.login-ecr.outputs.registry }}/$ECR_REPOSITORY:${{ github.sha }}|g" \
    ../../manifests/springboot/deployment.yaml

    rm -f ../../manifests/springboot/deployment.yaml.bak

And the commit step should be:

- name: Commit Manifest
  run: |
    git config user.email "github-actions@github.com"
    git config user.name "github-actions"

    git add ../../manifests/springboot/deployment.yaml

    git commit -m "Update image to ${{ github.sha }}" || true

    git push

Before pushing, I recommend adding one temporary debug step immediately before the sed command:

- name: Debug Paths
  run: |
    pwd
    ls -lrt ../../manifests/springboot/

This will prove exactly where the runner is executing and whether it sees the deployment manifest.

Once this workflow succeeds, you should see:

Image pushed to ECR.
deployment.yaml updated with the new SHA tag.
Workflow commits back to GitHub.
ArgoCD detects the Git change.
New ReplicaSet created.
New pods rolled out.
curl -k https://springboot.dev.learnsystems.co/version returns:
{"version":"v2","service":"platform-demo"}

At that point your complete CI → ECR → GitOps → ArgoCD → EKS deployment pipeline is functioning end-to-end.

aws ecr describe-images \
  --repository-name platform-demo
{
    "imageDetails": [
        {
            "registryId": "136863648867",
            "repositoryName": "platform-demo",
            "imageDigest": "sha256:a1a4309a34d5667767ce68438ee82fecf7be1676c4660c57d5abfabcf28c2b73",
            "imageSizeInBytes": 1421,
            "imagePushedAt": "2026-07-29T22:20:47.325000+05:30",
            "imageManifestMediaType": "application/vnd.oci.image.manifest.v1+json",
            "artifactMediaType": "application/vnd.oci.image.config.v1+json",
            "imageStatus": "ACTIVE"
        },
        {
            "registryId": "136863648867",
            "repositoryName": "platform-demo",
            "imageDigest": "sha256:9c0c9982731ac0c35cc3fd87d0b8e630cb44e18e33b61120756560d8ec90ab4a",
            "imageSizeInBytes": 133740732,
            "imagePushedAt": "2026-07-29T22:20:47.431000+05:30",
            "imageManifestMediaType": "application/vnd.oci.image.manifest.v1+json",
            "artifactMediaType": "application/vnd.oci.image.config.v1+json",
            "lastRecordedPullTime": "2026-07-29T22:20:47.913000+05:30",
            "imageStatus": "ACTIVE"
        },
        {
            "registryId": "136863648867",
            "repositoryName": "platform-demo",
            "imageDigest": "sha256:ea7033f342b8c100a37d69ee189c4756883c922f442614f05ac55e58c7667077",
            "imageTags": [
                "1.0.0"
            ],
            "imageSizeInBytes": 133740732,
            "imagePushedAt": "2026-07-29T22:20:48.179000+05:30",
            "imageManifestMediaType": "application/vnd.oci.image.index.v1+json",
            "lastRecordedPullTime": "2026-07-29T22:21:00.603000+05:30",
            "imageStatus": "ACTIVE"
        },
        {
            "registryId": "136863648867",
            "repositoryName": "platform-demo",
            "imageDigest": "sha256:fd1efe908bde3d86c96927da4b8a4cedb09a11f70b8f46a690a268730d332803",
            "imageStatus": "ACTIVE"
        },
        {
            "registryId": "136863648867",
            "repositoryName": "platform-demo",
            "imageDigest": "sha256:fd1efe908bde3d86c96927da4b8a4cedb09a11f70b8f46a690a268730d332803",
            "imageTags": [
                "cd805d0389c253af98f184c5f3cb846806547667"
            ],
            "imageSizeInBytes": 133740871,
            "imagePushedAt": "2026-07-30T12:42:57.262000+05:30",
            "imageManifestMediaType": "application/vnd.docker.distribution.manifest.v2+json",
            "artifactMediaType": "application/vnd.docker.container.image.v1+json",
            "imageStatus": "ACTIVE"
        },
        {
            "registryId": "136863648867",
            "repositoryName": "platform-demo",
            "imageDigest": "sha256:64ac885ce9773f0c1656a98c8eeb3499aa87aad3ab3d1605dfb42a8057999fc7",
            "imageTags": [
                "0e4c175e328f2a86305e8949e06b46c6e2ce6344"
            ],
            "imageSizeInBytes": 133740883,
            "imagePushedAt": "2026-07-30T12:52:56.903000+05:30",
            "imageManifestMediaType": "application/vnd.docker.distribution.manifest.v2+json",
            "artifactMediaType": "application/vnd.docker.container.image.v1+json",
            "imageStatus": "ACTIVE"
        },
        {
            "registryId": "136863648867",
            "repositoryName": "platform-demo",
            "imageDigest": "sha256:fe02c143c8debced6b63cd7c61001ebe398c47409ad8544730872a696c3dc585",
            "imageTags": [
                "bc8010e0f4be9b492121d54de406745edf45cd65"
            ],
            "imageSizeInBytes": 133740870,
            "imagePushedAt": "2026-07-30T12:49:17.444000+05:30",
            "imageManifestMediaType": "application/vnd.docker.distribution.manifest.v2+json",
            "artifactMediaType": "application/vnd.docker.container.image.v1+json",
            "imageStatus": "ACTIVE"
        },
        {
            "registryId": "136863648867",
            "repositoryName": "platform-demo",
            "imageDigest": "sha256:c0a4d2aaace792211589d2651403183d5823cdbd7d69dd11d302be5a6e2da8cd",
            "imageTags": [
            "imageDigest": "sha256:c0a4d2aaace792211589d2651403183d5823cdbd7d69dd11d302be5a6e2da8cd",
            "imageTags": [
                "d8e7d0bae551e2d848a4c3d53c34c27a7090d0b4"
            ],
            "imageSizeInBytes": 133740880,
            "imagePushedAt": "2026-07-30T13:07:03.361000+05:30",
            "imageManifestMediaType": "application/vnd.docker.distribution.manifest.v2+json",
            "artifactMediaType": "application/vnd.docker.container.image.v1+json",
            "imageStatus": "ACTIVE"
        }
kchilak@kalandars-MBP aws-platform-engineering % curl -k https://springboot.dev.learnsystems.co/version
{"timestamp":"2026-07-30T07:39:41.628+00:00","status":404,"error":"Not Found","path":"/version"}%                  kchilak@kalandars-MBP aws-platform-engineering % kubectl get pods -n springboot
NAME                          READY   STATUS    RESTARTS   AGE
springboot-68b57c974c-bshtf   1/1     Running   0          14h
springboot-68b57c974c-rkhnn   1/1     Running   0          14h

At this point your pipeline is definitely pushing images to ECR.

The evidence is here:

imageTags:
  - bc8010e0f4be9b492121d54de406745edf45cd65
imagePushedAt: 2026-07-30T12:49:17

imageTags:
  - 0e4c175e328f2a86305e8949e06b46c6e2ce6344
imagePushedAt: 2026-07-30T12:52:56

imageTags:
  - d8e7d0bae551e2d848a4c3d53c34c27a7090d0b4
imagePushedAt: 2026-07-30T13:07:03

Those are Git commit SHAs, exactly what your workflow tags images with:

docker build \
  -t $ECR_REPOSITORY:${{ github.sha }}

docker push \
  ${{ steps.login-ecr.outputs.registry }}/$ECR_REPOSITORY:${{ github.sha }}

So:

✅ GitHub Actions ran
✅ Built the JAR
✅ Built Docker image
✅ Pushed image to ECR

But why is /version returning 404?

Your running pods are still the old pods:

kubectl get pods -n springboot

springboot-68b57c974c-bshtf
springboot-68b57c974c-rkhnn
AGE 14h

Notice:

AGE 14h

They have not been recreated.

If the deployment had rolled out the new image, you would see:

AGE 2m
AGE 2m

or a new ReplicaSet name.

What happened?

Your workflow failed here:

sed: can't read deployment.yaml

which means it never updated:

gitops/manifests/springboot/deployment.yaml

and therefore never committed the new image tag.

ArgoCD never saw a manifest change.

No deployment happened.

Verify what image Kubernetes is currently running

Run:

kubectl get deployment springboot \
-n springboot \
-o jsonpath='{.spec.template.spec.containers[0].image}'

I expect:

136863648867.dkr.ecr.us-east-1.amazonaws.com/platform-demo:1.0.0

not one of the SHA tags.

Check what image is in Git
cat gitops/manifests/springboot/deployment.yaml

Look for:

image:

I expect it still says:

image: 136863648867.dkr.ecr.us-east-1.amazonaws.com/platform-demo:1.0.0
Fix deployment manually now

Update deployment.yaml:

image: 136863648867.dkr.ecr.us-east-1.amazonaws.com/platform-demo:d8e7d0bae551e2d848a4c3d53c34c27a7090d0b4

Commit:

git add gitops/manifests/springboot/deployment.yaml

git commit -m "deploy latest image"

git push origin main

Then sync ArgoCD.

Verify rollout

Watch:

kubectl get pods -n springboot -w

You should see:

springboot-xxxxx   Running
springboot-yyyyy   Running

with a new ReplicaSet name.

Then test
curl -k https://springboot.dev.learnsystems.co/version

Expected:

v2
One more improvement

Your workflow currently does:

docker push image:${{ github.sha }}

but your deployment started life with:

image: platform-demo:1.0.0

For GitOps, I recommend never using fixed tags like 1.0.0.

Use only commit SHAs:

image: 136863648867.dkr.ecr.us-east-1.amazonaws.com/platform-demo:${{ github.sha }}

Then every deployment is traceable:

Git Commit
   ↓
Docker Image SHA Tag
   ↓
GitOps Manifest Update
   ↓
ArgoCD Sync
   ↓
Deployment Rollout

That's the production-grade GitOps flow you're building toward. Right now you've successfully completed the CI portion (GitHub → ECR); the remaining issue is that the CD portion (manifest update → ArgoCD rollout) never completed because the workflow failed during the sed step.

it did work kubectl get deployment springboot \
-n springboot \
-o jsonpath='{.spec.template.spec.containers[0].image}'
136863648867.dkr.ecr.us-east-1.amazonaws.com/platform-demo:d8e7d0bae551e2d848a4c3d53c34c27a7090d0b4%               kchilak@kalandars-MBP aws-platform-engineering % kubectl get pods -n springboot
NAME                          READY   STATUS    RESTARTS   AGE
springboot-7bb6cd8c8d-8gcfg   1/1     Running   0          63s
springboot-7bb6cd8c8d-rxp22   1/1     Running   0          65s
kchilak@kalandars-MBP aws-platform-engineering % curl -k https://springboot.dev.learnsystems.co/version
{"version":"v3","service":"platform-demo"}%   

Excellent. This confirms your entire GitOps pipeline is now functioning end-to-end.

What just happened

Your deployment is now using:

kubectl get deployment springboot \
-n springboot \
-o jsonpath='{.spec.template.spec.containers[0].image}'

Output:

136863648867.dkr.ecr.us-east-1.amazonaws.com/platform-demo:d8e7d0bae551e2d848a4c3d53c34c27a7090d0b4

and:

curl -k https://springboot.dev.learnsystems.co/version

returns:

{
  "version":"v3",
  "service":"platform-demo"
}

which proves:

Code change was committed to GitHub
GitHub Actions triggered
Maven built the JAR
Docker image built successfully
Image pushed to ECR
GitOps manifest updated with new image tag
Commit pushed back to GitHub
ArgoCD detected manifest change
ArgoCD synced deployment
Kubernetes created new ReplicaSet
New pods pulled image from ECR
ALB registered healthy targets
Traffic reached new pods

That's a complete CI/CD/GitOps flow.

Architecture you have built
Developer
    |
    v
Git Push
    |
    v
GitHub Actions
    |
    +--> Maven Package
    |
    +--> Docker Build
    |
    +--> Push Image to ECR
    |
    +--> Update GitOps Manifest
              |
              v
           Git Repo
              |
              v
           ArgoCD
              |
              v
             EKS
              |
              v
      SpringBoot Pods
              |
              v
 AWS Load Balancer Controller
              |
              v
             ALB
              |
              v
 ExternalDNS
              |
              v
 Route53
              |
              v
springboot.dev.learnsystems.co
Issues you successfully debugged

You actually worked through several real production problems:

1. ExternalDNS IRSA trust policy

Initially:

No Route53 records created

Root cause:

ServiceAccount namespace mismatch

You verified:

kubectl get sa external-dns -n kube-system

and

aws iam get-role
2. Route53 DNS propagation

Initially:

curl springboot.dev.learnsystems.co

failed.

You verified:

dig springboot.dev.learnsystems.co

Eventually records propagated.

3. ALB 503

You saw:

HTTP 503

Most engineers would start troubleshooting ALB.

You correctly drilled down:

kubectl get pods

and found:

ImagePullBackOff
4. ECR empty repository

You found:

aws ecr describe-images

returned:

{
  "imageDetails": []
}

Root cause:

No image was ever pushed
5. GitHub OIDC

You discovered:

platform-github-actions-role

did not exist.

Then traced:

manage_oidc

and validated:

aws iam get-role \
--role-name platform-github-actions-role
6. Workflow trigger issue

The workflow wasn't running because:

paths:
  - springboot-app/**

while the application lived in:

gitops/applications/springboot-app

That is a classic GitHub Actions trigger mistake.

7. Manifest update path issue

Workflow failed because:

gitops/manifests/springboot/deployment.yaml

was referenced using an incorrect relative path.

You fixed it.

8. ArgoCD deployment verification

You verified:

kubectl get deployment

and

kubectl get pods

showing a completely new ReplicaSet:

springboot-7bb6cd8c8d

instead of:

springboot-68b57c974c

which proves a new deployment rollout occurred.

What you now have on your resume

This isn't a toy project anymore.

You can honestly say:

Designed and implemented a production-style GitOps platform on AWS using Terraform, EKS, ArgoCD, GitHub Actions, ECR, Route53, ExternalDNS, AWS Load Balancer Controller, ACM and Spring Boot.

And discuss:

IRSA
OIDC Federation
Route53 automation
ExternalDNS
ALB Controller
GitOps
ArgoCD sync
ECR image lifecycle
CI/CD pipelines
Kubernetes troubleshooting
AWS networking

because you've actually debugged them.

Recommended next milestones
Add /actuator/health
Configure ALB health checks explicitly
Add readiness/liveness probes
Add Prometheus
Add Grafana
Add Loki
Add cert-manager
Add Argo Rollouts (blue/green deployments)
Add Karpenter
Add External Secrets Operator + AWS Secrets Manager

That sequence takes your platform from a working Kubernetes deployment to something very close to what many platform engineering teams run in production.

We should build External Secrets Operator + AWS Secrets Manager first.

Reasoning from a Platform Engineering perspective:

You already have:

EKS
ArgoCD
GitHub Actions
ECR
Route53
ExternalDNS
AWS Load Balancer Controller
IRSA

External Secrets is the next natural evolution because it builds directly on skills you've already used:

IRSA
  ↓
ExternalDNS
  ↓
External Secrets

You'll reuse:

IAM Roles
OIDC
Service Accounts
ArgoCD
GitOps
Kubernetes Controllers

and learn:

AWS Secrets Manager
Secret rotation
Secret injection
Security patterns

If we jump to observability now, you'll get Prometheus and Grafana running quickly, but your application is still not consuming secrets the way production applications do.

A typical production maturity path is:

Deploy App
    ↓
DNS
    ↓
TLS
    ↓
Secrets
    ↓
Monitoring
    ↓
Autoscaling
    ↓
Database
    ↓
Platform Services

Looking at your repo structure, I would add:

infrastructure/modules
├── external-secrets-irsa

and

gitops/manifests
├── external-secrets
│   ├── secretstore.yaml
│   ├── springboot-secret.yaml
│   ├── serviceaccount.yaml
│   └── kustomization.yaml

and

gitops/applications/platform
├── external-secrets-prereqs.yaml
├── external-secrets.yaml

Exactly the same pattern you already used for:

external-dns
aws-load-balancer-controller

which keeps the platform consistent.

Next task

Let's start by creating the AWS secret.

Run:

aws secretsmanager create-secret \
  --name springboot/dev/app-config \
  --secret-string '{
    "username":"admin",
    "password":"SuperSecret123",
    "apiKey":"abc123xyz"
  }'

If the secret already exists, run:

aws secretsmanager describe-secret \
  --secret-id springboot/dev/app-config

and show me the output.

Once we confirm the secret exists, we'll create the external-secrets-irsa Terraform module by cloning the pattern from your existing external-dns-irsa module and wire it into the EKS platform.

aws secretsmanager create-secret \
  --name springboot/dev/app-config \
  --secret-string '{
    "username":"admin",
    "password":"SuperSecret123",
    "apiKey":"abc123xyz"
  }'
{
    "ARN": "arn:aws:secretsmanager:us-east-1:136863648867:secret:springboot/dev/app-config-VP6PJS",
    "Name": "springboot/dev/app-config",
    "VersionId": "b3aa7036-b57a-44b5-b4c4-9ea8e8d1936b"
}
kchilak@kalandars-MBP aws-platform-engineering % aws secretsmanager describe-secret \
  --secret-id springboot/dev/app-config
{
    "ARN": "arn:aws:secretsmanager:us-east-1:136863648867:secret:springboot/dev/app-config-VP6PJS",
    "Name": "springboot/dev/app-config",
    "LastChangedDate": "2026-07-30T14:48:10.241000+05:30",
    "VersionIdsToStages": {
        "b3aa7036-b57a-44b5-b4c4-9ea8e8d1936b": [
            "AWSCURRENT"
        ]
    },
    "CreatedDate": "2026-07-30T14:48:09.951000+05:30"
}

Perfect. Secret creation is done.

Now we move into the platform implementation.

Step 1: Create the External Secrets IRSA module

Since you already have:

modules/external-dns-irsa

don't reinvent it.

Clone it:

cd infrastructure/modules

cp -R external-dns-irsa external-secrets-irsa
Step 2: Update main.tf

Inside:

infrastructure/modules/external-secrets-irsa/main.tf

Replace the policy with:

resource "aws_iam_policy" "external_secrets" {

  name = "${var.cluster_name}-external-secrets"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]

        Resource = "*"
      }
    ]
  })
}

Update the trust relationship.

Change:

values = [
  "system:serviceaccount:external-dns:external-dns"
]

to:

values = [
  "system:serviceaccount:external-secrets:external-secrets"
]

Update role name:

resource "aws_iam_role" "external_secrets" {

  name = "${var.cluster_name}-external-secrets"

  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = local.common_tags
}

Update attachment:

resource "aws_iam_role_policy_attachment" "external_secrets" {

  role       = aws_iam_role.external_secrets.name
  policy_arn = aws_iam_policy.external_secrets.arn
}
Step 3: outputs.tf

Create:

output "role_arn" {
  value = aws_iam_role.external_secrets.arn
}
Step 4: Wire module into environment

Show me your:

cat infrastructure/environments/dev/main.tf

(or wherever you're currently instantiating:

module "external_dns_irsa"

)

I want to place the new module beside:

module "external_dns_irsa"

and use the existing EKS OIDC outputs rather than guessing your wiring.

After that we'll:

Apply Terraform
Create ArgoCD Application
Install External Secrets Operator
Create SecretStore
Create ExternalSecret
Inject secrets into SpringBoot
Verify via /config

Let's do the Terraform wiring next.
You're very close. I see a few issues that should be fixed before you run terraform apply.

1. Good Improvement

This is much better than hardcoding:

values = [
  "system:serviceaccount:${var.namespace}:${var.service_account_name}"
]

Now the module is reusable.

2. outputs.tf is Wrong

Current:

output "external_dns_role_arn" {
  value = aws_iam_role.external_dns.arn
}

There is no resource:

aws_iam_role.external_dns

in this module anymore.

It should be:

output "external_secrets_role_arn" {
  value = aws_iam_role.external_secrets.arn
}
3. hosted_zone_id Should Be Removed

You have:

variable "hosted_zone_id" {}

but External Secrets doesn't use Route53.

Remove it.

# delete
variable "hosted_zone_id" {}
4. Namespace Default Is Wrong

Current:

variable "namespace" {
  default = "kube-system"
}

External Secrets will run in:

external-secrets

not:

kube-system

Use:

variable "namespace" {
  default = "external-secrets"
}
5. Add ListSecrets Permission

Currently:

Action = [
  "secretsmanager:GetSecretValue",
  "secretsmanager:DescribeSecret"
]

Usually works, but I prefer:

Action = [
  "secretsmanager:GetSecretValue",
  "secretsmanager:DescribeSecret",
  "secretsmanager:ListSecrets"
]

Makes troubleshooting easier.

6. Better Security (Optional)

Right now:

Resource = "*"

works.

For learning purposes it's fine.

Later we can tighten to:

Resource = [
  "arn:aws:secretsmanager:us-east-1:136863648867:secret:springboot/*"
]
Final Expected Files
variables.tf
variable "cluster_name" {}
variable "oidc_provider_arn" {}
variable "oidc_provider_url" {}

variable "project_name" {}
variable "environment" {}

variable "namespace" {
  default = "external-secrets"
}

variable "service_account_name" { 
  default = "external-secrets"
}
outputs.tf
output "external_secrets_role_arn" {
  value = aws_iam_role.external_secrets.arn
}
Next Check

Show me where you're instantiating modules in your environment.

I need:

cat infrastructure/environments/dev/main.tf

or at least the section containing:

module "eks"
module "external_dns_irsa"
module "platform"

Then I'll give you the exact module "external_secrets_irsa" block to add.

last time when we were doing for external-dns-irsa, we had issues deploying in external-dns-irsa so we used kube-system, again think where this resource has to be created, this my infrastructure/environments/dev/main.tf, give me the complete updated file data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "vpc" {
  source = "../../modules/vpc"

  environment              = local.common.environment
  project_name             = local.common.project_name
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
}

# Security Groups

module "security_groups" {

  source = "../../modules/security_groups"

  project_name = local.common.project_name
  environment  = local.common.environment

  vpc_id = module.vpc.vpc_id
}

## EKS Cluster

module "eks" {

  source = "../../modules/eks"

  project_name = local.common.project_name
  environment  = local.common.environment

  private_app_subnet_ids = module.vpc.private_app_subnet_ids

  eks_node_sg_id    = module.security_groups.eks_node_sg_id
  eks_cluster_sg_id = module.security_groups.eks_cluster_sg_id
}

module "platform" {

  source = "../../modules/platform"

  project_name = local.common.project_name
  environment  = local.common.environment

  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_issuer_url   = module.eks.oidc_issuer_url

  cluster_name = module.eks.cluster_name

  vpc_id = module.vpc.vpc_id

  aws_region = "us-east-1"
}

module "argocd" {

  source = "../../modules/argocd"

  cluster_name = module.eks.cluster_name

  cluster_endpoint = module.eks.cluster_endpoint

  cluster_ca_certificate = module.eks.cluster_certificate_authority_data

  aws_region = "us-east-1"

  root_app_path = "${path.root}/../../../gitops/bootstrap/root-app.yaml"

  depends_on = [
    module.eks
  ]
}

module "ecr" {

  source = "../../modules/ecr"

}

# External DNS IRSA
#
data "aws_route53_zone" "main" {
  name         = "learnsystems.co"
  private_zone = false
}
module "external_dns_irsa" {

  source = "../../modules/external-dns-irsa"

  cluster_name = module.eks.cluster_name

  oidc_provider_arn = module.eks.oidc_provider_arn

  oidc_provider_url = module.eks.oidc_provider_url

  hosted_zone_id = data.aws_route53_zone.main.zone_id

  project_name = var.project_name

  environment = var.environment
}

Good catch. We should not blindly change the namespace because we learned something during ExternalDNS deployment.

Let's reason from the actual architecture.

For IRSA, the trust policy must match where the ServiceAccount actually exists.

For ExternalDNS we ended up with:

namespace: kube-system
name: external-dns

and the IAM role trust policy became:

system:serviceaccount:kube-system:external-dns

because that's where the ServiceAccount was deployed.

For External Secrets Operator, we need to decide before Terraform:

Will the ServiceAccount be:

namespace: kube-system
name: external-secrets

OR

namespace: external-secrets
name: external-secrets

My recommendation:

Run ESO in its own namespace:

namespace: external-secrets

because:

cleaner separation
easier RBAC
easier troubleshooting
aligns with Helm defaults
production standard

But if you decide to deploy the ServiceAccount in kube-system, then the IAM trust policy must use kube-system.

The namespace in Terraform must match the ServiceAccount namespace exactly.

Your module invocation

Add this immediately after module "external_dns_irsa":

module "external_secrets_irsa" {

  source = "../../modules/external-secrets-irsa"

  cluster_name = module.eks.cluster_name

  oidc_provider_arn = module.eks.oidc_provider_arn

  oidc_provider_url = module.eks.oidc_provider_url

  project_name = var.project_name

  environment = var.environment

  namespace = "external-secrets"

  service_account_name = "external-secrets"
}
I would not modify anything else in main.tf

Your existing file is already clean.

Just append:

module "external_secrets_irsa" {
...
}

below:

module "external_dns_irsa"
Before Terraform Apply

Let's validate the module itself.

Show me:

cat infrastructure/modules/external-secrets-irsa/main.tf
cat infrastructure/modules/external-secrets-irsa/variables.tf
cat infrastructure/modules/external-secrets-irsa/outputs.tf

I want to verify:

No remaining external_dns references.
No unused hosted_zone_id.
Output names are correct.
Trust relationship is parameterized correctly.

After that we'll run:

terraform fmt -recursive
terraform validate
terraform plan

and create the IAM role.

Are we creating these secrets using terraform? then why did we create them manually earlier? Run:

aws secretsmanager create-secret \
  --name springboot/dev/app-config \
  --secret-string '{
    "username":"admin",
    "password":"SuperSecret123",
    "apiKey":"abc123xyz"
  }'

If the secret already exists, run:

aws secretsmanager describe-secret \
  --secret-id springboot/dev/app-config

Excellent question. From a platform engineering perspective, we need to distinguish between secret metadata/integration infrastructure and secret values.

What we created manually

This command:

aws secretsmanager create-secret \
  --name springboot/dev/app-config \
  --secret-string '{
    "username":"admin",
    "password":"SuperSecret123",
    "apiKey":"abc123xyz"
  }'

created the actual secret value.

Secrets Manager
└── springboot/dev/app-config
      ├── username
      ├── password
      └── apiKey

We created it manually because we needed something for External Secrets Operator to read.

Could Terraform create it?

Yes.

Example:

resource "aws_secretsmanager_secret" "springboot" {
  name = "springboot/dev/app-config"
}

resource "aws_secretsmanager_secret_version" "springboot" {
  secret_id = aws_secretsmanager_secret.springboot.id

  secret_string = jsonencode({
    username = "admin"
    password = "SuperSecret123"
    apiKey   = "abc123xyz"
  })
}

But there is a problem.

Why production teams usually DON'T store secret values in Terraform

If you do this:

secret_string = jsonencode({
  password = "SuperSecret123"
})

the value ends up in:

terraform code
terraform state
terraform plan output
terraform logs

which is exactly what we're trying to avoid.

Even with encrypted state, most organizations prohibit storing real credentials in Terraform.

Common Production Pattern

Terraform creates the secret container:

resource "aws_secretsmanager_secret" "springboot" {
  name = "springboot/dev/app-config"
}

Then the secret value is populated by:

Security team
CI/CD pipeline
Vault integration
Manual onboarding process

For example:

aws secretsmanager put-secret-value \
  --secret-id springboot/dev/app-config \
  --secret-string '{...}'
What I would do in your platform

For learning:

Terraform manages
EKS
VPC
ALB
Route53
IRSA
Secrets Manager Secret
Secret values managed separately
username
password
apiKey

That gives you the same pattern used in most enterprises.

For your project right now

Since you've already created:

springboot/dev/app-config

manually and it exists:

ARN:
arn:aws:secretsmanager:us-east-1:136863648867:secret:springboot/dev/app-config-...

Do not create it again with Terraform.

We'll use the existing secret and focus on:

External Secrets IRSA
External Secrets Operator
SecretStore
ExternalSecret
Injecting secrets into SpringBoot

Once that works, we can later refactor and decide whether Terraform should manage the secret metadata resource itself.

Exactly. The evidence is right there:

application.argoproj.io/external-secrets-prereqs created
application.argoproj.io/external-secrets created

and later:

Resources:
  Name: external-secrets
  Status: Synced

  Name: external-secrets-prereqs
  Status: Synced

So my previous assumption was wrong.

Your App-of-Apps architecture is working correctly and ArgoCD did create both Application CRs.

The real issue is different:

You previously ran:

kubectl get applications -n argocd

and didn't see them.

But now platform-app clearly shows they exist.

So let's verify directly:

kubectl get application external-secrets -n argocd

kubectl get application external-secrets-prereqs -n argocd

If those exist, inspect them:

kubectl describe application external-secrets -n argocd

kubectl describe application external-secrets-prereqs -n argocd

I expect one of two things:

Possibility 1

Application exists but is unhealthy.

Example:

STATUS: Unknown
STATUS: Missing
STATUS: Degraded
Possibility 2

Application exists and synced but Helm chart failed.

Check:

kubectl get events -n argocd --sort-by=.metadata.creationTimestamp

and

kubectl logs \
-n argocd \
deploy/argocd-application-controller \
--tail=200 | grep external-secrets

The important lesson from this debugging session:

Your platform layer is Directory source type, not Kustomize.

We now know ArgoCD behavior in your repo is:

root-app
  └─ platform-app
        sourceType: Directory
        path: gitops/applications/platform

Directory contains Application CRs
        ↓
ArgoCD creates child Applications
        ↓
Child Applications deploy Helm charts / manifests

That's the model we should use going forward.

Next command I want to see is:

kubectl get application external-secrets -n argocd -o yaml

because platform-app already proved the child Application exists. Now we need to find out why the operator namespace and pods never appeared.

Pasted text(10).txt
Document

Good. We finally have enough evidence to stop guessing.

Your platform-app successfully created BOTH ArgoCD Applications:

application.argoproj.io/external-secrets-prereqs created
application.argoproj.io/external-secrets created

So App-of-Apps is working correctly.

The next thing to check is whether those child Applications are healthy.

Run:

kubectl get application external-secrets-prereqs \
-n argocd

kubectl get application external-secrets \
-n argocd

Then:

kubectl describe application external-secrets-prereqs \
-n argocd

and

kubectl describe application external-secrets \
-n argocd

I want to see:

Health Status
Sync Status
Events
Operation State

because we're now beyond the root app.

Also check whether Argo actually created the namespace:

kubectl get ns external-secrets

If namespace doesn't exist:

kubectl describe application external-secrets -n argocd

will usually show the exact Helm/chart error.

One thing jumps out immediately from your repo structure.

You have:

gitops/manifests/external-secrets
├── kustomization.yaml
└── serviceaccount.yaml

but we have not yet verified the ServiceAccount annotation.

Show:

cat gitops/manifests/external-secrets/serviceaccount.yaml

I want to confirm it contains the IRSA role:

annotations:
  eks.amazonaws.com/role-arn: arn:aws:iam::136863648867:role/kk-platform-dev-external-secrets

because Terraform created:

kk-platform-dev-external-secrets

and if the ARN in the manifest is wrong, the prereqs app may sync but the operator won't be able to assume the role.

After that run:

kubectl get application external-secrets-prereqs \
-n argocd -o yaml | grep health -A5

kubectl get application external-secrets \
-n argocd -o yaml | grep health -A5

Those outputs will tell us exactly where the deployment stopped.

We're very close now—the root app and platform app are already doing their job. The issue is inside one of the two newly-created child applications.

They are healthy and good, lets proceed further kubectl get ns external-secrets
NAME               STATUS   AGE
external-secrets   Active   16m
kchilak@kalandars-MBP aws-platform-engineering % kubectl get application external-secrets-prereqs \
-n argocd -o yaml | grep health -A5

kubectl get application external-secrets \
-n argocd -o yaml | grep health -A5
  health:
    lastTransitionTime: "2026-07-30T11:05:05Z"
    status: Healthy
  history:
  - deployStartedAt: "2026-07-30T11:05:05Z"
    deployedAt: "2026-07-30T11:05:05Z"
  health:
    lastTransitionTime: "2026-07-30T11:05:53Z"
    status: Healthy
  history:
  - deployStartedAt: "2026-07-30T11:05:06Z"
    deployedAt: "2026-07-30T11:05:52Z"

Perfect. External Secrets Operator is deployed and healthy.

We can stop validating ArgoCD and start consuming AWS Secrets Manager.

Next objective:

AWS Secrets Manager
        ↓
External Secrets Operator
        ↓
Kubernetes Secret
        ↓
SpringBoot Pod
Step 1: Verify External Secrets pods
kubectl get pods -n external-secrets

Expected:

external-secrets-xxxxx       Running
external-secrets-cert-xxxxx  Running
external-secrets-webhook     Running
Step 2: Verify IRSA annotation
kubectl get sa external-secrets \
-n external-secrets \
-o yaml

You should see:

annotations:
  eks.amazonaws.com/role-arn: arn:aws:iam::136863648867:role/kk-platform-dev-external-secrets

If present, IRSA is wired correctly.

Step 3: Create SecretStore

Create:

mkdir -p gitops/manifests/external-secrets

Create:

gitops/manifests/external-secrets/secretstore.yaml

apiVersion: external-secrets.io/v1
kind: SecretStore

metadata:
  name: aws-secretsmanager
  namespace: springboot

spec:
  provider:

    aws:
      service: SecretsManager
      region: us-east-1

      auth:
        jwt:
          serviceAccountRef:
            name: external-secrets
            namespace: external-secrets
Step 4: Create ExternalSecret

Create:

gitops/manifests/external-secrets/app-config.yaml

apiVersion: external-secrets.io/v1

kind: ExternalSecret

metadata:
  name: app-config
  namespace: springboot

spec:

  refreshInterval: 1m

  secretStoreRef:
    name: aws-secretsmanager
    kind: SecretStore

  target:
    name: app-config

  data:

    - secretKey: username
      remoteRef:
        key: springboot/dev/app-config
        property: username

    - secretKey: password
      remoteRef:
        key: springboot/dev/app-config
        property: password

    - secretKey: apiKey
      remoteRef:
        key: springboot/dev/app-config
        property: apiKey
Step 5: Update kustomization

Show me your current:

cat gitops/manifests/external-secrets/kustomization.yaml

We need to add:

resources:
  - serviceaccount.yaml
  - secretstore.yaml
  - app-config.yaml
Step 6: Commit
git add .
git commit -m "add external secret resources"
git push

ArgoCD should reconcile automatically.

Step 7: Verify Secret Creation

Wait about 30 seconds.

Then:

kubectl get externalsecret -n springboot

kubectl get secret -n springboot

Expected:

app-config

Then:

kubectl describe externalsecret app-config \
-n springboot

Status should be:

Ready=True

After that, we'll modify the SpringBoot Deployment so the application receives:

USERNAME
PASSWORD
API_KEY

directly from AWS Secrets Manager without hardcoding anything in Kubernetes manifests.

That is the first production-grade secret-management pattern you'll use across EKS workloads.
Pasted text(11).txt
Document
Pasted text(12).txt
Document
I have removed externalsecret.yaml from kustomize.yaml stop complaining about 


Perfect. Now we have the actual root cause.

The error is crystal clear:

invalid Auth.JWT.ServiceAccountRef: namespace should either be empty
or match the namespace of the SecretStore for a namespaced SecretStore

Your current SecretStore:

apiVersion: external-secrets.io/v1
kind: SecretStore

metadata:
  name: aws-secretsmanager
  namespace: springboot

spec:
  provider:
    aws:
      service: SecretsManager
      region: us-east-1

      auth:
        jwt:
          serviceAccountRef:
            name: external-secrets
            namespace: external-secrets

The webhook is rejecting it because:

SecretStore namespace = springboot
ServiceAccount namespace = external-secrets

A SecretStore is namespaced and can only reference a ServiceAccount in the same namespace.

You have two options.

Option 1 (Recommended)

Use a ClusterSecretStore.

This is what most production EKS platforms do.

Then one AWS Secrets Manager integration can be reused by:

springboot
nginx
payments
orders
monitoring

without creating a SecretStore in every namespace.

Option 2

Keep SecretStore and create another ServiceAccount in springboot namespace.

Not ideal because you'd duplicate IRSA objects.

For a platform-engineering repo, I'd move to ClusterSecretStore now.

Create:

apiVersion: external-secrets.io/v1
kind: ClusterSecretStore

metadata:
  name: aws-secretsmanager

spec:
  provider:

    aws:
      service: SecretsManager
      region: us-east-1

      auth:
        jwt:
          serviceAccountRef:
            name: external-secrets
            namespace: external-secrets

Notice:

kind: ClusterSecretStore

instead of:

kind: SecretStore

Then update app-config.yaml:

secretStoreRef:
  name: aws-secretsmanager
  kind: ClusterSecretStore

instead of:

secretStoreRef:
  name: aws-secretsmanager
  kind: SecretStore

This fits your architecture much better:

AWS Secrets Manager
        │
        ▼
ClusterSecretStore
        │
        ▼
External Secrets Operator
        │
 ┌──────┼──────┐
 ▼      ▼      ▼
springboot nginx monitoring

which is how a shared platform team would build it.

So update:

gitops/manifests/external-secrets/secretstore.yaml

from:

kind: SecretStore

to:

kind: ClusterSecretStore

and update:

gitops/manifests/external-secrets/app-config.yaml

from:

kind: SecretStore

to:

kind: ClusterSecretStore

Commit, push, wait for ArgoCD sync, then check:

kubectl get clustersecretstore

Expected:

aws-secretsmanager   Valid

After that we'll verify IRSA is working and the Kubernetes Secret gets created.

kubectl get clustersecretstore
NAME                 AGE     STATUS   CAPABILITIES   READY
aws-secretsmanager   9m10s   Valid    ReadWrite      True

Excellent. That means:

✅ External Secrets Operator installed

✅ IRSA working enough for validation

✅ ClusterSecretStore created

✅ ClusterSecretStore validated by ESO

✅ ArgoCD successfully applied the resource

We've moved past the SecretStore problem.

Now check whether ESO has synced the secret:

kubectl get externalsecret -n springboot

Then:

kubectl describe externalsecret app-config -n springboot

Pay attention to:

Status:
Conditions:
Ready:
Message:

If Ready=True, verify the Kubernetes Secret:

kubectl get secret app-config -n springboot

Then:

kubectl get secret app-config \
-n springboot \
-o jsonpath='{.data.username}' | base64 -d

echo

and

kubectl get secret app-config \
-n springboot \
-o jsonpath='{.data.password}' | base64 -d

echo

Expected:

admin
SuperSecret123

If the ExternalSecret still shows an error, paste:

kubectl describe externalsecret app-config -n springboot

and we'll troubleshoot the IRSA/AWS permissions layer next. This is the stage where ESO actually attempts:

Pod
  ↓
IRSA
  ↓
STS AssumeRoleWithWebIdentity
  ↓
Secrets Manager
  ↓
Kubernetes Secret

and we'll verify each hop.

kubectl get clustersecretstore
NAME                 AGE     STATUS   CAPABILITIES   READY
aws-secretsmanager   9m10s   Valid    ReadWrite      True
kchilak@kalandars-MBP aws-platform-engineering % kubectl get externalsecret -n springboot
NAME         STORETYPE            STORE                REFRESH INTERVAL   STATUS         READY
app-config   ClusterSecretStore   aws-secretsmanager   1m                 SecretSynced   True
kchilak@kalandars-MBP aws-platform-engineering % kubectl get secret app-config -n springboot
NAME         TYPE     DATA   AGE
app-config   Opaque   3      7m21s
kchilak@kalandars-MBP aws-platform-engineering % kubectl get secret app-config \
-n springboot \
-o jsonpath='{.data.username}' | base64 -d

echo
admin
kchilak@kalandars-MBP aws-platform-engineering % kubectl get secret app-config \
-n springboot \
-o jsonpath='{.data.password}' | base64 -d

echo
SuperSecret123

Perfect. We've completed the full External Secrets flow.

You now have:

AWS Secrets Manager
        ↓
ClusterSecretStore
        ↓
External Secrets Operator
        ↓
ExternalSecret
        ↓
Kubernetes Secret
        ↓
SpringBoot Namespace

Verification:

ClusterSecretStore     READY=True
ExternalSecret         READY=True
Kubernetes Secret      Created
username               admin
password               SuperSecret123

This is a major platform capability. Most EKS environments stop at GitOps + ArgoCD. You've now added:

IRSA
AWS Secrets Manager
External Secrets Operator
ArgoCD-managed secret synchronization

which is exactly how production EKS platforms typically handle application secrets.

Next thing to build

I would not jump to observability yet.

The highest-value next step is:

SpringBoot Application
       ↓
Consumes Kubernetes Secret
       ↓
Environment Variables
       ↓
Application uses secret

Right now the secret exists in Kubernetes, but your application isn't using it.

A platform engineer's job isn't just getting the secret into the cluster—the workload must consume it.

Update your SpringBoot deployment.

Current deployment likely has:

containers:
  - name: springboot

Add:

env:
  - name: APP_USERNAME
    valueFrom:
      secretKeyRef:
        name: app-config
        key: username

  - name: APP_PASSWORD
    valueFrom:
      secretKeyRef:
        name: app-config
        key: password

  - name: APP_API_KEY
    valueFrom:
      secretKeyRef:
        name: app-config
        key: apiKey

in:

gitops/manifests/springboot/deployment.yaml

Then update your controller:

@Value("${APP_USERNAME:unknown}")
private String username;

@GetMapping("/config")
public Map<String, String> config() {

    return Map.of(
        "username", username,
        "service", "platform-demo"
    );
}

or use System.getenv() if you prefer.

What you'll learn next:

AWS Secrets Manager
        ↓
External Secrets
        ↓
Kubernetes Secret
        ↓
Pod Environment Variable
        ↓
SpringBoot Runtime

This completes the entire secret management lifecycle.

After that, I would move directly into observability:

Prometheus
Grafana
Loki
Alertmanager
Ingress
ArgoCD-managed deployment
SpringBoot metrics

because once secrets are working end-to-end, observability gives the biggest increase in platform maturity.

validate these files package com.kk.platform;

import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PlatformController {

    @GetMapping("/")
    public Map<String, String> home() {

        return Map.of(
                "service", "platform-demo",
                "environment", "dev",
                "status", "healthy");
    }

    @GetMapping("/health")
    public Map<String, String> health() {

        return Map.of(
                "service", "platform-demo",
                "environment", "dev",
                "status", "healthy");
    }

    @GetMapping("/version")
    public Map<String, String> version() {

        return Map.of(
                "version", "v3",
                "service", "platform-demo");
    }

    @Value("${APP_USERNAME:unknown}")
    private String username;

    @GetMapping("/config")
    public Map<String, String> config() {

    return Map.of(
        "username", username,
        "service", "platform-demo"
    );
}
gitops/manifests/springboot/deployment.yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  name: springboot

spec:
  replicas: 2

  selector:
    matchLabels:
      app: springboot

  template:
    metadata:
      labels:
        app: springboot

    spec:
      containers:
        - name: springboot

          image: 136863648867.dkr.ecr.us-east-1.amazonaws.com/platform-demo:d8e7d0bae551e2d848a4c3d53c34c27a7090d0b4
          #image: 136863648867.dkr.ecr.us-east-1.amazonaws.com/platform-demo:d8e7d0bae551e2d848a4c3d53c34c27a7090d0b4

          ports:
            - containerPort: 8080

          resources:
            requests:
              cpu: "100m"
              memory: "128Mi"

            limits:
              cpu: "500m"
              memory: "512Mi"
              env:
                - name: APP_USERNAME
                  valueFrom:
                    secretKeyRef:
                      name: app-config
                      key: username

                - name: APP_PASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: app-config
                      key: password

                - name: APP_API_KEY
                  valueFrom:
                    secretKeyRef:
                      name: app-config
                      key: apiKey

There are a couple of issues in both files.

1. PlatformController.java

You're missing the @Value import and the class closing brace.

Correct version
package com.kk.platform;

import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PlatformController {

    @Value("${APP_USERNAME:unknown}")
    private String username;

    @GetMapping("/")
    public Map<String, String> home() {

        return Map.of(
                "service", "platform-demo",
                "environment", "dev",
                "status", "healthy");
    }

    @GetMapping("/health")
    public Map<String, String> health() {

        return Map.of(
                "service", "platform-demo",
                "environment", "dev",
                "status", "healthy");
    }

    @GetMapping("/version")
    public Map<String, String> version() {

        return Map.of(
                "version", "v3",
                "service", "platform-demo");
    }

    @GetMapping("/config")
    public Map<String, String> config() {

        return Map.of(
                "username", username,
                "service", "platform-demo");
    }
}
Alternative (my preference)

Since these are environment variables and not Spring properties, use:

@GetMapping("/config")
public Map<String, String> config() {

    return Map.of(
            "username", System.getenv("APP_USERNAME"),
            "service", "platform-demo");
}

This avoids Spring property binding confusion and makes it obvious the value comes from the pod environment.

2. deployment.yaml

Your YAML indentation is wrong.

Currently you have:

resources:
  requests:
    ...
  limits:
    ...
    env:
      ...

which means Kubernetes interprets env as part of limits, which is invalid.

Correct placement
containers:
  - name: springboot

    image: 136863648867.dkr.ecr.us-east-1.amazonaws.com/platform-demo:d8e7d0bae551e2d848a4c3d53c34c27a7090d0b4

    ports:
      - containerPort: 8080

    env:
      - name: APP_USERNAME
        valueFrom:
          secretKeyRef:
            name: app-config
            key: username

      - name: APP_PASSWORD
        valueFrom:
          secretKeyRef:
            name: app-config
            key: password

      - name: APP_API_KEY
        valueFrom:
          secretKeyRef:
            name: app-config
            key: apiKey

    resources:
      requests:
        cpu: "100m"
        memory: "128Mi"

      limits:
        cpu: "500m"
        memory: "512Mi"
Before committing

Validate locally:

mvn clean package

Then:

kubectl apply --dry-run=client \
-f gitops/manifests/springboot/deployment.yaml

Commit and push.

After ArgoCD syncs:

kubectl rollout status deployment/springboot -n springboot

Verify the env vars reached the pod:

kubectl exec -it \
$(kubectl get pod -n springboot -o jsonpath='{.items[0].metadata.name}') \
-n springboot -- env | grep APP_

Expected:

APP_USERNAME=admin
APP_PASSWORD=SuperSecret123
APP_API_KEY=abc123xyz

Then test:

curl -k https://springboot.dev.learnsystems.co/config

Expected:

{
  "username":"admin",
  "service":"platform-demo"
}

That will prove the complete chain:

AWS Secrets Manager
        ↓
External Secrets Operator
        ↓
Kubernetes Secret
        ↓
Pod Environment Variables
        ↓
SpringBoot Application
        ↓
Public Endpoint

kubectl exec -it \
$(kubectl get pod -n springboot -o jsonpath='{.items[0].metadata.name}') \
-n springboot -- env | grep APP_
APP_USERNAME=admin
APP_PASSWORD=SuperSecret123
APP_API_KEY=abc123xyz
kchilak@kalandars-MBP aws-platform-engineering % curl -k https://springboot.dev.learnsystems.co/config
{"service":"platform-demo","username":"admin"}%   

Excellent. This is now fully working.

You've successfully proven:

AWS Secrets Manager
        ↓
IRSA
        ↓
External Secrets Operator
        ↓
ClusterSecretStore
        ↓
ExternalSecret
        ↓
Kubernetes Secret
        ↓
Pod Environment Variables
        ↓
SpringBoot Application
        ↓
ALB
        ↓
Internet

And you've validated every layer:

kubectl get clustersecretstore

✅ Valid

kubectl get externalsecret -n springboot

✅ SecretSynced

kubectl get secret app-config -n springboot

✅ Secret created

kubectl exec ... env | grep APP_

✅ Environment variables injected

curl https://springboot.dev.learnsystems.co/config

✅ Application consuming secret

Response:

{
  "service":"platform-demo",
  "username":"admin"
}

Now let's move immediately to the next platform capability:

Observability Stack

We already have:

GitOps
ArgoCD
EKS
ALB Controller
External DNS
External Secrets
IRSA
SpringBoot App

The next thing every platform team adds is:

Prometheus
Grafana
Loki
Alertmanager

Architecture:

SpringBoot
     │
     ▼
Actuator Metrics
     │
     ▼
Prometheus
     │
     ├── Alerts
     │
     ▼
Grafana Dashboards

Pods Logs
     │
     ▼
Promtail
     │
     ▼
Loki
     │
     ▼
Grafana

We'll build it GitOps-first exactly like the rest of your platform:

gitops/applications/platform/
    monitoring.yaml

gitops/values/monitoring/
    dev.yaml

using the:

kube-prometheus-stack

Helm chart.

This gives you:

Prometheus
Grafana
Alertmanager
Node Exporter
kube-state-metrics

in one deployment.

Before we write manifests, show me:

tree gitops/values

I want to see your current values directory structure so we place the monitoring values file consistently with the way you've already organized ALB Controller and External DNS.
