resource "aws_api_gateway_rest_api" "serverless-app" {
  name = var.api-gw-name
}

resource "aws_api_gateway_resource" "resources" {
  for_each = local.path-parts

  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  parent_id   = aws_api_gateway_rest_api.serverless-app.root_resource_id
  path_part   = each.value
}

// api gateway methods

resource "aws_api_gateway_method" "health_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  resource_id   = aws_api_gateway_resource.resources["health"].id
  http_method   = local.methods.get
  authorization = var.authorization
}

resource "aws_api_gateway_method" "student-methods" {
  for_each = local.methods

  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  resource_id   = aws_api_gateway_resource.resources["student"].id
  http_method   = each.value
  authorization = var.authorization
}

resource "aws_api_gateway_method" "students_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  resource_id   = aws_api_gateway_resource.resources["students"].id
  http_method   = local.methods.get
  authorization = var.authorization
}

// api gateway resourse method integration

resource "aws_api_gateway_integration" "health-GET-integration" {
  rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
  resource_id             = aws_api_gateway_resource.resources["health"].id
  http_method             = aws_api_gateway_method.health_get_method.http_method
  integration_http_method = var.integration_http_method
  type                    = var.integration_type
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_integration" "student-integration" {
  for_each                = aws_api_gateway_method.student-methods

  rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
  resource_id             = aws_api_gateway_resource.resources["student"].id
  http_method             = each.value.http_method
  integration_http_method = var.integration_http_method
  type                    = var.integration_type
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_integration" "students-GET-integration" {
  rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
  resource_id             = aws_api_gateway_resource.resources["students"].id
  http_method             = aws_api_gateway_method.students_get_method.http_method
  integration_http_method = var.integration_http_method
  type                    = var.integration_type
  uri                     = var.lambda_invoke_arn
}

// api gateway deployment

resource "aws_api_gateway_deployment" "api-gw-deployment" {
  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.serverless-app.body))
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [

    aws_api_gateway_method.health_get_method,
    aws_api_gateway_method.student-methods,
    aws_api_gateway_method.students_get_method,
    aws_api_gateway_integration.health-GET-integration,
    aws_api_gateway_integration.student-integration,
    aws_api_gateway_integration.students-GET-integration
  ]
}

// api gateway deployment stage

resource "aws_api_gateway_stage" "deployment-stage" {
  deployment_id = aws_api_gateway_deployment.api-gw-deployment.id
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  stage_name    = var.stage_name
}