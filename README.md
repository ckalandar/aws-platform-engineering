# AWS Platform Engineering

This repository follows a simplified, scalable structure for Terraform and platform engineering work.

## Naming convention

Use resource names in the form:
- platform-dev-vpc
- platform-stage-eks
- platform-prod-rds

## Repository layout

- infrastructure/modules: reusable resource modules such as vpc, security-groups, ecr, eks, rds, and monitoring
- infrastructure/environments: environment entrypoints for dev, stage, and prod
- applications: service directories such as user-service, order-service, and payment-service
- gitops: GitOps base and environment overlays
- monitoring, docs, and runbooks: operational assets

## Recommended approach

- Keep one module per resource type
- Keep one environment folder per environment
- Compose modules from the environment entrypoints
- Avoid creating separate module folders for every environment/resource combination

## AWS authentication

This repository uses GitHub OIDC for AWS authentication.
No long-lived AWS access keys are used in GitHub secrets.

See [docs/aws-oidc-setup.md](docs/aws-oidc-setup.md) for setup details.
