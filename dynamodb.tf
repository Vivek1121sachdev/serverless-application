# resource "aws_dynamodb_table" "students-data" {
#   name           = "students-data"
#   billing_mode   = "PROVISIONED"
#   read_capacity  = 20
#   write_capacity = 20
#   hash_key       = "studentId"
#   attribute {
#     name = "studentId"
#     type = "S"
#   }
# }
