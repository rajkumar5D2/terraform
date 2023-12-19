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

variable "azs" {
  default = ["us-east-1a","us-east-1b"]
}

variable "public_subnet_names" {
  default = ["roboshop-public-1a","roboshop-public-1b"]
}

variable "private_subnet_cidr" {
  # type = list
  default = ["10.0.11.0/24","10.0.12.0/24"]
}


variable "private_subnet_names" {
  default = ["roboshop-private-1a","roboshop-private-1b"]
}


variable "database_subnet_cidr" {
  # type = list
  default = ["10.0.21.0/24","10.0.22.0/24"]
}


variable "database_subnet_names" {
  default = ["roboshop-database-1a","roboshop-database-1b"]
}

variable "public_route_table_tags" {
  default = {
    Name = "roboshop-public"
  }
}

variable "private_route_table_tags" {
  default = {
    Name = "roboshop-private"
  }
}

variable "database_route_table_tags" {
 default = {
  Name = "roboshop-database"
 } 
}
