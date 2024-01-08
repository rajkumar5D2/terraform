resource "aws_ssm_parameter" "web-alb_listener_arn_https" {
  name = "/${var.project_name}/${var.environment}/web-alb_listener_arn_https"
  type = "String"
  value = aws_lb_listener.mydomainproject_https.arn
}

resource "aws_ssm_parameter" "web-alb_listener_arn_http" {
  name = "/${var.project_name}/${var.environment}/web-alb_listener_arn_http"
  type = "String"
  value = aws_lb_listener.mydomainproject_http.arn
}