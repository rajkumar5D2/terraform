# variable "sg_ingress" {
  
# }

variable "project_name" {
  default = "roboshop"
}


variable "common_tags" {
  default = {
    Name = "Roboshop"
    Environment = "Dev"
    component = "vpn"
    terraform = true
  }
}