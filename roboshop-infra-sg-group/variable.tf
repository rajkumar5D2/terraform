variable "project_name" {
  default = "roboshop"
}

variable "cidr_block" {
  default = "10.0.0.0/16" 
}

variable "common_tags" {
  default = {
    Name = "Roboshop"
    Environment = "Dev"
    terraform = true
  }
}

variable "vpc_tags" {
  default = {
    Name = "Roboshop"
  }
}

variable "igw_tag" {
  type = map
  default = {
    Name = "Roboshop"
  }
}

variable "public_subnet_cidr" {
  # type = list
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

# variable "azs" {
#   default = NOT USING HERE INSTEAD USING DIRECTLY FROM LOCALS TO MAIN.TF(MODULE)
# }

# variable "public_subnet_names" {
#   default = ["roboshop-public-1a","roboshop-public-1b"]
# }

variable "private_subnet_cidr" {
  # type = list
  default = ["10.0.11.0/24","10.0.12.0/24"]
}


# variable "private_subnet_names" {
#   default = ["roboshop-private-1a","roboshop-private-1b"]
# }


variable "database_subnet_cidr" {
  # type = list
  default = ["10.0.21.0/24","10.0.22.0/24"]
}


variable "sg_ingress" {
   type = list
  default = [
    {
      from_port = 0
      to_port = 0
      description = "allowing all traffic from internet"
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "instances"{ # USING FOR LOOP
  type = map
  default = {
    mongodb = "t3.medium"
    mysql = "t3.medium"
    user = "t2.micro"
    web = "t2.micro"
    cart = "t2.micro"
    redit = "t2.micro"
    rabbitmq = "t2.micro"
    shipping = "t2.micro"
    payment = "t2.micro"
    dispatch = "t2.micro"
    catalogue = "t2.micro"
  }
}

variable "zone_name" {
  default = "mydomainproject.tech"
}