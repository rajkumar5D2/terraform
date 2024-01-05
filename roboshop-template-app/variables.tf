# variable "sg_ingress" {
  
# }

variable "project_name" {
  default = ""
}

variable "environment" {
  default = ""
}
variable "common_tags" {
  
}
variable "port" {
  default = 80
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
    path = "/health"
    port = 8080
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 3}
}

#for launch template
variable "image_id" {
  
}

variable "instance_initiated_shutdown_behavior" {
  default = "terminate"
}

variable "instance_type" {
  default = "t2.micro"
}
variable "vpc_security_group_ids" {

}

variable "user_data" {
  default = ""
}

variable "launch_template_tags" {
  default = [
 
  ]
}

#for auto-scalling groups
variable "max_size" {
  default = 5
}
variable "min_size" {
  default = 1
}
variable "desired_capacity" {
  default = 2
}
variable "health_check_grace_period" {
  default = 120
}
variable "health_check_type" {
  default = "ELB"
}

variable "vpc_zone_identifier" {
type = list
}

variable "tags" {
  default = []
}