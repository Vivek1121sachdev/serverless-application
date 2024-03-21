resource "aws_api_gateway_rest_api" "serverless-app" {
  name = "serverless-app"
}

locals {
  resource-method = {
    health   = toset(["GET"]),
    student  = toset(["GET", "POST", "PATCH", "DELETE"]),
    students = toset(["GET"])
  }
}

resource "aws_api_gateway_resource" "resources" {
  for_each = local.resource-method

  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  parent_id   = aws_api_gateway_rest_api.serverless-app.root_resource_id
  path_part   = each.key
}

resource "aws_api_gateway_method" "all_method" {

  for_each = local.resource-method

  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  resource_id   = "aws_api_gateway_resource.resources.${each.key}.id"
  http_method   = each.value
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "resource-method-integration" {
  for_each = local.resource-method

  rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
  resource_id             = "aws_api_gateway_resource.resources.${each.key}.id"
  http_method             = each.value
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda.invoke_arn
}


resource "aws_api_gateway_deployment" "api-gw-deployment" {
  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.serverless-app.body))
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [

    aws_api_gateway_method.all_method,
    aws_api_gateway_integration.resource-method-integration

  ]
}

resource "aws_api_gateway_stage" "deployment-stage" {
  deployment_id = aws_api_gateway_deployment.api-gw-deployment.id
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  stage_name    = "dev"
}
