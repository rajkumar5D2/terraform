#CREATING VPC WITH IP 10.0.0.0/16==========================
resource "aws_vpc" "roboshop" { 
  cidr_block       = "10.0.0.0/16"
  # instance_tenancy = "default"

  tags = {
    Name = "roboshop"
    Environment = "DEV"
    Terraform = true
  }
}

#CREATING PUBLIC AND PRIVATE SUBNETS ============== 

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.roboshop.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "roboshop_public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.roboshop.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "roboshop_private_subnet"
  }
}

# CREATING INTERNET GATEWAY with our vpc id==================
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.roboshop.id

  tags = {
    Name = "roboshop_gateway"
  }
}

# CREATING ROUTE TABLES PUBLIC AND PRIVATE
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.roboshop.id

  route {
    cidr_block = "0.0.0.0/0" #ALLOWING ALL
    gateway_id = aws_internet_gateway.gw.id
  }

  # route {
  #   ipv6_cidr_block        = "::/0"
  #   egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  # }

  tags = {
    Name = "public_route"
  }
}

# PRIVATE ROUTE TABLE WITH NO ROUTES (ALLOWING NONE)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.roboshop.id
 
  tags = {
    Name = "private_route"
  }
}

# NOW ASSOSIATE ROUTE TABLES WITH SUBNETS
resource "aws_route_table_association" "private_subnet_assosiation" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "public_subnet_assosiation" {
  subnet_id     = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

#CREATING SG PORT 80 FOR PUBLIC AND PORT 22 FOR PRIVATE

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow http and ssh inbound traffic"
  vpc_id      = aws_vpc.roboshop.id

  ingress {
    description      = "http from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description      = "ssh from my laptop"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["31.94.5.223/32"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}

#CREATING WEB INSTANCE
resource "aws_instance" "web" {
  ami = "ami-03265a0778a880afb"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id] # IF WE ARE CREATING INSTANCE IN OUR VPC USE vpc_security_group
  subnet_id = aws_subnet.public_subnet.id # creating instance in our subnet so the private ip gets within our specified ip(10.0.1.something)
  associate_public_ip_address = true #this will give both public and private addr if false only private add will be given to the instance

  tags = {
    Name = "web"
  }
}