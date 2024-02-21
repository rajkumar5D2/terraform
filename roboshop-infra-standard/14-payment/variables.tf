variable "project_name" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}
variable "common_tags" {
  default = {
    Name = "Roboshop"
    component = "payment"
    terraform = true
  }
}

variable "port" {
default = 8080
}
variable "protocol" {
  default = "HTTP"
}

# variable "vpc_id" {
#   default = ""
# }

# variable "health_check" { giving default helth checks in ../../roboshop-templete-app so dont need from here
#   default = {  enabled = true
#     healthy_threshold = 2
#     interval = 300
#     matcher = "200-299"
#     path = "/"
#     port = 80
#     protocol = "HTTP"
#     timeout = 5
#     unhealthy_threshold = 3}
# }

variable "launch_template_tags" {
  default = [
    {
      resource_type = "instance"
      tags = {
        Name = "payment"
      }
    },
    {
      resource_type = "volume"
      tags = {
        Name = "payment"
      }
    }
  ]
}

variable "auto_scalling_tags" {
  default = [
    {
        key                 = "Name"
        value               = "payment"
        propagate_at_launch = true
    }
    
  ]
}