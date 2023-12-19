resource "aws_instance" "roboshop"{
  for_each = var.instances
  ami = var.ami-id
  instance_type = each.value # EACH IS THE VARIABLE FOR_EACH LOOP GENERATES TO ACCESS ITS VALUES
  # security_groups = [aws_security_group.allow-all-terraform.name]
  tags = {
    Name = each.key
  }
}

resource "aws_route53_record" "record" {
  for_each =  aws_instance.roboshop
  zone_id = var.hosted_id
  name    = "${each.key}.mydomainproject.tech"
  type    = "A"
  ttl     = 1
  records = [each.key == "web" ? each.value.public_ip : each.value.private_ip]
}