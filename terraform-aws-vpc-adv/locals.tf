locals { #restricting only for 2 azs and passing to outputs.tf to send to employees
  azs_vpc_local = slice(data.aws_availability_zones.available.names,0,2)
}

locals {
  default_vpc_id = data.aws_vpc.default.id
}

# #getting value from vpc(roboshop) created
# locals {
#   aws_vpc_id_local = aws_vpc.vpc.id
# }