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

# variable "integration_response_parameters" {
#   type = map
#   default = {
#     "method.response.header.Access-Control-Allow-Origin"  = "'http://serverless-application-frontend-code.s3-website.us-east-1.amazonaws.com'"
#   }
# }
