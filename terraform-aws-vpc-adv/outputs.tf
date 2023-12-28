output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "azs_vpc_output" { #getting fromm locals.tf and sending to roboshop-infra-adv(employee) locals.tf
  value = local.azs_vpc_local
  }

  output "public_subnet_id" {
    value = aws_subnet.public[*].id
  }

   output "private_subnet_id" {
    value = aws_subnet.private[*].id
  }

   output "database_subnet_id" {
    value = aws_subnet.database[*].id
  }

  # #getting value from locals.tf 
  # output "aws_vpc_id_output" {
  #   value = local.aws_vpc_id_local
  # }