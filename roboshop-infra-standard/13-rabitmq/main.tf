module "rabitmq_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.ami_id.id
  instance_type = "t2.micro"
  subnet_id = element(split(",",data.aws_ssm_parameter.database_subnet_ids.value),0)
  vpc_security_group_ids =[data.aws_ssm_parameter.rabitmq_sg_id.value]
  user_data = file("rabitmq.sh")
  tags = merge(var.common_tags,{
    Name = "rabitmq"
  })
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"
  zone_name = var.zone_name
     records = [{
      name    = "rabitmq"
      type    = "A"
      ttl     = 1
      records = [
        module.rabitmq_instance.private_ip
      ]
     }]
}