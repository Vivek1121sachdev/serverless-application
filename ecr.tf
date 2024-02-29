resource "aws_ecr_repository" "repository_name" {
  name                 = "python-deployment"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  provisioner "local-exec" {
    working_dir = "/mnt/a/Tech-Holding/python-deployment/code"

    command = "./ecr-img-push.sh"
  }
}

