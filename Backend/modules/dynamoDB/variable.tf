variable "table-name" {
  type = string
  description = "DynamoDB table name"
}

variable "hash-key" {
  type = string
  description = "Partition key"
}

variable "attribute-name" {
  type = string
  description = "Name of the attribute"
}

variable "attribute-type" {
  type = string
  description = "Type of the attribute"
}
