output "invoke_arn" {
  value = aws_lambda_function.lambda-function.invoke_arn
}

output "function_name" {
  value = aws_lambda_function.lambda-function.function_name
}
