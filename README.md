# terraform-aws-rhythmic-monitoring

[![tflint](https://github.com/rhythmictech/terraform-aws-rhythmic-monitoring/workflows/tflint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-rhythmic-monitoring/actions?query=workflow%3Atflint+event%3Apush+branch%3Amaster)
[![tfsec](https://github.com/rhythmictech/terraform-aws-rhythmic-monitoring/workflows/tfsec/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-rhythmic-monitoring/actions?query=workflow%3Atfsec+event%3Apush+branch%3Amaster)
[![yamllint](https://github.com/rhythmictech/terraform-aws-rhythmic-monitoring/workflows/yamllint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-rhythmic-monitoring/actions?query=workflow%3Ayamllint+event%3Apush+branch%3Amaster)
[![misspell](https://github.com/rhythmictech/terraform-aws-rhythmic-monitoring/workflows/misspell/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-rhythmic-monitoring/actions?query=workflow%3Amisspell+event%3Apush+branch%3Amaster)
[![pre-commit-check](https://github.com/rhythmictech/terraform-aws-rhythmic-monitoring/workflows/pre-commit-check/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-rhythmic-monitoring/actions?query=workflow%3Apre-commit-check+event%3Apush+branch%3Amaster)
<a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=twitter" alt="follow on Twitter"></a>

_This is an experimental module_

Configures a basic monitoring pattern based on three thresholds:

* *Alerting* - send to something like PagerDuty
* *Ticketing* - send to something like Jira
* *Notify* - send to something like Slack

Currently this module only supports these targets, though we aim to make it more flexible over time to support different integrations.

You can attach currently CloudWatch Alarms and Metric Alarms.

## Example
Here's what using the module will look like
```tf
module "monitoring" {
  source = "rhythmictech/terraform-aws-rhythmic-monitoring"

  alert_webhook              = var.pagerduty_webhook
  enable_jira_integration    = true
  name                       = "Monitoring"
  notify_webhook             = var.slack_webhook
  jira_api_token_secret_name = "jira-api-token"
  jira_issue_type            = "Incident"
  jira_project               = "JSD"
  jira_url                   = "https://customer.atlassian.net/"
  jira_username              = "jira_user"
  slack_channel              = var.slack_channel
  slack_username             = var.slack_username
}
```

## Jira integration
To use Jira integration, you need to save your API key in AWS Secrets Manager. Something like this would work:

```sh
aws secretsmanager create-secret \
  --region us-east-1 \
  --name jira-api-token \
  --secret-string="JIRA_API_TOKEN" \
  --tags '[{"Key":"terraform_managed","Value":"false"}]'
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| archive | 1.3.0 |
| aws | >= 3.0 |
| null | 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| archive | 1.3.0 |
| aws | >= 3.0 |
| null | 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alert\_webhook | Webhook to send alerts to. Currently must be a PagerDuty webhook | `string` | n/a | yes |
| name | Moniker to apply to all resources in the module | `string` | n/a | yes |
| notify\_webhook | Webhook to send notifications to. Currently must be a Slack webhook | `string` | n/a | yes |
| slack\_channel | Slack channel to route alerts to | `string` | n/a | yes |
| create\_jira\_secret\_access\_policy | If true, will attach an IAM policy granting read access to the secret containing the Jira access token. Only effective if `enable_jira_integration=true` | `bool` | `true` | no |
| enable\_jira\_integration | Enable Jira integration Lambda | `bool` | `false` | no |
| jira\_api\_token\_secret\_name | Name of Secrets Manager secret containing API Token to use for requests (see https://confluence.atlassian.com/cloud/api-tokens-938839638.html) | `string` | `null` | no |
| jira\_issue\_type | Issue Type (key) to use for all issues | `string` | `null` | no |
| jira\_project | Jira Project Key to create issues in | `string` | `null` | no |
| jira\_url | URL of Jira instance | `string` | `null` | no |
| jira\_username | Jira Username (must match specified API key) | `string` | `null` | no |
| pip\_path | Path to your pip installation (must be valid if `enable_jira_integration=true`) | `string` | `"/usr/local/bin/pip"` | no |
| slack\_username | Slack username to post alerts as (will use aws account id if not specified) | `string` | `""` | no |
| tags | User-Defined tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| sns\_topic\_alert\_arn | Alert Topic ARN |
| sns\_topic\_notify\_arn | Notification Topic ARN |
| sns\_topic\_ticket\_arn | Ticketing Topic ARN |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
