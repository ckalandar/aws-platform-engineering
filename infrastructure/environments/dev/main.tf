data "aws_caller_identity" "current" {}

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

  manage_oidc = false
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

module "karpenter" {

  source = "../../modules/karpenter"

  cluster_name = module.eks.cluster_name

  project_name = var.project_name

  environment = var.environment

  oidc_provider_arn = module.eks.oidc_provider_arn

  oidc_provider_url = module.eks.oidc_provider_url
}
