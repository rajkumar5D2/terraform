#creating application load balancer
resource "aws_lb" "app-alb" {
  name               = "App-alb"
  internal           = true #means it is private load balancer
  load_balancer_type = "application" #specfying it is ALB
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

#creating listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
        content_type = "text/plain"
        message_body = "ikkada ledu beyyy"
        status_code = "400"
    }
  }
}

#creating a record and attaching load balancer to our website
module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"
  zone_name = "mydomainproject.tech"

  records = [
    {
        name = "*.app"
        type = "A"
        alias = {
            name = aws_lb.app-alb.dns_name
            zone_id = aws_lb.app-alb.zone_id
        }
    }
  ]
}