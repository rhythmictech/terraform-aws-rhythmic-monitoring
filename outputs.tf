output "sns_topic_alert_arn" {
  description = "Alert Topic ARN"
  value       = aws_sns_topic.alert.arn
}

output "sns_topic_notify_arn" {
  description = "Notification Topic ARN"
  value       = aws_sns_topic.notify.arn
}

output "sns_topic_ticket_arn" {
  description = "Ticketing Topic ARN"
  value       = aws_sns_topic.ticket.arn
}