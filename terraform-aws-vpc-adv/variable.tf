variable "project_name" {
  default = "roboshop"
}

variable "cidr_block" {
  default = "" #if we like this means its optional and required user will give in their directory (eg like in roboshop-infra/variable.tf)
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
    type = list
    validation {
      condition = length(var.public_subnet_cidr) == 2
      error_message = "you must pass 2 cidr"
    }
}

# variable "azs" {

# }

# variable "public_subnet_names" {

# }


  variable "private_subnet_cidr" {
    validation {
      condition = length(var.private_subnet_cidr) == 2
      error_message = "you must pass 2 private subnet"
    }
}


# variable "private_subnet_names" {

# }

variable "database_subnet_cidr" {
      validation {
      condition = length(var.database_subnet_cidr) == 2
      error_message = "you must pass 2 database subnet"
      }
}
variable "nat_gateway_tags" {
  default = {}
}


# variable "database_subnet_names" {

# }

# variable "public_route_table_tags" {
#   default = {}
# }

# variable "private_route_table_tags" {
  
# }

# variable "database_route_table_tags" {
  
# }

#developing peering module
variable "isPeering_required" {
  default = false
}

variable "requester_vpc_id" {

}

variable "default_route_table_id" {
  
}