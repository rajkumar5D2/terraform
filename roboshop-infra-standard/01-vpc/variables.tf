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
   component = "vpn"
    terraform = true
  }
}

variable "environment" {
  default = "dev"
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

variable "private_subnet_cidr" {
  # type = list
  default = ["10.0.11.0/24","10.0.12.0/24"]
}

variable "database_subnet_cidr" {
  # type = list
  default = ["10.0.21.0/24","10.0.22.0/24"]
}
