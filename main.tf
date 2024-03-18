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
  source = ".\\Modules\\ecr"
}

module "lambda" {
  source = ".\\Modules\\lambda"

  function_name = "serverless-app"
  lambda_timeout = 900
}

module "dynamodb" {
  source = ".\\Modules\\dynamoDB"
}