resource "aws_api_gateway_rest_api" "serverless-app" {
  name = "serverless-app"
}


# resource "aws_api_gateway_resource" "resources" {
#   rest_api_id = aws_api_gateway_rest_api.serverless-app.id
#   parent_id   = aws_api_gateway_rest_api.serverless-app.root_resource_id
#   path_part   = var.api-gateway-resources[count.index]
# }

resource "aws_api_gateway_resource" "health" {
  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  parent_id   = aws_api_gateway_rest_api.serverless-app.root_resource_id
  path_part   = "health"
}

resource "aws_api_gateway_resource" "student" {
  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  parent_id   = aws_api_gateway_rest_api.serverless-app.root_resource_id
  path_part   = "student"
}

resource "aws_api_gateway_resource" "students" {
  rest_api_id = aws_api_gateway_rest_api.serverless-app.id
  parent_id   = aws_api_gateway_rest_api.serverless-app.root_resource_id
  path_part   = "students"
}

resource "aws_api_gateway_method" "health_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  resource_id   = aws_api_gateway_resource.health.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "student_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  resource_id   = aws_api_gateway_resource.student.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "student_delete_method" {
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  resource_id   = aws_api_gateway_resource.student.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "student_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  resource_id   = aws_api_gateway_resource.student.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "student_patch_method" {
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  resource_id   = aws_api_gateway_resource.student.id
  http_method   = "PATCH"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "students_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  resource_id   = aws_api_gateway_resource.students.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "health-GET-integration" {
  rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
  resource_id             = aws_api_gateway_resource.health.id
  http_method             = aws_api_gateway_method.health_get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${module.lambda.invoke_arn}"
}

resource "aws_api_gateway_integration" "student-GET-integration" {
  rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
  resource_id             = aws_api_gateway_resource.student.id
  http_method             = aws_api_gateway_method.student_get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${module.lambda.invoke_arn}"
}

resource "aws_api_gateway_integration" "student-DELETE-integration" {
  rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
  resource_id             = aws_api_gateway_resource.student.id
  http_method             = aws_api_gateway_method.student_delete_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${module.lambda.invoke_arn}"
}

resource "aws_api_gateway_integration" "student-POST-integration" {
  rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
  resource_id             = aws_api_gateway_resource.student.id
  http_method             = aws_api_gateway_method.student_post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${module.lambda.invoke_arn}"
}

resource "aws_api_gateway_integration" "student-PATCH-integration" {
  rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
  resource_id             = aws_api_gateway_resource.student.id
  http_method             = aws_api_gateway_method.student_patch_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${module.lambda.invoke_arn}"
}

resource "aws_api_gateway_integration" "students-GET-integration" {
  rest_api_id             = aws_api_gateway_rest_api.serverless-app.id
  resource_id             = aws_api_gateway_resource.students.id
  http_method             = aws_api_gateway_method.students_get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${module.lambda.invoke_arn}"
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
    aws_api_gateway_method.student_delete_method,
    aws_api_gateway_method.student_get_method,
    aws_api_gateway_method.student_patch_method,
    aws_api_gateway_method.student_post_method,
    aws_api_gateway_method.students_get_method,
    aws_api_gateway_method.health_get_method,

    aws_api_gateway_integration.student-GET-integration,
    aws_api_gateway_integration.student-DELETE-integration,
    aws_api_gateway_integration.student-PATCH-integration,
    aws_api_gateway_integration.student-POST-integration,
    aws_api_gateway_integration.students-GET-integration,
    aws_api_gateway_integration.health-GET-integration
  ]
}

resource "aws_api_gateway_stage" "deployment-stage" {
  deployment_id = aws_api_gateway_deployment.api-gw-deployment.id
  rest_api_id   = aws_api_gateway_rest_api.serverless-app.id
  stage_name    = "dev"
}
