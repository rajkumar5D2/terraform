
variable "project_name" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}
variable "common_tags" {
  default = {
    # Name = "Roboshop"
     component = "mysql"
    terraform = true
  }
}

variable "zone_name" {
  default = "mydomainproject.tech"
}