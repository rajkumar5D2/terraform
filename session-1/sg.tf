resource "aws_security_group" "allow-all-terraform" {
  name        = var.sg_name
  description = "Allow all inbound traffic"


  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = var.sg_cidr
  
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.sg_cidr
   
  }

  tags = {
    Name = "allow_tls"
  }
}     