provider "aws" {
  region = var.region
  # profile = "vivek"
}

terraform {
  backend "s3" {
    bucket = "python-deployment-backend"
    key    = "terraform.tfstate"
    region = "us-east-1"
    # dynamodb_table = "terraform_state"
  }
}

module "ecr" {
  source = ".\\modules\\ecr"
}

module "lambda" {
  source = ".\\modules\\lambda"

  function_name   = "serverless-app"
  lambda_timeout  = 900
  repository_name = module.ecr.repository_name
  lambda-role-arn = aws_iam_role.lambda-role.arn
  image-uri = "${module.ecr.repository_url}:${data.aws_ecr_image.image.image_tags[0]}"
}

module "dynamodb" {
  source = ".\\modules\\dynamoDB"
}

