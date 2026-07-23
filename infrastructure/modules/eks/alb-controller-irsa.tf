data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.this.name
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}

# OIDC Provider Lookup
data "aws_iam_openid_connect_provider" "eks" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# IAM Assume Role Policy for ALB Controller Service Account

data "aws_iam_policy_document" "alb_assume_role" {

  statement {

    actions = ["sts:AssumeRoleWithWebIdentity"]

    effect = "Allow"

    principals {

      type = "Federated"

      identifiers = [
        data.aws_iam_openid_connect_provider.eks.arn
      ]
    }

    condition {

      test = "StringEquals"

      variable = "${replace(
        aws_eks_cluster.this.identity[0].oidc[0].issuer,
        "https://",
        ""
      )}:sub"

      values = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller"
      ]
    }
  }
}

# IAM Role for ALB Controller Service Account

resource "aws_iam_role" "alb_controller" {

  name = "${var.project_name}-${var.environment}-alb-controller"

  assume_role_policy = data.aws_iam_policy_document.alb_assume_role.json
}

# Attach IAM Policies to ALB Controller Role

resource "aws_iam_role_policy_attachment" "alb_controller" {

  role = aws_iam_role.alb_controller.name

  policy_arn = "arn:aws:iam::590183739792:policy/AWSLoadBalancerControllerIAMPolicy"
}



