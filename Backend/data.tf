data "aws_ecr_image" "image" {
  repository_name = module.ecr.repository_name
  most_recent     = true
}

locals {

  // CloudWatch Alarm names //
  cloudWatch_Alarm = ["4XXError", "5XXError"]

  // API-GW resource names and methods //
  resources = {
    health = "GET",
    student = "ANY",
    students = "GET"
  }

  // SSM parameter keys and values //
  parameters = {
    "/serverless/dynamodb/dbTableName" = "students-data",
    "mySecondParam"                    = "foo"
  }
}