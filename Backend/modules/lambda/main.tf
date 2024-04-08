resource "aws_lambda_function" "lambda-function" {
  function_name = var.function_name
  timeout       = var.lambda_timeout
  image_uri     = var.image-uri
  package_type  = "Image"

  role = aws_iam_role.lambda-role.arn
}
//testing comment
resource "aws_ssm_parameter" "ssm_parameter" {
  name  = "dbTableName"
  type  = "String"
  value = "students-data"
}
