
data "aws_iam_policy_document" "monitoring_key" {

  statement {
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey*"
    ]

    principals {
      type = "Service"
      identifiers = [
        "cloudwatch.amazonaws.com",
        "events.amazonaws.com"
      ]
    }
  }
}

resource "aws_kms_key" "monitoring" {
  deletion_window_in_days = 7
  description             = "Monitoring Topic KMS Key"
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.monitoring_key.json

  tags = merge(var.tags,
    {
      "Name" = "monitoring-key"
    }
  )
}

resource "aws_kms_alias" "monitoring" {
  name          = "alias/account-monitoring"
  target_key_id = aws_kms_key.monitoring.id
}
