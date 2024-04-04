output "repository_url" {
  value = aws_ecr_repository.repository_name.repository_url
}

output "repository_name" {
  value = aws_ecr_repository.repository_name.name
}