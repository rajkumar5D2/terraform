resource "aws_instance" "mongodb-instance"{
  ami = var.ami-id
  instance_type = var.name == "Mongodb" ? "t3.medium" : "t2.micro"
  # security_groups = [aws_security_group.allow-all-terraform.id]
}