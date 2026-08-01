locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

#########################################
# IRSA Role
#########################################

data "aws_iam_policy_document" "karpenter_assume_role" {

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

      variable = "${var.oidc_provider_url}:sub"

      values = [
        "system:serviceaccount:karpenter:karpenter"
      ]
    }
  }
}

resource "aws_iam_role" "karpenter_controller" {

  name = "${var.cluster_name}-karpenter-controller"

  assume_role_policy = data.aws_iam_policy_document.karpenter_assume_role.json

  tags = local.common_tags
}

#########################################
# Controller Policy
#########################################

resource "aws_iam_policy" "karpenter_controller" {

  name = "${var.cluster_name}-karpenter-controller"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "ec2:CreateLaunchTemplate",
          "ec2:DeleteLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:Describe*",
          "ec2:CreateTags",
          "pricing:GetProducts",
          "ssm:GetParameter",
          "iam:PassRole"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "controller" {

  role = aws_iam_role.karpenter_controller.name

  policy_arn = aws_iam_policy.karpenter_controller.arn
}

#########################################
# Node Role
#########################################

resource "aws_iam_role" "karpenter_node" {

  name = "${var.cluster_name}-karpenter-node"

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

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "worker" {

  role = aws_iam_role.karpenter_node.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "ecr" {

  role = aws_iam_role.karpenter_node.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "cni" {

  role = aws_iam_role.karpenter_node.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ssm" {

  role = aws_iam_role.karpenter_node.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#########################################
# Instance Profile
#########################################

resource "aws_iam_instance_profile" "karpenter" {

  name = "${var.cluster_name}-karpenter"

  role = aws_iam_role.karpenter_node.name
}
