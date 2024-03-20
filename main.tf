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
  source             = ".\\modules\\ecr"
  repo-name          = "serverless-app"
  image-expire-count = 3
}

module "lambda" {
  source = ".\\modules\\lambda"

  function_name   = "serverless-app"
  lambda_timeout  = 900
  repository_name = module.ecr.repository_name
  image-uri       = "${module.ecr.repository_url}:${data.aws_ecr_image.image.image_tags[0]}"
  execution_arn   = aws_api_gateway_rest_api.serverless-app.execution_arn
}


module "dynamodb" {
  source         = ".\\modules\\dynamoDB"
  table-name     = "students-data"
  hash-key       = "studentId"
  attribute-name = "studentId"
  attribute-type = "S"
}

