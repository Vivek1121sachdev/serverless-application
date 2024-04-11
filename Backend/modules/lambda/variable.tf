variable "function_name" {
  type = string
  default = "serverless-application"
}

variable "lambda_timeout" {
  type = number
  description = "amount of time lambda runs the code"
  default = 3
}

variable "repository_name" {
  type = string
  description = "ecr repo name"
  default = "serverless-app"
}

variable "image-uri" {
  type = string
}

variable "execution_arn" {
  description = "api gateway execution arn to generate source arn of each resources"
  type = string
}

variable "path-parts" {
  type = list(string)
  description = "api gateway resource name"
}

variable "dynamodb-arn" {
  type = string
}

variable "ssm-parameter-arn" {
  type = string
}
