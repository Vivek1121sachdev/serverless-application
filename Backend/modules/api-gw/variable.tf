variable "api-gw-name" {
  type = string
  description = "API-GW name"
  default = "serverless-app"
}

variable "lambda_invoke_arn" {
  type = string
  description = "lambda invoke arn"
}

variable "authorization" {
  type    = string
  description = "method authorization type"
  default = "NONE"
}

variable "integration_http_method" {
  type    = string
  description = "http integration method"
  default = "POST"
}

variable "integration_type" {
  type    = string
  description = "integration type"
  default = "AWS_PROXY"
}

variable "stage_name" {
  type = string
  description = "stage name"
}

variable "cloudWatch_Alarms" {
  type = list(string)
  description = "list of cloudwatch alarms name"
}

variable "topic_arn" {
  type = string
  description = "arn of sns topic"
}