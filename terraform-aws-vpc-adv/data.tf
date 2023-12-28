#compant restricts employees not to create azs as their wish by only giving 1st 2 azs
data "aws_availability_zones" "available" { #GETTING ALL AVAILABILITY ZONES and passing to locals.tf to restrict only 2
  state = "available"
}

data "aws_vpc" "default" {
  default = true
} 
