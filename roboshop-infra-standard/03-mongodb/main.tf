# #moving this code to 01.1-firewall folder
# module "mongodb_sg" {
#   source = "../../aws-security-group-module"
#   sg_name = "roboshop-mongodb"
#   sg_description = "allowing traffic"
# #   sg_ingress = var.sg_ingress
#   vpc_id = data.aws_ssm_parameter.vpc_id.value
#   project_name = var.project_name
#   common_tags = var.common_tags
#  }

#  #giving inbound rule
#  resource "aws_security_group_rule" "mongodb_vpn" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "tcp"
#   # cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
# #   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
#   source_security_group_id = data.aws_ssm_parameter.vpn_sg_id.value
#   security_group_id = module.mongodb_sg.sg_id
# }

module "mongodb_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.ami_id.id
  instance_type = "t3.medium"
  subnet_id = element(split(",",data.aws_ssm_parameter.database_subnet_ids.value),0)
  vpc_security_group_ids =[data.aws_ssm_parameter.mongodnb_sg_id.value]
  user_data = file("mongodb.sh")
  tags = merge(var.common_tags,{
    Name = "mongodb"
  })
}