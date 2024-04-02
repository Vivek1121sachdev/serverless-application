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
				"logs:CreateLogGroup",
				"logs:CreateLogStream",
				"logs:DescribeLogGroups",
				"logs:DescribeLogStreams",
				"logs:PutLogEvents",
				"logs:GetLogEvents",
				"logs:FilterLogEvents",
				"lambda:InvokeFunction"
			],
			"Resource": ["arn:aws:lambda:us-east-1:593242862402:function:students-lambda-funtions"]
		}
	]
}
EOF
}

resource "aws_iam_role_policy_attachment" "apigw" {
  role       = aws_iam_role.apigw-role.name
  policy_arn = aws_iam_policy.apigw-policy.arn
}
