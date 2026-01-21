resource "aws_sns_topic" "superstore_notifications" {
  name = "superstore-notifications"
}

resource "aws_sns_topic_subscription" "superstore_notifications_sns_target" {
  topic_arn = aws_sns_topic.superstore_notifications.arn
  protocol  = "email"
  endpoint  = var.sns_email_endpoint
}




