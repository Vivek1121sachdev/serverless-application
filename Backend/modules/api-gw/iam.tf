# resource "aws_iam_role" "apigw-role" {
#   name               = "apigw-role"
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "apigateway.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role" "cloudwatch" {
#   name = "api_gateway_cloudwatch_global"
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "apigateway.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }


# resource "aws_iam_policy" "apigw-policy" {

#   name        = "apigw-policy"
#   path        = "/"
#   description = "AWS IAM Policy for managing aws lambda role"
#   policy      = <<EOF
# {
# 	"Version": "2012-10-17",
# 	"Statement": [
# 		{
# 			"Sid": "Statement1",
# 			"Effect": "Allow",
# 			"Action": [
# 				"logs:CreateLogGroup",
# 				"logs:CreateLogStream",
# 				"logs:DescribeLogGroups",
# 				"logs:DescribeLogStreams",
# 				"logs:PutLogEvents",
# 				"logs:GetLogEvents",
# 				"logs:FilterLogEvents"
# 			],
# 			"Resource": ["${aws_cloudwatch_log_group.api-gw-log-group.arn}"]
# 		}
# 	]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "apigw" {
#   role       = aws_iam_role.cloudwatch.role
#   policy_arn = aws_iam_policy.apigw-policy.arn
# }

resource "aws_iam_role" "api-gw-role" {
  name = "api-gw-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "apigw-log-policy" {
  name = "apigw-log-policy"
  role = aws_iam_role.api-gw-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
        	"logs:CreateLogGroup",
			"logs:CreateLogStream",
			"logs:DescribeLogGroups",
			"logs:DescribeLogStreams",
			"logs:PutLogEvents",
			"logs:GetLogEvents",
			"logs:FilterLogEvents"
        ]
        Effect   = "Allow"
        Resource = ["${aws_cloudwatch_log_group.api-gw-log-group.arn}"]
      },
    ]
  })
}

