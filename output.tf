output "api-gw-execution-arn" {
  value = aws_api_gateway_rest_api.serverless-app.execution_arn
}

output "ecr_uri" {
  value = "${module.ecr.repository_url}"
}

output "image_uri" {
  value = "${module.ecr.image_uri}"
}

output "image_tag" {
  value = "${module.ecr.image_tag}"
}

