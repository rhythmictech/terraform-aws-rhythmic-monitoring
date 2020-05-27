locals {
  jira_name = "${var.name}-create-jira"
}

resource "aws_sns_topic_subscription" "jira" {
  count                  = var.enable_jira_integration ? 1 : 0
  endpoint               = aws_lambda_function.jira[0].arn
  endpoint_auto_confirms = true
  protocol               = "https"
  topic_arn              = aws_sns_topic.ticket.arn
}

data "archive_file" "jira" {
  type        = "zip"
  source_file = "${path.module}/create_jira.py"
  output_path = "${path.module}/tmp/create_jira.zip"
}

data "aws_iam_policy_document" "jira_assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "jira" {
  count              = var.enable_jira_integration ? 1 : 0
  name_prefix        = local.jira_name
  assume_role_policy = data.aws_iam_policy_document.jira_assume.json
}

resource "aws_iam_role_policy_attachment" "jira" {
  count      = var.enable_jira_integration ? 1 : 0
  role       = aws_iam_role.jira[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "jira" {
  count            = var.enable_jira_integration ? 1 : 0
  function_name    = local.jira_name
  filename         = data.archive_file.jira.output_path
  handler          = "create_jira.handler"
  role             = aws_iam_role.jira[0].arn
  runtime          = "python3.7"
  source_code_hash = data.archive_file.jira.output_base64sha256
  tags             = var.tags
  timeout          = 180

  environment {
    variables = {

    }
  }

  lifecycle {
    ignore_changes = [
      filename,
      last_modified,
    ]
  }
}

resource "aws_lambda_permission" "jira" {
  count               = var.enable_jira_integration ? 1 : 0
  statement_id_prefix = "AllowExecutionFromCloudWatch-"
  action              = "lambda:InvokeFunction"
  function_name       = aws_lambda_function.jira[0].function_name
  principal           = "sns.amazonaws.com"
  source_arn          = aws_sns_topic.ticket.arn

  lifecycle {
    create_before_destroy = true
  }
}
