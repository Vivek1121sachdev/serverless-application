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

  policy = <<EOF
{
	"Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : [
		"logs:DescribeLogStreams",
        "logs:PutLogEvents",
        "logs:GetLogEvents",
        "logs:CreateLogStream"
      ],
      "Resource" :  ["*"]
    }
  ]
}
EOF
}