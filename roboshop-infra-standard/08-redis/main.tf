module "redis_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.ami_id.id
  instance_type = "t2.micro"
  subnet_id = element(split(",",data.aws_ssm_parameter.database_subnet_ids.value),0)
  vpc_security_group_ids =[data.aws_ssm_parameter.redis_sg_id.value]
  user_data = file("redis.sh")
  tags = merge(var.common_tags,{
    Name = "redis"
  })
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  zone_name = var.zone_name
     records = [{
      name    = "redis"
      type    = "A"
      ttl     = 1
      records = [
        module.redis_instance.private_ip
      ]
     }]
}