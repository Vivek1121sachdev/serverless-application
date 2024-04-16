variable "api-gw-name" {
  type = string
  default = "serverless-app"
}

variable "lambda_invoke_arn" {
  type = string
}

variable "authorization" {
  type    = string
  default = "NONE"
}

variable "integration_http_method" {
  type    = string
  default = "POST"
}

variable "integration_type" {
  type    = string
  default = "AWS_PROXY"
}

variable "stage_name" {
  type = string
}

variable "cloudWatch_Alarms" {
  type = list(string)
}

variable "topic_arn" {
  type = string
}

#add description for all variables