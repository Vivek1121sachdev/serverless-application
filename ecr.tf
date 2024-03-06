resource "aws_ecr_repository" "repository_name" {
  name                 = "python-deployment"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "null_resource" "config" {

  triggers = {
    # always_run = "${timestamp()}"
    lambda_function = "${sha1(file("/mnt/a/Tech-Holding/python-deployment/code/lambda_function.py"))}"
    custom_encoder  = "${sha1(file("/mnt/a/Tech-Holding/python-deployment/code/custom_encoder.py"))}"
  }

  provisioner "local-exec" {
    working_dir = "/mnt/a/Tech-Holding/python-deployment/code"

    command = "sh ./ecr-img-push.sh ${var.arg-1} ${var.arg-2} ${var.arg-3} ${var.arg-4}"

  }
  depends_on = [aws_ecr_repository.repository_name]
}

