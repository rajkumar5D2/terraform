# resource "aws_ssm_parameter" "vpn_sg_id" {
#   name = "/${var.project_name}/${var.environment}/vpn_sg_id"
#   type = "String"
#   value = module.vpn_sg.sg_id
# }