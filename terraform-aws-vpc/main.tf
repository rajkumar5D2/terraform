#creating vpc resource
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostname
  enable_dns_support = var.enable_dns_support
  tags = merge(var.common_tags,var.vpc_tags)

}

#creating public internet gateway with our vpc attached
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags,var.igw_tags)
  }

#creating 2 public subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(var.common_tags,{
    Name = var.public_subnet_names[count.index]
  })
}

#creating 2 private subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(var.common_tags,{
    Name = var.private_subnet_names[count.index]
  })
}

#creating 2 database subnets
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(var.common_tags,{
    Name = var.database_subnet_names[count.index]
  })
}

#creating route public table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags,var.public_route_table_tags)
}

#giving routes to the tables
resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
  depends_on  = [aws_route_table.public] #99% not required if we give only route without route table this line tells aws to create route table 1st and then create route
}

#public subnet association with routes
resource "aws_route_table_association" "public_association" {
  count = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public[*].id,count.index)
  route_table_id = aws_route_table.public.id
}


#creating route table private
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags,var.private_route_table_tags)
}


#private subnet association with routes
resource "aws_route_table_association" "private_association" {
  count = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private[*].id,count.index)
  route_table_id = aws_route_table.private.id
}

#creating database route table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags,var.database_route_table_tags)
}



#database subnet association with routes
resource "aws_route_table_association" "database_association" {
  count = length(var.database_subnet_cidr)
  subnet_id      = element(aws_subnet.database[*].id,count.index)
  route_table_id = aws_route_table.database.id
}