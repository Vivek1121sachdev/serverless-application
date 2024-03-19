output "repository_url" {
  value = aws_ecr_repository.repository_name.repository_url
}

output "image_tag" {
  value = data.aws_ecr_image.image.image_tags[0]
}

output "image_uri" {
  value = data.aws_ecr_image.image.image_uri
}