data "aws_caller_identity" "current" {
}

locals {
  account_id        = data.aws_caller_identity.current.account_id
  alert_topic_name  = "${var.name}-Alert-Topic"
  ticket_topic_name = "${var.name}-Ticket-Topic"
  notify_topic_name = "${var.name}-Notify-Topic"
}

resource "aws_sns_topic" "alert" {
  name = local.alert_topic_name
  tags = var.tags
}

resource "aws_sns_topic_subscription" "alert" {
  endpoint               = var.alert_webhook
  endpoint_auto_confirms = true
  protocol               = "https"
  topic_arn              = aws_sns_topic.alert.arn
}

resource "aws_sns_topic_policy" "alert" {
  arn    = aws_sns_topic.alert.arn
  policy = data.aws_iam_policy_document.alert.json
}

data "aws_iam_policy_document" "alert" {

  policy_id = "__default_policy_ID"

  statement {
    effect = "Allow"
    sid    = "__default_statement_ID"

    actions = [
      "SNS:AddPermission",
      "SNS:DeleteTopic",
      "SNS:GetTopicAttributes",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive",
      "SNS:RemovePermission",
      "SNS:SetTopicAttributes",
      "SNS:Subscribe"
    ]

    resources = [aws_sns_topic.alert.arn]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        local.account_id
      ]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    effect = "Allow"
    sid    = "CloudWatchEvents"

    actions = [
      "sns:Publish"
    ]

    resources = [aws_sns_topic.alert.arn]

    principals {
      type = "Service"

      identifiers = [
        "events.amazonaws.com"
      ]
    }
  }
}

resource "aws_sns_topic" "ticket" {
  name = local.ticket_topic_name
  tags = var.tags
}

# resource "aws_sns_topic_policy" "ticket" {
#   arn    = aws_sns_topic.notify.arn
#   policy = data.aws_iam_policy_document.policy.json
# }

resource "aws_sns_topic" "notify" {
  name = local.notify_topic_name
  tags = var.tags
}

resource "aws_sns_topic_policy" "notify" {
  arn    = aws_sns_topic.notify.arn
  policy = data.aws_iam_policy_document.notify.json
}

data "aws_iam_policy_document" "notify" {

  policy_id = "__default_policy_ID"

  statement {
    effect = "Allow"
    sid    = "__default_statement_ID"

    actions = [
      "SNS:AddPermission",
      "SNS:DeleteTopic",
      "SNS:GetTopicAttributes",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive",
      "SNS:RemovePermission",
      "SNS:SetTopicAttributes",
      "SNS:Subscribe"
    ]

    resources = [aws_sns_topic.notify.arn]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        local.account_id
      ]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    effect = "Allow"
    sid    = "CloudWatchEvents"

    actions = [
      "sns:Publish"
    ]

    resources = [aws_sns_topic.notify.arn]

    principals {
      type = "Service"

      identifiers = [
        "events.amazonaws.com"
      ]
    }
  }
}
