locals {
  policy_arns = {
    "lambda-dynamodb-policy" = aws_iam_policy.lambda-dynamodb-policy.arn
    "lambda-ssm-policy"      = aws_iam_policy.lambda-ssm-policy.arn
    "lambda-log-policy"      = aws_iam_policy.lambda-log-policy.arn
    "AWSLambdaBasicExecutionRole" = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
path-parts = compact(var.path-parts)
}

