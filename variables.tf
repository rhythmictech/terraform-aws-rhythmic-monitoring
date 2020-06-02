########################################
# General Vars
########################################

variable "name" {
  description = "Moniker to apply to all resources in the module"
  type        = string
}

variable "pip_path" {
  default     = "/usr/local/bin/pip"
  description = "Path to your pip installation (must be valid if `enable_jira_integration=true`)"
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
variable "create_jira_secret_access_policy" {
  default     = true
  description = "If true, will attach an IAM policy granting read access to the secret containing the Jira access token. Only effective if `enable_jira_integration=true`"
}

variable "enable_jira_integration" {
  default     = false
  description = "Enable Jira integration Lambda"
  type        = bool
}

variable "jira_api_token_secret_name" {
  default     = null
  description = "Name of Secrets Manager secret containing API Token to use for requests (see https://confluence.atlassian.com/cloud/api-tokens-938839638.html)"
  type        = string
}

variable "jira_issue_type" {
  default     = null
  description = "Issue Type (key) to use for all issues"
  type        = string
}

variable "jira_project" {
  default     = null
  description = "Jira Project Key to create issues in"
  type        = string
}

variable "jira_url" {
  default     = null
  description = "URL of Jira instance"
  type        = string
}

variable "jira_username" {
  default     = null
  description = "Jira Username (must match specified API key)"
  type        = string
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
