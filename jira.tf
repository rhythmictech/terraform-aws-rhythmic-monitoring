locals {
  jira_api_token = try(data.aws_secretsmanager_secret.jira[0].arn, null)
  jira_name      = "${var.name}-create-jira"
}

resource "aws_sns_topic_subscription" "jira" {
  count                  = var.enable_jira_integration ? 1 : 0
  endpoint               = aws_lambda_function.jira[0].arn
  endpoint_auto_confirms = true
  protocol               = "lambda"
  topic_arn              = aws_sns_topic.ticket.arn
}

resource "null_resource" "pip" {
  triggers = {
    main         = base64sha256(file("${path.module}/lambda/create_jira.py"))
    requirements = base64sha256(file("${path.module}/lambda/requirements.txt"))
    zipexists    = ! fileexists("${path.module}/create_jira.zip")
  }

  provisioner "local-exec" {
    command = "rm -rf ${path.module}/build"
  }

  provisioner "local-exec" {
    command = "mkdir -p ${path.module}/build"
  }

  provisioner "local-exec" {
    command = "${var.pip_path} install -r ${path.module}/lambda/requirements.txt -t ${path.module}/build"
  }

  provisioner "local-exec" {
    command = "cp ${path.module}/lambda/create_jira.py ${path.module}/build"
  }
}

data "archive_file" "jira_bundle" {
  type        = "zip"
  source_dir  = "${path.module}/build/"
  output_path = "${path.module}/create_jira.zip"

  depends_on = [null_resource.pip]
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

data "aws_secretsmanager_secret" "jira" {
  count = var.enable_jira_integration ? 1 : 0
  name  = var.jira_api_token_secret_name
}

data "aws_iam_policy_document" "secret_access" {
  count = var.create_jira_secret_access_policy ? 1 : 0

  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    effect    = "Allow"
    resources = [local.jira_api_token]
  }
}

resource "aws_iam_role_policy" "secret_access" {
  count  = var.create_jira_secret_access_policy ? 1 : 0
  role   = aws_iam_role.jira[0].name
  policy = data.aws_iam_policy_document.secret_access[0].json
}



resource "aws_lambda_function" "jira" {
  count            = var.enable_jira_integration ? 1 : 0
  function_name    = local.jira_name
  filename         = "${path.module}/create_jira.zip"
  handler          = "create_jira.lambda_handler"
  role             = aws_iam_role.jira[0].arn
  runtime          = "python3.7"
  source_code_hash = data.archive_file.jira_bundle.output_base64sha256
  tags             = var.tags
  timeout          = 180

  environment {
    variables = {
      INTEGRATION_NAME          = var.name
      ISSUE_TYPE                = var.jira_issue_type
      JIRA_API_TOKEN_SECRET_ARN = local.jira_api_token
      JIRA_PROJECT              = var.jira_project
      JIRA_URL                  = var.jira_url
      JIRA_USERNAME             = var.jira_username
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
