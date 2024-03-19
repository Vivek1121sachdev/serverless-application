resource "aws_lambda_function" "lambda-function" {
  function_name = "${var.function_name}"
  timeout       = "${var.lambda_timeout}"
  image_uri     = "${var.repository_name}:${var.image_tag}"
  package_type  = "Image"

  role = var.lambda-role-arn
}