locals {
  path-parts = {
    health = "health",
    student = "student",
    students = "students"
  }
  policy_arn = {
    lambda_simple = "${aws_iam_policy.lambda-policy.arn}"
    basic_lambda_execution = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  }
}
