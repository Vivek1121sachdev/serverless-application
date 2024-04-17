variable "function_name" {
  type = string
  description = "Lambda function name"
}

variable "lambda_timeout" {
  type = number
  description = "amount of time lambda runs the code"
  default = 3
}

variable "repository_name" {
  type = string
  description = "ECR repository name"
}

variable "image-uri" {
  type = string
  description = "ecr image uri"
}

variable "execution_arn" {
  type = string
  description = "api gateway execution arn to generate source arn of each resources"
}

variable "path-parts" {
  type = list(string)
  description = "api gateway resource name"
}

variable "dynamodb-arn" {
  type = string
  description = "DynamoDB table arn"
}

variable "parameters" {
  type = string
  description = "SSM parameters"
}

variable "parameter_ssm_arn" {
  type = any
  description = "ARN of the SSM parameters"
}

variable "lambda_log_retention_period" {
  type = number
  description = "Retention period to save logs"
}