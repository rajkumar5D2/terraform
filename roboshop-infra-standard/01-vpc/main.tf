module "vpc" {
  source = "../../terraform-aws-vpc-adv"
  cidr_block = var.cidr_block
  common_tags = var.common_tags
  vpc_tags = var.vpc_tags
  igw_tags = var.igw_tag
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  database_subnet_cidr = var.database_subnet_cidr
  #peering config, telling module to that i want peering
  isPeering_required = true
  requester_vpc_id = data.aws_vpc.default.id
  default_route_table_id = data.aws_vpc.default.main_route_table_id
  default_cidr_block = data.aws_vpc.default.cidr_block
}