# variable "sg_ingress" {
  
# }

variable "project_name" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}
variable "common_tags" {
  default = {
    # Name = "Roboshop"
    #  component = "mongodb"
    terraform = true
  }
}

variable "zone_name" {
  default = "mydomainproject.tech"
}