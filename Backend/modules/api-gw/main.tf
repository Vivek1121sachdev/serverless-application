###############
# API Gateway #
###############

resource "aws_api_gateway_rest_api" "serverless-app" {
  name = var.api-gw-name
}

#############
# Resources #
#############

resource "aws_api_gateway_resource" "resources" {
  for_each = var.resources

  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  parent_id   = aws_api_gateway_rest_api.serverless-app.root_resource_id
  path_part   = each.key
}

###########
# Methods #
###########

resource "aws_api_gateway_method" "methods" {
  for_each = var.resources

  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  resource_id   = aws_api_gateway_resource.resources[each.key].id
  http_method   = each.value
  authorization = var.authorization
}

########################
# Backend -Integration #
########################

resource "aws_api_gateway_integration" "method-resource-integration" {
  for_each = var.resources

  rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
  resource_id             = aws_api_gateway_resource.resources[each.key].id
  http_method             = aws_api_gateway_method.methods[each.key].http_method
  integration_http_method = var.integration_http_method
  type                    = var.integration_type
  uri                     = var.lambda_invoke_arn

  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

###################
# Method Response #
###################

resource "aws_api_gateway_method_response" "method_responses" {
  for_each = var.resources

  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  resource_id = aws_api_gateway_resource.resources[each.key].id
  http_method = aws_api_gateway_method.methods[each.key].http_method
  status_code = 200
  response_parameters = {
   "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}


############################
# Student - Option Method  #
############################

// HTTP method //
resource "aws_api_gateway_method" "student-method-option" {

  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  resource_id   = aws_api_gateway_resource.resources["student"].id
  http_method   = "OPTIONS"
  authorization = var.authorization
}

// Mock Integration //
resource "aws_api_gateway_integration" "student-integration-option" {

  rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
  resource_id             = aws_api_gateway_resource.resources["student"].id
  http_method             = aws_api_gateway_method.student-method-option.http_method
  integration_http_method = var.integration_http_method
  type                    = "MOCK"

  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

// Integration Response //
resource "aws_api_gateway_integration_response" "integration_response_student-option" {

  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  resource_id = aws_api_gateway_resource.resources["student"].id
  http_method = aws_api_gateway_method.student-method-option.http_method
  status_code = 200
  response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
        "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
  depends_on = [
    aws_api_gateway_integration.student-integration-option,
    aws_api_gateway_method_response.method_response_student-option
  ]
}

// Method Response //
resource "aws_api_gateway_method_response" "method_response_student-option" {

  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  resource_id = aws_api_gateway_resource.resources["student"].id
  http_method = aws_api_gateway_method.student-method-option.http_method
  status_code = 200

  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

# // Integration Response //
# resource "aws_api_gateway_integration_response" "integration_response_student-option" {

#   rest_api_id = aws_api_gateway_rest_api.serverless-app.id
#   resource_id = aws_api_gateway_resource.resources["student"].id
#   http_method = aws_api_gateway_method.student-method-option.http_method
#   status_code = 200
#   response_parameters = {
#         "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
#         "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
#         "method.response.header.Access-Control-Allow-Origin" = "'*'"
#     }
#   depends_on = [
#     aws_api_gateway_integration.student-integration-option,
#     aws_api_gateway_method_response.method_response_student-option
#   ]
# }

#####################
# API-GW Deployment #
#####################

resource "aws_api_gateway_deployment" "api-gw-deployment" {
  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.serverless-app.body))
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_api_gateway_method.methods,
    aws_api_gateway_method.student-method-option,
    aws_api_gateway_integration.method-resource-integration,
    aws_api_gateway_integration.student-integration-option
  ]
}

###########################
# API-GW Deployment Stage #
###########################

// CloudWatch Log Group for API-GW //
resource "aws_cloudwatch_log_group" "api-gw-log-group" {
  name = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.serverless-app.id}/${var.stage_name}"
}

// API-GW Account //
resource "aws_api_gateway_account" "api-gw-account" {
  cloudwatch_role_arn = "${aws_iam_role.api-gw-role.arn}"
}

// Deployment Stage //
resource "aws_api_gateway_stage" "deployment-stage" {
  deployment_id = aws_api_gateway_deployment.api-gw-deployment.id
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  stage_name    = var.stage_name

  access_log_settings {
    destination_arn = "${aws_cloudwatch_log_group.api-gw-log-group.arn}"
    format          = jsonencode({
      requestId     = "$context.requestId"
      ip            = "$context.identity.sourceIp"
      httpMethod    = "$context.httpMethod"
      path          = "$context.path"
      status        = "$context.status" 
      responseLength = "$context.responseLength"
      domainName    = "$context.domainName"
    })
  }

    depends_on = [aws_cloudwatch_log_group.api-gw-log-group]
}

// Method Settings //
resource "aws_api_gateway_method_settings" "enable_logging" {
  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  stage_name  = aws_api_gateway_stage.deployment-stage.stage_name
  method_path = "*/*"

  settings {
    logging_level      = "INFO"
    metrics_enabled    = true
    data_trace_enabled = true
  }
}

