resource "aws_ecr_repository" "springboot" {

  name = "platform-demo"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}

########Added this for testing push
