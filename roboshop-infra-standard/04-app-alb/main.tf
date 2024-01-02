resource "aws_lb" "app-alb" {
  name               = "App_ALB"
  internal           = true #means it is private load balancer
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app-alb_sg_id.value]
  subnets            = split(",",data.aws_ssm_parameter.private_subnet_ids.value)

#   enable_deletion_protection = true  ---NOT REQUIRED---

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id   ---NOT REQUIRED---
#     prefix  = "test-lb"
#     enabled = true
#   }

  tags = {
    Environment = "production"
  }
}