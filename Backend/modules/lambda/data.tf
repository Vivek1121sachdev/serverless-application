locals {
  policy_arns = {
    "lambda-dynamodb-policy" = aws_iam_policy.lambda-dynamodb-policy.arn
    "lambda-ssm-policy"      = aws_iam_policy.lambda-ssm-policy.arn
    "lambda-log-policy"      = aws_iam_policy.lambda-log-policy.arn
    "AWSLambdaBasicExecutionRole" = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  }
  path-parts = compact(var.path-parts)
}


// if we use this, we dont need the iam policy for this parameter and directly use the value of this parameter whenever we want
data "aws_ssm_parameter" "dbTableName" {
  name = "/serverless-application/dynamodb/dbTableName"
}