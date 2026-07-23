locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

#######################################
# ALB Security Group
#######################################

resource "aws_security_group" "alb" {

  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-alb-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {

  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Allow HTTP from Internet"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {

  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  description = "Allow HTTPS from Internet"
}

resource "aws_vpc_security_group_egress_rule" "alb_all" {

  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound traffic"
}

#######################################
# EKS Cluster Security Group
#######################################

resource "aws_security_group" "eks_cluster" {

  name        = "${var.project_name}-${var.environment}-eks-cluster-sg"
  description = "EKS Control Plane Security Group"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-eks-cluster-sg"
    }
  )
}

#######################################
# EKS Node Security Group
#######################################

resource "aws_security_group" "eks_nodes" {

  name        = "${var.project_name}-${var.environment}-eks-node-sg"
  description = "EKS Worker Nodes"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-eks-node-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "eks_nodes_self" {

  security_group_id            = aws_security_group.eks_nodes.id
  referenced_security_group_id = aws_security_group.eks_nodes.id

  from_port   = 0
  to_port     = 65535
  ip_protocol = "tcp"

  description = "Allow node to node communication"
}

resource "aws_vpc_security_group_ingress_rule" "cluster_from_nodes" {

  security_group_id            = aws_security_group.eks_cluster.id
  referenced_security_group_id = aws_security_group.eks_nodes.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  description = "Allow nodes to communicate with EKS API"
}

resource "aws_vpc_security_group_ingress_rule" "nodes_from_cluster" {

  security_group_id            = aws_security_group.eks_nodes.id
  referenced_security_group_id = aws_security_group.eks_cluster.id

  from_port   = 10250
  to_port     = 10250
  ip_protocol = "tcp"

  description = "Allow EKS Control Plane to communicate with Kubelet"
}

resource "aws_vpc_security_group_egress_rule" "eks_nodes_all" {

  security_group_id = aws_security_group.eks_nodes.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound traffic"
}

#######################################
# RDS Security Group
#######################################

resource "aws_security_group" "rds" {

  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "RDS Security Group"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-rds-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "eks_to_rds" {

  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.eks_nodes.id

  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"

  description = "Allow PostgreSQL from EKS Nodes"
}