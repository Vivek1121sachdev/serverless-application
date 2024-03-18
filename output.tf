output "api-gw-execution-arn" {
  value = aws_api_gateway_rest_api.serverless-app.execution_arn
}

output "ecr_uri"{
  value = aws_ecr_repository.repository_name.repository_url
}

output "image_uri" {
  value = data.aws_ecr_image.image.image_uri
}

output "image_tag" {
  value = data.aws_ecr_image.image.image_tags[0]
}