output "alb_controller_role_arn" {
  description = "IRSA role for AWS Load Balancer Controller"

  value = aws_iam_role.alb_controller.arn
}

output "alb_controller_policy_arn" {

  description = "ALB Controller IAM Policy ARN"

  value = aws_iam_policy.alb_controller.arn
}