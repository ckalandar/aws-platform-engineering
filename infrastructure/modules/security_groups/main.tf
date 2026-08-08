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

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "Allow HTTP from Internet"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "Allow HTTPS from Internet"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "Allow outbound traffic"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-alb-sg"
    }
  )
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

  ingress {
    self        = true
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    description = "Allow node to node communication"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "Allow outbound traffic"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-eks-node-sg"

      "karpenter.sh/discovery" = "${var.project_name}-${var.environment}"
    }
  )
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

#######################################
# Cross-referencing SG rules
# Using null_resource + local-exec to work around floci's
# DescribeSecurityGroupRules API limitation (rules are created
# but Terraform can't verify them via the standard resource).
#######################################

resource "null_resource" "cluster_from_nodes_rule" {

  depends_on = [
    aws_security_group.eks_cluster,
    aws_security_group.eks_nodes
  ]

  triggers = {
    cluster_sg_id = aws_security_group.eks_cluster.id
    nodes_sg_id   = aws_security_group.eks_nodes.id
    endpoint      = var.localstack_endpoint
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws ec2 authorize-security-group-ingress \
        --endpoint-url ${var.localstack_endpoint} \
        --region us-east-1 \
        --group-id ${aws_security_group.eks_cluster.id} \
        --source-group ${aws_security_group.eks_nodes.id} \
        --protocol tcp \
        --port 443
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      aws ec2 revoke-security-group-ingress \
        --endpoint-url ${self.triggers.endpoint} \
        --region us-east-1 \
        --group-id ${self.triggers.cluster_sg_id} \
        --source-group ${self.triggers.nodes_sg_id} \
        --protocol tcp \
        --port 443 || true
    EOT
  }
}

resource "null_resource" "nodes_from_cluster_rule" {

  depends_on = [
    aws_security_group.eks_cluster,
    aws_security_group.eks_nodes
  ]

  triggers = {
    cluster_sg_id = aws_security_group.eks_cluster.id
    nodes_sg_id   = aws_security_group.eks_nodes.id
    endpoint      = var.localstack_endpoint
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws ec2 authorize-security-group-ingress \
        --endpoint-url ${var.localstack_endpoint} \
        --region us-east-1 \
        --group-id ${aws_security_group.eks_nodes.id} \
        --source-group ${aws_security_group.eks_cluster.id} \
        --protocol tcp \
        --port 10250
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      aws ec2 revoke-security-group-ingress \
        --endpoint-url ${self.triggers.endpoint} \
        --region us-east-1 \
        --group-id ${self.triggers.nodes_sg_id} \
        --source-group ${self.triggers.cluster_sg_id} \
        --protocol tcp \
        --port 10250 || true
    EOT
  }
}

resource "null_resource" "eks_to_rds_rule" {

  depends_on = [
    aws_security_group.rds,
    aws_security_group.eks_nodes
  ]

  triggers = {
    rds_sg_id  = aws_security_group.rds.id
    nodes_sg_id = aws_security_group.eks_nodes.id
    endpoint    = var.localstack_endpoint
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws ec2 authorize-security-group-ingress \
        --endpoint-url ${var.localstack_endpoint} \
        --region us-east-1 \
        --group-id ${aws_security_group.rds.id} \
        --source-group ${aws_security_group.eks_nodes.id} \
        --protocol tcp \
        --port 5432
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      aws ec2 revoke-security-group-ingress \
        --endpoint-url ${self.triggers.endpoint} \
        --region us-east-1 \
        --group-id ${self.triggers.rds_sg_id} \
        --source-group ${self.triggers.nodes_sg_id} \
        --protocol tcp \
        --port 5432 || true
    EOT
  }
}