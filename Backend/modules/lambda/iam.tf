############
# IAM Role #
############

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

# ##############
# # Log Policy #
# ##############

# resource "aws_iam_policy" "lambda-log-policy" {
#   name        = "lambda-log-policy"
#   path        = "/"
#   description = "AWS IAM log Policy for managing aws lambda role"
#   policy      = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "Statement1",
#       "Effect": "Allow",
#       "Action": [
#         "logs:DescribeLogStreams",
#         "logs:PutLogEvents",
#         "logs:GetLogEvents",
#         "logs:CreateLogStream"
#         ],
#       "Resource": ["${aws_cloudwatch_log_group.lambda-log-group.arn}"]
#     }
#   ]
# }
# EOF
# }

###################
# DynamoDB Policy #
###################

resource "aws_iam_policy" "lambda-dynamodb-policy" {

  name        = "lambda-dynamodb-policy"
  path        = "/"
  description = "AWS IAM dynamodb Policy for managing aws lambda role"
  policy      = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement2",
			"Effect": "Allow",
			"Action": [
        "dynamodb:BatchGetItem",
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:BatchWriteItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
        ],
			"Resource": ["${var.dynamodb-arn}"]
		}
	]
}
EOF
}

##############
# SSM Policy #
##############

resource "aws_iam_policy" "lambda-ssm-policy" {
#are you passing this value?

  name        = "lambda-ssm-policy"
  path        = "/"
  description = "AWS IAM SSM Policy for managing aws lambda role"
  policy      = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement3",
			"Effect": "Allow",
			"Action": ["ssm:GetParameters"],
			"Resource": ["${var.parameter_ssm_arn}"]
		}
	]
}
EOF
}

##########################
# Role-Policy Attachment #
##########################

resource "aws_iam_role_policy_attachment" "policy-attachment" {
  for_each = local.policy_arns

  role       = aws_iam_role.lambda-role.name
  policy_arn = each.value
}

############################
# Lambda Invoke Permission #
############################

resource "aws_lambda_permission" "lambda_permission_all_resources" {
  for_each = toset(local.path-parts)

  statement_id  = "AllowExecutionFromAPIGatewayForResources-${each.value}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.execution_arn}/*/*/${each.value}"
}