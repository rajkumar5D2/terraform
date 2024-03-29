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
    Name = "Roboshop"
    component = "catalogue"
    terraform = true
  }
}


variable "port" {
  default = 8080
}
variable "protocol" {
  default = "HTTP"
}

variable "vpc_id" {
  default = ""
}

variable "health_check" {
  default = {  enabled = true
    healthy_threshold = 2
    interval = 15
    matcher = "200-299"
    path = "/"
    port = 8080
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 3}
}