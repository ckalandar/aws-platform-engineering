locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

### ALB Security Group

resource "aws_security_group" "alb" {

  name        = "${var.project_name}-${var.environment}-alb-sg"

  description = "ALB Security Group"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-alb-sg"
    }
  )
}

### EKS Node Security Group

resource "aws_security_group" "eks_nodes" {

  name = "${var.project_name}-${var.environment}-eks-node-sg"

  description = "EKS Worker Nodes"

  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-eks-node-sg"
    }
  )
}

### ALB to EKS Node Security Group Ingress Rule

resource "aws_security_group_rule" "alb_to_nodes" {

  type = "ingress"

  from_port = 30000
  to_port   = 32767

  protocol = "tcp"

  source_security_group_id = aws_security_group.alb.id

  security_group_id = aws_security_group.eks_nodes.id
}

### RDS Security Group

resource "aws_security_group" "rds" {

  name = "${var.project_name}-${var.environment}-rds-sg"

  description = "Database Security Group"

  vpc_id = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-rds-sg"
    }
  )
}

### EKS Node to RDS Security Group Ingress Rule example for PostgreSQL

resource "aws_security_group_rule" "eks_to_rds" {

  type = "ingress"

  from_port = 5432
  to_port   = 5432

  protocol = "tcp"

  source_security_group_id = aws_security_group.eks_nodes.id

  security_group_id = aws_security_group.rds.id
}

