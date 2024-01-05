variable "project_name" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}
variable "common_tags" {
  default = {
    Name = "Roboshop"
    component = "web"
    terraform = true
  }
}

variable "port" {
default = 80
}
variable "protocol" {
  default = "HTTP"
}

# variable "vpc_id" {
#   default = ""
# }

variable "health_check" {
  default = {  enabled = true
    healthy_threshold = 2
    interval = 15
    matcher = "200-299"
    path = "/"
    port = 80
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 3}
}

variable "launch_template_tags" {
  default = [
    {
      resource_type = "instance"
      tags = {
        Name = "web"
      }
    },
    {
      resource_type = "volume"
      tags = {
        Name = "web"
      }
    }
  ]
}

variable "auto_scalling_tags" {
  default = [
    {
        key                 = "Name"
        value               = "web"
        propagate_at_launch = true
    }
    
  ]
}