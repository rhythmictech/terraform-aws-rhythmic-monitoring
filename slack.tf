locals {
  slack_username = coalesce(var.slack_username, local.account_id)
}

module "notify-slack" {
  source            = "terraform-aws-modules/notify-slack/aws"
  create_sns_topic  = false
  sns_topic_name    = aws_sns_topic.notify.name
  slack_webhook_url = var.notify_webhook
  slack_channel     = var.slack_channel
  slack_username    = local.slack_username
  tags              = var.tags
}
