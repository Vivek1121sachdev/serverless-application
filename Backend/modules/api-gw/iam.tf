resource "aws_iam_role" "apigw-role" {
  name               = "apigw-role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "apigateway.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "apigw-policy" {

  name        = "apigw-policy"
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
				"logs:CreateLogStream",
				"logs:DescribeLogStreams",
				"logs:PutLogEvents",
				"logs:GetLogEvents"
			],
			"Resource": ["${aws_cloudwatch_log_group.api-gw-log-group.arn}:*"]
		}
	]
}
EOF
}

resource "aws_iam_role_policy_attachment" "apigw" {
  role       = aws_iam_role.apigw-role.name
  policy_arn = aws_iam_policy.apigw-policy.arn
}
