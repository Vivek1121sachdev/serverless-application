resource "aws_dynamodb_table" "students-data" {
  name           = var.table-name
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = var.hash-key
  attribute {
    name = var.attribute-name
    type = var.attribute-type
  }
}
