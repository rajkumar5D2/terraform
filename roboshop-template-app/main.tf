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

  # tag_specifications {
  #   resource_type = var.tag_specifications.resource_type
  #   tags = {
  #     Name = var.tag_specifications.tag.Name
  #   }
  # }

  dynamic tag_specifications {
    for_each = var.launch_specification
    content {
      resource_type = tag_specifications.value["resource_type"]
      tags = tag_specifications.value["tags"]
    }
  }
  user_data = var.user_data
}

