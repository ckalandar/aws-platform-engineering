# AWS OIDC Authentication Setup

This repository uses GitHub OIDC to authenticate to AWS without storing long-lived secrets.

## Required GitHub repository variables

Set these in GitHub repository settings -> Secrets and variables -> Actions -> Variables:

- AWS_ROLE_TO_ASSUME: ARN of the IAM role that GitHub Actions will assume
- AWS_REGION: AWS region, for example us-east-1
- PROJECT_NAME: project name used for Terraform resource naming, for example platform

## AWS setup

1. Create an IAM OIDC identity provider for GitHub Actions.
2. Create an IAM role that trusts the GitHub repository and branch.
3. Attach the required permissions for Terraform bootstrap resources.
4. Add the role ARN and region as GitHub Actions variables.

## Example trust policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:<OWNER>/<REPO>:ref:refs/heads/main"
        }
      }
    }
  ]
}
```
