#creating a target group of catalogue
resource "aws_lb_target_group" "main" {
  name        = "${var.project_name}-${var.common_tags.component}"
  # target_type = "alb"
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc_id
  health_check {
    enabled             = var.health_check.enabled
    healthy_threshold   = var.health_check.healthy_threshold
    interval            = var.health_check.interval
    matcher             = var.health_check.matcher
    path                = var.health_check.path
    port                = var.health_check.port
    protocol            = var.health_check.protocol
    timeout             = var.health_check.timeout
    unhealthy_threshold = var.health_check.unhealthy_threshold
  }
}
