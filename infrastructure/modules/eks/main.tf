locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

#######################################
# EKS Cluster IAM Role
#######################################

resource "aws_iam_role" "cluster" {

  name = "${var.project_name}-${var.environment}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "eks.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-eks-cluster-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {

  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

#######################################
# EKS Node IAM Role
#######################################

resource "aws_iam_role" "node_group" {

  name = "${var.project_name}-${var.environment}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-eks-node-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {

  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {

  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_policy" {

  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ssm" {

  role       = aws_iam_role.node_group.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#######################################
# CloudWatch Log Group
#######################################

#resource "aws_cloudwatch_log_group" "eks" {

 # name              = "/aws/eks/${var.project_name}-${var.environment}/cluster"
  #retention_in_days = 30

  #tags = local.common_tags
#}

#######################################
# EKS Cluster
#######################################

resource "aws_eks_cluster" "this" {

  name     = "${var.project_name}-${var.environment}"
  role_arn = aws_iam_role.cluster.arn

  version = var.eks_version

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  vpc_config {

    subnet_ids = var.private_app_subnet_ids

    security_group_ids = [
      var.eks_cluster_sg_id
    ]

    endpoint_private_access = true

    # For now while building from laptop
    endpoint_public_access = true
  }

  depends_on = [
    #aws_cloudwatch_log_group.eks,
    aws_iam_role_policy_attachment.cluster_policy
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-eks"
    }
  )
}

#######################################
# Managed Node Group
#######################################

resource "aws_eks_node_group" "general" {

  cluster_name = aws_eks_cluster.this.name

  node_group_name = "general"

  node_role_arn = aws_iam_role.node_group.arn

  subnet_ids = var.private_app_subnet_ids

  capacity_type = "ON_DEMAND"

  instance_types = [
    #"t3.medium"
    "t2.micro"
  ]

  scaling_config {

    desired_size = 2

    min_size = 2

    max_size = 5
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    workload = "general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ecr_policy,
    aws_iam_role_policy_attachment.ssm
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-general-ng"
    }
  )
}