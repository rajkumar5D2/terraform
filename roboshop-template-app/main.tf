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


#creating launch template
resource "aws_launch_template" "main" {
  name = "${var.project_name}-${var.common_tags.component}"

  image_id = var.image_id

  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior

  instance_type = var.instance_type

  vpc_security_group_ids =[var.vpc_security_group_ids]

  dynamic tag_specifications {
    for_each = var.launch_template_tags
    content {
      resource_type = tag_specifications.value["resource_type"]
      tags = tag_specifications.value["tags"]
    }
  }
  user_data = var.user_data
}

#creating auto-scalling groups
resource "aws_autoscaling_group" "main" {
  name                      = "${var.project_name}-${var.common_tags.component}"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired_capacity
  target_group_arns = [aws_lb_target_group.main.arn]
  launch_template  {
    # id = aws_launch_template.catalogue.id
    id = aws_launch_template.main.id
    version = "$Latest"
    }
  # vpc_zone_identifier       = split(",",data.aws_ssm_parameter.private_subnet_ids.value)
  vpc_zone_identifier = var.vpc_zone_identifier

  dynamic tag {
    for_each = var.tags
    content {
      key = tag.value["key"]
      value = tag.value["value"]
      propagate_at_launch = tag.value["propagate_at_launch"]
 
  }

}
}

#creating a listener rule for the load balancer
resource "aws_lb_listener_rule" "https" {
listener_arn = var.lb_listener_arn
  priority = var.rule_priority
  
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    host_header {
      values = [var.host_header]
    }
  }
  tags ={
    Name = "https"
  }

}


# #creating a listener rule for the load balancer
# resource "aws_lb_listener_rule" "http" {
# listener_arn = var.lb_listener_arn
#   priority = var.rule_priority
  
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.main.arn
#   }

#   condition {
#     host_header {
#       values = [var.host_header]
#     }
#   }
#   tags ={
#     Name = "http"
#   }

# }