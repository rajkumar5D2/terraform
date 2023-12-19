resource "aws_instance" "mongodb-instance"{
  count = 11
  ami = var.ami-id
  instance_type = var.instance_names[count.index] == "mongodb" || var.instance_names[count.index] == "mysql" ? "t3.medium" : "t2.micro"
  # security_groups = [aws_security_group.allow-all-terraform.id]
  tags = {
    Name = var.instance_names[count.index]
  }
}