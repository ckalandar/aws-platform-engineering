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
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_issuer_url" {
  description = "OIDC Issuer URL"
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}
