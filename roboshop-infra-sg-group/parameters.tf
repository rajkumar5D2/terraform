resource "aws_ssm_parameter" "vpc_id" {
  name  = "/roboshop/DEV/vpc_id"
  type  = "String"
  value = local.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/roboshop/DEV/public_subnet_ids"
  type  = "String"
  value = join(",",local.public_subnet_id)
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/roboshop/DEV/private_subnet_ids"
  type  = "StringList"
  value = join(",",local.private_subnet_id)
}

resource "aws_ssm_parameter" "database_subnet_ids" {
  name  = "/roboshop/DEV/database_subnet_ids"
  type  = "StringList"
  value = join(",",local.database_subnet_id)
}


resource "aws_ssm_parameter" "sg_id" {
  name  = "/roboshop/DEV/sg_id"
  type  = "StringList"
  value = local.allow_all_sg_id
}

