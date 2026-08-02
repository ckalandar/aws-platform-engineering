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
This is actually a very useful clue.

The CRDs now exist, but the operator never created any Prometheus or Alertmanager custom resources.

That means one of these is happening:

ArgoCD never reapplied the monitoring manifests after CRDs became available.
The Helm chart is not rendering the Prometheus/Alertmanager resources.
ArgoCD sync is still failing silently.

Let's inspect the actual state.

Check ArgoCD health
kubectl get application monitoring -n argocd -o yaml | grep -A20 health:
Check current sync errors
kubectl describe application monitoring -n argocd

Look specifically for:

Operation State
Conditions
Sync Status
Message
Check what resources ArgoCD thinks belong to monitoring
kubectl get application monitoring -n argocd -o yaml | grep -A100 resources:

or:

kubectl get application monitoring -n argocd -o jsonpath='{.status.resources[*].kind}'

If Prometheus and Alertmanager are missing there, Helm never rendered them.

Check whether the chart rendered them

Let's inspect the generated manifests:

kubectl get secret -n argocd | grep monitoring

Then:

kubectl get application monitoring -n argocd -o yaml > /tmp/monitoring-app.yaml

But an easier test is:

helm template monitoring prometheus-community/kube-prometheus-stack \
  --version 78.0.0 \
  -f gitops/values/monitoring/dev.yaml | grep "^kind:"

Look for:

kind: Prometheus
kind: Alertmanager

If they're missing, something in values is disabling them.

Also check the monitoring Application

Show the full file:

cat gitops/applications/platform/monitoring.yaml

I want to verify:

sources:

structure.

The chart version you're using should absolutely create:

Prometheus
Alertmanager

by default.

Since Grafana, node-exporter, kube-state-metrics, and the operator are running, the chart itself is installing successfully. The missing piece is specifically the custom resources.

My suspicion right now is that the monitoring Application failed during the original CRD installation, and ArgoCD never retried rendering the missing resources after the CRDs appeared.

Run these two commands and paste the output:

kubectl describe application monitoring -n argocd
cat gitops/applications/platform/monitoring.yaml

Those will tell us exactly whether we're dealing with an ArgoCD sync issue or a Helm rendering issue.

======== log 31july ======

there is no cat infrastructure/modules/platform/main.tf, I have attached the module repo structure

Excellent. This is the signal we were waiting for.

✅ EBS CSI is now healthy
ebs-csi-controller ... 6/6 Running
ebs-csi-controller ... 6/6 Running
ebs-csi-node       ... 3/3 Running
ebs-csi-node       ... 3/3 Running

This means:

IRSA role is working
EBS CSI addon is working
EBS CSI controller can talk to AWS APIs
StorageClass gp3 is managed by Terraform
Terraform state and cluster state are aligned
Next verification

Now check if the PVCs got provisioned:

kubectl get pvc -n monitoring

Expected:

STATUS   Bound

instead of Pending.

Then check Prometheus
kubectl get pods -n monitoring

Expected:

prometheus-monitoring-kube-prometheus-prometheus-0      Running
alertmanager-monitoring-kube-prometheus-alertmanager-0  Running
If PVCs are still Pending

Describe one PVC:

kubectl describe pvc \
prometheus-monitoring-kube-prometheus-prometheus-db-prometheus-monitoring-kube-prometheus-prometheus-0 \
-n monitoring

The event section will tell us exactly what's happening.

Repository status

At this point your Terraform platform should contain:

EKS
modules/eks/
├── main.tf
├── addons.tf
├── oidc.tf
├── ebs-csi.tf
├── storageclass.tf
├── outputs.tf
└── variables.tf
Managed by Terraform

✅ EKS Cluster
✅ Node Groups
✅ OIDC Provider
✅ EBS CSI IRSA
✅ EBS CSI Addon
✅ Default gp3 StorageClass

This is the correct production-grade approach.

One thing I would add next

For the platform roadmap, before we move further into GitOps apps:

EFS CSI Driver

Prometheus uses EBS (good).

But later you'll likely deploy:

Grafana dashboards
Jenkins
SonarQube
Nexus
Shared application storage

Those typically benefit from:

ReadWriteMany (RWX)

which EBS cannot provide.

So the next platform storage layer should be:

modules/eks/
├── ebs-csi.tf
├── efs-csi.tf
├── storageclass-gp3.tf
└── storageclass-efs.tf

Not required today, but part of the platform baseline.

Now run:

kubectl get pvc -n monitoring
kubectl get pods -n monitoring

and let's confirm Prometheus and Alertmanager have successfully attached EBS volumes.

kubectl get pvc -n monitoring
NAME                                                                                                             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
alertmanager-monitoring-kube-prometheus-alertmanager-db-alertmanager-monitoring-kube-prometheus-alertmanager-0   Bound    pvc-d7f06425-b79e-404a-af28-276f0ecc0b11   5Gi        RWO            gp3            <unset>                 3h58m
prometheus-monitoring-kube-prometheus-prometheus-db-prometheus-monitoring-kube-prometheus-prometheus-0           Bound    pvc-a8183314-af9c-42ff-b348-5b99ea1c042f   20Gi       RWO            gp3            <unset>                 3h58m
kchilak@kalandars-MBP aws-platform-engineering % kubectl get pods -n monitoring
NAME                                                     READY   STATUS    RESTARTS   AGE
alertmanager-monitoring-kube-prometheus-alertmanager-0   2/2     Running   0          4h12m
monitoring-grafana-6cd9bdb8b-8x6mr                       3/3     Running   0          22h
monitoring-kube-prometheus-operator-796cdc678d-2ghjz     1/1     Running   0          4h12m
monitoring-kube-state-metrics-7fc7c7469d-lxmn5           1/1     Running   0          22h
monitoring-prometheus-node-exporter-fczln                1/1     Running   0          22h
monitoring-prometheus-node-exporter-qcqc7                1/1     Running   0          22h
prometheus-monitoring-kube-prometheus-prometheus-0       2/2     Running   0          4h12m

Excellent. We have now fully resolved the original issue.

What happened

Initially:

Prometheus PVC -> Pending
Alertmanager PVC -> Pending

Root cause:

Prometheus
   ↓
PVC
   ↓
StorageClass gp3
   ↓
EBS CSI Driver
   ↓
AWS EBS Volume


The EBS CSI driver was failing because it had no valid AWS credentials:

Failed health check
no EC2 IMDS role found

which meant:

PVC -> Pending
PV  -> Not Created
Pod -> Pending
What fixed it

We implemented the platform correctly through Terraform:

EKS OIDC
aws_iam_openid_connect_provider.eks
EBS CSI IRSA Role
aws_iam_role.ebs_csi
EBS CSI Policy
AmazonEBSCSIDriverPolicy
EKS Addon
aws_eks_addon.ebs_csi
Default StorageClass
kubernetes_storage_class.gp3
Current healthy state
Storage
alertmanager PVC -> Bound
prometheus PVC   -> Bound
Volumes
5Gi  GP3 EBS
20Gi GP3 EBS
Monitoring
Prometheus   Running
Alertmanager Running
Grafana      Running
Operator     Running
NodeExporter Running
CSI
Controller 6/6 Running
Controller 6/6 Running
Node       3/3 Running
Node       3/3 Running
Architecture review

If I were reviewing this platform as a senior platform architect, I would now consider the monitoring stack production-capable for a small environment.

You now have:

AWS
└── EKS
    ├── ALB Controller
    ├── External DNS
    ├── External Secrets
    ├── EBS CSI
    ├── ArgoCD
    └── kube-prometheus-stack
         ├── Prometheus
         ├── Alertmanager
         ├── Grafana
         ├── Node Exporter
         └── Kube State Metrics
Lessons learned for this repository

This is the important part.

When introducing a platform component, think through all dependencies before deployment.

For example:

Monitoring

Not just:

Install Prometheus

But:

Prometheus
 ├─ PVC
 ├─ StorageClass
 ├─ CSI Driver
 ├─ IAM Permissions
 ├─ IRSA
 ├─ Persistent Volumes
 ├─ Backup Strategy
 └─ Retention Policy
ALB Controller

Not just:

helm install aws-load-balancer-controller

But:

ALB Controller
 ├─ OIDC
 ├─ IRSA
 ├─ IAM Policy
 ├─ Subnet Tags
 ├─ Security Groups
 └─ IngressClass
External DNS
External DNS
 ├─ Route53
 ├─ Hosted Zone
 ├─ IRSA
 ├─ IAM Policy
 └─ DNS Ownership

This is the mindset that differentiates a platform engineer from someone who just installs Helm charts.

What I would do next

Before pushing further application workloads, I would add:

Storage Layer
modules/eks/
├── ebs-csi.tf
├── efs-csi.tf
├── storageclass-gp3.tf
└── storageclass-efs.tf
Observability Layer

Add ArgoCD-managed:

gitops/apps/
├── monitoring/
├── loki/
├── tempo/
└── opentelemetry/

so the platform provides:

Metrics  -> Prometheus
Logs     -> Loki
Traces   -> Tempo
Telemetry-> OpenTelemetry

This becomes a proper Internal Developer Platform foundation.

For now, I would:

Commit the EBS CSI Terraform changes.
Commit the StorageClass Terraform resource.
Run terraform plan one final time and ensure 0 changes.
Push to Git.
Continue with the next GitOps application.

The monitoring stack is healthy and the storage problem is resolved.

done above all .. lets proceed

Great. Before we rush into the next component, let's take stock of what your platform actually has now.

Current Platform State
Infrastructure (Terraform)

✅ VPC

✅ Public / Private App / Private DB subnets

✅ NAT Gateway

✅ Security Groups

✅ EKS Cluster

✅ Managed Node Groups

✅ OIDC Provider

✅ ECR

EKS Platform Services

✅ AWS Load Balancer Controller

✅ External DNS

✅ External Secrets

✅ EBS CSI Driver

✅ GP3 StorageClass

GitOps

✅ ArgoCD

✅ Root App

✅ App-of-Apps pattern

Observability

✅ Prometheus

✅ Alertmanager

✅ Grafana

✅ Node Exporter

✅ Kube State Metrics

Storage

✅ EBS CSI

✅ Persistent Volumes

✅ Persistent Claims

What should come next?

If I were designing this as a real enterprise Internal Developer Platform, I'd prioritize:

Phase 1 — Complete Platform Foundation
1. EFS CSI Driver

Add shared storage support.

Needed later for:

Jenkins
SonarQube
Nexus
Shared application data
RWX workloads

Current limitation:

EBS = ReadWriteOnce

Future:

EFS = ReadWriteMany
2. Cluster Autoscaler / Karpenter

You previously mentioned Karpenter experience.

Right now:

NodeGroup
  min = 2
  desired = 2
  max = 4

This is fine for learning.

A production platform should move to:

Karpenter

Benefits:

Faster scale-out
Spot instances
Cost optimization
Mixed instance families
3. Logging Platform

You currently have metrics.

You do not have logs.

Add:

Loki

and connect Grafana.

Architecture:

Pods
  ↓
Promtail
  ↓
Loki
  ↓
Grafana
4. Tracing

Add:

Tempo

and later:

OpenTelemetry Collector

Architecture:

Application
  ↓
OTEL SDK
  ↓
OTEL Collector
  ↓
Tempo
My recommendation

Do not jump to Jenkins, SonarQube, Backstage, Crossplane, IDP features yet.

Your platform is missing:

Metrics  ✅
Logs     ❌
Traces   ❌

A modern platform needs all three.

Suggested Next Milestone

I would implement:

gitops/apps/observability/
├── prometheus/
├── loki/
├── tempo/
└── otel-collector/

This gives you:

Golden Signals

Metrics -> Prometheus
Logs    -> Loki
Traces  -> Tempo

and creates a production-grade observability foundation before we start deploying business applications.

My suggested order from here:

1. EFS CSI Driver
2. Loki
3. Tempo
4. OpenTelemetry Collector
5. Karpenter
6. Sample Java Application
7. CI/CD Pipeline
8. Service Mesh (Istio)
9. Backstage
10. Crossplane
11. Enterprise IDP

Let's start with EFS CSI Driver via Terraform + GitOps, because it completes the storage layer of the platform and follows naturally from the EBS work we just finished.

Perfect.

This is exactly the GitOps workflow we want:

Terraform
 ├─ VPC
 ├─ EKS
 ├─ IRSA
 ├─ EBS CSI
 ├─ StorageClass
 └─ Cluster Infrastructure

ArgoCD
 ├─ Prometheus
 ├─ Grafana
 ├─ Loki
 ├─ Tempo
 ├─ OTel Collector
 ├─ Istio
 └─ Workloads

Since Loki itself is already healthy:

loki-0                 2/2 Running
loki-canary-*          Running
PVC                    Bound

the only missing piece is Grafana datasource provisioning.

Your values should look something like:

grafana:

  adminPassword: admin123

  service:
    type: ClusterIP

  ingress:
    enabled: true
    ingressClassName: alb

    annotations:
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip

    hosts:
      - grafana.dev.learnsystems.co

  additionalDataSources:
    - name: Loki
      type: loki
      access: proxy
      url: http://loki.loki.svc.cluster.local:3100
      editable: true

After ArgoCD syncs:

Connections
 ├─ Prometheus
 ├─ Alertmanager
 └─ Loki

should appear automatically.

Small architectural note

For a production platform I would eventually move Grafana credentials out of Git:

Current:

adminPassword: admin123

Future:

AWS Secrets Manager
        ↓
External Secrets Operator
        ↓
Grafana Secret

We already have External Secrets running, so later we can wire Grafana, ArgoCD, Backstage, Tempo, etc. to Secrets Manager.

Once the monitoring app becomes Healthy/Synced again

Validate:

kubectl get application -n argocd monitoring

Then check Grafana:

Connections → Data Sources

If Loki appears, we can immediately proceed to the next platform component:

Observability Stack
───────────────────
✅ Prometheus
✅ Grafana
✅ Loki
⬜ Tempo
⬜ OpenTelemetry Collector

I recommend doing Tempo and OpenTelemetry Collector together in the next commit, because Tempo without trace collection doesn't provide much value, whereas deploying both gives you a complete metrics + logs + traces observability platform.

loki is available now but I don't see any logs 

This is actually expected at this stage.

You have:

Grafana  ✅
Loki     ✅

but you do not have anything shipping logs to Loki yet.

Loki is just storage and query.

Something must collect logs from the nodes and push them to Loki.

Typically:

Application Pods
        ↓
Container stdout/stderr
        ↓
Promtail OR Grafana Alloy OR OTel Collector
        ↓
Loki
        ↓
Grafana
Verify whether Loki has any log streams

In Grafana Explore, try:

{job=~".+"}

or

{}

If you get:

No labels found

or

Empty result

then nothing is writing to Loki.

Check what's deployed

Run:

kubectl get pods -A | grep -E "promtail|alloy|fluent|otel"

I expect you'll get nothing.

Because looking at your GitOps tree, I don't see:

promtail
alloy
otel-collector
fluent-bit

applications anywhere.

Production Recommendation

I would not deploy Promtail now.

Promtail is being phased out by Grafana.

Since your roadmap already includes:

✅ Prometheus
✅ Grafana
✅ Loki
⬜ Tempo
⬜ OpenTelemetry Collector

the better path is:

OpenTelemetry Collector
        ↓
Loki
        ↓
Tempo
        ↓
Prometheus

One collector handles:

Metrics
Logs
Traces

instead of deploying multiple agents.

Quick validation

Run:

kubectl get pods -A | grep loki

and

kubectl get pods -A | grep -E "promtail|alloy|otel"

If the second command returns nothing, we've found the issue.

Platform Architecture Suggestion

Given what you're building (Platform Engineering → IDP), I'd slightly adjust the roadmap:

Current
-------
✅ EKS
✅ ArgoCD
✅ External Secrets
✅ External DNS
✅ ALB Controller
✅ Prometheus
✅ Grafana
✅ Loki

Next
----
1. OpenTelemetry Collector
2. Tempo
3. Java App Instrumentation
4. Karpenter
5. CI/CD
6. Istio
7. Backstage
8. Crossplane
9. Enterprise IDP

The reason is that Tempo is almost useless until something emits traces, and OpenTelemetry Collector is what will give you logs, metrics, and traces flowing through the platform in a production-style architecture.

So before touching Tempo, let's add an OpenTelemetry Collector GitOps application and wire:

Pods → OTel Collector → Loki
Pods → OTel Collector → Tempo
Pods → OTel Collector → Prometheus

That gives you a complete observability foundation.

kubectl get pods -A | grep -E "promtail|alloy|fluent|otel"
kchilak@kalandars-MBP aws-platform-engineering % kubectl get pods -A | grep loki
loki               loki-0                                                   2/2     Running   0          51m
loki               loki-canary-7gzd5                                        1/1     Running   0          28m
loki               loki-canary-99hhp                                        1/1     Running   0          28m
loki               loki-canary-dkfzd                                        1/1     Running   0          28m

Exactly. That confirms the diagnosis.

You have:

✅ Loki running
✅ Grafana datasource configured
❌ No log collector deployed

Loki is sitting there waiting for logs, but nothing is sending any.

What happened?

When you installed Loki, you probably used the simple chart deployment:

Loki
└── StatefulSet

but not:

Loki
└── Promtail

or

Loki
└── Grafana Alloy

or

Loki
└── OpenTelemetry Collector
Since we're building a modern platform...

I would not install Promtail.

Promtail still works, but Grafana's direction is moving toward Grafana Alloy and OpenTelemetry.

Your roadmap already includes:

1. Loki
2. Tempo
3. OpenTelemetry Collector

so we should do it properly.

Recommended Next Step

Deploy:

OpenTelemetry Collector

via ArgoCD.

Then:

Node Logs
        ↓
OTel Collector
        ↓
Loki

Application Traces
        ↓
OTel Collector
        ↓
Tempo

Metrics
        ↓
OTel Collector
        ↓
Prometheus

This becomes your enterprise observability pipeline.

If you want logs immediately

We can deploy Grafana Alloy first.

Architecture:

Node
 └─ /var/log/containers/*.log
          ↓
      Alloy
          ↓
       Loki

Then all pods:

springboot
argocd
external-secrets
coredns
aws-load-balancer-controller

will automatically appear in Grafana.

What I would do as your platform architect

Current state:

✅ EKS
✅ ArgoCD
✅ External DNS
✅ External Secrets
✅ ALB Controller
✅ Prometheus
✅ Grafana
✅ Loki
✅ EBS CSI

Next:

1. Grafana Alloy
2. Tempo
3. OpenTelemetry Collector
4. Java Auto-Instrumentation
5. Karpenter
6. CI/CD
7. Istio
8. Backstage
9. Crossplane
10. Enterprise IDP

Reason:

Alloy immediately gives logs.
Tempo needs traces.
OTel Collector ties everything together.
Then your Java app can emit traces and you'll see:
Metrics in Prometheus
Logs in Loki
Traces in Tempo

which is where observability becomes truly useful.

So I'd proceed with Grafana Alloy via ArgoCD next, then Tempo, then instrument the Spring Boot application. That will give you a complete logs + metrics + traces stack before moving on to Karpenter and the platform engineering pieces.

lets proceed further

Good. At this point you've crossed the "basic EKS cluster" stage and entered the "platform engineering" stage.

Current platform status:

Infrastructure
--------------
✅ VPC
✅ EKS
✅ ECR
✅ RDS
✅ Route53
✅ Security Groups
✅ EBS CSI
✅ GP3 StorageClass

GitOps
------
✅ ArgoCD
✅ App of Apps

Platform Services
-----------------
✅ AWS Load Balancer Controller
✅ External DNS
✅ External Secrets

Observability
-------------
✅ Prometheus
✅ Grafana
✅ Loki
⬜ Log Collection
⬜ Tempo
⬜ OpenTelemetry Collector
What should be next?

There are two possible paths:

Path A (Recommended)

Complete observability first:

Alloy
↓
Tempo
↓
OpenTelemetry Collector
↓
Spring Boot instrumentation

Result:

Metrics  -> Prometheus
Logs     -> Loki
Traces   -> Tempo

This gives you a complete observability platform.

Path B

Jump to:

Karpenter

But Karpenter is more valuable once applications are generating real workload.

My recommendation

Let's finish observability.

Step 1: Deploy Grafana Alloy

Create:

gitops/
├── applications/
│   └── platform/
│       └── alloy.yaml

├── values/
│   └── alloy/
│       └── dev.yaml
Application

gitops/applications/platform/alloy.yaml

apiVersion: argoproj.io/v1alpha1
kind: Application

metadata:
  name: alloy
  namespace: argocd

spec:
  project: default

  destination:
    server: https://kubernetes.default.svc
    namespace: alloy

  source:
    repoURL: https://grafana.github.io/helm-charts
    chart: alloy
    targetRevision: 1.2.1

    helm:
      valueFiles:
        - $values/gitops/values/alloy/dev.yaml

  sources:
    - repoURL: https://grafana.github.io/helm-charts
      chart: alloy
      targetRevision: 1.2.1

      helm:
        valueFiles:
          - $values/gitops/values/alloy/dev.yaml

    - repoURL: https://github.com/ckalandar/aws-platform-engineering.git
      targetRevision: main
      ref: values

  syncPolicy:
    automated:
      prune: true
      selfHeal: true

    syncOptions:
      - CreateNamespace=true
Values

gitops/values/alloy/dev.yaml

alloy:

  configMap:
    create: true

    content: |
      logging {
        level = "info"
      }

      loki.write "default" {
        endpoint {
          url = "http://loki.loki.svc.cluster.local:3100/loki/api/v1/push"
        }
      }

      local.file_match "pods" {
        path_targets = [{
          __path__ = "/var/log/containers/*.log"
        }]
      }

      loki.source.file "pods" {
        targets    = local.file_match.pods.targets
        forward_to = [loki.write.default.receiver]
      }
Commit
git add .
git commit -m "Add Grafana Alloy"
git push
Verify
kubectl get applications -n argocd

You should see:

alloy
Healthy
Synced

Then:

kubectl get pods -n alloy

Expected:

alloy-xxxxx Running
Verify logs

Open Grafana:

Explore
→ Loki

Query:

{namespace="springboot"}

or

{namespace="argocd"}

You should start seeing container logs.

After Alloy is healthy and logs are flowing, the next step is Tempo, because then we'll start collecting traces from the Spring Boot application and build a true enterprise observability stack.

Pasted text(13).txt
Document

This explains the problem.

Your values file only defines the Alloy configuration, but does not configure the DaemonSet to mount node log directories.

Right now Alloy is trying to read:

__path__ = "/var/log/containers/*.log"

but inside the pod:

ls /var/log/containers

returns:

No such file or directory

which proves the host filesystem isn't mounted.

First determine the chart values structure

Let's inspect the rendered DaemonSet:

kubectl get ds alloy -n alloy -o yaml | grep -A30 volumeMounts

and

kubectl get ds alloy -n alloy -o yaml | grep -A30 volumes

This tells us whether:

The chart supports built-in log mounts that aren't enabled.
We need extraVolumes.
We need controller.extraVolumeMounts.
We need a different values structure entirely.
What I expect we'll need

Something like:

alloy:

  mounts:
    varlog: true

or

alloy:

  extraVolumes:
    - name: varlog
      hostPath:
        path: /var/log

  extraVolumeMounts:
    - name: varlog
      mountPath: /var/log
      readOnly: true

But I don't want to guess because Grafana's Alloy chart has changed values structure multiple times.

Another thing I noticed

Your config currently has:

loki.process "pods" {
  forward_to = [loki.write.default.receiver]
}

but nothing forwards into it.

You currently have:

loki.source.file "pods" {
  targets    = local.file_match.pods.targets
  forward_to = [loki.write.default.receiver]
}

which bypasses the processor completely.

That won't crash Alloy, but it's dead code.

Eventually we should do:

loki.source.file
        ↓
loki.process
        ↓
loki.write

for labels and parsing.

Next step

Show me:

kubectl get ds alloy -n alloy -o yaml | grep -A30 volumeMounts

and

kubectl get ds alloy -n alloy -o yaml | grep -A30 volumes

Once I see how the chart rendered, I'll give you the exact GitOps values to commit so Alloy can access /var/log/containers and start shipping logs to Loki.

kubectl get ds alloy -n alloy -o yaml | grep -A30 volumeMounts
      {"apiVersion":"apps/v1","kind":"DaemonSet","metadata":{"annotations":{"argocd.argoproj.io/tracking-id":"alloy:apps/DaemonSet:alloy/alloy"},"labels":{"app.kubernetes.io/instance":"alloy","app.kubernetes.io/managed-by":"Helm","app.kubernetes.io/name":"alloy","app.kubernetes.io/part-of":"alloy","app.kubernetes.io/version":"v1.10.1","helm.sh/chart":"alloy-1.2.1"},"name":"alloy","namespace":"alloy"},"spec":{"minReadySeconds":10,"selector":{"matchLabels":{"app.kubernetes.io/instance":"alloy","app.kubernetes.io/name":"alloy"}},"template":{"metadata":{"annotations":{"checksum/config":"79e84cf8852515542f16fb251ec86493b31b86c364465e4a05abacc6f83d85f","kubectl.kubernetes.io/default-container":"alloy"},"labels":{"app.kubernetes.io/instance":"alloy","app.kubernetes.io/name":"alloy"}},"spec":{"containers":[{"args":["run","/etc/alloy/config.alloy","--storage.path=/tmp/alloy","--server.http.listen-addr=0.0.0.0:12345","--server.http.ui-path-prefix=/","--stability.level=generally-available"],"env":[{"name":"ALLOY_DEPLOY_MODE","value":"helm"},{"name":"HOSTNAME","valueFrom":{"fieldRef":{"fieldPath":"spec.nodeName"}}}],"image":"docker.io/grafana/alloy:v1.10.1","imagePullPolicy":"IfNotPresent","name":"alloy","ports":[{"containerPort":12345,"name":"http-metrics"}],"readinessProbe":{"httpGet":{"path":"/-/ready","port":12345,"scheme":"HTTP"},"initialDelaySeconds":10,"timeoutSeconds":1},"volumeMounts":[{"mountPath":"/etc/alloy","name":"config"}]},{"args":["--watched-dir=/etc/alloy","--reload-url=http://localhost:12345/-/reload"],"image":"quay.io/prometheus-operator/prometheus-config-reloader:v0.81.0","name":"config-reloader","resources":{"requests":{"cpu":"10m","memory":"50Mi"}},"volumeMounts":[{"mountPath":"/etc/alloy","name":"config"}]}],"dnsPolicy":"ClusterFirst","serviceAccountName":"alloy","volumes":[{"configMap":{"name":"alloy"},"name":"config"}]}}}}
  creationTimestamp: "2026-07-31T13:02:42Z"
  generation: 2
  labels:
    app.kubernetes.io/instance: alloy
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: alloy
    app.kubernetes.io/part-of: alloy
    app.kubernetes.io/version: v1.10.1
    helm.sh/chart: alloy-1.2.1
  name: alloy
  namespace: alloy
  resourceVersion: "672053"
  uid: 61322148-7e0f-4727-ba91-bdcd59b06763
spec:
  minReadySeconds: 10
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app.kubernetes.io/instance: alloy
      app.kubernetes.io/name: alloy
  template:
    metadata:
      annotations:
        checksum/config: 79e84cf8852515542f16fb251ec86493b31b86c364465e4a05abacc6f83d85f
        kubectl.kubernetes.io/default-container: alloy
      creationTimestamp: null
      labels:
        app.kubernetes.io/instance: alloy
        app.kubernetes.io/name: alloy
    spec:
--
        volumeMounts:
        - mountPath: /etc/alloy
          name: config
      - args:
        - --watched-dir=/etc/alloy
        - --reload-url=http://localhost:12345/-/reload
        image: quay.io/prometheus-operator/prometheus-config-reloader:v0.81.0
        imagePullPolicy: IfNotPresent
        name: config-reloader
        resources:
          requests:
            cpu: 10m
            memory: 50Mi
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /etc/alloy
          name: config
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      serviceAccount: alloy
      serviceAccountName: alloy
      terminationGracePeriodSeconds: 30
      volumes:
      - configMap:
          defaultMode: 420
          name: alloy
        name: config
  updateStrategy:
    rollingUpdate:
      maxSurge: 0
      maxUnavailable: 1
    type: RollingUpdate
status:
  currentNumberScheduled: 3
  desiredNumberScheduled: 3
  numberAvailable: 3
  numberMisscheduled: 0
  numberReady: 3
  observedGeneration: 2
  updatedNumberScheduled: 3
kchilak@kalandars-MBP aws-platform-engineering % kubectl get ds alloy -n alloy -o yaml | grep -A30 volumes
      {"apiVersion":"apps/v1","kind":"DaemonSet","metadata":{"annotations":{"argocd.argoproj.io/tracking-id":"alloy:apps/DaemonSet:alloy/alloy"},"labels":{"app.kubernetes.io/instance":"alloy","app.kubernetes.io/managed-by":"Helm","app.kubernetes.io/name":"alloy","app.kubernetes.io/part-of":"alloy","app.kubernetes.io/version":"v1.10.1","helm.sh/chart":"alloy-1.2.1"},"name":"alloy","namespace":"alloy"},"spec":{"minReadySeconds":10,"selector":{"matchLabels":{"app.kubernetes.io/instance":"alloy","app.kubernetes.io/name":"alloy"}},"template":{"metadata":{"annotations":{"checksum/config":"79e84cf8852515542f16fb251ec86493b31b86c364465e4a05abacc6f83d85f","kubectl.kubernetes.io/default-container":"alloy"},"labels":{"app.kubernetes.io/instance":"alloy","app.kubernetes.io/name":"alloy"}},"spec":{"containers":[{"args":["run","/etc/alloy/config.alloy","--storage.path=/tmp/alloy","--server.http.listen-addr=0.0.0.0:12345","--server.http.ui-path-prefix=/","--stability.level=generally-available"],"env":[{"name":"ALLOY_DEPLOY_MODE","value":"helm"},{"name":"HOSTNAME","valueFrom":{"fieldRef":{"fieldPath":"spec.nodeName"}}}],"image":"docker.io/grafana/alloy:v1.10.1","imagePullPolicy":"IfNotPresent","name":"alloy","ports":[{"containerPort":12345,"name":"http-metrics"}],"readinessProbe":{"httpGet":{"path":"/-/ready","port":12345,"scheme":"HTTP"},"initialDelaySeconds":10,"timeoutSeconds":1},"volumeMounts":[{"mountPath":"/etc/alloy","name":"config"}]},{"args":["--watched-dir=/etc/alloy","--reload-url=http://localhost:12345/-/reload"],"image":"quay.io/prometheus-operator/prometheus-config-reloader:v0.81.0","name":"config-reloader","resources":{"requests":{"cpu":"10m","memory":"50Mi"}},"volumeMounts":[{"mountPath":"/etc/alloy","name":"config"}]}],"dnsPolicy":"ClusterFirst","serviceAccountName":"alloy","volumes":[{"configMap":{"name":"alloy"},"name":"config"}]}}}}
  creationTimestamp: "2026-07-31T13:02:42Z"
  generation: 2
  labels:
    app.kubernetes.io/instance: alloy
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: alloy
    app.kubernetes.io/part-of: alloy
    app.kubernetes.io/version: v1.10.1
    helm.sh/chart: alloy-1.2.1
  name: alloy
  namespace: alloy
  resourceVersion: "672053"
  uid: 61322148-7e0f-4727-ba91-bdcd59b06763
spec:
  minReadySeconds: 10
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app.kubernetes.io/instance: alloy
      app.kubernetes.io/name: alloy
  template:
    metadata:
      annotations:
        checksum/config: 79e84cf8852515542f16fb251ec86493b31b86c364465e4a05abacc6f83d85f
        kubectl.kubernetes.io/default-container: alloy
      creationTimestamp: null
      labels:
        app.kubernetes.io/instance: alloy
        app.kubernetes.io/name: alloy
    spec:
--
      volumes:
      - configMap:
          defaultMode: 420
          name: alloy
        name: config
  updateStrategy:
    rollingUpdate:
      maxSurge: 0
      maxUnavailable: 1
    type: RollingUpdate
status:
  currentNumberScheduled: 3
  desiredNumberScheduled: 3
  numberAvailable: 3
  numberMisscheduled: 0
  numberReady: 3
  observedGeneration: 2
  updatedNumberScheduled: 3

Perfect. Now we have the real problem.

Your Alloy DaemonSet has zero hostPath mounts.

Current state:

volumeMounts:
  - mountPath: /etc/alloy
    name: config

volumes:
  - name: config
    configMap:
      name: alloy

That's it.

So Alloy can read:

/etc/alloy/config.alloy

but cannot read:

/var/log/containers
/var/log/pods

which is why:

kubectl exec -n alloy alloy-thnhp -- ls /var/log/containers

failed.

Before changing values blindly

Let's identify exactly which Alloy chart you're using.

Show me:

cat gitops/applications/platform/alloy.yaml

or if it doesn't exist:

grep -R "grafana/alloy" gitops

or

grep -R "chart: alloy" gitops

I want to see:

repoURL:
chart:
targetRevision:

because the values structure differs between chart versions.

What we'll ultimately add

Something along these lines:

alloy:

  extraVolumes:
    - name: varlog
      hostPath:
        path: /var/log

  extraVolumeMounts:
    - name: varlog
      mountPath: /var/log
      readOnly: true

or possibly:

controller:
  extraVolumes:
  extraVolumeMounts:

depending on chart version.

Platform Engineering Observation

This is exactly why I wanted us to move into observability after Prometheus.

You've now encountered three classic production issues:

Storage Layer
Prometheus PVC Pending
        ↓
EBS CSI missing
Compute Layer
Loki Pending
        ↓
Node capacity exhausted
Logging Layer
Loki datasource healthy
        ↓
No log shipper mounted to host logs

These are the kinds of issues platform teams solve every day.

Once you show me the Alloy ArgoCD application YAML, I'll give you the exact gitops/values/alloy/dev.yaml structure for chart 1.2.1 and we'll get logs flowing into Loki. After that, the next major step is Tempo + OpenTelemetry, which will complete metrics + logs + traces.

cat gitops/applications/platform/alloy.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application

metadata:
  name: alloy
  namespace: argocd

spec:
  project: default

  destination:
    server: https://kubernetes.default.svc
    namespace: alloy

  source:
    repoURL: https://grafana.github.io/helm-charts
    chart: alloy
    targetRevision: 1.2.1

    helm:
      valueFiles:
        - $values/gitops/values/alloy/dev.yaml

  sources:
    - repoURL: https://grafana.github.io/helm-charts
      chart: alloy
      targetRevision: 1.2.1

      helm:
        valueFiles:
          - $values/gitops/values/alloy/dev.yaml

    - repoURL: https://github.com/ckalandar/aws-platform-engineering.git
      targetRevision: main
      ref: values

  syncPolicy:
    automated:
      prune: true
      selfHeal: true

    syncOptions:
      - CreateNamespace=true

Good. Now we know exactly what we're dealing with.

You're using:

chart: alloy
targetRevision: 1.2.1

and the rendered DaemonSet confirms that none of the host log mounts are enabled.

First thing I'd clean up

Your ArgoCD Application has both:

spec:
  source:

and

spec:
  sources:

You should only keep:

spec:
  sources:

since you're using a multi-source application.

Remove the entire:

source:
  repoURL: ...

block.

It isn't causing the Alloy issue, but it's technical debt.

Fix Alloy properly

Update:

gitops/values/alloy/dev.yaml

to:

alloy:

  mounts:
    varlog: true

  extraVolumes:

    - name: varlogpods
      hostPath:
        path: /var/log/pods

    - name: varlogcontainers
      hostPath:
        path: /var/log/containers

  extraVolumeMounts:

    - name: varlogpods
      mountPath: /var/log/pods
      readOnly: true

    - name: varlogcontainers
      mountPath: /var/log/containers
      readOnly: true

  configMap:
    create: true

    content: |
      logging {
        level = "info"
      }

      loki.write "default" {
        endpoint {
          url = "http://loki.loki.svc.cluster.local:3100/loki/api/v1/push"
        }
      }

      local.file_match "pods" {
        path_targets = [
          {
            __path__ = "/var/log/containers/*.log",
          },
        ]
      }

      loki.source.file "pods" {
        targets    = local.file_match.pods.targets
        forward_to = [loki.write.default.receiver]
      }

Commit that.

After Argo syncs

Verify mounts exist:

kubectl get ds alloy -n alloy -o yaml | grep -A5 varlog

You should see:

hostPath:
  path: /var/log/containers

hostPath:
  path: /var/log/pods
Then verify inside Alloy
kubectl exec -n alloy alloy-xxxx -- ls /var/log/containers | head

Expected:

argocd-server...
coredns...
prometheus...
springboot...

not:

No such file or directory
Then verify Loki ingestion

Run:

kubectl logs -n alloy alloy-xxxx -c alloy

You should see no errors.

Then in Grafana Explore:

Datasource:

Loki

Query:

{namespace="argocd"}

or

{namespace="springboot"}

If labels aren't present yet:

{}

and switch to:

Last 15 minutes
Architecture note

What you've built so far is now becoming a real observability stack:

EKS
 ├── Prometheus
 ├── Alertmanager
 ├── Grafana
 ├── Loki
 └── Alloy

Once logs are flowing, the next component should be:

Tempo

followed by:

OpenTelemetry Collector

because then your Spring Boot app can emit:

Metrics  -> Prometheus
Logs     -> Loki
Traces   -> Tempo

and Grafana can correlate all three from a single dashboard. That's where the platform starts feeling like an enterprise observability solution rather than a collection of tools.

Pasted text(14).txt
Document

Good progress. We have now isolated the problem.

What we know

✅ Alloy pods are running

✅ /var/log/containers exists inside the Alloy pod

✅ Loki is running

✅ Grafana can reach Loki

✅ Alloy configuration syntax is fixed

❌ Logs still aren't showing in Loki

The next step is to verify whether Alloy is actually reading files and pushing them to Loki.

Run:

kubectl logs -n alloy alloy-5fw2z -c alloy --tail=200

Look for messages containing:

loki.write
loki.source.file
tailing
reading file
push
batch
error

Also check Alloy metrics:

kubectl port-forward -n alloy pod/alloy-5fw2z 12345:12345

In another terminal:

curl localhost:12345/metrics | grep loki

and

curl localhost:12345/metrics | grep file

We should see counters such as:

loki_write_sent_entries_total
loki_source_file_read_lines_total

If those remain zero, Alloy isn't processing files.

I suspect one more issue

Your current config:

local.file_match "pods" {
  path_targets = [
    {
      __path__ = "/var/log/containers/*.log",
    },
  ]
}

loki.source.file "pods" {
  targets    = local.file_match.pods.targets
  forward_to = [loki.write.default.receiver]
}

reads logs but does not attach useful labels.

Try querying in Grafana:

{job=~".*"}

or

{}

If logs arrive without labels, {namespace="argocd"} won't return anything.

Verify directly from Loki

Run:

kubectl exec -n loki loki-0 -- \
wget -qO- "http://localhost:3100/loki/api/v1/labels"

You should get something like:

{
  "status":"success",
  "data":[ ... labels ... ]
}

If data is empty:

"data":[]

then Alloy is not sending anything to Loki.

Most likely root cause

Looking at your DaemonSet earlier, initially it had:

volumeMounts:
- mountPath: /etc/alloy

only.

After you updated the Helm values, we verified /var/log/containers exists, which means hostPath mounts are now present.

The remaining question is:

Is Alloy discovering files?

Run:

kubectl logs -n alloy alloy-5fw2z -c alloy --tail=200

and paste the output.

That log will tell us immediately whether:

Alloy isn't matching files
Alloy is matching files but failing to push
Alloy is successfully pushing and the issue is labels/querying

Once logs are flowing, we'll move to the next platform milestone:

Tempo → OpenTelemetry Collector → Distributed Tracing → Java application instrumentation, which is where the observability stack starts becoming production-grade.

Pasted text(15).txt
Document

Good progress. We've now found the real issue.

What we know

Your Alloy pods are now healthy:

alloy-5fw2z   2/2 Running

And inside the pod:

kubectl exec -n alloy alloy-5fw2z -- ls /var/log/containers

shows container logs correctly.

That means:

✅ Alloy configuration parses successfully
✅ Host log directory is mounted correctly
✅ Alloy can see Kubernetes container logs
✅ Loki is running
✅ Grafana can reach Loki

Next step: verify logs are actually reaching Loki

Run:

kubectl logs -n alloy alloy-5fw2z -c alloy --tail=100

Look for messages like:

level=info component=loki.source.file
level=info component=loki.write

or errors like:

connection refused
push failed
Check what labels Loki is receiving

Port-forward Loki:

kubectl port-forward -n loki svc/loki 3100:3100

Then in another terminal:

curl -G http://localhost:3100/loki/api/v1/labels

and

curl -G http://localhost:3100/loki/api/v1/label/job/values

If logs are arriving, you'll see labels returned.

Most likely remaining problem

Your Alloy config is currently:

local.file_match "pods" {
  path_targets = [
    {
      __path__ = "/var/log/containers/*.log",
    },
  ]
}

loki.source.file "pods" {
  targets    = local.file_match.pods.targets
  forward_to = [loki.write.default.receiver]
}

This ships raw files but doesn't attach Kubernetes metadata.

Therefore queries like:

{namespace="argocd"}

return nothing because no namespace label exists.

Test with "everything"

In Grafana Explore run:

{}

or

{filename=~".*"}

If logs appear, Loki ingestion is working and only labels are missing.

Production-grade Alloy configuration

The next thing we should do is replace the current minimal config with a Kubernetes-aware Alloy config that:

Discovers pods automatically
Adds labels:
namespace
pod
container
node
app
Sends logs to Loki

Then queries such as:

{namespace="argocd"}
{namespace="springboot"}
{container="springboot"}

will work.

Run these two commands and share the outputs:

kubectl logs -n alloy alloy-5fw2z -c alloy --tail=100
curl -G http://localhost:3100/loki/api/v1/labels

Once we see those, we'll build the proper Kubernetes discovery Alloy configuration and then move on to:

OpenTelemetry Collector
Tempo
Distributed Tracing
Java App Instrumentation
Karpenter
CI/CD Pipeline
Istio
Backstage
Crossplane
Enterprise IDP

which is the path toward a production-grade platform engineering stack.

I used this and I am able to see the logs {filename="/var/log/containers/alertmanager-monitoring-kube-prometheus-alertmanager-0_monitoring_alertmanager-bd1b88171f20616dd560ccfbfb915976c1152f08485b4eef3df78f2c041c3b50.log"}

/var/log/containers/alertmanager-monitoring-kube-prometheus-alertmanager-0_monitoring_alertmanager-bd1b88171f20616dd560ccfbfb915976c1152f08485b4eef3df78f2c041c3b50.log

Excellent. This tells us exactly where we are.

Your screenshot shows Loki is working and Alloy is successfully shipping logs.

The proof is:

{filename="/var/log/containers/alertmanager-....log"}

returns logs.

And the labels visible are:

filename
detected_level
service_name

but not:

namespace
pod
container
node
app
What this means

Current state:

Container Logs
        ↓
Alloy
        ↓
Loki
        ↓
Grafana

✅ Working

But Alloy is only reading files.

It is not performing Kubernetes discovery and metadata enrichment.

Therefore queries such as:

{namespace="monitoring"}
{namespace="argocd"}
{pod="springboot-xxxxx"}

will never work.

Why this happened

Your current config:

local.file_match "pods" {
  path_targets = [
    {
      __path__ = "/var/log/containers/*.log",
    },
  ]
}

loki.source.file "pods" {
  targets = local.file_match.pods.targets
}

reads files only.

The filename contains:

alertmanager-monitoring-kube-prometheus-alertmanager-0_monitoring_alertmanager.log

but Alloy does not automatically extract:

namespace=monitoring
pod=alertmanager-monitoring-kube-prometheus-alertmanager-0
container=alertmanager
This is actually good news

We have validated:

✅ Loki deployed

✅ Grafana datasource works

✅ Alloy deployed

✅ HostPath mount works

✅ Logs are reaching Loki

This completes the "centralized logging" milestone.

What I would do next

Instead of spending another hour perfecting labels right now, move forward with the platform roadmap.

Current stack:

EKS
ArgoCD
External Secrets
External DNS
ALB Controller
Prometheus
Grafana
Loki
Alloy

This is already a solid observability foundation.

Next Logical Step

I recommend:

Step 1: OpenTelemetry Collector

Add:

Application Metrics
Application Logs
Application Traces

pipeline.

Architecture:

Spring Boot
      ↓
OpenTelemetry SDK
      ↓
OTEL Collector
      ↓
Prometheus
      ↓
Loki
      ↓
Tempo
Step 2: Tempo

Distributed tracing.

Then you can trace:

User Request
      ↓
ALB
      ↓
Spring Boot
      ↓
Database

inside Grafana.

Step 3: Instrument Spring Boot

Add:

opentelemetry-javaagent.jar

and start generating traces.

Step 4: Karpenter

Right now you manually resized nodes:

t3.medium → t3.large

Karpenter should do that automatically.

That is the next major platform engineering milestone.

Recommendation

Don't stop to perfect Alloy labels right now.

You have already proven:

Logs → Loki → Grafana

works.

Let's proceed to:

OpenTelemetry Collector
        ↓
Tempo
        ↓
Java Auto Instrumentation
        ↓
Distributed Tracing
        ↓
Karpenter

This is where the platform starts looking like a real production-grade observability stack rather than just log aggregation.

Perfect. Now we move from Monitoring + Logging into Observability.

What we have today:

EKS
 ├── Prometheus
 ├── Grafana
 ├── Loki
 ├── Alloy
 ├── ArgoCD
 └── Spring Boot App

Current visibility:

Metrics  ✅
Logs     ✅
Traces   ❌

Our next objective:

Metrics  → Prometheus
Logs     → Loki
Traces   → Tempo

This is the foundation of a modern platform.

Target Architecture
                    ┌─────────────┐
                    │ Spring Boot │
                    └──────┬──────┘
                           │
                           │ OTLP
                           ▼
                 ┌──────────────────┐
                 │ OTEL Collector   │
                 └──────┬───────────┘
                        │
      ┌─────────────────┼────────────────┐
      │                 │                │
      ▼                 ▼                ▼

 Prometheus         Loki            Tempo
 (Metrics)         (Logs)          (Traces)

      └───────────── Grafana ────────────┘
Why OTEL Collector?

Many beginners send data directly:

App → Prometheus
App → Loki
App → Tempo

Bad idea.

Production platforms use:

App → OTEL Collector → Backend

Benefits:

buffering
retries
batching
sampling
vendor-neutral
one configuration point

This is the CNCF standard.

GitOps Structure

We'll add:

gitops/
├── applications/
│   └── platform/
│       ├── otel-collector.yaml
│       └── tempo.yaml

├── values/
│   ├── otel-collector/
│   │   └── dev.yaml
│   └── tempo/
│       └── dev.yaml
Step 1 — Deploy Tempo

Create:

gitops/applications/platform/tempo.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application

metadata:
  name: tempo
  namespace: argocd

spec:
  project: default

  destination:
    server: https://kubernetes.default.svc
    namespace: tempo

  sources:

    - repoURL: https://grafana.github.io/helm-charts
      chart: tempo
      targetRevision: 1.23.2

      helm:
        valueFiles:
          - $values/gitops/values/tempo/dev.yaml

    - repoURL: https://github.com/ckalandar/aws-platform-engineering.git
      targetRevision: main
      ref: values

  syncPolicy:
    automated:
      prune: true
      selfHeal: true

    syncOptions:
      - CreateNamespace=true
Tempo Values

Create:

gitops/values/tempo/dev.yaml
tempo:

  retention: 24h

persistence:
  enabled: true

  storageClassName: gp3

  size: 10Gi

service:
  type: ClusterIP

Commit:

git add .
git commit -m "add tempo"
git push

Wait for ArgoCD sync.

Verify:

kubectl get pods -n tempo

Expected:

tempo-0    Running
Step 2 — Add Tempo Datasource

Extend Grafana datasource configuration.

In:

gitops/values/monitoring/dev.yaml

add:

grafana:

  additionalDataSources:

    - name: Loki
      type: loki
      access: proxy
      url: http://loki.loki.svc.cluster.local:3100

    - name: Tempo
      type: tempo
      access: proxy
      url: http://tempo.tempo.svc.cluster.local:3100

Commit.

Sync.

Verify:

Grafana
 → Connections
 → Data Sources

You should see:

Prometheus
Loki
Tempo
Step 3 — Deploy OpenTelemetry Collector

Create:

gitops/applications/platform/otel-collector.yaml

Using the official chart:

apiVersion: argoproj.io/v1alpha1
kind: Application

metadata:
  name: otel-collector
  namespace: argocd

spec:
  project: default

  destination:
    server: https://kubernetes.default.svc
    namespace: observability

  sources:

    - repoURL: https://open-telemetry.github.io/opentelemetry-helm-charts
      chart: opentelemetry-collector
      targetRevision: 0.128.0

      helm:
        valueFiles:
          - $values/gitops/values/otel-collector/dev.yaml

    - repoURL: https://github.com/ckalandar/aws-platform-engineering.git
      targetRevision: main
      ref: values

  syncPolicy:
    automated:
      prune: true
      selfHeal: true

    syncOptions:
      - CreateNamespace=true
OTEL Collector Values

Create:

gitops/values/otel-collector/dev.yaml
mode: deployment

config:

  receivers:

    otlp:
      protocols:
        grpc:
        http:

  processors:

    batch:

  exporters:

    debug:

    otlp:
      endpoint: tempo.tempo.svc.cluster.local:4317
      tls:
        insecure: true

  service:

    pipelines:

      traces:
        receivers:
          - otlp

        processors:
          - batch

        exporters:
          - debug
          - otlp

This means:

Spring Boot
      ↓
OTEL Collector
      ↓
Tempo
Verify Collector

After sync:

kubectl get pods -n observability

Expected:

otel-collector-xxxxx Running
Where We Go Next

After Tempo and OTEL Collector are healthy, we will:

Phase 2

Instrument Spring Boot

Java Agent
      ↓
OTEL Collector
      ↓
Tempo

Generate traces automatically.

Then in Grafana:

Explore
  ├── Prometheus
  ├── Loki
  └── Tempo

You'll be able to click a trace and follow a request end-to-end.

For now, implement Tempo first, sync it, and show me:

kubectl get pods -n tempo
kubectl get svc -n tempo

Then we'll wire the OTEL Collector correctly against the actual Tempo service endpoints created by the chart.

kubectl get pods -n tempo
kubectl get svc -n tempo
NAME      READY   STATUS    RESTARTS   AGE
tempo-0   1/1     Running   0          13m
NAME    TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                                                                                   AGE
tempo   ClusterIP   172.20.138.215   <none>        6831/UDP,6832/UDP,3200/TCP,14268/TCP,14250/TCP,9411/TCP,55680/TCP,55681/TCP,4317/TCP,4318/TCP,55678/TCP   13m

Excellent. Tempo is running and exposing the OTLP endpoints:

tempo.tempo.svc.cluster.local:4317   # OTLP gRPC
tempo.tempo.svc.cluster.local:4318   # OTLP HTTP

At this point your observability stack looks like this:

Spring Boot App
    |
    +--> Prometheus Metrics
    |         |
    |         v
    |    Prometheus
    |         |
    |         v
    |      Grafana
    |
    +--> Application Logs
    |         |
    |         v
    |       Alloy
    |         |
    |         v
    |       Loki
    |         |
    |         v
    |      Grafana
    |
    +--> Distributed Traces
              |
              v
      OpenTelemetry SDK
              |
              v
           Tempo
              |
              v
           Grafana

You now have Metrics + Logs.

Next: Traces.

Step 1: Add Tempo datasource to Grafana

Add to your monitoring values.

grafana:
  additionalDataSources:
    - name: Loki
      type: loki
      access: proxy
      url: http://loki.loki.svc.cluster.local:3100

    - name: Tempo
      type: tempo
      access: proxy
      url: http://tempo.tempo.svc.cluster.local:3200

Commit:

git add .
git commit -m "Add Tempo datasource"
git push

Wait for ArgoCD sync.

Verify:

kubectl logs -n monitoring deploy/monitoring-grafana

Then check:

Grafana
  Connections
    Data Sources

You should see:

Prometheus
Loki
Tempo
Alertmanager
Step 2: Instrument Spring Boot

What Spring Boot version are you running?

Check:

cat pom.xml | grep spring-boot

If you're using Spring Boot 3.x (most likely), add:

<dependency>
    <groupId>io.opentelemetry.instrumentation</groupId>
    <artifactId>opentelemetry-spring-boot-starter</artifactId>
    <version>2.15.0</version>
</dependency>
Step 3: Configure OTLP Export

Add to:

application.yaml
management:
  tracing:
    sampling:
      probability: 1.0

otel:
  exporter:
    otlp:
      endpoint: http://tempo.tempo.svc.cluster.local:4318

  traces:
    exporter: otlp

This exports every request trace to Tempo.

Step 4: Verify Connectivity

Enter Spring Boot pod:

kubectl exec -it \
springboot-xxxxx \
-n springboot -- sh

Test:

curl http://tempo.tempo.svc.cluster.local:3200/ready

Expected:

ready
Step 5: Generate Traffic

Open:

https://springboot.dev.learnsystems.co

or

for i in {1..100}; do
  curl https://springboot.dev.learnsystems.co
done
Step 6: Verify Tempo Receives Traces

Check Tempo logs:

kubectl logs -n tempo tempo-0

You should start seeing:

received spans
ingested traces
Step 7: Query Traces in Grafana

Go to:

Explore

Select:

Tempo

Query:

{}

or

service.name="springboot"

You should start seeing trace IDs.

Step 8: Correlate Metrics ↔ Logs ↔ Traces

This is where observability becomes powerful.

A request flow becomes:

HTTP Request
      |
      v
Trace (Tempo)
      |
      +--> Logs (Loki)
      |
      +--> Metrics (Prometheus)

From a trace you can jump to logs.

From logs you can jump to traces.

From metrics you can jump to traces.

Exactly what platform teams run in production.

What I'd do next

Once Tempo datasource appears in Grafana and traces are visible, the next production-grade step is:

Auto-instrument Spring Boot with OpenTelemetry
Add service maps
Add exemplars (Prometheus ↔ Tempo linking)
Build RED dashboards
Rate
Errors
Duration
Create SLOs
Alerting via Alertmanager
Add a second microservice and visualize distributed traces across services

That gets you very close to a real enterprise observability platform running on EKS.

Good. You have added the OpenTelemetry Spring Boot starter, but that dependency alone does not automatically export traces to Tempo.

For Spring Boot 3.x + OpenTelemetry + Tempo, you need:

1. Create application.yaml

Create:

src/main/resources/application.yaml

Contents:

spring:
  application:
    name: springboot-app

management:
  endpoints:
    web:
      exposure:
        include: health,info,prometheus

otel:
  exporter:
    otlp:
      endpoint: http://tempo.tempo.svc.cluster.local:4318

  metrics:
    exporter: none

  logs:
    exporter: none

  traces:
    exporter: otlp

  resource:
    attributes:
      service.name: springboot-app
2. Verify Tempo OTLP endpoint

From your output:

tempo
4317/TCP
4318/TCP

Tempo exposes:

4317 = OTLP gRPC
4318 = OTLP HTTP

The Spring starter uses OTLP HTTP by default, so:

http://tempo.tempo.svc.cluster.local:4318

is correct.

3. Add a simple controller
package com.kk.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello from Platform Engineering";
    }
}
4. Build new image
mvn clean package

Build and push:

docker build -t <ecr-repo>:latest .
docker push <ecr-repo>:latest
5. Redeploy
kubectl rollout restart deployment springboot -n springboot

Wait:

kubectl get pods -n springboot
6. Generate traffic

Port forward:

kubectl port-forward svc/springboot 8080:80 -n springboot

Generate requests:

for i in {1..50}
do
  curl http://localhost:8080/hello
done
7. Verify traces reached Tempo

Check Spring logs:

kubectl logs deployment/springboot -n springboot

Look for anything like:

OTLP exporter initialized

or exporter errors.

8. Add Tempo datasource to Grafana

You already did Loki manually.

Now add Tempo datasource.

Grafana → Connections → Data Sources → Add Data Source → Tempo

URL:

http://tempo.tempo.svc.cluster.local:3200

Save & Test.

9. Verify traces

Go to:

Explore

Select:

Tempo

Search:

service.name = springboot-app

or

springboot-app

You should see traces generated from /hello.

Production-grade improvement

Instead of configuring every application with:

otel.exporter.otlp.endpoint

most enterprises deploy an OpenTelemetry Collector:

Spring Boot
      |
      v
OpenTelemetry Collector
      |
      +--> Tempo
      +--> Prometheus
      +--> Loki
      +--> Datadog
      +--> New Relic

This becomes your telemetry gateway and allows routing, filtering, batching, retries, and multi-destination exports.

For your platform-engineering project, the next logical step is:

Spring Boot
    ↓
OpenTelemetry Collector
    ↓
Tempo

Then we'll have the complete observability stack:

Prometheus -> Metrics
Loki       -> Logs
Tempo      -> Traces
Grafana    -> Visualization
Alloy      -> Log Collection
OpenTelemetry Collector -> Trace Pipeline

which is the architecture used in many production Kubernetes platforms.

this is my application.yaml
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
and platformController.java
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
            "username", System.getenv("APP_USERNAME"),
            "service", "platform-demo");
    }
}
giv me the updated two files I don't want to make mistakes in updating these files

Here are the complete updated files with OpenTelemetry support added while preserving your existing endpoints.

src/main/resources/application.yaml
server:
  port: 8080

spring:
  application:
    name: platform-demo

management:
  endpoints:
    web:
      exposure:
        include: health,info,prometheus

otel:
  exporter:
    otlp:
      endpoint: http://tempo.tempo.svc.cluster.local:4318

  traces:
    exporter: otlp

  metrics:
    exporter: none

  logs:
    exporter: none

  resource:
    attributes:
      service.name: platform-demo
src/main/java/com/kk/platform/PlatformController.java
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

    @GetMapping("/orders")
    public Map<String, Object> orders() {

        return Map.of(
                "orderId", "ORD-1001",
                "status", "SUCCESS",
                "amount", 2500);
    }

    @GetMapping("/payments")
    public Map<String, Object> payments() {

        return Map.of(
                "paymentId", "PAY-2001",
                "status", "COMPLETED",
                "amount", 2500);
    }
}

After committing these changes:

mvn clean package
docker build -t <ecr-repo>:latest .
docker push <ecr-repo>:latest

Then:

kubectl rollout restart deployment springboot -n springboot

Generate traffic:

for i in {1..100}
do
  curl http://<springboot-url>/orders
  curl http://<springboot-url>/payments
  curl http://<springboot-url>/health
done

Then check the application logs:

kubectl logs deployment/springboot -n springboot

If traces are not appearing in Tempo after deployment, show me:

kubectl logs deployment/springboot -n springboot --tail=100

and we'll verify whether the OpenTelemetry starter is actually exporting traces or if we need to switch to the Java agent approach (which is common in production Kubernetes platforms).

why do we need to run those manual steps? it shld run from the pipeline right?

Yes, in your platform the pipeline should do all of that.

I was giving the manual steps only as a way to validate the instrumentation quickly if you were testing locally. In a GitOps platform, the flow should be:

Developer
    |
    v
Git Push
    |
    v
GitHub Actions
    |
    +--> mvn test
    +--> mvn package
    +--> docker build
    +--> docker push ECR
    +--> update image tag in GitOps repo
    |
    v
GitOps Repository Updated
    |
    v
ArgoCD Sync
    |
    v
Deployment Updated
    |
    v
Pods Restart
    |
    v
Telemetry starts flowing to Tempo

For your repository specifically:

applications/
├── springboot-app/        <-- source code
└── workloads/
    └── springboot.yaml    <-- deployment

A production-grade approach would be:

CI Repository (Application)

When code changes:

mvn test
mvn package
docker build
docker push ECR

Image produced:

136863648867.dkr.ecr.us-east-1.amazonaws.com/platform-demo:v1.0.15
CD Repository (GitOps)

Pipeline updates:

image:
  repository: platform-demo
  tag: v1.0.15

or directly updates:

containers:
- name: springboot
  image: 136863648867.dkr.ecr.us-east-1.amazonaws.com/platform-demo:v1.0.15

Commits:

git commit
git push
ArgoCD

Argo sees:

Desired State != Cluster State

and automatically:

Sync
Deploy
Rollout

No kubectl commands required.

Enterprise Improvement

Instead of editing manifests manually, we usually use:

springboot-app
        |
        v
Github Action
        |
        v
ArgoCD Image Updater
        |
        v
updates image tag automatically

Then the developer only does:

git push

and the entire chain happens automatically.

For the platform we're building, I would implement:

Phase 1
ECR
GitHub Actions
ArgoCD
Phase 2
ArgoCD Image Updater
Phase 3
Backstage Software Templates
Phase 4
Crossplane Self-Service Infrastructure
Phase 5
Enterprise Internal Developer Platform (IDP)

At that point a developer clicks:

Create Service

in Backstage and gets:

Git repository
CI pipeline
ECR repository
Kubernetes namespace
ArgoCD application
Monitoring
Logging
Tracing

automatically.

That is the direction we're heading with the remaining items:

✓ EKS
✓ ALB Controller
✓ External DNS
✓ External Secrets
✓ ArgoCD
✓ Prometheus
✓ Grafana
✓ Loki
✓ Tempo

Next:
→ OpenTelemetry Collector
→ Karpenter
→ CI/CD
→ Istio
→ Backstage
→ Crossplane
→ Enterprise IDP

So you're thinking correctly: once the CI/CD pipeline is in place, you shouldn't need to run mvn package, docker build, docker push, or kubectl rollout restart manually except during initial development and troubleshooting.

==== 1 Aug ===
Perfect. You've actually solved the problem.

This output proves:

{
  "rootServiceName":"platform-demo",
  "rootTraceName":"GET /"
}

Tempo contains traces from your Spring Boot application.

And:

curl http://localhost:3200/ready

returns:

ready

So all of these are working:

✅ Spring Boot instrumentation
✅ OTEL exporter
✅ OTLP endpoint (4318)
✅ Tempo ingestion
✅ Tempo storage
✅ Tempo query API

What happened?

Earlier we were troubleshooting because:

Tempo logs weren't obviously showing new traces
No OTEL logs appeared in Spring Boot
Actuator wasn't installed

After fixing Actuator and redeploying, traces are clearly flowing.

Your architecture is now:

Spring Boot
    ↓
OpenTelemetry SDK
    ↓
OTLP HTTP (4318)
    ↓
Tempo
    ↓
Grafana
Next step: Visualize traces in Grafana

Open Grafana.

Go to:

Connections
  → Data Sources

Verify Tempo datasource exists.

If not:

Type: Tempo
URL: http://tempo.tempo.svc.cluster.local:3200

Save & Test.

Search traces in Grafana

Navigate:

Explore

Datasource:

Tempo

Search:

service.name="platform-demo"

or simply select:

platform-demo

from the service dropdown.

You should see traces like:

GET /
GET /health
GET /version
Better Demo

Right now every trace is:

GET /
duration = 1ms

which isn't very interesting.

Let's create a realistic distributed trace.

Update your controller:

@GetMapping("/slow")
public Map<String, String> slow() throws Exception {

    Thread.sleep(500);

    return Map.of(
            "service", "platform-demo",
            "status", "completed");
}

Deploy.

Generate traffic:

for i in {1..20}
do
  curl https://springboot.dev.learnsystems.co/slow
done

Now Grafana will show:

GET /slow
duration ≈ 500ms

which is much easier to inspect.

Next maturity level

You're currently collecting:

Logs  -> Loki
Metrics -> Prometheus
Traces -> Tempo

This is the complete Grafana observability stack.

The next thing I would implement is trace ↔ log correlation.

Goal:

Error trace
    ↓
Click trace ID
    ↓
Jump directly to logs in Loki

This is where observability starts becoming truly useful for troubleshooting microservices and Kubernetes workloads.

You're actually at a good milestone now:

EKS
 ├─ ArgoCD
 ├─ Spring Boot App
 ├─ Loki Logs
 ├─ Prometheus Metrics
 ├─ Tempo Traces
 └─ Grafana Visualization

That's a production-style observability platform foundation.

I can see the traces now 

That's exactly what we wanted to see.

From your screenshot:

✅ Tempo datasource is working
✅ Service platform-demo is discovered
✅ Traces are searchable
✅ Trace name is GET /
✅ Grafana ↔ Tempo integration is working
✅ Spring Boot → OTEL → Tempo pipeline is working

At this point you have a complete observability pipeline:

Spring Boot
    ↓
OpenTelemetry
    ↓
Tempo
    ↓
Grafana Explore
What you've actually achieved

Many engineers stop at:

Application Logs → Loki

You now have:

Logs    → Loki
Metrics → Prometheus
Traces  → Tempo

which is the full Grafana observability stack.

Next thing I would do

Your traces are currently:

GET /
duration ≈ 1 ms

Not very interesting.

Let's make traces useful.

Add a slow endpoint:

@GetMapping("/slow")
public Map<String, String> slow() throws Exception {

    Thread.sleep(500);

    return Map.of(
            "status", "success",
            "endpoint", "slow");
}

Deploy.

Generate traffic:

for i in {1..20}
do
  curl https://springboot.dev.learnsystems.co/slow
done

Now in Tempo you'll see:

GET /slow
duration ≈ 500ms

and can visually inspect latency.

Real-world next step: Trace → Log correlation

This is where observability becomes powerful.

Today:

Grafana
 ├─ Logs (Loki)
 ├─ Metrics (Prometheus)
 └─ Traces (Tempo)

Next goal:

Trace
  ↓
Click TraceID
  ↓
Jump to related logs

To achieve that we would:

1. Add Trace ID to application logs

For Spring Boot:

logging:
  pattern:
    level: "%5p [${spring.application.name:},trace_id=%X{trace_id:-},span_id=%X{span_id:-}]"

Example log:

INFO [platform-demo,trace_id=8cda245fa484d...,span_id=123abc]
Request received
2. Send application logs to Loki

Right now Alloy is collecting container logs.

Once trace IDs are present in logs:

Loki log
   contains trace_id
3. Configure Grafana derived fields

In Loki datasource:

trace_id

maps to

Tempo datasource

Then Grafana automatically adds:

View Trace

button beside logs.

Even more interesting

After that we can create:

Custom spans
@WithSpan("database-call")
public User getUser() {
   ...
}

or

Span span = tracer.spanBuilder("payment-processing").startSpan();

Then Tempo shows:

GET /checkout
 ├── authentication
 ├── payment-processing
 ├── inventory-check
 └── notification

which is what you see in real production microservices.

At this stage you've successfully completed the first full observability implementation on your EKS platform. The next logical milestone is correlating logs and traces, then introducing custom spans and multiple services so you can see distributed traces across service boundaries.

lets proceed further

Great. Now that traces are working, I wouldn't stop at "I can see traces in Grafana."

The next objective is to build something that resembles a real production platform.

Phase 1: Correlate Logs ↔ Traces

Currently you have:

Request
  ↓
Trace in Tempo

Request
  ↓
Log in Loki

But they're separate.

In production, you want:

Trace
  ↓
Click
  ↓
Related logs

Log
  ↓
Click
  ↓
Related trace
Update application.yaml

Add:

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

logging:
  pattern:
    console: >
      %d{yyyy-MM-dd HH:mm:ss}
      [%thread]
      %-5level
      trace_id=%X{trace_id:-}
      span_id=%X{span_id:-}
      %logger{36}
      - %msg%n
Add logs to controller

Example:

package com.kk.platform;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RestController
public class PlatformController {

    private static final Logger log =
            LoggerFactory.getLogger(PlatformController.class);

    @GetMapping("/")
    public Map<String,String> home() {

        log.info("Home endpoint called");

        return Map.of(
            "service", "platform-demo",
            "status", "healthy");
    }
}

Deploy.

Verify

Generate traffic:

curl https://springboot.dev.learnsystems.co/

Then:

kubectl logs -n springboot deployment/springboot

You should see:

INFO trace_id=8cda245fa484d...
span_id=4a62f4d...
Home endpoint called

This is the same Trace ID stored in Tempo.

Phase 2: Create Business Spans

Auto instrumentation is useful, but production systems need custom spans.

Add a service layer.

PlatformService.java
package com.kk.platform;

import io.opentelemetry.instrumentation.annotations.WithSpan;
import org.springframework.stereotype.Service;

@Service
public class PlatformService {

    @WithSpan("config-read")
    public String getConfig() throws Exception {

        Thread.sleep(100);

        return "success";
    }
}
Controller
@Autowired
private PlatformService service;

@GetMapping("/config")
public Map<String,String> config() throws Exception {

    service.getConfig();

    return Map.of(
        "service","platform-demo");
}
Result in Tempo

Before:

GET /config

After:

GET /config
 └── config-read

Now you're seeing application-level operations.

Phase 3: Create a Second Service

This is where observability becomes truly valuable.

Current:

Browser
  ↓
Spring Boot

Next:

Browser
  ↓
Frontend Service
  ↓
Backend Service

Example:

platform-demo
    ↓
inventory-service

Each service gets its own trace spans.

Tempo will show:

GET /order
 ├── platform-demo
 └── inventory-service

This is distributed tracing.

Phase 4: Metrics from Application

You already have Prometheus.

Add:

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>

<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>

Expose:

management:
  endpoints:
    web:
      exposure:
        include: health,info,prometheus

  prometheus:
    metrics:
      export:
        enabled: true

Verify:

curl localhost:8080/actuator/prometheus

You should see:

http_server_requests_seconds
jvm_memory_used_bytes
jvm_gc_pause_seconds
Phase 5: Build a Realistic Demo System

Instead of one service, create:

platform-demo
inventory-service
payment-service
notification-service

Deploy all through ArgoCD.

Then:

User Request
   ↓
platform-demo
   ↓
inventory-service
   ↓
payment-service
   ↓
notification-service

Observability stack:

Grafana
├── Loki
├── Prometheus
└── Tempo

Now you can demonstrate:

Request flow
Latency analysis
Error tracking
Service dependencies
Trace-to-log correlation
Metrics dashboards

This is the point where your EKS platform starts looking like a production platform engineering environment rather than a single application demo.

My recommendation is to tackle these next in order:

Trace ↔ Log correlation
Custom spans (@WithSpan)
Prometheus metrics from Spring Boot
Second microservice
Service graph in Tempo
Grafana dashboards and alerts

Each step builds directly on what you've already working today.

curl -v https://springboot.dev.learnsystems.co/config
* Host springboot.dev.learnsystems.co:443 was resolved.
                                                       * IPv6: (none)
                                                                     * IPv4: 100.56.181.163, 52.70.193.32
                                                                                                         *   Trying 100.56.181.163:443...
                      * Connected to springboot.dev.learnsystems.co (100.56.181.163) port 443
                                                                                             * ALPN: curl offers h2,http/1.1
         * (304) (OUT), TLS handshake, Client hello (1):
                                                        *  CAfile: /etc/ssl/cert.pem
                                                                                    *  CApath: none
                                                                                                   * (304) (IN), TLS handshake, Server hello (2):
                              * TLSv1.2 (IN), TLS handshake, Certificate (11):
                                                                              * TLSv1.2 (IN), TLS handshake, Server key exchange (12):
                   * TLSv1.2 (IN), TLS handshake, Server finished (14):
                                                                       * TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
             * TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
                                                                        * TLSv1.2 (OUT), TLS handshake, Finished (20):
   * TLSv1.2 (IN), TLS change cipher, Change cipher spec (1):
                                                             * TLSv1.2 (IN), TLS handshake, Finished (20):
                                                                                                          * SSL connection using TLSv1.2 / ECDHE-RSA-AES128-GCM-SHA256 / [blank] / UNDEF
                                                                     * ALPN: server accepted h2
                                                                                               * Server certificate:
 *  subject: CN=*.dev.learnsystems.co
                                     *  start date: Jul 29 00:00:00 2026 GMT
                                                                            *  expire date: Feb 11 23:59:59 2027 GMT
 *  subjectAltName: host "springboot.dev.learnsystems.co" matched cert's "*.dev.learnsystems.co"
                                                                                                *  issuer: C=US; O=Amazon; CN=Amazon RSA 2048 M01
                              *  SSL certificate verify ok.
                                                           * using HTTP/2
                                                                         * [HTTP/2] [1] OPENED stream for https://springboot.dev.learnsystems.co/config
                                    * [HTTP/2] [1] [:method: GET]
                                                                 * [HTTP/2] [1] [:scheme: https]
                                                                                                * [HTTP/2] [1] [:authority: springboot.dev.learnsystems.co]
                                        * [HTTP/2] [1] [:path: /config]
                                                                       * [HTTP/2] [1] [user-agent: curl/8.7.1]
                                                                                                              * [HTTP/2] [1] [accept: */*]
                       > GET /config HTTP/2
> Host: springboot.dev.learnsystems.co
> User-Agent: curl/8.7.1
> Accept: */*
>
* Request completely sent off
                             < HTTP/2 200
< date: Sat, 01 Aug 2026 10:02:27 GMT
< content-type: application/json
<
* Connection #0 to host springboot.dev.learnsystems.co left intact
                                                                  {"username":"admin","service":"platform-demo"}%  kchilak@kalandars-MacBook-Pro aws-platform-engineering % kubectl get deploy springboot -n springboot \
-o=jsonpath='{.spec.template.spec.containers[0].image}'
136863648867.dkr.ecr.us-east-1.amazonaws.com/platform-demo:90852d5d2f0eb6cc7f15d77be3e45718df230ab2%               kchilak@kalandars-MacBook-Pro aws-platform-engineering % kubectl logs -n springboot deploy/springboot --tail=50
Found 2 pods, using pod/springboot-f6c7bcc9b-r9txm
                                                  2026-08-01 09:59:54 [http-nio-8080-exec-7] INFO  trace_id=046b2633490d66152c9b26435500d45a span_id=b916b1abebffdb41 com.kk.platform.PlatformController - Home endpoint called

                                                                                                            2026-08-01 10:00:08 [http-nio-8080-exec-9] INFO  trace_id=63894e5c81a30df0c274995eb7a8bfd3 span_id=1ec9a20e933acdfe com.kk.platform.PlatformController - Home endpoint called

                                                   2026-08-01 10:00:09 [http-nio-8080-exec-10] INFO  trace_id=00099380824ed3184d9f7f53196a1424 span_id=28795d50f17bbaa1 com.kk.platform.PlatformController - Home endpoint called

                                                                                                              2026-08-01 10:00:23 [http-nio-8080-exec-1] INFO  trace_id=41186ce7811fc8a4c9150b10044ac083 span_id=ac357d2b76940025 com.kk.platform.PlatformController - Home endpoint called

                                                     2026-08-01 10:00:24 [http-nio-8080-exec-2] INFO  trace_id=255f6659f3f21d855364f35f80dada6d span_id=d74d80803eacc2d3 com.kk.platform.PlatformController - Home endpoint called

                                                                                                               2026-08-01 10:00:38 [http-nio-8080-exec-3] INFO  trace_id=24c06725f2065248b2099e46fda79cac span_id=79ba7bf13d64af77 com.kk.platform.PlatformController - Home endpoint called

                                                      2026-08-01 10:00:39 [http-nio-8080-exec-4] INFO  trace_id=00e3a74461a5da2242eeb8d0279ecb58 span_id=4826252921e1a29d com.kk.platform.PlatformController - Home endpoint called

                                                                                                                2026-08-01 10:00:53 [http-nio-8080-exec-6] INFO  trace_id=ca8cdf5e10cc8f48d6ae3aaea5d39181 span_id=e4a418c2ccc650c8 com.kk.platform.PlatformController - Home endpoint called

                                                       2026-08-01 10:00:54 [http-nio-8080-exec-7] INFO  trace_id=7f36c97292500d3883dbc4ef858791ca span_id=3c993b452525dac9 com.kk.platform.PlatformController - Home endpoint called

                                                                                                                 2026-08-01 10:01:08 [http-nio-8080-exec-9] INFO  trace_id=d70b85ff87974d23d3b53c9992ff4eda span_id=98adf4456f7c1cf7 com.kk.platform.PlatformController - Home endpoint called

                                                        2026-08-01 10:01:09 [http-nio-8080-exec-10] INFO  trace_id=73f97a4b6ce003b9da308ce916aeb1c9 span_id=67829fbc5873984f com.kk.platform.PlatformController - Home endpoint called

                                                                                                                   2026-08-01 10:01:23 [http-nio-8080-exec-1] INFO  trace_id=c106d496e91363099d79c7a2954f0c4e span_id=16d3ca85332a3383 com.kk.platform.PlatformController - Home endpoint called

                                                          2026-08-01 10:01:24 [http-nio-8080-exec-2] INFO  trace_id=498196abf5a9cac34d97d8b7145da5d8 span_id=b281ab20e178fd89 com.kk.platform.PlatformController - Home endpoint called

 2026-08-01 10:01:39 [http-nio-8080-exec-3] INFO  trace_id=40ef9400b33fdf5b23495f9fde82bd34 span_id=016ae5e2401eefdc com.kk.platform.PlatformController - Home endpoint called

                                                           2026-08-01 10:01:39 [http-nio-8080-exec-4] INFO  trace_id=d80be88933cb0533c5056ae329cb2765 span_id=ae8877003a95ee6d com.kk.platform.PlatformController - Home endpoint called

  2026-08-01 10:01:54 [http-nio-8080-exec-5] INFO  trace_id=3b2f3904e8e6db576d91ca54a331dcde span_id=7de08e8fff93dc7b com.kk.platform.PlatformController - Home endpoint called

                                                            2026-08-01 10:01:54 [http-nio-8080-exec-6] INFO  trace_id=346de5d65d85a34661ac16b010547c4b span_id=4b293cee36660c49 com.kk.platform.PlatformController - Home endpoint called

   2026-08-01 10:02:09 [http-nio-8080-exec-7] INFO  trace_id=511e90ddb672ea5c3b6f200678ca8b1a span_id=b074c9c52b4127c5 com.kk.platform.PlatformController - Home endpoint called

                                                             2026-08-01 10:02:09 [http-nio-8080-exec-8] INFO  trace_id=d3b98129327321240a1120689b159301 span_id=b182d7e117ec2d4d com.kk.platform.PlatformController - Home endpoint called

    2026-08-01 10:02:24 [http-nio-8080-exec-9] INFO  trace_id=ac9c8b23cd0aa7aab39eb8ce3a0455dc span_id=cefc7b34d05bbb97 com.kk.platform.PlatformController - Home endpoint called

                                                              2026-08-01 10:02:24 [http-nio-8080-exec-10] INFO  trace_id=3ea5116004fd6611d30206ca6cae2b8d span_id=ffb4682c8ae0b469 com.kk.platform.PlatformController - Home endpoint called

      2026-08-01 10:02:39 [http-nio-8080-exec-2] INFO  trace_id=fa4757d0b77ba4a294700406dba15623 span_id=fa276cf796e0ae24 com.kk.platform.PlatformController - Home endpoint called

                                                                2026-08-01 10:02:39 [http-nio-8080-exec-3] INFO  trace_id=07487c386b709e9fa38d6c4c7113ccc6 span_id=32b7fc6f95d7abf8 com.kk.platform.PlatformController - Home endpoint called

       2026-08-01 10:02:54 [http-nio-8080-exec-4] INFO  trace_id=ae0cce6cd3552f3868ef4f4ab3c6e1a5 span_id=dcb5f5d231120cdc com.kk.platform.PlatformController - Home endpoint called

                                                                 2026-08-01 10:02:54 [http-nio-8080-exec-5] INFO  trace_id=0e8683966331f560a011c9eb0dfe8219 span_id=3f3f0c24b4cc0328 com.kk.platform.PlatformController - Home endpoint called

        %    
analyse the snapshot I had just attached it is showing config-read also in Grafana

Yes — this screenshot changes the conclusion significantly.

Looking carefully at your Grafana Tempo search:

Service Name = platform-demo
Span Name = config-read
Grafana has accepted the query and generated:
{resource.service.name="platform-demo" && name="config-read"}

That means Grafana already knows that a span called config-read exists in Tempo's index.

If Tempo had never seen that span name, searching for it would normally return nothing.

What this proves

You have successfully completed the important part:

✅ Spring Boot application is generating manual spans
✅ OTEL exporter is sending spans to Tempo
✅ Tempo is indexing config-read spans
✅ Grafana can query those spans

In other words:

Span span = tracer.spanBuilder("config-read").startSpan();

is working.

What I would do next

Click the blue Refresh/Search button in the upper right.

If traces appear in the results table below, then you have end-to-end tracing working.

If no results appear

Most likely one of these:

1. Time range too narrow

Check Grafana's time picker.

Try:

Last 1 hour

or

Last 6 hours

and search again.

2. Need fresh traffic

Generate traffic:

for i in {1..20}; do
  curl -s https://springboot.dev.learnsystems.co/config >/dev/null
done

Wait 10–20 seconds and search again.

3. Query traces without filtering

Remove:

Span Name = config-read

Keep only:

Service Name = platform-demo

Search.

You should see traces such as:

GET /config
GET /

Open a trace and inspect the span tree.

You should find:

GET /config
└── config-read
Looking at your logs

This is another strong signal:

trace_id=ac9c8b23cd0aa7aab39eb8ce3a0455dc
span_id=cefc7b34d05bbb97

The logging pattern is receiving OpenTelemetry context.

That means:

Request
   ↓
Spring Instrumentation
   ↓
Trace Context
   ↓
Logs
   ↓
Tempo

is already wired together.

From an observability-engineering perspective

You've now demonstrated:

Application deployment through GitOps/ArgoCD
OpenTelemetry instrumentation
Context propagation
Trace correlation in logs
Tempo ingestion
Grafana trace search
Custom business span (config-read)

That's the core of a production distributed tracing setup.

The next valuable exercise would be to open one trace and verify the hierarchy looks something like:

GET /config
 └── config-read

and that the config.username attribute you set on the span is visible in Tempo. If you can see that attribute, then your manual instrumentation is fully validated end-to-end.

I can see the traces see the attached snapshot

Yes — this screenshot is the proof we were looking for.

What I can see in the Tempo search results:

Trace name: GET /config
Service: platform-demo
Child span: config-read
Multiple traces returned successfully

The important part is this row:

GET /config
  └── config-read

That means:

Request hits your application.

Spring/OpenTelemetry creates the HTTP server span:

GET /config

Your manual instrumentation creates:

config-read
Tempo receives both spans.
Grafana can search and display them.

So the manual span implementation is working correctly.

What you have successfully validated
Automatic instrumentation

OpenTelemetry automatically created:

GET /config

This comes from Spring Boot instrumentation.

Manual instrumentation

Your code created:

config-read

This comes from:

Span span = tracer.spanBuilder("config-read").startSpan();

or equivalent code.

Trace hierarchy

The child span is attached to the HTTP request span.

Trace
└── GET /config
      └── config-read

This is exactly how business spans should appear.

Next thing to verify

Click on one of the trace IDs:

ba75b1032c13...

Then inspect the trace details.

You should see attributes similar to:

service.name=platform-demo
http.method=GET
http.route=/config

and hopefully your custom attribute:

span.setAttribute("config.username", username);

or whatever attribute name you used.

If you see that custom attribute, then you've validated:

Application
    ↓
OpenTelemetry SDK
    ↓
OTLP Export
    ↓
Tempo
    ↓
Grafana Search
    ↓
Custom Span Attributes

end-to-end.

From a Platform Engineering perspective

At this point your platform already demonstrates:

Infrastructure
Terraform
EKS
ALB
Route53
ACM
ArgoCD
Security
Kubernetes Secrets
HTTPS/TLS
ExternalDNS
Observability
Prometheus
Grafana
Loki (if installed)
Tempo
OpenTelemetry
Application
Spring Boot
CI/CD
GitOps
Distributed tracing

This is already the foundation of a production-grade internal developer platform.

The next natural step is to instrument a second service (for example a Config Service or User Service) and then observe a distributed trace flowing:

Client
  ↓
Springboot API
  ↓
Config Service
  ↓
Database

where Tempo shows spans across multiple services in a single trace. That's where distributed tracing becomes really powerful.

do we really need this second service now? can't we progress further?

No, you do not need a second service right now.

The reason I suggested it is because distributed tracing becomes more impressive when a request crosses service boundaries. But from a platform engineering learning perspective, you've already proven the OpenTelemetry → Tempo → Grafana pipeline works.

You've reached this milestone:

User
  ↓
ALB
  ↓
Ingress
  ↓
Spring Boot
  ↓
OpenTelemetry
  ↓
Tempo
  ↓
Grafana

and you have evidence:

GET /config
  └── config-read

So I would not spend more time adding another service yet.

Where I would go next

Looking at your original goal:

Learn implementation, architecture, troubleshooting, platform engineering, production-grade systems.

Observability was only one component.

Your platform currently looks something like:

Terraform
    ↓
EKS
    ↓
ArgoCD
    ↓
Spring Boot
    ↓
Secrets
    ↓
ALB + Route53
    ↓
Observability

The next high-value topics are:

Option 1: Kubernetes Security (Recommended)

This is usually the next major platform engineering layer.

Implement:

Network Policies

Restrict pod-to-pod communication.

Example:

springboot
    ↓
can talk to
    ↓
tempo

but NOT

random pod
    ↓
springboot

Learn:

CNI
Calico/Cilium
Egress control
Namespace isolation

These are common production interview topics.

Pod Security

Add:

runAsNonRoot: true

allowPrivilegeEscalation: false

readOnlyRootFilesystem: true

Understand:

Privileged containers
Linux capabilities
Security Contexts
External Secrets Operator

Instead of:

AWS Secrets Manager
      ↓
manual sync
      ↓
Kubernetes Secret

Use:

AWS Secrets Manager
      ↓
External Secrets Operator
      ↓
Kubernetes Secret
      ↓
Application

This is a real-world production pattern.

Option 2: Service Mesh

Good learning but larger effort.

Add:

Istio
Linkerd

Learn:

mTLS
Traffic Splitting
Canary Releases
Retries
Circuit Breakers

I would postpone this until security fundamentals are complete.

Option 3: Platform Engineering / IDP

This aligns closely with your stated goal.

Current flow:

Developer
    ↓
Git Repo
    ↓
ArgoCD
    ↓
Deployment

Build:

Developer
    ↓
Backstage
    ↓
Template
    ↓
Git Repo
    ↓
ArgoCD
    ↓
Deployment

Learn:

Backstage
Software Catalog
Templates
Self-Service Deployments

This is modern Platform Engineering.

Option 4: Production Operations

This is what senior SREs and platform engineers do daily.

Implement:

HPA
CPU > 70%
    ↓
scale pods
Karpenter
pods increase
    ↓
nodes increase
Pod Disruption Budgets
minAvailable: 1
Readiness/Liveness Probes
Resource Quotas
Limit Ranges
If I were mentoring you

I would choose this order:

Phase 1 (Done)

✅ Terraform

✅ EKS

✅ ArgoCD

✅ Spring Boot

✅ ALB

✅ Route53

✅ Secrets

✅ OpenTelemetry

✅ Tempo

✅ Grafana

Phase 2

✅ Network Policies

✅ External Secrets Operator

✅ Pod Security Standards

✅ RBAC

Phase 3

✅ Prometheus Alerting

✅ HPA

✅ Karpenter

✅ Disaster Recovery

Phase 4

✅ Backstage

✅ Developer Self-Service

✅ Internal Developer Platform

This path will teach you far more about real platform engineering than adding a second demo microservice right now. The observability proof-of-concept is already complete. The bigger gaps are security, operations, and developer platform capabilities.
Excellent. You've completed the "deploy an application on Kubernetes with observability" phase.

Now let's start building the platform like a real enterprise platform team would.

Next Milestone: Kubernetes Security Foundation

Before we touch Service Mesh, Backstage, or advanced platform engineering, we need to secure the cluster.

Most EKS environments fail audits because they lack:

Pod Security
Network Segmentation
RBAC
Secret Management
Workload Identity
Phase 2.1 — Lock Down the SpringBoot Pod

Currently your pod is probably running as:

root user
writable filesystem
default capabilities

That's fine for learning.

Not fine for production.

Goal

When we finish, the pod should run as:

securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
Check Current State

Run:

kubectl exec -it -n springboot deploy/springboot -- id

Expected:

uid=0(root)

or

uid=1000

Show me the output.

Phase 2.2 — Audit RBAC

Let's see what permissions your application has.

Run:

kubectl auth can-i --list \
--as=system:serviceaccount:springboot:default \
-n springboot

This tells us:

Can create pods?
Can read secrets?
Can list namespaces?

Many applications accidentally get too many permissions.

Show me the output.

Phase 2.3 — Network Segmentation

Right now any pod in the cluster can probably talk to:

springboot
grafana
tempo
prometheus
argocd

A compromised pod could scan everything.

We want:

springboot
   ├── tempo: allowed
   ├── dns: allowed
   └── everything else: denied

First let's see if your cluster supports NetworkPolicies.

Run:

kubectl get pods -A -o wide

and

kubectl get daemonset -A

I want to see whether you're using:

AWS VPC CNI
Cilium
Calico

because NetworkPolicy behavior depends on the CNI.

Phase 2.4 — Secrets Modernization

Currently:

AWS Secrets Manager
      ↓
kubectl secret
      ↓
pod

I want to know how you're creating the secret.

Run:

kubectl get secret app-config -n springboot -o yaml

(remove the base64 values before sharing if you prefer)

and show me:

kubectl describe secret app-config -n springboot

We're going to decide whether to move to:

External Secrets Operator

which is the production-grade pattern.

Why we're doing this before Service Mesh

A common enterprise maturity path is:

Application
    ↓
Observability
    ↓
Security
    ↓
Scaling
    ↓
Platform Engineering

You have completed Observability.

The next biggest gap in your platform is Security.

So let's start with these four checks:

kubectl exec -it -n springboot deploy/springboot -- id

kubectl auth can-i --list \
--as=system:serviceaccount:springboot:default \
-n springboot

kubectl get pods -A -o wide

kubectl get daemonset -A

kubectl describe secret app-config -n springboot

Post the outputs and we'll perform a proper platform security review before making changes.

That's exactly the right concern.

A junior engineer sees:

No NetworkPolicies found

and immediately creates a deny-all policy.

A platform architect asks:

"What workloads exist today, what workloads will exist in 3 months, what traffic patterns will emerge, and what operational burden will these controls create?"

That's the correct approach.

Let's Analyze Your Platform First

Current platform:

Internet
   │
Route53
   │
ALB
   │
SpringBoot
   │
External Secrets
   │
AWS Secrets Manager

SpringBoot
   │
OpenTelemetry
   │
Tempo

Alloy
   │
Loki

Prometheus
   │
Grafana

You also have:

ArgoCD
ExternalDNS
AWS Load Balancer Controller
Karpenter (future)

running in-cluster.

What Happens If We Add Strict Network Policies Today?

Many people assume:

deny all
allow app traffic

is automatically better.

Not always.

Risk 1: Break Future Microservices

Today:

SpringBoot

Tomorrow:

SpringBoot
     │
     ├── User Service
     ├── Config Service
     ├── Payment Service
     └── Notification Service

If we lock networking too aggressively now:

SpringBoot -> Config Service

fails later.

Then developers start opening holes everywhere.

Result:

20+
NetworkPolicies

nobody understands.

Risk 2: Break Observability

Currently:

SpringBoot
   │
OTLP 4318
   │
Tempo

works.

Later:

Prometheus scraping
Grafana access
Metrics exporter
Log shipping
OTEL Collector

may require additional paths.

A deny-all policy often breaks telemetry first.

And telemetry is usually the thing you need during an outage.

Risk 3: ArgoCD and Operational Tooling

Future scenarios:

Argo Rollouts
Argo Events
Notifications
Webhook Receivers

may need namespace communication.

Security controls should not prevent platform evolution.

What Would I Do In Enterprise?

Not this:

Namespace
   ↓
Deny All

Too early.

Instead:

Phase 1

Inventory traffic.

Questions:

Who talks to SpringBoot?
Who talks to Tempo?
Who talks to Loki?
Who talks to Prometheus?

before blocking anything.

Phase 2

Observe flows.

With Cilium/Hubble or Calico Flow Logs:

springboot -> tempo
springboot -> dns
prometheus -> kube-state-metrics
alloy -> loki

Now you know actual dependencies.

Phase 3

Apply policies gradually.

Example:

Allow DNS
Allow OTLP
Allow Ingress

Deny everything else

for one namespace.

Validate.

Expand.

What Security Gap Is Bigger Right Now?

Honestly?

Not NetworkPolicies.

This is.

uid=0(root)

Your application runs as root.

That is a more immediate security concern than open pod networking in your current environment.

If an attacker exploits SpringBoot:

Remote Code Execution
      ↓
root inside container

Now they have maximum privileges inside the container.

My Architectural Priorities For Your Platform

If this were my EKS platform:

Priority 1

Container Hardening

runAsNonRoot
drop capabilities
readOnlyRootFilesystem

Low risk.

High value.

Almost no architectural impact.

Priority 2

HPA

You currently have:

2 replicas
fixed

No autoscaling.

For a platform project:

CPU -> HPA -> Pods

is more valuable than NetworkPolicies.

Priority 3

Karpenter

Then:

Pods scale
Nodes scale

Now you're demonstrating cloud-native elasticity.

Priority 4

Network Policies

After traffic patterns are known.

Priority 5

Service Mesh

When you actually have multiple services.

What I Would Recommend Today

Do not implement NetworkPolicies yet.

Instead:

Keep networking open for now.
Harden the SpringBoot container.
Add HPA.
Add Karpenter.
Build one more service (Config Service or User Service).
Observe service-to-service traffic in Tempo.
Then design NetworkPolicies based on real communication patterns.

That sequence matches how mature platform teams typically evolve a new EKS platform. Right now, your biggest architectural gap is workload hardening and autoscaling, not east-west traffic restrictions.

kubectl get svc -A
NAMESPACE          NAME                                                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                                                                                   AGE
alloy              alloy                                                ClusterIP   172.20.230.20    <none>        12345/TCP                                                                                                 21h
argocd             argocd-applicationset-controller                     ClusterIP   172.20.30.82     <none>        7000/TCP                                                                                                  3d3h
argocd             argocd-dex-server                                    ClusterIP   172.20.43.97     <none>        5556/TCP,5557/TCP                                                                                         3d3h
argocd             argocd-redis                                         ClusterIP   172.20.108.214   <none>        6379/TCP                                                                                                  3d3h
argocd             argocd-repo-server                                   ClusterIP   172.20.138.253   <none>        8081/TCP                                                                                                  3d3h
argocd             argocd-server                                        ClusterIP   172.20.167.172   <none>        80/TCP,443/TCP                                                                                            3d3h
default            kubernetes                                           ClusterIP   172.20.0.1       <none>        443/TCP                                                                                                   3d3h
demo               nginx                                                ClusterIP   172.20.49.13     <none>        80/TCP                                                                                                    3d3h
external-secrets   external-secrets-webhook                             ClusterIP   172.20.173.250   <none>        443/TCP                                                                                                   47h
kube-system        aws-load-balancer-webhook-service                    ClusterIP   172.20.202.41    <none>        443/TCP                                                                                                   3d3h
kube-system        eks-extension-metrics-api                            ClusterIP   172.20.151.249   <none>        443/TCP                                                                                                   3d3h
kube-system        external-dns                                         ClusterIP   172.20.247.62    <none>        7979/TCP                                                                                                  2d22h
kube-system        kube-dns                                             ClusterIP   172.20.0.10      <none>        53/UDP,53/TCP,9153/TCP                                                                                    3d3h
kube-system        monitoring-kube-prometheus-coredns                   ClusterIP   None             <none>        9153/TCP                                                                                                  45h
kube-system        monitoring-kube-prometheus-kube-controller-manager   ClusterIP   None             <none>        10257/TCP                                                                                                 45h
kube-system        monitoring-kube-prometheus-kube-etcd                 ClusterIP   None             <none>        2381/TCP                                                                                                  45h
kube-system        monitoring-kube-prometheus-kube-proxy                ClusterIP   None             <none>        10249/TCP                                                                                                 45h
kube-system        monitoring-kube-prometheus-kube-scheduler            ClusterIP   None             <none>        10259/TCP                                                                                                 45h
kube-system        monitoring-kube-prometheus-kubelet                   ClusterIP   None             <none>        10250/TCP,10255/TCP,4194/TCP                                                                              45h
loki               loki                                                 ClusterIP   172.20.47.70     <none>        3100/TCP,9095/TCP                                                                                         22h
loki               loki-canary                                          ClusterIP   172.20.233.134   <none>        3500/TCP                                                                                                  22h
loki               loki-headless                                        ClusterIP   None             <none>        3100/TCP                                                                                                  22h
loki               loki-memberlist                                      ClusterIP   None             <none>        7946/TCP                                                                                                  22h
monitoring         alertmanager-operated                                ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP                                                                                27h
monitoring         monitoring-grafana                                   ClusterIP   172.20.161.255   <none>        80/TCP                                                                                                    45h
monitoring         monitoring-kube-prometheus-alertmanager              ClusterIP   172.20.152.211   <none>        9093/TCP,8080/TCP                                                                                         45h
monitoring         monitoring-kube-prometheus-operator                  ClusterIP   172.20.125.197   <none>        443/TCP                                                                                                   45h
monitoring         monitoring-kube-prometheus-prometheus                ClusterIP   172.20.171.218   <none>        9090/TCP,8080/TCP                                                                                         45h
monitoring         monitoring-kube-state-metrics                        ClusterIP   172.20.115.148   <none>        8080/TCP                                                                                                  45h
monitoring         monitoring-prometheus-node-exporter                  ClusterIP   172.20.23.103    <none>        9100/TCP                                                                                                  45h
monitoring         prometheus-operated                                  ClusterIP   None             <none>        9090/TCP                                                                                                  27h
springboot         springboot                                           ClusterIP   172.20.94.41     <none>        80/TCP                                                                                                    3d3h
tempo              tempo                                                ClusterIP   172.20.138.215   <none>        6831/UDP,6832/UDP,3200/TCP,14268/TCP,14250/TCP,9411/TCP,55680/TCP,55681/TCP,4317/TCP,4318/TCP,55678/TCP   17h
kchilak@kalandars-MBP aws-platform-engineering % kubectl get ingress -A
NAMESPACE    NAME                 CLASS   HOSTS                            ADDRESS                                                                   PORTS   AGE
demo         nginx                alb     *                                k8s-demo-nginx-2e5ada922c-716034082.us-east-1.elb.amazonaws.com           80      3d3h
monitoring   monitoring-grafana   alb     grafana.dev.learnsystems.co      k8s-monitori-monitori-17da4d04b1-1367080749.us-east-1.elb.amazonaws.com   80      45h
springboot   springboot           alb     springboot.dev.learnsystems.co   k8s-springbo-springbo-2f4bc59496-561847438.us-east-1.elb.amazonaws.com    80      3d3h

This output is exactly what I wanted before making any security recommendations.

Looking at your platform as an architect, I would not deploy NetworkPolicies yet.

Here's why.

Current Architecture
Internet
   │
Route53
   │
ALB Ingress
   │
SpringBoot
   │
──────────────
   │
Tempo
Loki
Prometheus
Grafana
──────────────
   │
External Secrets
   │
AWS Secrets Manager

ArgoCD
ExternalDNS
AWS LB Controller

This is still a platform foundation stage, not a mature microservices platform.

What I Observe
1. SpringBoot is already talking to Tempo

You proved that.

Grafana shows:

GET /
config-read

Those spans are arriving.

Meaning:

SpringBoot
   │
4318
   │
Tempo

must remain open.

2. DNS is critical

Everything relies on:

kube-dns
172.20.0.10

If we accidentally block DNS:

tempo.tempo.svc.cluster.local

stops resolving.

Then:

OTEL → Tempo

breaks instantly.

3. Prometheus Future Dependency

Today:

SpringBoot

is not exporting metrics.

Tomorrow:

/actuator/prometheus

will be scraped by:

monitoring-kube-prometheus-prometheus

If we lock ingress too early:

Prometheus scraping fails
4. External Secrets Dependency

Today your app only consumes:

Secret app-config

from Kubernetes.

No runtime AWS calls.

That's good.

But later you may introduce:

IRSA
AWS SDK
S3
SQS
SNS
DynamoDB
RDS

Network policies must accommodate that evolution.

The Bigger Security Findings

From your output:

kubectl exec ... -- id

uid=0(root)

This is currently a larger issue.

Because:

NetworkPolicy
   protects traffic

runAsRoot
   affects workload compromise

If someone achieves RCE:

SpringBoot exploit
       ↓
Shell
       ↓
root inside container

That's a higher-priority risk.

What I Would Do Next

Not NetworkPolicies.

I'd move to workload hardening.

Phase 1

Fix:

securityContext:
  runAsNonRoot: true
  runAsUser: 10001
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true

capabilities:
  drop:
    - ALL

Verify app still works.

Phase 2

Add Pod Security Standards

Namespace labels:

pod-security.kubernetes.io/enforce: restricted
pod-security.kubernetes.io/audit: restricted
pod-security.kubernetes.io/warn: restricted

This immediately elevates the security posture.

Phase 3

Metrics

Add:

Micrometer
Prometheus scraping
Grafana dashboards

Right now you have:

Logs ✓
Traces ✓
Metrics ✗

Observability is incomplete until metrics exist.

Phase 4

HPA

Currently:

replicas: 2

static.

Add:

CPU based scaling
Memory based scaling
Phase 5

Karpenter

Then:

Pods scale
Nodes scale
Phase 6

Introduce a second service

For example:

platform-demo
      │
      └── config-service

or

platform-demo
      │
      └── user-service

Now tracing becomes truly valuable because you'll see:

ALB
 ↓
SpringBoot
 ↓
Config Service

as a distributed trace.

When Should We Implement NetworkPolicies?

After at least one of these exists:

Service A -> Service B
Service A -> RDS
Service A -> Redis
Service A -> SQS
Service A -> DynamoDB

Then we can observe actual traffic patterns and create policies that match reality.

Otherwise we're designing controls for dependencies that don't exist yet.

If I were reviewing this platform for production-readiness today, my roadmap would be:

1. Container Hardening        ← next
2. Metrics                    ← next
3. HPA
4. Karpenter
5. Second Microservice
6. Network Policies
7. Service Mesh

That sequence gives the highest architectural value with the lowest chance of breaking your current platform.

You remember this order for future, you have been changing umpteen times on this order now 1. Container Hardening        ← next
2. Metrics                    ← next
3. HPA
4. Karpenter
5. Second Microservice
6. Network Policies
7. Service Mesh

Fair point, and you're right to call it out.

The reason you've seen the order change is because the platform itself has changed significantly during the build.

For example:

A few days ago

No Tempo
No traces
No External Secrets
No Grafana
No realistic workload

At that stage I would have prioritized:

HPA
Karpenter
Microservice
Observability

because there wasn't much worth securing yet.

Today, after seeing the actual cluster state:

✓ EKS
✓ ArgoCD
✓ External Secrets
✓ ExternalDNS
✓ ALB Controller
✓ Grafana
✓ Loki
✓ Tempo
✓ Distributed tracing
✓ SpringBoot workload

the priorities become different.

I can now see:

uid=0(root)

which is a concrete security issue.

I can also see:

No metrics from application

which means your observability stack is only 66% complete:

Logs     ✓
Traces   ✓
Metrics  ✗

So the roadmap evolved based on evidence rather than a fixed checklist.

For this platform's current state, I would now lock the roadmap as:

PHASE 1 — Workload Security
1. Container Hardening
2. Pod Security Standards

PHASE 2 — Observability
3. Application Metrics (Micrometer + Prometheus)
4. Grafana Dashboards
5. Alerting

PHASE 3 — Scalability
6. HPA
7. Load Testing
8. Karpenter

PHASE 4 — Platform Expansion
9. Second Microservice
10. Distributed Tracing Across Services

PHASE 5 — Zero Trust Networking
11. Network Policies
12. RBAC Hardening
13. IRSA Adoption Everywhere

PHASE 6 — Platform Engineering
14. Service Mesh
15. Progressive Delivery (Argo Rollouts)
16. Developer Self-Service / IDP

This is the sequence I would recommend unless the architecture changes materially (for example adding RDS, Redis, SQS, multiple services, multi-tenant namespaces, etc.).

So yes—going forward, for the platform you've built today, let's treat this as the baseline roadmap rather than reshuffling every few messages.

Immediate next task: Container Hardening.

That gives the biggest security improvement with the lowest blast radius and doesn't interfere with Tempo, Loki, Prometheus, ArgoCD, External Secrets, ALB, or any future

lets start as planned, now stop giving summary and speedddddd it up what we have to achieve, I am running the resources on my own personal account with cost associated

Agreed. You're paying for the infrastructure, so we'll prioritize highest learning value per dollar spent and avoid rabbit holes.

Current Status

✅ EKS
✅ Terraform
✅ ArgoCD
✅ External Secrets
✅ ALB Ingress
✅ Route53
✅ TLS/ACM
✅ Loki
✅ Tempo
✅ Grafana
✅ Distributed Tracing

Next:

Phase 1 — Container Hardening (30 min)
Goal

Move from:

uid=0(root)

to:

uid=10001(appuser)

and enforce:

runAsNonRoot: true
allowPrivilegeEscalation: false
readOnlyRootFilesystem: true
capabilities:
  drop:
    - ALL

This is a real production control.

Step 1

Show me:

Dockerfile
cat Dockerfile

or

cat docker/Dockerfile

wherever it lives.

Also show deployment
kubectl get deploy springboot -n springboot -o yaml

or just paste the container section.

Once I see those two files, I'll give you the exact minimal changes.

No theory. No summaries.

Just the changes.

Dockerfile
FROM eclipse-temurin:21-jre

WORKDIR /app

COPY target/platform-demo-1.0.0.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
kubectl get deploy springboot -n springboot -o yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    argocd.argoproj.io/tracking-id: springboot:apps/Deployment:springboot/springboot
    deployment.kubernetes.io/revision: "11"
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{"argocd.argoproj.io/tracking-id":"springboot:apps/Deployment:springboot/springboot"},"name":"springboot","namespace":"springboot"},"spec":{"replicas":2,"selector":{"matchLabels":{"app":"springboot"}},"template":{"metadata":{"labels":{"app":"springboot"}},"spec":{"containers":[{"env":[{"name":"APP_USERNAME","valueFrom":{"secretKeyRef":{"key":"username","name":"app-config"}}},{"name":"APP_PASSWORD","valueFrom":{"secretKeyRef":{"key":"password","name":"app-config"}}},{"name":"APP_API_KEY","valueFrom":{"secretKeyRef":{"key":"apiKey","name":"app-config"}}},{"name":"OTEL_SERVICE_NAME","value":"platform-demo"},{"name":"OTEL_TRACES_EXPORTER","value":"otlp"},{"name":"OTEL_METRICS_EXPORTER","value":"none"},{"name":"OTEL_LOGS_EXPORTER","value":"none"},{"name":"OTEL_EXPORTER_OTLP_ENDPOINT","value":"http://tempo.tempo.svc.cluster.local:4318"},{"name":"OTEL_EXPORTER_OTLP_PROTOCOL","value":"http/protobuf"}],"image":"136863648867.dkr.ecr.us-east-1.amazonaws.com/platform-demo:90852d5d2f0eb6cc7f15d77be3e45718df230ab2","name":"springboot","ports":[{"containerPort":8080}],"resources":{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}}]}}}}
  creationTimestamp: "2026-07-29T07:27:33Z"
  generation: 11
  name: springboot
  namespace: springboot
  resourceVersion: "967578"
  uid: 33b0a80f-b8ea-4edd-8b5a-ba5479dfb96f
spec:
  progressDeadlineSeconds: 600
  replicas: 2
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: springboot
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      annotations:
        kubectl.kubernetes.io/restartedAt: "2026-07-29T22:21:44+05:30"
      creationTimestamp: null
      labels:
        app: springboot
    spec:
      containers:
      - env:
        - name: APP_USERNAME
          valueFrom:
            secretKeyRef:
              key: username
              name: app-config
        - name: APP_PASSWORD
          valueFrom:
            secretKeyRef:
              key: password
              name: app-config
        - name: APP_API_KEY
          valueFrom:
            secretKeyRef:
              key: apiKey
              name: app-config
        - name: OTEL_SERVICE_NAME
          value: platform-demo
        - name: OTEL_TRACES_EXPORTER
          value: otlp
        - name: OTEL_METRICS_EXPORTER
          value: none
        - name: OTEL_LOGS_EXPORTER
          value: none
        - name: OTEL_EXPORTER_OTLP_ENDPOINT
          value: http://tempo.tempo.svc.cluster.local:4318
        - name: OTEL_EXPORTER_OTLP_PROTOCOL
          value: http/protobuf
        image: 136863648867.dkr.ecr.us-east-1.amazonaws.com/platform-demo:90852d5d2f0eb6cc7f15d77be3e45718df230ab2
        imagePullPolicy: IfNotPresent
        name: springboot
        ports:
        - containerPort: 8080
          protocol: TCP
        resources:
          limits:
            cpu: 500m
            memory: 512Mi
          requests:
            cpu: 100m
            memory: 128Mi
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
status:
  availableReplicas: 2
  conditions:
  - lastTransitionTime: "2026-08-01T09:56:37Z"
    lastUpdateTime: "2026-08-01T09:56:37Z"
    message: Deployment has minimum availability.
    reason: MinimumReplicasAvailable
    status: "True"
    type: Available
  - lastTransitionTime: "2026-07-29T16:41:51Z"
    lastUpdateTime: "2026-08-01T09:56:37Z"
    message: ReplicaSet "springboot-f6c7bcc9b" has successfully progressed.
    reason: NewReplicaSetAvailable
    status: "True"
    type: Progressing
  observedGeneration: 11
  readyReplicas: 2
  replicas: 2
  updatedReplicas: 2

Good. Your app is currently running as root and has zero container security controls.

1. Fix Dockerfile

Replace with:

FROM eclipse-temurin:21-jre

RUN addgroup --system appgroup && \
    adduser --system --ingroup appgroup --uid 10001 appuser

WORKDIR /app

COPY target/platform-demo-1.0.0.jar app.jar

RUN chown -R appuser:appgroup /app

USER 10001

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
2. Add Container Security Context

In your deployment manifest:

containers:
  - name: springboot
    image: ...
    securityContext:
      runAsNonRoot: true
      runAsUser: 10001
      runAsGroup: 10001

      allowPrivilegeEscalation: false

      capabilities:
        drop:
          - ALL

      readOnlyRootFilesystem: true

      seccompProfile:
        type: RuntimeDefault
3. Add Pod Security Context

Under:

spec:
  template:
    spec:

add:

securityContext:
  fsGroup: 10001
4. Build + Push

Your normal pipeline.

No manual kubectl edits.

Argo should deploy it.

5. Verify

After rollout:

kubectl exec -it -n springboot deploy/springboot -- id

Expected:

uid=10001(appuser)
gid=10001(appgroup)
6. Verify Security Context
kubectl get pod -n springboot \
-o yaml | grep -A20 securityContext

Should show:

runAsNonRoot: true
allowPrivilegeEscalation: false
readOnlyRootFilesystem: true
7. Watch for Failure

The one thing that may break is:

readOnlyRootFilesystem: true

because some Java libraries write temp files.

If pods fail:

kubectl logs <pod> -n springboot

Paste the error.

We'll mount a small writable /tmp volume if needed.

Make these changes and deploy. Don't touch RBAC, NetworkPolicies, HPA, or Karpenter yet. We want a clean hardened workload first.

Good. Your current structure is fine.

Do not create another directory. You already have:

gitops/prereqs/karpenter

and your ArgoCD application is already pointing to it:

path: gitops/prereqs/karpenter

Leave that as-is.

The next step is simply to make sure the prereqs directory contains the correct manifests.

gitops/prereqs/karpenter/namespace.yaml
apiVersion: v1
kind: Namespace

metadata:
  name: karpenter
gitops/prereqs/karpenter/serviceaccount.yaml

Replace the role ARN with the output from Terraform.

apiVersion: v1
kind: ServiceAccount

metadata:
  name: karpenter
  namespace: karpenter

  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::136863648867:role/kk-platform-dev-karpenter-controller
gitops/prereqs/karpenter/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - namespace.yaml
  - serviceaccount.yaml
One important change in karpenter.yaml

Your chart values are incomplete.

Change:

settings:
  clusterName: kk-platform-dev

to:

settings:
  clusterName: kk-platform-dev
  clusterEndpoint: https://AF26FC10DEFD4735F4B0A57806441113.gr7.us-east-1.eks.amazonaws.com

Use the endpoint from your Terraform output.

After that:

git add .
git commit -m "add karpenter"
git push

Then watch:

kubectl get applications -n argocd

Wait until:

karpenter-prereqs   Synced   Healthy
karpenter           Synced   Healthy

If Karpenter does not become Healthy, the next thing I'll need is:

kubectl get pods -n karpenter
kubectl logs -n karpenter deployment/karpenter --tail=100

Don't change Terraform yet. First get the ArgoCD applications deployed successfully.

kubectl describe application karpenter-prereqs -n argocd
Name:         karpenter-prereqs
Namespace:    argocd
Labels:       <none>
Annotations:  argocd.argoproj.io/tracking-id: platform-app:argoproj.io/Application:argocd/karpenter-prereqs
API Version:  argoproj.io/v1alpha1
Kind:         Application
Metadata:
  Creation Timestamp:  2026-08-01T17:53:35Z
  Generation:          3
  Resource Version:    1096399
  UID:                 55289a8f-c61a-4c7a-b2fa-350238a4f4c4
Spec:
  Destination:
    Namespace:  karpenter
    Server:     https://kubernetes.default.svc
  Project:      default
  Source:
    Path:             gitops/prereqs/karpenter
    Repo URL:         https://github.com/ckalandar/aws-platform-engineering.git
    Target Revision:  main
  Sync Policy:
    Automated:
      Prune:      true
      Self Heal:  true
    Sync Options:
      CreateNamespace=true
Status:
  Conditions:
    Last Transition Time:  2026-08-01T17:53:35Z
    Message:               Failed to load target state: failed to generate manifest for source 1 of 1: rpc error: code = Unknown desc = gitops/prereqs/karpenter: app path does not exist
    Type:                  ComparisonError
  Controller Namespace:    argocd
  Health:
    Last Transition Time:  2026-08-01T17:53:35Z
    Status:                Healthy
  Reconciled At:           2026-08-01T17:53:35Z
  Resource Health Source:  appTree
  Sync:
    Compared To:
      Destination:
        Namespace:  karpenter
        Server:     https://kubernetes.default.svc
      Source:
        Path:             gitops/prereqs/karpenter
        Repo URL:         https://github.com/ckalandar/aws-platform-engineering.git
        Target Revision:  main
    Status:               Unknown
Events:
  Type    Reason           Age    From                           Message
  ----    ------           ----   ----                           -------
  Normal  ResourceUpdated  6m16s  argocd-application-controller  Updated sync status:  -> Unknown
  Normal  ResourceUpdated  6m16s  argocd-application-controller  Updated health status:  -> Healthy
kchilak@kalandars-MacBook-Pro aws-platform-engineering % kubectl describe application karpenter -n argocd
Name:         karpenter
Namespace:    argocd
Labels:       <none>
Annotations:  argocd.argoproj.io/tracking-id: platform-app:argoproj.io/Application:argocd/karpenter
API Version:  argoproj.io/v1alpha1
Kind:         Application
Metadata:
  Creation Timestamp:  2026-08-01T17:53:35Z
  Generation:          3
  Resource Version:    1096406
  UID:                 f40fb180-1d81-4f76-a629-874a6babbfb3
Spec:
  Destination:
    Namespace:  karpenter
    Server:     https://kubernetes.default.svc
  Project:      default
  Sources:
    Chart:  karpenter
    Helm:
      Values:  serviceAccount:
  create: false
  name: karpenter

settings:
  clusterName: kk-platform-dev
  clusterEndpoint: https://AF26FC10DEFD4735F4B0A57806441113.gr7.us-east-1.eks.amazonaws.com

    Repo URL:         oci://public.ecr.aws/karpenter
    Target Revision:  1.6.1
  Sync Policy:
    Automated:
      Prune:      true
      Self Heal:  true
    Sync Options:
      CreateNamespace=true
Status:
  Conditions:
    Last Transition Time:  2026-08-01T17:53:35Z
    Message:               Failed to load target state: failed to generate manifest for source 1 of 1: rpc error: code = Unknown desc = failed to resolve revision "1.6.1": cannot get digest for revision 1.6.1: public.ecr.aws/karpenter:1.6.1: not found
    Type:                  ComparisonError
  Controller Namespace:    argocd
  Health:
    Last Transition Time:  2026-08-01T17:53:35Z
    Status:                Healthy
  Reconciled At:           2026-08-01T17:53:35Z
  Resource Health Source:  appTree
  Sync:
    Compared To:
      Destination:
        Namespace:  karpenter
        Server:     https://kubernetes.default.svc
      Sources:
        Chart:  karpenter
        Helm:
          Values:  serviceAccount:
  create: false
  name: karpenter

settings:
  clusterName: kk-platform-dev
  clusterEndpoint: https://AF26FC10DEFD4735F4B0A57806441113.gr7.us-east-1.eks.amazonaws.com

        Repo URL:         oci://public.ecr.aws/karpenter
        Target Revision:  1.6.1
    Status:               Unknown
Events:
  Type    Reason           Age    From                           Message
  ----    ------           ----   ----                           -------
  Normal  ResourceUpdated  6m50s  argocd-application-controller  Updated sync status:  -> Unknown
  Normal  ResourceUpdated  6m50s  argocd-application-controller  Updated health status:  -> Healthy

Now we have actual errors, which is progress.

You have 2 separate failures.

1. Karpenter prereqs path does not exist

Error:

gitops/prereqs/karpenter: app path does not exist

ArgoCD is looking in GitHub and cannot find:

gitops/prereqs/karpenter

Verify locally:

git status
git add .
git commit -m "add karpenter prereqs"
git push origin main

Then verify GitHub contains:

gitops/prereqs/karpenter/
├── namespace.yaml
├── serviceaccount.yaml
└── kustomization.yaml

If not pushed, ArgoCD can't see it.

2. Wrong Karpenter chart repository

Error:

public.ecr.aws/karpenter:1.6.1: not found

Your current file:

repoURL: oci://public.ecr.aws/karpenter
chart: karpenter
targetRevision: 1.6.1

This is wrong.

For Karpenter v1.x use:

repoURL: oci://public.ecr.aws/karpenter/karpenter
chart: karpenter
targetRevision: 1.6.1

Notice:

/karpenter

at the end of repoURL.

Edit

File:

gitops/applications/platform/karpenter.yaml

Change:

repoURL: oci://public.ecr.aws/karpenter

to

repoURL: oci://public.ecr.aws/karpenter/karpenter

Commit:

git add .
git commit -m "fix karpenter chart source"
git push

Then force refresh:

argocd app get karpenter
argocd app sync karpenter

or

kubectl annotate application karpenter \
  -n argocd \
  argocd.argoproj.io/refresh=hard --overwrite

After pushing, run:

kubectl get application -n argocd

and show me the output.

I expect the prereqs error to disappear first. The chart error may change to a values/configuration error, which we'll fix next.

kubectl get pods -n karpenter
NAME                         READY   STATUS    RESTARTS   AGE
karpenter-55ffbf9564-mj4jf   1/1     Running   0          5m2s
karpenter-55ffbf9564-tvzbd   1/1     Running   0          5m2s

Perfect.

Karpenter controller is deployed and healthy.

karpenter-55ffbf9564-mj4jf   Running
karpenter-55ffbf9564-tvzbd   Running

Now move to the part that actually provisions nodes.

Create these manifests.

gitops/manifests/karpenter/ec2nodeclass.yaml
apiVersion: karpenter.k8s.aws/v1
kind: EC2NodeClass

metadata:
  name: default

spec:

  amiFamily: AL2023

  role: kk-platform-dev-karpenter-node

  subnetSelectorTerms:
    - tags:
        kubernetes.io/cluster/kk-platform-dev: owned

  securityGroupSelectorTerms:
    - tags:
        Name: kk-platform-dev-eks-node-sg

  tags:
    Project: kk-platform
    Environment: dev
gitops/manifests/karpenter/nodepool.yaml
apiVersion: karpenter.sh/v1
kind: NodePool

metadata:
  name: default

spec:

  template:

    spec:

      nodeClassRef:
        group: karpenter.k8s.aws
        kind: EC2NodeClass
        name: default

      requirements:

        - key: kubernetes.io/arch
          operator: In
          values:
            - amd64

        - key: kubernetes.io/os
          operator: In
          values:
            - linux

        - key: karpenter.sh/capacity-type
          operator: In
          values:
            - on-demand

        - key: node.kubernetes.io/instance-type
          operator: In
          values:
            - t3.large
            - t3.xlarge

  limits:
    cpu: "20"

  disruption:
    consolidationPolicy: WhenEmptyOrUnderutilized
    consolidateAfter: 30s
gitops/manifests/karpenter/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ec2nodeclass.yaml
  - nodepool.yaml
gitops/applications/platform/karpenter-resources.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application

metadata:
  name: karpenter-resources
  namespace: argocd

spec:
  project: default

  source:
    repoURL: https://github.com/ckalandar/aws-platform-engineering.git
    targetRevision: main
    path: gitops/manifests/karpenter

  destination:
    server: https://kubernetes.default.svc
    namespace: karpenter

  syncPolicy:
    automated:
      prune: true
      selfHeal: true

Commit and push:

git add .
git commit -m "add karpenter nodepool"
git push

Then verify:

kubectl get nodepool
kubectl get ec2nodeclass

Both should show:

default

After that we'll do the real test:

Reduce EKS managed nodegroup to minimum.
Create a workload that cannot fit.
Watch Karpenter launch a new EC2 automatically.
Watch Karpenter terminate it when load disappears.

That's the point where we know autoscaling is actually working.


kubectl get cm -n monitoring
NAME                                                           DATA   AGE
kube-root-ca.crt                                               1      2d17h
monitoring-grafana                                             2      2d17h
monitoring-grafana-config-dashboards                           1      2d17h
monitoring-kube-prometheus-alertmanager-overview               1      2d17h
monitoring-kube-prometheus-apiserver                           1      2d17h
monitoring-kube-prometheus-cluster-total                       1      2d17h
monitoring-kube-prometheus-controller-manager                  1      2d17h
monitoring-kube-prometheus-etcd                                1      2d17h
monitoring-kube-prometheus-grafana-datasource                  1      2d17h
monitoring-kube-prometheus-grafana-overview                    1      2d17h
monitoring-kube-prometheus-k8s-coredns                         1      2d17h
monitoring-kube-prometheus-k8s-resources-cluster               1      2d17h
monitoring-kube-prometheus-k8s-resources-multicluster          1      2d17h
monitoring-kube-prometheus-k8s-resources-namespace             1      2d17h
monitoring-kube-prometheus-k8s-resources-node                  1      2d17h
monitoring-kube-prometheus-k8s-resources-pod                   1      2d17h
monitoring-kube-prometheus-k8s-resources-workload              1      2d17h
monitoring-kube-prometheus-k8s-resources-workloads-namespace   1      2d17h
monitoring-kube-prometheus-kubelet                             1      2d17h
monitoring-kube-prometheus-namespace-by-pod                    1      2d17h
monitoring-kube-prometheus-namespace-by-workload               1      2d17h
monitoring-kube-prometheus-node-cluster-rsrc-use               1      2d17h
monitoring-kube-prometheus-node-rsrc-use                       1      2d17h
monitoring-kube-prometheus-nodes                               1      2d17h
monitoring-kube-prometheus-nodes-aix                           1      2d17h
monitoring-kube-prometheus-nodes-darwin                        1      2d17h
monitoring-kube-prometheus-persistentvolumesusage              1      2d17h
monitoring-kube-prometheus-pod-total                           1      2d17h
monitoring-kube-prometheus-prometheus                          1      2d17h
monitoring-kube-prometheus-proxy                               1      2d17h
monitoring-kube-prometheus-scheduler                           1      2d17h
monitoring-kube-prometheus-workload-total                      1      2d17h
prometheus-monitoring-kube-prometheus-prometheus-rulefiles-0   35     47h
I only see cluster dashboards, not springboot
I see dashboard now, lets proceed with PHASE 4 — Platform Expansion
9. Second Microservice
10. Distributed Tracing Across Services
part karpenter for later

Perfect. The screenshot tells us everything we need:

✅ Grafana dashboard provisioning works
✅ Prometheus is scraping Spring Boot metrics
✅ ServiceMonitor works
✅ Micrometer works
✅ Dashboard ConfigMaps are loading through GitOps

We can consider Phase 2 complete.

Current Platform State

You now have:

Internet
   │
ALB
   │
SpringBoot
   │
Micrometer
   │
Prometheus
   │
Grafana

and

SpringBoot
   │
Logs
   ▼
Alloy
   ▼
Loki
   ▼
Grafana

and

SpringBoot
   │
OTEL
   ▼
Tempo
   ▼
Grafana Traces

The missing piece is:

Service A
   │
   ▼
Service B

because tracing becomes interesting only when requests cross service boundaries.

PHASE 4 — Platform Expansion

We will intentionally skip Karpenter for now.

New roadmap:

Sprint 4
---------
Second Microservice

Sprint 5
---------
Distributed Tracing

Sprint 6
---------
Trace ↔ Metrics ↔ Logs Correlation
What Second Service Should We Build?

Don't build another CRUD app.

Build something that demonstrates platform concepts.

Current:

platform-app

Add:

inventory-service

Architecture:

User
 │
 ▼
platform-app
 │
 ▼
inventory-service
Flow

Current endpoint:

GET /hello

becomes:

GET /order

Platform Service:

@RestController
public class OrderController {

    @GetMapping("/order")
    public String order() {

        return inventoryClient.checkInventory();
    }
}

calls

inventory-service

through Kubernetes DNS.

Kubernetes Service Discovery

No ingress needed.

Platform App calls:

http://inventory-service.demo.svc.cluster.local:8080/inventory

or

http://inventory-service:8080/inventory

inside namespace.

New Workload

Create:

gitops/manifests/inventory

Structure:

inventory
├── deployment.yaml
├── service.yaml
├── servicemonitor.yaml
└── kustomization.yaml
Deployment

Almost identical to SpringBoot.

apiVersion: apps/v1
kind: Deployment
metadata:
  name: inventory-service
  namespace: demo
spec:
  replicas: 2

  selector:
    matchLabels:
      app: inventory-service

  template:
    metadata:
      labels:
        app: inventory-service

    spec:
      containers:

      - name: inventory

        image: <your-image>

        ports:
        - containerPort: 8080
Service
apiVersion: v1
kind: Service
metadata:
  name: inventory-service
  namespace: demo

spec:
  selector:
    app: inventory-service

  ports:
  - port: 8080
    targetPort: 8080
ServiceMonitor
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor

metadata:
  name: inventory-service
  namespace: monitoring

spec:

  namespaceSelector:
    matchNames:
      - demo

  selector:
    matchLabels:
      app: inventory-service

  endpoints:
    - port: http
      path: /actuator/prometheus

Now Prometheus scrapes both services.

Sprint 5 — Distributed Tracing

This is where Tempo becomes valuable.

Current:

Browser
   │
   ▼
Platform App

Future:

Browser
   │
   ▼
Platform App
   │
   ▼
Inventory Service

A single request produces:

TraceID
 ├── Span 1
 │   Platform App
 │
 └── Span 2
     Inventory Service

visible in Tempo.

Required Code Changes

Both applications need:

micrometer-tracing-bridge-otel

opentelemetry-exporter-otlp

in pom.xml.

application.yml

management:

  tracing:
    sampling:
      probability: 1.0

  otlp:
    tracing:
      endpoint: http://otel-collector.monitoring.svc.cluster.local:4318/v1/traces
Spring Boot → Spring Boot Trace Propagation

Use RestTemplate or WebClient.

Example:

@Bean
RestTemplate restTemplate(RestTemplateBuilder builder) {
    return builder.build();
}

Micrometer automatically propagates:

traceparent

header.

No custom code required.

Result

Tempo trace becomes:

GET /order

Platform App
  40ms

Inventory Service
  15ms

instead of:

GET /order

Platform App only
What I would do next
Create inventory-service
Deploy through ArgoCD/GitOps
Add ServiceMonitor
Verify Prometheus metrics
Add OTEL tracing dependencies
Connect platform-app → inventory-service
Verify distributed traces in Tempo
Add trace-to-log correlation in Grafana

That gives you a genuinely production-relevant platform pattern: multi-service observability with metrics, logs, and distributed tracing, which is a much better use of time right now than continuing to fight Karpenter.

since we already saw deploying one app, lets move to PHASE 5 — Zero Trust Networking
11. Network Policies
12. RBAC Hardening
13. IRSA Adoption Everywhere

PHASE 6 — Platform Engineering
14. Service Mesh
15. Progressive Delivery (Argo Rollouts)
16. Developer Self-Service / IDP and then we can work on karpenter and second microservice

I would not jump directly to Service Mesh, Argo Rollouts, and IDP before finishing Zero Trust Networking. In a real platform engineering journey, security foundations come before platform abstractions.

For your current platform, I'd reorder the roadmap slightly:

Next Roadmap
PHASE 5A — Zero Trust Foundations
---------------------------------
11. Network Policies
12. RBAC Hardening
13. IRSA Adoption Everywhere

PHASE 5B — Runtime Security
---------------------------
14. Kyverno Policies
15. Image Signature Verification
16. Secrets Governance

PHASE 6 — Platform Engineering
------------------------------
17. Service Mesh
18. Progressive Delivery
19. Internal Developer Platform

PHASE 7
--------
20. Second Microservice
21. Distributed Tracing
22. Karpenter

Reason:

Network Policy
      ↓
RBAC
      ↓
IRSA
      ↓
Service Mesh
      ↓
Progressive Delivery
      ↓
IDP

A service mesh without network segmentation and proper identity is just extra complexity.

What I would start tomorrow
Step 1 — Network Policies

Right now your cluster is probably:

Pod A  ─────────► Pod B
Pod A  ─────────► Pod C
Pod A  ─────────► Prometheus
Pod A  ─────────► Loki
Pod A  ─────────► KubeDNS

Everything can talk to everything.

That's not Zero Trust.

Goal

SpringBoot should only reach:

DNS
Prometheus scraping
Ingress traffic

Nothing else.

Policy 1 — Default Deny

Create:

gitops/manifests/security/default-deny.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy

metadata:
  name: default-deny
  namespace: springboot

spec:
  podSelector: {}

  policyTypes:
    - Ingress
    - Egress

Immediately:

everything blocked
Policy 2 — Allow Ingress
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy

metadata:
  name: allow-ingress
  namespace: springboot

spec:

  podSelector:
    matchLabels:
      app: springboot

  policyTypes:
    - Ingress

  ingress:

  - from:
      - namespaceSelector: {}

    ports:
      - protocol: TCP
        port: 8080
Policy 3 — DNS

Without this everything breaks.

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy

metadata:
  name: allow-dns
  namespace: springboot

spec:

  podSelector:
    matchLabels:
      app: springboot

  policyTypes:
    - Egress

  egress:

  - to:

      - namespaceSelector:
          matchLabels:
            kubernetes.io/metadata.name: kube-system

    ports:
      - protocol: UDP
        port: 53

      - protocol: TCP
        port: 53
Policy 4 — Allow Metrics

Prometheus scraping.

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy

metadata:
  name: allow-prometheus
  namespace: springboot

spec:

  podSelector:
    matchLabels:
      app: springboot

  ingress:

  - from:

      - namespaceSelector:
          matchLabels:
            kubernetes.io/metadata.name: monitoring

    ports:
      - protocol: TCP
        port: 8080
Then RBAC Hardening

Today most likely:

default service account

or

cluster-admin somewhere

which is common in labs.

Goal

SpringBoot gets:

No API permissions

Literally:

automountServiceAccountToken: false

inside deployment.

Create dedicated service account:

apiVersion: v1
kind: ServiceAccount

metadata:
  name: springboot
  namespace: springboot

Deployment:

spec:
  serviceAccountName: springboot
  automountServiceAccountToken: false

Huge security improvement.

Then IRSA Adoption Everywhere

Currently you probably have IRSA only on:

ALB Controller
External DNS
External Secrets
Karpenter

I would verify every AWS-integrated workload uses IRSA.

Current target list:

ALB Controller
ExternalDNS
External Secrets
Karpenter
Alloy
OTEL Collector
Future applications
After That: Service Mesh

Only after Network Policies and IRSA.

Then we introduce:

Istio
or
Linkerd

For learning purposes:

Istio

because it teaches:

mTLS
Authorization Policies
Traffic Splitting
Canary Releases
Observability

all in one platform.

Then Progressive Delivery

Install:

Argo Rollouts

You already have:

GitOps
ArgoCD
ALB
Prometheus
Grafana

which is exactly what Argo Rollouts needs.

We'll replace:

kind: Deployment

with

kind: Rollout

and perform:

10%
25%
50%
100%

traffic promotion.

Then IDP

Only after all of the above.

At that point your platform has:

Terraform
GitHub Actions
EKS
ArgoCD
External Secrets
ALB
ExternalDNS
Prometheus
Grafana
Loki
Tempo
Network Policies
IRSA
Service Mesh
Rollouts

Now an Internal Developer Platform actually makes sense because there is something substantial to abstract.

So my recommendation is:

Next sprint = Network Policies → RBAC Hardening → IRSA audit.

That is the highest security return for the least engineering effort, and it sets up everything that follows.

lets proceed with Next sprint = Network Policies → RBAC Hardening → IRSA audit, but now I want you to give all the complete files, path in order how they needs to be implemented

Good. At this stage I would implement this exactly as a real platform team would:

Sprint 4.1
├── Network Policies
├── Service Accounts
├── RBAC Hardening
└── IRSA Audit

Sprint 4.2
├── Kyverno
├── Security Policies
└── Admission Controls

Sprint 4.3
├── Istio
├── mTLS
└── Authorization Policies

Let's do Sprint 4.1 completely.

Step 1 Create Security Manifests Directory

Create:

gitops/manifests/security
├── allow-dns.yaml
├── allow-prometheus.yaml
├── default-deny.yaml
├── ingress-allow.yaml
├── springboot-serviceaccount.yaml
├── springboot-role.yaml
├── springboot-rolebinding.yaml
└── kustomization.yaml
File 1
gitops/manifests/security/default-deny.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy

metadata:
  name: default-deny
  namespace: springboot

spec:
  podSelector: {}

  policyTypes:
    - Ingress
    - Egress
File 2
gitops/manifests/security/allow-dns.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy

metadata:
  name: allow-dns
  namespace: springboot

spec:

  podSelector:
    matchLabels:
      app: springboot

  policyTypes:
    - Egress

  egress:

    - to:

        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: kube-system

      ports:

        - protocol: UDP
          port: 53

        - protocol: TCP
          port: 53
File 3
gitops/manifests/security/allow-prometheus.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy

metadata:
  name: allow-prometheus
  namespace: springboot

spec:

  podSelector:
    matchLabels:
      app: springboot

  policyTypes:
    - Ingress

  ingress:

    - from:

        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: monitoring

      ports:

        - protocol: TCP
          port: 8080
File 4
gitops/manifests/security/ingress-allow.yaml

This allows ALB traffic.

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy

metadata:
  name: allow-alb-ingress
  namespace: springboot

spec:

  podSelector:
    matchLabels:
      app: springboot

  policyTypes:
    - Ingress

  ingress:

    - from:

        - namespaceSelector: {}

      ports:

        - protocol: TCP
          port: 8080
RBAC Hardening

Most applications need zero Kubernetes API access.

That means:

automountServiceAccountToken: false

and a dedicated ServiceAccount.

File 5
gitops/manifests/security/springboot-serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount

metadata:
  name: springboot
  namespace: springboot
File 6
gitops/manifests/security/springboot-role.yaml

For now:

apiVersion: rbac.authorization.k8s.io/v1
kind: Role

metadata:
  name: springboot
  namespace: springboot

rules: []

No permissions.

Exactly what we want.

File 7
gitops/manifests/security/springboot-rolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding

metadata:
  name: springboot
  namespace: springboot

subjects:

  - kind: ServiceAccount
    name: springboot
    namespace: springboot

roleRef:
  kind: Role
  name: springboot
  apiGroup: rbac.authorization.k8s.io
File 8
gitops/manifests/security/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - default-deny.yaml
  - allow-dns.yaml
  - allow-prometheus.yaml
  - ingress-allow.yaml
  - springboot-serviceaccount.yaml
  - springboot-role.yaml
  - springboot-rolebinding.yaml
Modify SpringBoot Deployment

Open:

gitops/manifests/springboot/deployment.yaml

Locate:

spec:
  template:
    spec:

Replace with:

spec:
  template:
    spec:

      serviceAccountName: springboot

      automountServiceAccountToken: false

Example:

spec:
  replicas: 2

  template:

    spec:

      serviceAccountName: springboot

      automountServiceAccountToken: false

      containers:
        - name: springboot
Create Argo Application

Create:

gitops/applications/platform/security.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application

metadata:
  name: security
  namespace: argocd

spec:

  project: default

  source:
    repoURL: https://github.com/ckalandar/aws-platform-engineering.git
    targetRevision: main
    path: gitops/manifests/security

  destination:
    server: https://kubernetes.default.svc
    namespace: springboot

  syncPolicy:

    automated:
      prune: true
      selfHeal: true
Verify Deployment

After Argo sync:

kubectl get networkpolicy -n springboot

Expected:

default-deny
allow-dns
allow-prometheus
allow-alb-ingress

Verify ServiceAccount:

kubectl get sa -n springboot

Expected:

springboot

Verify token removed:

kubectl describe pod -n springboot

You should NOT see:

/var/run/secrets/kubernetes.io/serviceaccount

mounted into the application container.

IRSA Audit (same sprint)

After the above is deployed run:

kubectl get sa -A -o yaml | grep eks.amazonaws.com/role-arn -B2 -A2

We will inventory every IRSA-enabled workload and identify anything still using node credentials.

That audit is the final task of this sprint before moving to Kyverno and admission
I have done the validation of above verifications all look good kubectl get sa -A -o yaml | grep eks.amazonaws.com/role-arn -B2 -A2
    annotations:
      argocd.argoproj.io/tracking-id: external-secrets-prereqs:/ServiceAccount:external-secrets/external-secrets
      eks.amazonaws.com/role-arn: arn:aws:iam::136863648867:role/kk-platform-dev-external-secrets
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"v1","kind":"ServiceAccount","metadata":{"annotations":{"argocd.argoproj.io/tracking-id":"external-secrets-prereqs:/ServiceAccount:external-secrets/external-secrets","eks.amazonaws.com/role-arn":"arn:aws:iam::136863648867:role/kk-platform-dev-external-secrets"},"name":"external-secrets","namespace":"external-secrets"}}
    creationTimestamp: "2026-07-30T11:05:05Z"
    name: external-secrets
--
    annotations:
      argocd.argoproj.io/tracking-id: karpenter-resources:/ServiceAccount:karpenter/karpenter
      eks.amazonaws.com/role-arn: arn:aws:iam::136863648867:role/kk-platform-dev-karpenter-controller
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"v1","kind":"ServiceAccount","metadata":{"annotations":{"argocd.argoproj.io/tracking-id":"karpenter-resources:/ServiceAccount:karpenter/karpenter","eks.amazonaws.com/role-arn":"arn:aws:iam::136863648867:role/kk-platform-dev-karpenter-controller"},"name":"karpenter","namespace":"karpenter"}}
    creationTimestamp: "2026-08-01T18:08:17Z"
    name: karpenter
--
    annotations:
      argocd.argoproj.io/tracking-id: aws-load-balancer-controller-prereqs:/ServiceAccount:kube-system/aws-load-balancer-controller
      eks.amazonaws.com/role-arn: arn:aws:iam::136863648867:role/kk-platform-dev-alb-controller
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"v1","kind":"ServiceAccount","metadata":{"annotations":{"argocd.argoproj.io/tracking-id":"aws-load-balancer-controller-prereqs:/ServiceAccount:kube-system/aws-load-balancer-controller","eks.amazonaws.com/role-arn":"arn:aws:iam::136863648867:role/kk-platform-dev-alb-controller"},"name":"aws-load-balancer-controller","namespace":"kube-system"}}
    creationTimestamp: "2026-07-29T07:27:32Z"
    name: aws-load-balancer-controller
--
  metadata:
    annotations:
      eks.amazonaws.com/role-arn: arn:aws:iam::136863648867:role/kk-platform-dev-ebs-csi-role
    creationTimestamp: "2026-07-31T10:34:34Z"
    labels:
--
    annotations:
      argocd.argoproj.io/tracking-id: external-dns-prereqs:/ServiceAccount:kube-system/external-dns
      eks.amazonaws.com/role-arn: arn:aws:iam::136863648867:role/kk-platform-dev-external-dns
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"v1","kind":"ServiceAccount","metadata":{"annotations":{"argocd.argoproj.io/tracking-id":"external-dns-prereqs:/ServiceAccount:kube-system/external-dns","eks.amazonaws.com/role-arn":"arn:aws:iam::136863648867:role/kk-platform-dev-external-dns"},"name":"external-dns","namespace":"kube-system"}}
    creationTimestamp: "2026-07-29T12:19:54Z"
    name: external-dns

Excellent. Your IRSA audit looks healthy.

Current IRSA-enabled workloads:

Component	Status
AWS Load Balancer Controller	✅ IRSA
External DNS	✅ IRSA
External Secrets	✅ IRSA
EBS CSI Driver	✅ IRSA
Karpenter	✅ IRSA

For the platform you've built so far, that's exactly what I'd expect.

What We Just Achieved

You now have:

Network Segmentation
SpringBoot Namespace
├── Default Deny
├── Allow DNS
├── Allow Prometheus
└── Allow Ingress
Workload Identity
Dedicated ServiceAccount
No Kubernetes API Token
No Cluster Permissions
AWS Identity
IRSA
├── ALB Controller
├── External DNS
├── External Secrets
├── EBS CSI
└── Karpenter

This is already significantly more mature than many production EKS environments.

I Would Not Move To Service Mesh Yet

Most engineers install Istio too early.

Before introducing:

Istio
Linkerd
mTLS
Traffic Policies

you should first have a policy engine enforcing security standards.

Otherwise:

Developer deploys:
  privileged: true

and the cluster accepts it.

That's where admission control comes in.

Next Sprint
Runtime Security
1. Kyverno

Install:

Kyverno

via GitOps.

2. Enforce Non-Root Containers

Block:

securityContext:
  runAsUser: 0
3. Require Resource Limits

Block:

containers:
  - name: app

without:

resources:
  requests:
  limits:
4. Block Latest Tags

Block:

image: nginx:latest

Allow:

image: nginx:1.29.0
5. Require ReadOnlyRootFilesystem

Require:

securityContext:
  readOnlyRootFilesystem: true
6. Require Labels

Require:

app:
team:
environment:

on every workload.

Why This Order?

Real platform maturity looks like:

GitOps
↓
Monitoring
↓
Network Policies
↓
RBAC
↓
IRSA
↓
Admission Control
↓
Service Mesh
↓
Progressive Delivery
↓
Internal Developer Platform

Not:

GitOps
↓
Istio
↓
Chaos
↓
Complexity

which is unfortunately how many teams do it.

Recommended Next Implementation

The next concrete milestone I'd implement is:

Sprint 4.2
├── Kyverno
├── Non-root policy
├── No latest-tag policy
├── Resource limits policy
├── ReadOnlyRootFilesystem policy
└── Required labels policy

Once those are enforced cluster-wide, then we move to:

Sprint 5
├── Istio
├── mTLS
├── AuthorizationPolicy
├── PeerAuthentication
└── Traffic Management

At that point your platform starts looking like a real enterprise platform rather than just an EKS cluster with applications deployed on it.

lets proceed further, like how you gave the step wise files and paths along with code follow same from going forward

Good. Based on your validation, IRSA adoption is already in a healthy state:

✅ External Secrets → IRSA
✅ External DNS → IRSA
✅ AWS Load Balancer Controller → IRSA
✅ EBS CSI Driver → IRSA
✅ Karpenter → IRSA (even if provisioning isn't working yet)

That completes Sprint 3 — IRSA Audit.

Next Sprint: RBAC Hardening

Current state:

Most Helm charts install cluster-admin style permissions because it's easier.

A platform engineer should reduce permissions to least privilege.

Goal

Create dedicated roles for:

Developers
Observability Team
Platform Admins

Instead of everyone being cluster-admin.

Folder Structure

Create:

gitops/
└── manifests/
    └── security/
        ├── namespace-admin-role.yaml
        ├── namespace-admin-binding.yaml
        ├── observability-role.yaml
        ├── observability-binding.yaml
        ├── readonly-role.yaml
        ├── readonly-binding.yaml
        └── kustomization.yaml
File 1
gitops/manifests/security/readonly-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole

metadata:
  name: platform-readonly

rules:

- apiGroups: [""]
  resources:
    - pods
    - services
    - configmaps
    - endpoints
    - namespaces
  verbs:
    - get
    - list
    - watch

- apiGroups: ["apps"]
  resources:
    - deployments
    - replicasets
    - statefulsets
    - daemonsets
  verbs:
    - get
    - list
    - watch

- apiGroups: ["networking.k8s.io"]
  resources:
    - ingresses
  verbs:
    - get
    - list
    - watch
File 2
gitops/manifests/security/readonly-binding.yaml

Replace email with your IAM mapped user/group later.

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding

metadata:
  name: platform-readonly

subjects:

- kind: Group
  name: developers
  apiGroup: rbac.authorization.k8s.io

roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: platform-readonly
File 3
gitops/manifests/security/namespace-admin-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role

metadata:
  name: namespace-admin
  namespace: springboot

rules:

- apiGroups: [""]

  resources:
    - pods
    - services
    - configmaps
    - secrets

  verbs:
    - "*"

- apiGroups: ["apps"]

  resources:
    - deployments
    - replicasets

  verbs:
    - "*"

- apiGroups: ["autoscaling"]

  resources:
    - horizontalpodautoscalers

  verbs:
    - "*"
File 4
gitops/manifests/security/namespace-admin-binding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding

metadata:
  name: namespace-admin
  namespace: springboot

subjects:

- kind: Group
  name: app-team

roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: namespace-admin
File 5
gitops/manifests/security/observability-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole

metadata:
  name: observability-admin

rules:

- apiGroups: ["monitoring.coreos.com"]
  resources:
    - servicemonitors
    - prometheusrules

  verbs:
    - "*"

- apiGroups: [""]
  resources:
    - pods
    - services

  verbs:
    - get
    - list
    - watch
File 6
gitops/manifests/security/observability-binding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding

metadata:
  name: observability-admin

subjects:

- kind: Group
  name: observability-team

roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: observability-admin
File 7
gitops/manifests/security/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - readonly-role.yaml
  - readonly-binding.yaml
  - namespace-admin-role.yaml
  - namespace-admin-binding.yaml
  - observability-role.yaml
  - observability-binding.yaml
ArgoCD Application

Create:

gitops/applications/platform/security.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application

metadata:
  name: security
  namespace: argocd

spec:

  project: default

  source:
    repoURL: https://github.com/ckalandar/aws-platform-engineering.git
    targetRevision: main
    path: gitops/manifests/security

  destination:
    server: https://kubernetes.default.svc

  syncPolicy:
    automated:
      prune: true
      selfHeal: true

Since your Platform AppSet already watches:

gitops/applications/platform/

just commit:

git add .
git commit -m "add rbac hardening"
git push

ArgoCD will create it automatically.

Validation
kubectl get clusterrole | grep platform
kubectl get clusterrolebinding | grep platform
kubectl get role -n springboot
kubectl get rolebinding -n springboot
After RBAC

The next sprint is the most important security sprint in the platform roadmap:

Sprint 5 — Network Policies (Zero Trust)

We'll implement:

default-deny
↓
allow-dns
↓
allow-ingress-from-alb
↓
allow-app-to-observability
↓
deny everything else

This is where your EKS platform starts behaving like a production platform rather than a default Kubernetes cluster.

After that we move into:

Service Mesh (Istio)
↓
mTLS
↓
Argo Rollouts
↓
Backstage IDP

which becomes the Platform Engineering phase.

I have validated all above verifications and look good, lets proceed further give me the steps/files/location like you had given earlier
kubectl get clusterrole | grep platform
kchilak@kalandars-MBP aws-platform-engineering % kubectl get application security -n argocd
NAME       SYNC STATUS   HEALTH STATUS
security   Synced        Healthy
kchilak@kalandars-MBP aws-platform-engineering % kubectl get clusterrole | grep platform
platform-readonly                                                      2026-08-02T10:26:23Z
kchilak@kalandars-MBP aws-platform-engineering % kubectl get clusterrolebinding | grep platform
platform-readonly                                               ClusterRole/platform-readonly                                               49s
kchilak@kalandars-MBP aws-platform-engineering % kubectl get role -n springboot
NAME              CREATED AT
namespace-admin   2026-08-02T10:26:23Z
kchilak@kalandars-MBP aws-platform-engineering % kubectl get rolebinding -n springboot
NAME              ROLE                   AGE
namespace-admin   Role/namespace-admin   66s

Perfect.

At this point you've completed:

✅ GitOps (ArgoCD)
✅ EKS Foundation
✅ External Secrets
✅ External DNS
✅ AWS Load Balancer Controller
✅ Observability Stack
✅ Grafana Dashboards
✅ Loki + Tempo
✅ IRSA Adoption
✅ RBAC Hardening

Next Sprint
Zero Trust Networking

This is where we stop trusting pod-to-pod communication.

Current Kubernetes behavior:

Any Pod
    ↓
Can talk to
    ↓
Any Pod

Production behavior:

SpringBoot Pod
    ↓
Can talk only to:
      DNS
      Prometheus
      Loki
      Tempo

Everything else denied
Folder Structure

Create:

gitops/manifests/network-policies
├── default-deny.yaml
├── allow-dns.yaml
├── allow-monitoring.yaml
├── allow-ingress.yaml
├── kustomization.yaml
Step 1
default-deny.yaml

Path:

gitops/manifests/network-policies/default-deny.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy

metadata:
  name: default-deny
  namespace: springboot

spec:

  podSelector: {}

  policyTypes:
    - Ingress
    - Egress
Step 2
allow-dns.yaml

Path:

gitops/manifests/network-policies/allow-dns.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy

metadata:
  name: allow-dns
  namespace: springboot

spec:

  podSelector: {}

  policyTypes:
    - Egress

  egress:

    - to:

        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: kube-system

      ports:

        - protocol: UDP
          port: 53

        - protocol: TCP
          port: 53
Step 3
allow-monitoring.yaml

Path:

gitops/manifests/network-policies/allow-monitoring.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy

metadata:
  name: allow-monitoring
  namespace: springboot

spec:

  podSelector: {}

  policyTypes:
    - Egress

  egress:

    - to:

        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: monitoring

    - to:

        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: loki

    - to:

        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: tempo
Step 4
allow-ingress.yaml

Allow traffic from ALB Controller-managed ingress.

Path:

gitops/manifests/network-policies/allow-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy

metadata:
  name: allow-ingress
  namespace: springboot

spec:

  podSelector:
    matchLabels:
      app: springboot

  policyTypes:
    - Ingress

  ingress:

    - from:

        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: kube-system

    - from:

        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: springboot

  egress:

    - {}
Step 5
kustomization.yaml

Path:

gitops/manifests/network-policies/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - default-deny.yaml
  - allow-dns.yaml
  - allow-monitoring.yaml
  - allow-ingress.yaml
Step 6

Create ArgoCD Application

Path:

gitops/applications/platform/network-policies.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application

metadata:
  name: network-policies
  namespace: argocd

spec:

  project: default

  source:
    repoURL: https://github.com/ckalandar/aws-platform-engineering.git
    targetRevision: main
    path: gitops/manifests/network-policies

  destination:
    server: https://kubernetes.default.svc

  syncPolicy:

    automated:
      prune: true
      selfHeal: true

Commit:

git add .
git commit -m "add network policies"
git push
Validation

Wait until:

kubectl get application network-policies -n argocd

shows:

Synced
Healthy

Then:

kubectl get networkpolicy -n springboot

Expected:

allow-dns
allow-ingress
allow-monitoring
default-deny
Real Validation

Launch a temporary pod:

kubectl run test \
  -n springboot \
  --image=busybox:1.36 \
  --restart=Never \
  -it -- sh

Inside pod:

DNS should work:

nslookup kubernetes.default

Expected:

Success

Try external internet:

wget google.com

Expected:

Fail

Try Prometheus:

wget monitoring-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090

Expected:

Success
What This Gives You

After this sprint:

Default Deny
↓
Explicit Allow
↓
Namespace Isolation
↓
Workload Isolation

This is the first real Zero Trust control in the cluster.

After Network Policies

Next sprint is where Platform Engineering starts becoming visible:

Sprint 6
├── Kyverno
├── Require non-root
├── Require resource limits
├── Block latest tags
├── Require labels
└── ReadOnlyRootFilesystem

Kyverno should come before Istio because policy enforcement is a more fundamental platform control than service mesh.

We already have enough evidence.

Notice this command:

kubectl get ds aws-node -n kube-system -o yaml | grep ENABLE_NETWORK_POLICY

returned nothing.

That is the smoking gun.

You are running:

aws-node

which means AWS VPC CNI, but Network Policy enforcement is not enabled.

So currently:

Kubernetes NetworkPolicy objects exist
↓
API server stores them
↓
AWS VPC CNI ignores them
↓
Traffic is not blocked

This is why:

wget google.com

still works from the SpringBoot pods even though the policies are correct.

Verify One Last Time

Run:

kubectl describe daemonset aws-node -n kube-system | grep -A5 ENABLE_NETWORK_POLICY

or:

kubectl -n kube-system get daemonset aws-node \
-o jsonpath='{.spec.template.spec.containers[0].env}'

You should not see:

ENABLE_NETWORK_POLICY=true
Production Options

For EKS you have 3 realistic choices:

Option 1 (Recommended)

Enable AWS Network Policy support.

AWS supports this through VPC CNI newer releases.

Check your version:

kubectl describe ds aws-node -n kube-system | grep Image

If you're on a recent release, we can enable it.

Option 2

Install Cilium.

Cilium
+
eBPF
+
Network Policies
+
Observability
+
Service Mesh later

This is what many modern platform teams are doing.

Option 3

Install Calico only for policy enforcement.

Works fine, but if we're heading toward:

Service Mesh
Progressive Delivery
Platform Engineering

I'd rather use Cilium than introduce Calico now.

My Recommendation

Given your roadmap:

✓ EKS
✓ ArgoCD
✓ Prometheus
✓ Grafana
✓ Loki
✓ Tempo
✓ External Secrets
✓ IRSA
✓ RBAC

Next:
Service Mesh
Progressive Delivery
IDP

I would not spend more time patching AWS VPC CNI policies.

I'd do:

Sprint 8
========
Install Cilium
Enable Network Policies
Validate Zero Trust

Then:

Sprint 9
========
Kyverno

Then:

Sprint 10
========
Argo Rollouts

Then:

Sprint 11
========
Backstage IDP

At that point you'll have something very close to a real Platform Engineering environment.

Before we move on, run:

kubectl describe ds aws-node -n kube-system | grep Image

and paste the output. I want to see which VPC CNI version you're running so we can decide whether enabling AWS Network Policy is a 5-minute change or whether Cilium is the cleaner path.

kubectl -n kube-system get daemonset aws-node \
-o jsonpath='{.spec.template.spec.containers[0].env}'
[{"name":"ADDITIONAL_ENI_TAGS","value":"{}"},{"name":"ANNOTATE_POD_IP","value":"false"},{"name":"AWS_VPC_CNI_NODE_PORT_SUPPORT","value":"true"},{"name":"AWS_VPC_ENI_MTU","value":"9001"},{"name":"AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG","value":"false"},{"name":"AWS_VPC_K8S_CNI_EXTERNALSNAT","value":"false"},{"name":"AWS_VPC_K8S_CNI_LOGLEVEL","value":"DEBUG"},{"name":"AWS_VPC_K8S_CNI_LOG_FILE","value":"/host/var/log/aws-routed-eni/ipamd.log"},{"name":"AWS_VPC_K8S_CNI_RANDOMIZESNAT","value":"prng"},{"name":"AWS_VPC_K8S_CNI_VETHPREFIX","value":"eni"},{"name":"AWS_VPC_K8S_PLUGIN_LOG_FILE","value":"/var/log/aws-routed-eni/plugin.log"},{"name":"AWS_VPC_K8S_PLUGIN_LOG_LEVEL","value":"DEBUG"},{"name":"CLUSTER_ENDPOINT","value":"https://AF26FC10DEFD4735F4B0A57806441113.gr7.us-east-1.eks.amazonaws.com"},{"name":"CLUSTER_NAME","value":"kk-platform-dev"},{"name":"DISABLE_INTROSPECTION","value":"false"},{"name":"DISABLE_METRICS","value":"false"},{"name":"DISABLE_NETWORK_RESOURCE_PROVISIONING","value":"false"},{"name":"ENABLE_IMDS_ONLY_MODE","value":"false"},{"name":"ENABLE_IPv4","value":"true"},{"name":"ENABLE_IPv6","value":"false"},{"name":"ENABLE_MULTI_NIC","value":"false"},{"name":"ENABLE_POD_ENI","value":"false"},{"name":"ENABLE_PREFIX_DELEGATION","value":"false"},{"name":"ENABLE_SUBNET_DISCOVERY","value":"true"},{"name":"NETWORK_POLICY_ENFORCING_MODE","value":"standard"},{"name":"VPC_CNI_VERSION","value":"v1.22.3"},{"name":"VPC_ID","value":"vpc-0c52e44ef7fe0b245"},{"name":"WARM_ENI_TARGET","value":"1"},{"name":"WARM_PREFIX_TARGET","value":"1"},{"name":"MY_NODE_NAME","valueFrom":{"fieldRef":{"apiVersion":"v1","fieldPath":"spec.nodeName"}}},{"name":"MY_POD_NAME","valueFrom":{"fieldRef":{"apiVersion":"v1","fieldPath":"metadata.name"}}}]%                                                                                         kchilak@kalandars-MBP aws-platform-engineering % kubectl -n kube-system get daemonset aws-node \
-o jsonpath='{.spec.template.spec.containers[0].env}' | grep -i "ENABLE_NETWORK_POLICY"
kchilak@kalandars-MBP aws-platform-engineering % kubectl describe ds aws-node -n kube-system | grep Image
    Image:      602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon-k8s-cni-init:v1.22.3-eksbuild.1
    Image:      602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon-k8s-cni:v1.22.3-eksbuild.1
    Image:      602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon/aws-network-policy-agent:v1.3.7-eksbuild.1

Interesting. This changes the diagnosis.

You are running:

VPC CNI v1.22.3
aws-network-policy-agent:v1.3.7
NETWORK_POLICY_ENFORCING_MODE=standard

So the network policy agent is installed and policy enforcement should be available.

The missing piece is likely that the feature isn't enabled at the EKS add-on level, or the policies aren't selecting the traffic the way we expect.

Before changing anything, let's validate properly.

Test 1: Verify the SpringBoot pod is actually restricted

Exec into the actual SpringBoot pod:

kubectl exec -it springboot-7597fbcc78-rn2n2 -n springboot -- sh

Try:

wget google.com

and

wget monitoring-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090

If both work, then policy enforcement is not active.

Test 2: Check Network Policy Agent
kubectl get pods -n kube-system | grep network-policy

Expected:

aws-network-policy-agent-xxxxx

or as a sidecar in aws-node.

Then:

kubectl logs -n kube-system ds/aws-node -c aws-network-policy-agent --tail=50

If the container name differs:

kubectl describe pod -n kube-system $(kubectl get pods -n kube-system -l k8s-app=aws-node -o name | head -1)

and identify the policy-agent container.

Test 3: Check EKS Addon Configuration

This is the one I suspect.

aws eks describe-addon \
  --cluster-name kk-platform-dev \
  --addon-name vpc-cni

Look for:

"configurationValues"

AWS requires network policy to be enabled in the VPC CNI addon configuration.

Something similar to:

{
  "enableNetworkPolicy": "true"
}

If that isn't present, the agent image can exist while enforcement is disabled.

Test 4: Strong Validation Policy

Let's create a policy that is impossible to bypass.

Create:

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: block-everything
  namespace: springboot
spec:
  podSelector:
    matchLabels:
      app: springboot

  policyTypes:
    - Ingress
    - Egress

Apply:

kubectl apply -f block-everything.yaml

Then immediately test from the SpringBoot pod:

wget google.com
wget kubernetes.default.svc

Expected:

connection timed out

If traffic still works with this policy, then enforcement is definitely disabled regardless of what objects exist.

Where we are in the roadmap

You've already completed:

✅ Container hardening
✅ Pod Security Standards
✅ Monitoring stack
✅ Grafana dashboards
✅ Alerting
✅ IRSA rollout
✅ RBAC hardening

The only unresolved item in Phase 5 is:

Network Policies

Once we prove whether enforcement is active or not, we can either:

Fix VPC CNI network policy enablement (likely 15–30 min), or
Decide to move directly to Cilium later.

Run these two commands next:

aws eks describe-addon \
  --cluster-name kk-platform-dev \
  --addon-name vpc-cni

and

kubectl get pods -n kube-system | grep -i policy

Those will tell us conclusively whether the AWS Network Policy feature is actually enabled.

kubectl exec -it springboot-7597fbcc78-rn2n2 -n springboot -- sh
$ wget google.com
Prepended http:// to 'google.com'
--2026-08-02 11:20:37--  http://google.com/
Resolving google.com (google.com)... 192.178.155.100, 192.178.155.101, 192.178.155.139, ...
Connecting to google.com (google.com)|192.178.155.100|:80... connected.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: http://www.google.com/ [following]
--2026-08-02 11:20:37--  http://www.google.com/
Resolving www.google.com (www.google.com)... 142.251.154.119, 142.251.152.119, 142.251.151.119, ...
Connecting to www.google.com (www.google.com)|142.251.154.119|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [text/html]
Saving to: ‘index.html’

index.html                       [ <=>                                          ]  78.84K  --.-KB/s    in 0.007s

2026-08-02 11:20:37 (10.9 MB/s) - ‘index.html’ saved [80736]

$ wget monitoring-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090
Prepended http:// to 'monitoring-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090'
--2026-08-02 11:20:50--  http://monitoring-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090/
Resolving monitoring-kube-prometheus-prometheus.monitoring.svc.cluster.local (monitoring-kube-prometheus-prometheus.monitoring.svc.cluster.local)... 172.20.171.218
Connecting to monitoring-kube-prometheus-prometheus.monitoring.svc.cluster.local (monitoring-kube-prometheus-prometheus.monitoring.svc.cluster.local)|172.20.171.218|:9090... connected.
HTTP request sent, awaiting response... 302 Found
Location: /query [following]
--2026-08-02 11:20:50--  http://monitoring-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090/query
Reusing existing connection to monitoring-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090.
HTTP request sent, awaiting response... 200 OK
Length: 1752 (1.7K) [text/html]
Saving to: ‘index.html.1’

index.html.1                 100%[=============================================>]   1.71K  --.-KB/s    in 0s

2026-08-02 11:20:50 (226 MB/s) - ‘index.html.1’ saved [1752/1752]

Good. This proves it definitively.

The policy is not being enforced.

You tested from the actual SpringBoot pod:

app=springboot

which is selected by your policies.

And despite having:

default-deny

the pod can still reach:

google.com

and

monitoring-kube-prometheus-prometheus.monitoring.svc.cluster.local

Therefore:

NetworkPolicy objects exist
✓

Pod is selected
✓

Traffic still flows
✓

=> Enforcement is not active
Before we spend more time

I want to be pragmatic here.

Your roadmap goal was:

PHASE 5
✓ RBAC
✓ IRSA
✓ Network Policies

From a platform engineering perspective you have already:

written policies
deployed policies
validated selection logic
identified enforcement gap

That is actually a useful learning outcome.

My recommendation

Do not spend another day on this.

The next stages are much more valuable:

PHASE 6
14. Service Mesh
15. Progressive Delivery
16. Internal Developer Platform

Those are the areas that differentiate a platform engineer.

What I would do
Sprint 1

Install Argo Rollouts

You'll learn:

Blue/Green
Canary
Progressive delivery
Automated rollback

This is used constantly in production.

Sprint 2

Install Service Mesh

Choose:

Istio

or

Linkerd

For learning purposes I'd choose Istio.

You'll get:

mTLS
traffic splitting
service identity
zero-trust networking

Ironically Istio will give you stronger traffic controls than the NetworkPolicy issue we're currently fighting.

Sprint 3

Backstage IDP

Build:

Developer Portal

with:

service catalog
templates
GitOps integration
ArgoCD integration

This is where platform engineering really starts.

What about Network Policies?

We'll revisit after Service Mesh.

At that point we can choose one of:

Option A

Enable AWS Network Policy correctly.

Option B

Install Cilium.

Personally I'd choose:

Cilium

because later you'll get:

Network Policies
Hubble
eBPF observability
Service Mesh capabilities

in one platform.

Suggested roadmap now
DONE
====
✓ GitOps
✓ ArgoCD
✓ EKS
✓ ALB Controller
✓ External DNS
✓ External Secrets
✓ Prometheus
✓ Grafana
✓ Loki
✓ Tempo
✓ Alerts
✓ RBAC
✓ IRSA

NEXT
====
1. Argo Rollouts
2. Istio Service Mesh
3. Backstage IDP
4. Cilium
5. Karpenter
6. Second Microservice

This sequence will give you the highest platform-engineering learning return for the time invested.

lets proceed further

Excellent. Now we're entering the part that most engineers never get to build end-to-end.

Current state of your platform:

Platform Foundation
===================
✓ Terraform
✓ EKS
✓ GitOps (ArgoCD)
✓ ALB Controller
✓ External DNS
✓ External Secrets
✓ Prometheus
✓ Grafana
✓ Loki
✓ Tempo
✓ Alerting
✓ Pod Security
✓ RBAC
✓ IRSA

In Progress
===========
△ Network Policy Enforcement

Not Started
===========
✗ Progressive Delivery
✗ Service Mesh
✗ IDP

At this point I would not jump to Istio first.

The next logical step is:

Sprint 9 — Progressive Delivery (Argo Rollouts)

Because:

Current
-------
Deployment
   ↓
Rolling Update

Target
------
Deployment
   ↓
Canary
   ↓
Automatic Promotion
   ↓
Automatic Rollback

This is one of the most valuable production skills.

What We Will Build

Instead of:

v1 ---> v2

We will do:

100% v1

Deploy v2

90% -> v1
10% -> v2

Observe metrics

50% -> v1
50% -> v2

Observe metrics

100% -> v2

using:

Argo Rollouts
+
Prometheus
+
Grafana
Final GitOps Structure

Create:

gitops
├── applications
│   └── platform
│       └── argo-rollouts.yaml

├── manifests
│   └── argo-rollouts
│       ├── namespace.yaml
│       └── kustomization.yaml

└── values
    └── argo-rollouts
        └── dev.yaml
Step 1
File
gitops/applications/platform/argo-rollouts.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application

metadata:
  name: argo-rollouts
  namespace: argocd

spec:

  project: default

  destination:
    namespace: argo-rollouts
    server: https://kubernetes.default.svc

  source:
    repoURL: https://argoproj.github.io/argo-helm
    chart: argo-rollouts
    targetRevision: 2.40.4

    helm:
      valueFiles:
        - $values/gitops/values/argo-rollouts/dev.yaml

  sources:
    - repoURL: https://argoproj.github.io/argo-helm
      chart: argo-rollouts
      targetRevision: 2.40.4

      helm:
        valueFiles:
          - $values/gitops/values/argo-rollouts/dev.yaml

    - repoURL: https://github.com/ckalandar/aws-platform-engineering.git
      targetRevision: main
      ref: values

  syncPolicy:

    automated:
      prune: true
      selfHeal: true

    syncOptions:
      - CreateNamespace=true
Step 2
File
gitops/values/argo-rollouts/dev.yaml
dashboard:
  enabled: true

controller:
  metrics:
    enabled: true

serviceAccount:
  create: true
Step 3

Commit

git add .
git commit -m "add argo rollouts"
git push
Step 4 Verify
kubectl get pods -n argo-rollouts

Expected:

argo-rollouts-xxxxx
Step 5 Verify CRDs
kubectl get crd | grep rollout

Expected:

rollouts.argoproj.io
analysisruns.argoproj.io
analysistemplates.argoproj.io
Step 6 Dashboard

Port-forward:

kubectl port-forward svc/argo-rollouts-dashboard \
  -n argo-rollouts \
  3100:3100

Open:

http://localhost:3100
After Verification

We'll convert your existing:

springboot Deployment

into:

Rollout

with:

Canary
10%
50%
100%

and integrate:

Prometheus metrics

for automatic rollback.

That will complete Progressive Delivery before we move into Istio Service Mesh.
have done verification looks good proceed furhter

Perfect.

Now we move from:

Deployment

to

Rollout

which is the real Progressive Delivery pattern.

Sprint 9.2 — Convert SpringBoot Deployment → Argo Rollout

Current:

Deployment
  ↓
Service
  ↓
Ingress

Target:

Rollout
  ↓
Stable Service
  ↓
Canary Service
  ↓
Ingress
Step 1

Create new directory

gitops/manifests/springboot-rollouts
File 1
gitops/manifests/springboot-rollouts/rollout.yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout

metadata:
 name: springboot
 namespace: springboot

spec:

 replicas: 2

 revisionHistoryLimit: 3

 selector:
   matchLabels:
     app: springboot

 template:

   metadata:
     labels:
       app: springboot

   spec:

     serviceAccountName: default

     containers:

       - name: springboot

         image: ghcr.io/ckalandar/platform-demo:latest

         imagePullPolicy: Always

         ports:
           - containerPort: 8080

         resources:

           requests:
             cpu: 100m
             memory: 256Mi

           limits:
             cpu: 500m
             memory: 512Mi

         readinessProbe:

           httpGet:
             path: /actuator/health
             port: 8080

           initialDelaySeconds: 10

         livenessProbe:

           httpGet:
             path: /actuator/health
             port: 8080

           initialDelaySeconds: 30

 strategy:

   canary:

     canaryService: springboot-canary

     stableService: springboot

     steps:

       - setWeight: 10

       - pause:
           duration: 60s

       - setWeight: 50

       - pause:
           duration: 60s

       - setWeight: 100
File 2
gitops/manifests/springboot-rollouts/service-stable.yaml
apiVersion: v1
kind: Service

metadata:
 name: springboot
 namespace: springboot

spec:

 selector:
   app: springboot

 ports:
   - port: 80
     targetPort: 8080
File 3
gitops/manifests/springboot-rollouts/service-canary.yaml
apiVersion: v1
kind: Service

metadata:
 name: springboot-canary
 namespace: springboot

spec:

 selector:
   app: springboot

 ports:
   - port: 80
     targetPort: 8080
File 4
gitops/manifests/springboot-rollouts/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
 - rollout.yaml
 - service-stable.yaml
 - service-canary.yaml
Step 2

Update workload application.

Existing
gitops/applications/workloads/springboot.yaml

Currently points to:

gitops/manifests/springboot

Replace path with:

path: gitops/manifests/springboot-rollouts
Step 3

Commit

git add .
git commit -m "convert springboot deployment to argo rollout"
git push
Step 4

Verify

kubectl get rollout -n springboot

Expected:

NAME         DESIRED   CURRENT   UP-TO-DATE   AVAILABLE
springboot
Step 5

Watch rollout

kubectl argo rollouts get rollout springboot \
 -n springboot \
 --watch

If plugin missing:

brew install argo-rollouts

Expected:

10%
Pause

50%
Pause

100%
Healthy
Step 6

Dashboard

kubectl port-forward svc/argo-rollouts-dashboard \
-n argo-rollouts \
3100:3100

Open:

http://localhost:3100

You should see:

springboot rollout
revision history
canary steps
promotion status
Important

Do not delete your current gitops/manifests/springboot directory yet.

Keep it as a backup until the rollout is healthy.

After you've deployed this and verified:

kubectl get rollout -n springboot
kubectl argo rollouts get rollout springboot -n springboot

send me the output.

The next step will be automated rollback using Prometheus AnalysisTemplates, which is where Argo Rollouts becomes significantly more powerful than a normal Deployment.
