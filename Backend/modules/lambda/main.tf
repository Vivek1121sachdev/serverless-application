########################
# CloudWatch Log Group #
########################

resource "aws_cloudwatch_log_group" "lambda-log-group" {
  name = "/aws/lambda/serverless-app"
  retention_in_days = 7 #value from var
}

###################
# Lambda Function #
###################

resource "aws_lambda_function" "lambda-function" {
  function_name = var.function_name
  timeout       = var.lambda_timeout
  image_uri     = var.image-uri
  package_type  = "Image"
  role          = aws_iam_role.lambda-role.arn

  environment {
    variables = {
      dynamoDB = "${var.ssm-parameter-value}"
    }
  }

  logging_config {
    log_format = "Text"
    log_group = aws_cloudwatch_log_group.lambda-log-group.name
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda-log-group
  ]
}
