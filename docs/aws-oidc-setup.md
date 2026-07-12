# AWS OIDC Authentication Setup

This repository uses GitHub OIDC to authenticate to AWS without storing long-lived secrets.

1. Create an IAM OIDC identity provider for GitHub Actions.

AWS Console

IAM └── Identity Providers └── Add Provider

Provider Type

OpenID Connect

Provider URL

https://token.actions.githubusercontent.com

Audience

sts.amazonaws.com

After creation you'll have:

arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com

2. Create an IAM role that trusts the GitHub repository and branch.

Name:

GitHubActionsPlatformEnggAdminRole

Trust Policy:

Replace <ACCOUNT_ID> with yours.

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

3. Attach the required permissions for Terraform bootstrap resources.

For learning:

Attach:

AdministratorAccess

I wouldn't do this in production, but for a personal lab it's the fastest way to get moving.

## Required GitHub repository variables

Set these in GitHub repository settings -> Secrets and variables -> Actions -> Variables:
- AWS_ROLE_TO_ASSUME: ARN of the IAM role that GitHub Actions will assume ex: Value: 
arn:aws:iam::<ACCOUNT_ID>:role/GitHubActionsCloudFormationRole
- AWS_REGION: AWS region, for example us-east-1
- PROJECT_NAME: project name used for Terraform resource naming, for example platform