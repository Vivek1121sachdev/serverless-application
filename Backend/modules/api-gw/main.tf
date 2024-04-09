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

resource "aws_api_gateway_method_response" "method_response_health" {
  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  resource_id = aws_api_gateway_resource.resources["health"].id
  http_method = aws_api_gateway_method.health_get_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Methods" = true
     "method.response.header.Access-Control-Allow-Headers" = true,
  }
}

resource "aws_api_gateway_method" "student-method" {

  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  resource_id   = aws_api_gateway_resource.resources["student"].id
  http_method   = "ANY"
  authorization = var.authorization
}

resource "aws_api_gateway_method_response" "method_response_student" {

  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  resource_id = aws_api_gateway_resource.resources["student"].id
  http_method = aws_api_gateway_method.student-method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_method" "students_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  resource_id   = aws_api_gateway_resource.resources["students"].id
  http_method   = local.methods.get
  authorization = var.authorization
}

resource "aws_api_gateway_method_response" "method_response_students" {
  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  resource_id = aws_api_gateway_resource.resources["students"].id
  http_method = aws_api_gateway_method.students_get_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
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

resource "aws_api_gateway_integration_response" "integration_response_health" {

  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  resource_id = aws_api_gateway_resource.resources["health"].id
  http_method = aws_api_gateway_method.health_get_method.http_method
  status_code = "200"

response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }

  depends_on = [
    aws_api_gateway_integration.health-GET-integration,
    aws_api_gateway_method_response.method_response_health
  ]
}

resource "aws_api_gateway_integration" "student-integration" {

  rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
  resource_id             = aws_api_gateway_resource.resources["student"].id
  http_method             = aws_api_gateway_method.student-method.http_method
  integration_http_method = var.integration_http_method
  type                    = var.integration_type
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_integration_response" "integration_response_student" {

  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  resource_id = aws_api_gateway_resource.resources["student"].id
  http_method = "ANY"
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS,GET,PATCH,DELETE'"
    "method.response.header.Access-Control-Allow-Origin"  = "'http://serverless-application-frontend-code.s3-website.us-east-1.amazonaws.com'"
  }
  depends_on = [
    aws_api_gateway_integration.student-integration,
    aws_api_gateway_method_response.method_response_student
  ]
}

resource "aws_api_gateway_integration" "students-GET-integration" {
  rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
  resource_id             = aws_api_gateway_resource.resources["students"].id
  http_method             = aws_api_gateway_method.students_get_method.http_method
  integration_http_method = var.integration_http_method
  type                    = var.integration_type
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_integration_response" "integration_response_students" {
  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  resource_id = aws_api_gateway_resource.resources["students"].id
  http_method = aws_api_gateway_method.students_get_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,GET'"
    "method.response.header.Access-Control-Allow-Origin"  = "'http://serverless-application-frontend-code.s3-website.us-east-1.amazonaws.com'"
  }
  depends_on = [aws_api_gateway_integration.students-GET-integration,
    aws_api_gateway_method_response.method_response_students
  ]
}

resource "aws_api_gateway_gateway_response" "test" {
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  response_type = "DEFAULT_4XX"

  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin" = "'http://serverless-application-frontend-code.s3-website.us-east-1.amazonaws.com'" 
  }
}

resource "aws_api_gateway_gateway_response" "test2" {
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  response_type = "DEFAULT_5XX"

  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin" = "'http://serverless-application-frontend-code.s3-website.us-east-1.amazonaws.com'" 
  }
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
    aws_api_gateway_method.student-method,
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
