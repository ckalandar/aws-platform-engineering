output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  value = module.vpc.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  value = module.vpc.private_db_subnet_ids
}

# Security Groups
output "alb_sg_id" {
  value = module.security_groups.alb_sg_id
}

output "eks_node_sg_id" {
  value = module.security_groups.eks_node_sg_id
}

output "rds_sg_id" {
  value = module.security_groups.rds_sg_id
}

output "eks_cluster_sg_id" {
  value = module.security_groups.eks_cluster_sg_id
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "node_group_name" {
  value = module.eks.node_group_name
}