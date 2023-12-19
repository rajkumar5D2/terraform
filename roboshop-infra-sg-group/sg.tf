module "allow-all-sg"{
  source = "../aws-security-group-module/"
  sg_name = "allow-all"
  sg_description = "allowing all port from internet"
  sg_ingress = var.sg_ingress
  vpc_id = local.vpc_id
  project_name = var.project_name
  common_tags = var.common_tags
}