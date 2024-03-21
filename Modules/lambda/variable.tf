variable "function_name" {
  type = string
}

variable "lambda_timeout" {
  type = number
}

variable "repository_name" {
  type = string
}

variable "image-uri" {
  type = string
}

variable "execution_arn" {
  type = string
}

variable "path-parts" {
  type = list(string)
}
