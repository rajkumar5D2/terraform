variable "ami-id"{
  type = string #optional
  default = "ami-03265a0778a880afb" #key and value
}

variable "instance-type"{
  default = "t2.micro"
}

variable "sg_cidr"{
  type = list
  default = ["0.0.0.0/0"] #list-- starts and ends with []
}

variable "sg_name"{
  default = "allow-all-terraform"
}

variable "tags"{
  default = {   #map-- starts and ends with {}, inside we have key value pair
    Name = "ec2_instance"
    environment = "dev"
    terraform = "true"
    project = "roboshop"
    component = "ec2 instance"
  }
}
