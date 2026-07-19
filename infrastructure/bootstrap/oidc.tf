resource "aws_iam_openid_connect_provider" "github" {
  count = var.manage_oidc ? 1 : 0
  url   = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

data "aws_iam_policy_document" "github_assume_role" {
  count = var.manage_oidc ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.github[0].arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:ckalandar/aws-platform-engineering:*"
      ]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  count = var.manage_oidc ? 1 : 0
  name  = "platform-github-actions-role"

  assume_role_policy = data.aws_iam_policy_document.github_assume_role[0].json
}

resource "aws_iam_role_policy_attachment" "admin" {
  count      = var.manage_oidc ? 1 : 0
  role       = aws_iam_role.github_actions[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


