data "aws_ecr_image" "image" {
  repository_name = aws_ecr_repository.repository_name.name
  most_recent     = true
}