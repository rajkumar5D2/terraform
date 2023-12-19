module "ec2_instance" {
  for_each = var.instances
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.ami_id.id
  instance_type = each.value
  subnet_id = each.key == "web" ? local.public_subnet_id[0] : local.private_subnet_id[0]
  vpc_security_group_ids = [local.allow_all_sg_id]
  tags = merge(var.common_tags,{
    Name = each.key
  })
}