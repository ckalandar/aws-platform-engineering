resource "aws_eks_addon" "vpc_cni" {
  count = var.manage_addons ? 1 : 0

  cluster_name = aws_eks_cluster.this.name
  addon_name   = "vpc-cni"

  resolve_conflicts_on_create = "OVERWRITE"

  depends_on = [
    aws_eks_node_group.general
  ]
}

resource "aws_eks_addon" "coredns" {
  count = var.manage_addons ? 1 : 0

  cluster_name = aws_eks_cluster.this.name
  addon_name   = "coredns"

  resolve_conflicts_on_create = "OVERWRITE"

  depends_on = [
    aws_eks_node_group.general
  ]
}

resource "aws_eks_addon" "kube_proxy" {
  count = var.manage_addons ? 1 : 0

  cluster_name = aws_eks_cluster.this.name
  addon_name   = "kube-proxy"

  resolve_conflicts_on_create = "OVERWRITE"

  depends_on = [
    aws_eks_node_group.general
  ]
}

resource "aws_eks_addon" "ebs_csi" {
  count = var.manage_addons ? 1 : 0

  cluster_name = aws_eks_cluster.this.name

  addon_name = "aws-ebs-csi-driver"

  service_account_role_arn = aws_iam_role.ebs_csi.arn

  resolve_conflicts_on_create = "OVERWRITE"

  depends_on = [
    aws_eks_node_group.general,
    aws_iam_role_policy_attachment.ebs_csi
  ]
}
