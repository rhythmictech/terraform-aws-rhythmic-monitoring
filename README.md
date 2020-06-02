# terraform-aws-rhythmic-monitoring [![](https://github.com/rhythmictech/terraform-aws-rhythmic-monitoring/workflows/pre-commit-check/badge.svg)](https://github.com/rhythmictech/terraform-aws-rhythmic-monitoring/actions) <a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=RhythmicTech" alt="follow on Twitter"></a>

_This is an experimental module_

Configures a basic monitoring pattern based on three thresholds:

* *Alerting* - send to something like PagerDuty
* *Ticketing* - send to something like Jira
* *Notify* - send to something like Slack

Currently this module only supports these targets, though we aim to make it more flexible over time to support different integrations.

You can attach currently CloudWatch Alarms and Metric Alarms.

## Example
Here's what using the module will look like
```
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

```
aws --region us-east-1 secretsmanager create-secret --name jira-api-token --secret-string="JIRA_API_TOKEN" --tags '[{"Key":"terraform_managed","Value":"false"}'
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alert\_webhook | Webhook to send alerts to. Currently muyst be a PagerDuty webhook | string | n/a | yes |
| enable\_jira\_integration | This is experimental and not fully working yet. | bool | `"false"` | no |
| name | Moniker to apply to all resources in the module | string | n/a | yes |
| notify\_webhook | Webhook to send notifications to. Currently must be a Slack webhook | string | n/a | yes |
| slack\_channel | Slack channel to route alerts to | string | n/a | yes |
| slack\_username | Slack username to post alerts as \(will use aws account id if not specified\) | string | `""` | no |
| tags | User-Defined tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| sns\_topic\_alert\_arn | Alert Topic ARN |
| sns\_topic\_notify\_arn | Notification Topic ARN |
| sns\_topic\_ticket\_arn | Ticketing Topic ARN |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## The Giants underneath this module
- pre-commit.com/
- terraform.io/
- github.com/tfutils/tfenv
- github.com/segmentio/terraform-docs
