provider "aws" {
  region = var.region
  # profile = "vivek"
}

#------------#
# S3 Backend #
#------------#

terraform {
  backend "s3" {
    bucket  = "python-deployment-backend"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    # dynamodb_table = "terraform_state"
  }
}

#------------#
# ECR Module #
#------------#

module "ecr" {
  source    = ".\\modules\\ecr"
  repo-name = "serverless-app"
}

#---------------#
# Lambda Module #
#---------------#

module "lambda" {
  source            = ".\\modules\\lambda"
  function_name     = "serverless-app"
  lambda_timeout    = 900
  repository_name   = module.ecr.repository_name
  image-uri         = "${module.ecr.repository_url}:${data.aws_ecr_image.image.image_tags[0]}"
  execution_arn     = module.api-gw.execution_arn
  path-parts        = compact(["health", "student", "students", ""])
  dynamodb-arn      = module.dynamodb.dynamodb-arn
  ssm-parameter-arn = aws_ssm_parameter.ssm_parameter.arn
}

#-----------------#
# DynamoDb Module #
#-----------------#

module "dynamodb" {
  source         = ".\\modules\\dynamoDB"
  table-name     = "students-data"
  hash-key       = "studentId"
  attribute-name = "studentId"
  attribute-type = "S"
}

#--------------------#
# API Gateway Module #
#--------------------#

module "api-gw" {
  source            = ".\\modules\\api-gw"
  lambda_invoke_arn = module.lambda.invoke_arn
  api-gw-name       = "serverless-app"
  stage_name        = "dev"
}

#------------#
# S3 Modulue #
#------------#

module "s3" {
  source      = ".\\modules\\s3"
  bucket_name = "serverless-application-frontend-code"
  region      = "us-east-1"
}

#------------------------------------#
# Local File to store API Invoke URL #
#------------------------------------#

resource "local_file" "api-gw-invoke-url" {
  content  = module.api-gw.invoke_url
  filename = "api-gw-invoke-url.txt"
}

#---------------#
# SSM Parameter #
#---------------#

resource "aws_ssm_parameter" "ssm_parameter" {
  name  = "dbTableName"
  type  = "String"
  value = "students-data"
}