#############
# SNS Topic #
#############

resource "aws_sns_topic" "sns_topic" {
  name = var.topic-name
}

######################
# Topic Subscription #
######################

resource "aws_sns_topic_subscription" "sns_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = var.protocol
  endpoint  = local.email
}