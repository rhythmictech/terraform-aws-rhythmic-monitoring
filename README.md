# terraform-aws-rhythmic-monitoring [![](https://github.com/rhythmictech/terraform-aws-rhythmic-monitoring/workflows/pre-commit-check/badge.svg)](https://github.com/rhythmictech/terraform-aws-rhythmic-monitoring/actions) <a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=RhythmicTech" alt="follow on Twitter"></a>

Configures a basic monitoring pattern based on three thresholds:

* *Alerting* - send to something like PagerDuty
* *Ticketing* - send to something like Jira
* *Notify* - send to something like Slack

Currently this module only supports these targets, though we aim to make it more flexible over time to support different integrations.

## Example
Here's what using the module will look like
```
module "example" {
  source = "rhythmictech/terraform-mycloud-mymodule
}
```

## About
A bit about this module

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
