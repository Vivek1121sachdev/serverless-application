data "aws_ecr_image" "image" {
  repository_name = module.ecr.repository_name
  most_recent     = true
}