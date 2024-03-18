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
				"cloudwatch:*",
				"lambda:*"
			],
			"Resource": ["arn:aws:lambda:us-east-1:593242862402:function:students-lambda-funtions"]
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
				"cloudwatch:*",
				"dynamodb:*"
			],
			"Resource": ["*"]
		}
	]
}
EOF
}

resource "aws_iam_role_policy_attachment" "apigw" {
  role       = aws_iam_role.apigw-role.name
  policy_arn = aws_iam_policy.apigw-policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_simple" {
  role       = aws_iam_role.lambda-role.name
  policy_arn = aws_iam_policy.lambda-policy.arn
}

resource "aws_iam_role_policy_attachment" "basic_lambda_execution" {
  role       = aws_iam_role.lambda-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "lambda_permission_health" {
  statement_id  = "AllowExecutionFromAPIGatewayForHealth"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.serverless-app.execution_arn}/*/*/health"
}

resource "aws_lambda_permission" "lambda_permission_student" {
  statement_id  = "AllowExecutionFromAPIGatewayForStudent"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.serverless-app.execution_arn}/*/*/student"
}

resource "aws_lambda_permission" "lambda_permission_students" {
  statement_id  = "AllowExecutionFromAPIGatewayForStudents"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.serverless-app.execution_arn}/*/*/students"
}

# arn:aws:execute-api:us-east-1:593242862402:usx36z2fm6:usx36z2fm6/*/POST/students
# arn:aws:execute-api:us-east-1:593242862402:usx36z2fm6/*/GET/health