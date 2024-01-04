#creating application load balancer
resource "aws_lb" "web-alb" {
  name               = "web-alb"
  internal           = false #means it is public load balancer
  load_balancer_type = "application" #specfying it is ALB
  security_groups    = [data.aws_ssm_parameter.web-alb_sg_id.value]
  subnets            = split(",",data.aws_ssm_parameter.public_subnet_ids.value)

  tags = var.common_tags
}

# #creating listener
# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.web-alb.arn
#   port              = "443"
#   protocol          = "HTTPS"

#   default_action {
#     type = "fixed-response"

#     fixed_response {
#         content_type = "text/plain"
#         message_body = "ikkada ledu beyyy"
#         status_code = "400"
#     }
#   }
# }
resource "aws_acm_certificate" "mydomainproject" {
  domain_name       = "mydomainproject.tech"
  validation_method = "DNS"
}

  data "aws_route53_zone" "mydomainproject" {
  name         = "mydomainproject.tech"
  private_zone = false
}

resource "aws_route53_record" "mydomainproject" {
  for_each = {
    for dvo in aws_acm_certificate.mydomainproject.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.mydomainproject.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.mydomainproject.arn
  validation_record_fqdns = [for record in aws_route53_record.mydomainproject : record.fqdn]

}

resource "aws_lb_listener" "mydomainproject_https" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   =aws_acm_certificate.mydomainproject.arn

  default_action {
    type = "fixed-response"

    fixed_response {
        content_type = "text/plain"
        message_body = "ikkada ledu beyyy from https"
        status_code = "400"
    }
}
}

resource "aws_lb_listener" "mydomainproject_http" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = "80"
  protocol          = "HTTP"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   =aws_acm_certificate.mydomainproject.arn

  default_action {
    type = "fixed-response"

    fixed_response {
        content_type = "text/plain"
        message_body = "ikkada ledu beyyy from http"
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
        name = ""
        type = "A"
        alias = {
            name = aws_lb.web-alb.dns_name
            zone_id = aws_lb.web-alb.zone_id
        }
    }
  ]
}