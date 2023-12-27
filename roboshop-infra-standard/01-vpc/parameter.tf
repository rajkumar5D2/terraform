resource "aws_ssm_parameter" "vpc_id" {
  name  = "${var.project_name}/${var.environment}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "${var.project_name}/${var.environment}/public_subnet_ids"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "${var.project_name}/${var.environment}/private_subnet_ids"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "database_subnet_ids" {
  name  = "${var.project_name}/${var.environment}/database_subnet_ids"
  type  = "String"
  value = module.vpc.vpc_id
}
