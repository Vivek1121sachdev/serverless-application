output "api-gw-execution-arn" {
  value       = module.api-gw.execution_arn
  description = "API-GW execution arn"
}

output "api-gw-invoke_url" {
  value       = module.api-gw.invoke_url
  description = "API-GW invoke url"
}

output "ecr_uri" {
  value       = module.ecr.repository_url
  description = "ECR repository url"
}

output "image_uri" {
  value       = module.lambda.image_uri
  description = "ECR image uri"
}

output "website_url" {
  value       = module.s3.website_url
  description = "Website endpoint"
}