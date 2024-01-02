resource "aws_ssm_parameter" "vpn_sg_id" {
  name = "/${var.project_name}/${var.environment}/vpn_sg_id"
  type = "String"
  value = module.vpn_sg.sg_id
}

resource "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/${var.project_name}/${var.environment}/mongodb_sg_id"
  type = "String"
  value = module.mongodb_sg.sg_id
}

resource "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project_name}/${var.environment}/catalogue_sg_id"
  type = "String"
  value = module.catalogue_sg.sg_id
}

resource "aws_ssm_parameter" "web_sg_id" {
  name = "/${var.project_name}/${var.environment}/web_sg_id"
  type = "String"
  value = module.web_sg.sg_id
}

resource "aws_ssm_parameter" "web-alb_sg" {
  name = "/${var.project_name}/${var.environment}/web-alb_sg_id"
  type = "String"
  value = module.web-alb_sg.sg_id
}

resource "aws_ssm_parameter" "app-alb_sg_id" {
  name = "/${var.project_name}/${var.environment}/app-alb_sg_id"
  type = "String"
  value = module.app-alb_sg.sg_id
}