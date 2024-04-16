output "execution_arn" {
  value = aws_api_gateway_rest_api.serverless-app.execution_arn
  description = "API-GW execution arn"
}

output "invoke_url" {
  value = aws_api_gateway_deployment.api-gw-deployment.invoke_url
  description = "API-GW invoke url"
}

output "api-gw-id"{
  value= aws_api_gateway_rest_api.serverless-app.id
  description = "API-GW id"
}

output "api-gw-stage" {
  value = aws_api_gateway_stage.deployment-stage.stage_name
  description = "API-GW stage name"
}