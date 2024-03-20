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
    }EOF
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

resource "aws_iam_role_policy_attachment" "policy-attachment" {
  for_each = local.policy_arn

  role       = aws_iam_role.lambda-role.name
  policy_arn = each.value
}

resource "aws_lambda_permission" "lambda_permission_all_resources" {
  for_each = local.path-parts

  statement_id  = "AllowExecutionFromAPIGatewayForResources"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.serverless-app.execution_arn}/*/*/${each.value}"
}

