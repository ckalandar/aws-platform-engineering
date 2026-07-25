resource "local_file" "alb_serviceaccount" {

  filename = "${path.root}/gitops/manifests/aws-load-balancer-controller/serviceaccount.yaml"

  content = templatefile(
    "${path.module}/templates/serviceaccount.yaml.tpl",
    {
      role_arn = aws_iam_role.alb_controller.arn
    }
  )
}

resource "local_file" "alb_values" {

  filename = "${path.root}/gitops/values/aws-load-balancer-controller/${var.environment}.yaml"

  content = templatefile(
    "${path.module}/templates/alb-values.yaml.tpl",
    {
      cluster_name = var.cluster_name
      vpc_id       = var.vpc_id
      region       = var.aws_region
    }
  )
}