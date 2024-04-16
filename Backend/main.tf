#----------------#
# Provider Block #
#----------------#

provider "aws" {
  region = var.region
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
  source              = ".\\modules\\lambda"
  function_name       = "serverless-app"
  lambda_timeout      = 900
  repository_name     = module.ecr.repository_name
  image-uri           = "${module.ecr.repository_url}:${data.aws_ecr_image.image.image_tags[0]}"
  execution_arn       = module.api-gw.execution_arn
  path-parts          = ["health", "student", "students", ""]
  dynamodb-arn        = module.dynamodb.dynamodb-arn
  lambda_log_retention_period = 7
  ssm-parameter-arn   = aws_ssm_parameter.ssm_parameter.arn
  ssm-parameter-value = aws_ssm_parameter.ssm_parameter.value
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
  cloudWatch_Alarms = ["4XXError", "5XXError"]
  topic_arn         = module.sns.topic_arn
}

#-----#
# SNS #
#-----#

module "sns" {
  source     = ".\\modules\\SNS"
  topic-name = "API-GW-Alarm-Topic"
  protocol   = "email"
  endpoint   = "vivek.sachdev@techholding.co"
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

#----------------------------------------#
# CloudWatch Alarm on 4XX and 5XX errors #
#----------------------------------------#

resource "aws_cloudwatch_metric_alarm" "api_gateway_alarms" {
  for_each = toset(local.cloudWatch_Alarm)

  alarm_name          = "${module.api-gw.api-gw-name} API gateway ${each.value} rate"
  comparison_operator = "GreaterThanThreshold"
  period              = 300
  evaluation_periods  = 1
  metric_name         = "${each.value}"
  namespace           = "AWS/ApiGateway"
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "API gateway ${each.value} rate has exceeded threshold"
  alarm_actions       = ["${module.sns.topic_arn}"]
  treat_missing_data  = "ignore"
  actions_enabled     = true
  dimensions          = {
    ApiName = module.api-gw.api-gw-name
    Stage    = module.api-gw.api-gw-stage
  }
}