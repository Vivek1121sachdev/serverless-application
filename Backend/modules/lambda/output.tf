output "invoke_arn" {
  value = aws_lambda_function.lambda-function.invoke_arn
  description = "Lambda invoke arn"
}

output "function_name" {
  value = aws_lambda_function.lambda-function.function_name
  description = "Lambda function name"
}

output "image_uri" {
  value = aws_lambda_function.lambda-function.image_uri
  description = "ECR image uri"
}