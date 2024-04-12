resource "aws_cloudwatch_log_group" "lambda-log-group" {
  name = "Lambda-serverless-app"
}

resource "aws_lambda_function" "lambda-function" {
  function_name = var.function_name
  timeout       = var.lambda_timeout
  image_uri     = var.image-uri
  package_type  = "Image"
  role          = aws_iam_role.lambda-role.arn

  logging_config {
    log_format = "Text"
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda-log-group
  ]
}
