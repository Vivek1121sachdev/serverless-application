# ########################
# # CloudWatch Log Group #
# ########################

# resource "aws_cloudwatch_log_group" "api-gw-log-group" {
#   name = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.serverless-app.id}/${var.stage_name}"
# }

##########################################
# CloudWatch Alarm on 4XX and 5XX errors #
##########################################

resource "aws_cloudwatch_metric_alarm" "api_gateway_alarms" {
  for_each = toset(local.cloudWatch_Alarm)

  alarm_name          = "${aws_api_gateway_rest_api.serverless-app.name} API gateway ${each.value} rate"
  comparison_operator = "GreaterThanThreshold"
  period              = 300 #value from var
  evaluation_periods  = 1 #value from var
  metric_name         = "${each.value}"
  namespace           = "AWS/ApiGateway"
  statistic           = "Sum"
  threshold           = 0 #value from var
  alarm_description   = "API gateway ${each.value} rate has exceeded threshold"
  alarm_actions       = ["${var.topic_arn}"]
  treat_missing_data  = "ignore"
  actions_enabled     = true
  dimensions          = {
    ApiName = aws_api_gateway_rest_api.serverless-app.name
    Stage    = var.stage_name
  }
}