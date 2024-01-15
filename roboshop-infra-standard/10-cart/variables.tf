variable "project_name" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}
variable "common_tags" {
  default = {
    Name = "Roboshop"
    component = "cart"
    terraform = true
  }
}

variable "port" {
default = 8080
}
variable "protocol" {
  default = "HTTP"
}


variable "launch_template_tags" {
  default = [
    {
      resource_type = "instance"
      tags = {
        Name = "cart"
      }
    },
    {
      resource_type = "volume"
      tags = {
        Name = "cart"
      }
    }
  ]
}

variable "auto_scalling_tags" {
  default = [
    {
        key                 = "Name"
        value               = "cart"
        propagate_at_launch = true
    }
    
  ]
}