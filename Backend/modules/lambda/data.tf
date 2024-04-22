locals {
  // Policy ARNs
  policy_arns = {
    "lambda-dynamodb-policy" = aws_iam_policy.lambda-dynamodb-policy.arn
    "lambda-ssm-policy"      = aws_iam_policy.lambda-ssm-policy.arn
    # "lambda-log-policy"      = aws_iam_policy.lambda-log-policy.arn
    "AWSLambdaBasicExecutionRole" = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  }

  // API-GW resources name //
  path-parts = compact(var.path-parts)

  // Mapping the dynamic names with the ssm parameter values for lambda environment variable
  env_ssm_params = length(keys(var.dynamic_env)) == 0 ? {} : zipmap(
    [for key, value in var.dynamic_env : key],
    [for parameter in data.aws_ssm_parameter.parameters : parameter.value]
  )

  // Merging the Static and Dynamic Environment variables //
  env_vars = merge(local.env_ssm_params,var.env)
}


// if we use this, we dont need the iam policy for this parameter and directly use the value of this parameter whenever we want
data "aws_ssm_parameter" "parameters" {
  for_each = var.dynamic_env
  name = each.value
}