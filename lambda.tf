resource "aws_lambda_function" "lambda-function" {
  function_name = var.function_name
  timeout       = var.lambda_timeout
  image_uri     = "${aws_ecr_repository.repository_name.repository_url}:latest"
  package_type  = "Image"

  role = aws_iam_role.lambda-role.arn
  # depends_on = [ null_resource.build-img-script ]
}

