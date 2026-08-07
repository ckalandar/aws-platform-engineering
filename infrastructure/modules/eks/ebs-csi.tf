data "aws_iam_policy_document" "ebs_csi_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        var.manage_oidc ? aws_iam_openid_connect_provider.eks[0].arn : "arn:aws:iam::000000000000:oidc-provider/oidc.eks.localhost/id/floci"
      ]
    }

    condition {
      test = "StringEquals"

      variable = "${var.manage_oidc ? replace(aws_iam_openid_connect_provider.eks[0].url, "https://", "") : "oidc.eks.localhost/id/floci"}:sub"

      values = [
        "system:serviceaccount:kube-system:ebs-csi-controller-sa"
      ]
    }
  }
}

resource "aws_iam_role" "ebs_csi" {

  name = "${var.project_name}-${var.environment}-ebs-csi-role"

  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ebs_csi" {

  role = aws_iam_role.ebs_csi.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
