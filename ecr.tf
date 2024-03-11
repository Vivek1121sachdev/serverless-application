resource "aws_ecr_repository" "repository_name" {
  name                 = "python-deployment"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}


resource "aws_ecr_lifecycle_policy" "image-lifecycle-policy" {
  repository = aws_ecr_repository.repository_name.id

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 3 images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 3
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}


resource "null_resource" "build-img-script" {

  triggers = {
    # always_run = "${timestamp()}"
    lambda_function = "${sha1(file("\\code\\lambda_function.py"))}"
    custom_encoder  = "${sha1(file("\\code\\custom_encoder.py"))}"
  }

  provisioner "local-exec" {
    working_dir = "./code"
    command = "bash ./ecr-img-push.sh ${var.arg-1} ${var.arg-2} ${var.arg-3} ${var.arg-4}"
    # command = "powershell -File .\\ecr-img-push.ps1 ${var.arg-1} ${var.arg-2} ${var.arg-3} ${var.arg-4}"

  }

  provisioner "local-exec" {
    when        = destroy
    working_dir = "."
    command     = "bash ./delete-ecr-img.sh"
  }

  depends_on = [aws_ecr_repository.repository_name]
}
