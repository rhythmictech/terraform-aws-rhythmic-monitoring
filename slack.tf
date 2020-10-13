locals {
  slack_username = coalesce(var.slack_username, local.account_id)
}

# The provider will compute sns_topic_name implicitly. Since you can't
# set depends_on in a module, the `aws_arn` object forces the object
# graph to complete before attempting to compute `aws_sns_topic.notify.name`.
data "aws_arn" "notify" {
  arn = aws_sns_topic.notify.arn
}

module "notify-slack" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 4.3"

  create_sns_topic  = false
  sns_topic_name    = data.aws_arn.notify.resource
  slack_webhook_url = var.notify_webhook
  slack_channel     = var.slack_channel
  slack_username    = local.slack_username
  tags              = var.tags
}
