module "vpc" {
  source = "../../modules/vpc"

  environment              = var.environment
  project_name             = var.project_name
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
}

# Security Groups 

module "security_groups" {

  source = "../../modules/security_groups"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.vpc.vpc_id
}

## EKS Cluster

module "eks" {

  source = "../../modules/eks"

  project_name = var.project_name
  environment  = var.environment

  private_app_subnet_ids = module.vpc.private_app_subnet_ids

  eks_node_sg_id    = module.security_groups.eks_node_sg_id
  eks_cluster_sg_id = module.security_groups.eks_cluster_sg_id
}