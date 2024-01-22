module "mysql_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.ami_id.id
  instance_type = "t2.micro"
  subnet_id = element(split(",",data.aws_ssm_parameter.database_subnet_ids.value),0)
  vpc_security_group_ids =[data.aws_ssm_parameter.mysql_sg_id.value]
  user_data = file("mysql.sh")
  tags = merge(var.common_tags,{
    Name = "mysql"
  })
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  zone_name = var.zone_name
     records = [{
      name    = "mysql"
      type    = "A"
      ttl     = 1
      records = [
        module.mysql_instance.private_ip
      ]
     }]
}