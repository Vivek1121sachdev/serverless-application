// variables of main.tf 
variable "region" {
  type = string
}

# variable "aws_profile" {
#   type = string
# }


// variables for lambda.tf
variable "function_name" {
  type = string
}

variable "lambda_timeout" {
  type = number
}

//variables for iam.tf
# variable "api-gw-role" {
#   type = string
# }

# variable "lambda-role" {
#   type = string
# }


# variable "policy_arns" {
#   type = list(string)
# }

# variable "arg-1" {
#   type = string
# }

# variable "arg-2" {
#   type = string
# }

# variable "arg-3" {
#   type = string
# }

# variable "arg-4" {
#   type = string
# }

