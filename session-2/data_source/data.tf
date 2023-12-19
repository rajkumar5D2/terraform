data "aws_ami" "ami_id"{
  most_recent = true
  owners = [ "amazon" ]

  filter {
    name = "name"
    values = [ "amzn2-ami-kernel-5.10-hvm-*.0-x86_64-gp2" ] #get it from aws console search for that image in amis for the 1st time and amzn2-ami-kernel-5.10-hvm-(2.0.20231116).0-x86_64-gp2 replace with * to select all the future updated amis as well
  }
}

output "id_ami"{
  value = data.aws_ami.ami_id.id # if you want diff regions id then change region in provider.tf
}

data "aws_vpc" "defaults"{
  default = true
}

output "details"{
  value = data.aws_vpc.defaults #"vpc-0df49f4a9bb34d514" if i run only vpc data source
}

resource "aws_security_group" "allow-http" {
  name        = "nameing"
  description = "allowing only http"


  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }
}