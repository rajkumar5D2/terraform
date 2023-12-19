resource "aws_instance" "for-route-53"{
  count = 11
  ami = var.ami-id
   instance_type = var.instance_names[count.index] == "mongodb" || var.instance_names[count.index] == "mysql" ? "t3.medium" : "t2.micro"
  # security_groups = [aws_security_group.allow-all-terraform.id]
  tags = {
    Name = var.instance_names[count.index]
  }
}

resource "aws_route53_record" "record" {
  count = 11
  zone_id = var.hosted_id
  name    = "${var.instance_names[count.index]}.mydomainproject.tech"
  type    = "A"
  ttl     = 1
  records = [aws_instance.for-route-53[count.index].private_ip]
}

