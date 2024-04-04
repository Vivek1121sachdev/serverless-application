resource "aws_iam_role" "lambda-role" {
  name               = "lambda-role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "lambda-policy" {

  name        = "lambda-policy"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			"Action": [
				"logs:CreateLogGroup",
				"logs:CreateLogStream",
				"logs:DescribeLogGroups",
				"logs:DescribeLogStreams",
				"logs:PutLogEvents",
				"logs:GetLogEvents",
				"logs:FilterLogEvents",

				"dynamodb:BatchGetItem",
                "dynamodb:GetItem",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:BatchWriteItem",
                "dynamodb:PutItem",
                "dynamodb:UpdateItem",
                "dynamodb:DeleteItem",
                "ssm:GetParameter",
                "ssm:GetParameters"
			],
			"Resource":
      [
        "arn:aws:dynamodb:us-east-1:593242862402:table/students-data",
        "arn:aws:ssm:us-east-1:593242862402:parameter/dbTableName" 
      ]
		}
	]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy-attachment" {
  for_each = local.policy_arn

  role       = aws_iam_role.lambda-role.name
  policy_arn = each.value
}

resource "aws_lambda_permission" "lambda_permission_all_resources" {
  for_each = toset(var.path-parts)

  statement_id  = "AllowExecutionFromAPIGatewayForResources-${each.value}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.execution_arn}/*/*/${each.value}"
}

