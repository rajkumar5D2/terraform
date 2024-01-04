module "target_group" {
  source = "../../roboshop-template-app"
  project_name = var.project_name
environment = var.environment
   port        = var.port
  protocol    = var.protocol
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
   common_tags = var.common_tags
    health_check = var.health_check
}