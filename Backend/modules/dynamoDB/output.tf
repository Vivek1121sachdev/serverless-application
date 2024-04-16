output "dynamodb-arn" {
  value = aws_dynamodb_table.students-data.arn
  description = "DynamoDB table arn"
}