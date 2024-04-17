data "aws_ecr_image" "image" {
  repository_name = module.ecr.repository_name
  most_recent     = true
}

locals {
  cloudWatch_Alarm = ["4XXError", "5XXError"]
  resources = {
    health = "GET",
    student = "ANY",
    students = "GET"
  }
  parameters = {
    "/serverless-application/dynamodb/dbTableName"   = "students-data"
    "mySecondParam" = "foo"
  }
}