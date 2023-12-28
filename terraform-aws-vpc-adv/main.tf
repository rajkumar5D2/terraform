#creating vpc resource
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostname
  enable_dns_support = var.enable_dns_support
  tags = merge(var.common_tags,var.vpc_tags)

}

#creating public internet gateway with our vpc attached
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.common_tags,var.igw_tags)
  }

#creating 2 public subnets after setting azs
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.vpc.id
  map_public_ip_on_launch = true #making instance in this public subnet always public when launched
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone =local.azs_vpc_local[count.index]
  tags = merge(var.common_tags,{
    Name = "${var.project_name}-public-${local.azs_vpc_local[count.index]}"
  })
}

#creating 2 private subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = local.azs_vpc_local[count.index]
  tags = merge(var.common_tags,{
    Name = "${var.project_name}-private-${local.azs_vpc_local[count.index]}"
  })
}

#creating 2 database subnets
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = local.azs_vpc_local[count.index]
  tags = merge(var.common_tags,{
    Name = "${var.project_name}-database-${local.azs_vpc_local[count.index]}"
  })
}

#creating public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  # route {
  #   cidr_block = "0.0.0.0/0" #giving route open to all internet
  #   gateway_id = aws_internet_gateway.main.id
  # }
  tags = merge(var.common_tags,{
    Name = "${var.project_name}-public-route"
  })
}

#giving route seperately
resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

#defining elastic ip
resource "aws_eip" "eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags =merge(var.common_tags,{
    Name = var.project_name
  },var.nat_gateway_tags)

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

#private route but connected to nat gateway in public
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  # route {
  #   cidr_block = "0.0.0.0/0" #giving route open to all internet
  #   nat_gateway_id = aws_nat_gateway.nat.id
  # }
  tags = merge(var.common_tags,{
    Name = "${var.project_name}-private-route"
  })
}
#giving route seperately
resource "aws_route" "private" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.vpc.id

  # route {
  #   cidr_block = "0.0.0.0/0" #giving route open to all internet
  #   nat_gateway_id = aws_nat_gateway.nat.id
  # }
  tags = merge(var.common_tags,{
    Name = "${var.project_name}-database-route"
  })
}

#giving route seperately
resource "aws_route" "database" {
  route_table_id = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "public_association" {
  count = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public[*].id,count.index)
  route_table_id = aws_route_table.public.id
}



# #creating route table private
# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id
#   tags = merge(var.common_tags,var.private_route_table_tags)
# }


#private subnet association with routes
resource "aws_route_table_association" "private_association" {
  count = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private[*].id,count.index)
  route_table_id = aws_route_table.private.id
}

# #creating database route table
# resource "aws_route_table" "database" {
#   vpc_id = aws_vpc.main.id
#   tags = merge(var.common_tags,var.database_route_table_tags)
# }



#database subnet association with routes
resource "aws_route_table_association" "database_association" {
  count = length(var.database_subnet_cidr)
  subnet_id      = element(aws_subnet.database[*].id,count.index)
  route_table_id = aws_route_table.database.id
}

resource "aws_db_subnet_group" "roboshop" {
  name       = var.project_name
  subnet_ids = aws_subnet.database[*].id

  tags = {
    Name = "My DB subnet group"
  }
}
