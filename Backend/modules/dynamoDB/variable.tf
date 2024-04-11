variable "table-name" {
  type = string
  default = "students-data"
}

variable "hash-key" {
  type = string
  description = "partition key"
  default = "StudentId"
}

variable "attribute-name" {
  type = string
  default = "StudentId"
}

variable "attribute-type" {
  type = string
  description = "type of the attribute"
  default = "S"
  
}
