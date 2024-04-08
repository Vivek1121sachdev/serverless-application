output "execution_arn" {
  value = aws_api_gateway_rest_api.serverless-app.execution_arn
}

output "invoke_url" {
  value = aws_api_gateway_deployment.api-gw-deployment.invoke_url
}