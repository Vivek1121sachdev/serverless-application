resource "aws_lambda_function" "lambda-function" {
  function_name = "${var.function_name}"
  timeout       = "${var.lambda_timeout}"
  image_uri     = "${var.repository_url}:${data.aws_ecr_image.image.image_tags[0]}"
  package_type  = "Image"

  role = var.lambda-role-arn
}

data "aws_ecr_image" "image" {
  repository_name = var.repository_name
  most_recent     = true
}
