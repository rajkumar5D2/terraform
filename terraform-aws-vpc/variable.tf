variable "cidr_block" {
  default = "" #if we like thid means its optional and required user will give in their directory (eg like in roboshop-infra/variable.tf)
}

variable "enable_dns_hostname" {
  default = "true"
}
# for these above and below variables will come to all who imported 
variable "enable_dns_support" {
  default = "true"
}

variable "common_tags" {
  default = {} #optional
  type = map
}

variable "vpc_tags" {
  default = {}
  type = map
}

variable "igw_tags" {
  type = map
  default = {}
  }

  variable "public_subnet_cidr" {

}

variable "azs" {

}

variable "public_subnet_names" {

}


  variable "private_subnet_cidr" {

}


variable "private_subnet_names" {

}

variable "database_subnet_cidr" {
  
}


variable "database_subnet_names" {

}

variable "public_route_table_tags" {
  default = {}
}

variable "private_route_table_tags" {
  
}

variable "database_route_table_tags" {
  
}