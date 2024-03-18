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



