resource "aws_instance" "any-name-here" {
  ami = var.ami-id
  instance_type = var.instance-type
  #type.name-of-recourse.name
  security_groups = [aws_security_group.allow-all-terraform.name]

#   tags {
#     name = "ec2 instance"
#     environment = "dev"
#     terraform = "true"
#     project = "roboshop"
#     component = "ec2 instance"
#   }

  tags = var.tags

}