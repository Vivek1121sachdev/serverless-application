resource "aws_lambda_function" "lambda-function" {
  function_name = var.function_name
  timeout       = var.lambda_timeout
  image_uri     = "${aws_ecr_repository.repository_name.repository_url}:${data.aws_ecr_image.image.image_tags[0]}"
  package_type  = "Image"

  role = aws_iam_role.lambda-role.arn

}

data "aws_ecr_image" "image" {
  repository_name = aws_ecr_repository.repository_name.name
  most_recent     = true
}
