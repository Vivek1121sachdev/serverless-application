resource "aws_lambda_function" "lambda-function" {
  function_name = "students-lambda-funtions"
  timeout       = 900 # seconds
  image_uri     = "${aws_ecr_repository.repository_name.repository_url}:latest"
  package_type  = "Image"

  role = aws_iam_role.lambda-role.arn
}

