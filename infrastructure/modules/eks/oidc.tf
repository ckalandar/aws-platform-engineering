#######################################
# EKS OIDC Provider
#######################################

data "tls_certificate" "eks_oidc" {
  count = var.manage_oidc ? 1 : 0

  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  count = var.manage_oidc ? 1 : 0

  url = aws_eks_cluster.this.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks_oidc[0].certificates[length(data.tls_certificate.eks_oidc[0].certificates) - 1].sha1_fingerprint
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-eks-oidc"
    }
  )
}