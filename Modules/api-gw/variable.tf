variable "api-gw-name" {
  type = string
}

variable "lambda_invoke_arn" {
  type = string
}

variable "authorization" {
  type = string
  default = "NONE"
}

variable "integration_http_method" {
  type = string
  default = "POST"
}

variable "integration_type" {
  type = string
  default = "AWS_PROXY"
}

variable "stage_name" {
  type = string
}