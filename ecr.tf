resource "aws_ecr_repository" "repository_name" {
  name                 = "python-deployment"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}


resource "aws_ecr_lifecycle_policy" "image-lifecycle-policy" {
  repository = "${aws_ecr_repository.repository_name.id}"

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
    lambda_function = "${sha1(file("A:\\Tech-Holding\\python-deployment\\code\\lambda_function.py"))}"
    custom_encoder  = "${sha1(file("A:\\Tech-Holding\\python-deployment\\code\\custom_encoder.py"))}"
  }

  provisioner "local-exec" {
    working_dir = "A:\\Tech-Holding\\python-deployment\\code\\"

    command = "sh ./ecr-img-push.sh ${var.arg-1} ${var.arg-2} ${var.arg-3} ${var.arg-4}"

  }
  depends_on = [aws_ecr_repository.repository_name]
}