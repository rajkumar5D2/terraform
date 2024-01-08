output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}

output "listener_arn" {
  value = var.lb_listener_arn
}