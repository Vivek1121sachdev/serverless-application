output "api-gw-execution-arn" {
  value = module.api-gw.execution_arn
}

output "ecr_uri" {
  value = module.ecr.repository_url
}

output "image_uri" {
  value = module.lambda.image_uri
}
