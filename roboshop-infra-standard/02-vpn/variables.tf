# variable "sg_ingress" {
  
# }

variable "project_name" {
  default = "roboshop"
}


variable "common_tags" {
  default = {
    # Name = "Roboshop"
    # component = "vpn"
    terraform = true
  }
}

variable "environment" {
  default = "dev"
}