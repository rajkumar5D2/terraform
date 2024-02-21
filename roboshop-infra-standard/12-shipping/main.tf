module "shipping" {
  source = "../../roboshop-template-app"
  project_name = var.project_name
  environment = var.environment
  common_tags = var.common_tags

  #target group
  #health_check = var.health_check
  port = var.port
  vpc_id = data.aws_ssm_parameter.vpc_id.value

  #launch template
  image_id = data.aws_ami.devops_ami.id
  vpc_security_group_ids = data.aws_ssm_parameter.shipping_sg_id.value
  user_data = filebase64("${path.module}/shipping.sh")
  launch_template_tags = var.launch_template_tags

  #autoscaling
  vpc_zone_identifier = split(",",data.aws_ssm_parameter.private_subnet_ids.value)
  tags = var.auto_scalling_tags

  #autoscalingpolicy, I am good with optional params

  #listener rule
  lb_listener_arn = data.aws_ssm_parameter.app_alb_listener_arn.value
  rule_priority = 40 # catalogue have 10 already
  host_header = "shipping.app.mydomainproject.tech"

}