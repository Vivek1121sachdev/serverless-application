output "api-gw-execution-arn" {
  value = aws_api_gateway_rest_api.python-deployment.execution_arn
}

output "ecr_uri"{
  value = aws_ecr_repository.repository_name.repository_url
}