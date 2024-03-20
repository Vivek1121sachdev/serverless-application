resource "aws_api_gateway_rest_api" "serverless-app" {
  name = "serverless-app"
}


# resource "aws_api_gateway_resource" "resources" {
#   rest_api_id = aws_api_gateway_rest_api.serverless-app.id
#   parent_id   = aws_api_gateway_rest_api.serverless-app.root_resource_id
#   path_part   = var.api-gateway-resources[count.index]
# }
locals {
  path-parts = {
    health   = "health",
    student  = "student",
    students = "students"
  }
  methods = {
    get    = "GET",
    post   = "POST",
    patch  = "PATCH",
    delete = "DELETE"
  }
}

resource "aws_api_gateway_resource" "resources" {
  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  parent_id   = aws_api_gateway_rest_api.serverless-app.root_resource_id
  for_each    = local.path-parts
  path_part   = each.value
}

resource "aws_api_gateway_method" "health_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  resource_id   = aws_api_gateway_resource.resources["health"].id
  http_method   = local.methods.get
  authorization = "NONE"
}

resource "aws_api_gateway_method" "student-methods" {
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  resource_id   = aws_api_gateway_resource.resources["student"].id
  for_each      = local.methods
  http_method   = each.value
  authorization = "NONE"
}

resource "aws_api_gateway_method" "students_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  resource_id   = aws_api_gateway_resource.resources["students"].id
  http_method   = local.methods.get
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "health-GET-integration" {
  rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
  resource_id             = aws_api_gateway_resource.resources["health"].id
  http_method             = aws_api_gateway_method.health_get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda.invoke_arn
}

resource "aws_api_gateway_integration" "student-integration" {
  for_each                = aws_api_gateway_method.student-methods
  rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
  resource_id             = aws_api_gateway_resource.resources["student"].id
  http_method             = each.value.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda.invoke_arn
}

# resource "aws_api_gateway_integration" "student-GET-integration" {
#   rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
#   resource_id             = aws_api_gateway_resource.student.id
#   http_method             = aws_api_gateway_method.student_get_method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = module.lambda.invoke_arn
# }
# resource "aws_api_gateway_integration" "student-DELETE-integration" {
#   rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
#   resource_id             = aws_api_gateway_resource.student.id
#   http_method             = aws_api_gateway_method.student_delete_method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = module.lambda.invoke_arn
# }
# resource "aws_api_gateway_integration" "student-POST-integration" {
#   rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
#   resource_id             = aws_api_gateway_resource.student.id
#   http_method             = aws_api_gateway_method.student_post_method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = module.lambda.invoke_arn
# }
# resource "aws_api_gateway_integration" "student-PATCH-integration" {
#   rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
#   resource_id             = aws_api_gateway_resource.student.id
#   http_method             = aws_api_gateway_method.student_patch_method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = module.lambda.invoke_arn
# }

resource "aws_api_gateway_integration" "students-GET-integration" {
  rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
  resource_id             = aws_api_gateway_resource.resources["students"].id
  http_method             = aws_api_gateway_method.students_get_method.http_method
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
    aws_api_gateway_method.student-methods,
    # aws_api_gateway_method.student_delete_method,
    # aws_api_gateway_method.student_get_method,
    # aws_api_gateway_method.student_patch_method,
    # aws_api_gateway_method.student_post_method,
    aws_api_gateway_method.students_get_method,
    aws_api_gateway_method.health_get_method,

    aws_api_gateway_integration.student-integration,
    # aws_api_gateway_integration.student-GET-integration,
    # aws_api_gateway_integration.student-DELETE-integration,
    # aws_api_gateway_integration.student-PATCH-integration,
    # aws_api_gateway_integration.student-POST-integration,
    aws_api_gateway_integration.students-GET-integration,
    aws_api_gateway_integration.health-GET-integration
  ]
}

resource "aws_api_gateway_stage" "deployment-stage" {
  deployment_id = aws_api_gateway_deployment.api-gw-deployment.id
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  stage_name    = "dev"
}
