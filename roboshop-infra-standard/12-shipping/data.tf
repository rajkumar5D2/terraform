data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}

data "aws_ami" "ami_id" {
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = ["973714476881"]

  filter {
    name   = "name"
    values = ["Centos-8-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "shipping_sg_id" {
  name = "/${var.project_name}/${var.environment}/shipping_sg_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "app-alb_listener_arn" {
  name = "/${var.project_name}/${var.environment}/app-alb_listener_arn"
}

# data "aws_ssm_parameter" "web-alb_listener_arn_http" {
#   name = "/${var.project_name}/${var.environment}/web-alb_listener_arn_http"
# }