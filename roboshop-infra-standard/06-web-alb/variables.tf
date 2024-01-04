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
     component = "web-alb"
    terraform = true
  }
}