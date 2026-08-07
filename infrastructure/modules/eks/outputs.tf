output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_role_arn" {
  value = aws_iam_role.cluster.arn
}

output "node_role_arn" {
  value = aws_iam_role.node_group.arn
}

output "node_group_name" {
  value = aws_eks_node_group.general.node_group_name
}

output "oidc_provider_arn" {
  description = "OIDC Provider ARN"
  value       = var.manage_oidc ? aws_iam_openid_connect_provider.eks[0].arn : "arn:aws:iam::000000000000:oidc-provider/oidc.eks.localhost/id/floci"
}

output "oidc_issuer_url" {
  description = "OIDC Issuer URL"
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "oidc_provider_url" {
  description = "OIDC provider URL without https://"
  value = var.manage_oidc ? replace(
    aws_iam_openid_connect_provider.eks[0].url,
    "https://",
    ""
  ) : "oidc.eks.localhost/id/floci"
}
