locals { #restricting only for 2 azs and passing to outputs.tf to send to employees
  azs_vpc_local = slice(data.aws_availability_zones.available.names,0,2)
}