########################################
# General Vars
########################################

variable "name" {
  description = "Moniker to apply to all resources in the module"
  type        = string
}

variable "tags" {
  default     = {}
  description = "User-Defined tags"
  type        = map(string)
}

########################################
# Monitoring Vars
########################################

variable "alert_webhook" {
  description = "Webhook to send alerts to. Currently muyst be a PagerDuty webhook"
  type        = string
}

variable "notify_webhook" {
  description = "Webhook to send notifications to. Currently must be a Slack webhook"
  type        = string
}

########################################
# Jira Integration Vars
########################################
variable "enable_jira_integration" {
  default     = false
  description = "This is experimental and not fully working yet."
  type        = bool
}

########################################
# Slack Integration Vars
########################################
variable "slack_channel" {
  description = "Slack channel to route alerts to"
  type        = string
}

variable "slack_username" {
  default     = ""
  description = "Slack username to post alerts as (will use aws account id if not specified)"
  type        = string
}
