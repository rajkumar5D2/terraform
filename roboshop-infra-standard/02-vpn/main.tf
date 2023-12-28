 module "vpn_sg" {
  source = "../../aws-security-group-module"
  sg_name = "roboshop-vpn"
  sg_description = "allowing all port from my home ip address"
#   sg_ingress = var.sg_ingress
  vpc_id = data.aws_vpc.default.id
  project_name = var.project_name
  common_tags = var.common_tags
 }

 resource "aws_security_group_rule" "vpn" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.vpn_sg.sg_id
}

module "vpn_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"# onilne git repo
  ami = data.aws_ami.ami_id.id
  instance_type = "t2.micro"
#   subnet_id = each.key == "web" ? local.public_subnet_id[0] : local.private_subnet_id[0] #not required since we want the instances created in default vpc
  vpc_security_group_ids = [module.vpn_sg.sg_id]
  tags = merge(var.common_tags,{
    Name = "Roboshop-vpn"
  })
}