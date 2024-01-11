# creating VPN security group--------------------------------------
 module "vpn_sg" {
  source = "../../aws-security-group-module"
  sg_name = "roboshop-vpn"
  sg_description = "allowing all port from my home ip address"
#   sg_ingress = var.sg_ingress
  vpc_id = data.aws_vpc.default.id
  # project_name = var.project_name
 common_tags = merge(var.common_tags,{
    Name = "Roboshop-vpn",
    Component = "VPN"
  })
 }

# creating mongodb security group--------------------------------
module "mongodb_sg" {
  source = "../../aws-security-group-module"
  sg_name = "roboshop-mongodb"
  sg_description = "allowing traffic"
#   sg_ingress = var.sg_ingress
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  # project_name = var.project_name
  common_tags = merge(var.common_tags,{
    Name = "mongodb_sg",
    Component = "mongodb"
  })
 }

# creating catalogue security group--------------------------------
module "catalogue_sg" {
  source = "../../aws-security-group-module"
  sg_name = "roboshop-catalogue"
  sg_description = "allowing traffic"
#   sg_ingress = var.sg_ingress
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  # project_name = var.project_name
 common_tags = merge(var.common_tags,{
    Name = "catalogue_sg",
    Component = "catalogue"
  })
 }


# creating web security group--------------------------------
module "web_sg" {
  source = "../../aws-security-group-module"
  sg_name = "roboshop-web"
  sg_description = "allowing traffic "
#   sg_ingress = var.sg_ingress
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  # project_name = var.project_name
 common_tags = merge(var.common_tags,{
    Name = "web_sg",
    Component = "web"
  })
 }

 # creating app(private) application Load Balancer(ALB) security group--------------------------------
module "app-alb_sg" {
  source = "../../aws-security-group-module"
  sg_name = "app-alb"
  sg_description = "allowing traffic "
#   sg_ingress = var.sg_ingress
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  # project_name = var.project_name
 common_tags = merge(var.common_tags,{
    Component = "app",
    Name = "app-alb"
  })
 }

  # creating web(public) application Load Balancer(ALB) security group--------------------------------
module "web-alb_sg" {
  source = "../../aws-security-group-module"
  sg_name = "web-alb"
  sg_description = "allowing traffic "
#   sg_ingress = var.sg_ingress
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project_name = var.project_name
 common_tags = merge(var.common_tags,{
    Component = "web",
    Name = "web-alb"
  })
 }

  # creating redis security group--------------------------------
module "redis_sg" {
  source = "../../aws-security-group-module"
  project_name = var.project_name
  sg_name = "redis"
  sg_description = "Allowing traffic"
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
        Component = "redis",
        Name = "redis"
    }
  )
}

module "user_sg" {
  source = "../../aws-security-group-module"
  project_name = var.project_name
  sg_name = "user"
  sg_description = "Allowing traffic"
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
        Component = "user",
        Name = "user"
    }
  )
}



 resource "aws_security_group_rule" "vpn" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.vpn_sg.sg_id
}
# giving inbound rule to mongodb_sg i.e accepting all the traffic from all instances created in catalogue component
 resource "aws_security_group_rule" "catalogue_to_mongodb" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.catalogue_sg.sg_id
  security_group_id = module.mongodb_sg.sg_id
}

# giving inbound rule i.e accepting all the traffic from all instances created in vpn component
 resource "aws_security_group_rule" "vpn_to_mongodb" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.mongodb_sg.sg_id
}

# giving inbound rule i.e accepting all the traffic from all instances created in vpn component to catalogue instances
 resource "aws_security_group_rule" "vpn_to_catalogue" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.catalogue_sg.sg_id
}

# giving inbound rule i.e accepting all the traffic from catalogue to alb
 resource "aws_security_group_rule" "catalogue_to_app-alb" {
  type              = "ingress"
  from_port         = 8080 #(catalogue port)
  to_port           = 8080
  protocol          = "tcp"
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.app-alb_sg.sg_id
  security_group_id = module.catalogue_sg.sg_id
}

# giving inbound rule i.e accepting all the traffic from vpn to app-alb 
 resource "aws_security_group_rule" "vpn_to_app-alb" {
  type              = "ingress"
  from_port         = 80 #(all alb runs on port 80)
  to_port           = 80
  protocol          = "tcp"
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.app-alb_sg.sg_id
}


# giving inbound rule i.e accepting all the traffic from web to app-alb 
 resource "aws_security_group_rule" "web_to_app-alb" {
  type              = "ingress"
  from_port         = 80 #(all alb runs on port 80)
  to_port           = 80
  protocol          = "tcp"
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.web_sg.sg_id
  security_group_id = module.app-alb_sg.sg_id
}

# giving inbound rule i.e accepting all the traffic from web instance to web-alb 
 resource "aws_security_group_rule" "web-alb_to_web" {
  type              = "ingress"
  from_port         = 80 #(all alb runs on port 80)
  to_port           = 80
  protocol          = "tcp"
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.web-alb_sg.sg_id
  security_group_id = module.web_sg.sg_id
}
# giving inbound rule i.e accepting all the traffic from internet (http) to web-alb
 resource "aws_security_group_rule" "interenet_to_web-alb" {
  type              = "ingress"
  from_port         = 80 #(all alb runs on port 80)
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  # source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.web-alb_sg.sg_id
}


# giving inbound rule i.e accepting all the traffic from roboshop-vpn to web
 resource "aws_security_group_rule" "vpn_to_web" {
  type              = "ingress"
  from_port         = 80 #(all alb runs on port 80)
  to_port           = 80
  protocol          = "tcp"
  # cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.web_sg.sg_id
}
# giving inbound rule i.e accepting all the traffic from roboshop-vpn to web
 resource "aws_security_group_rule" "vpn_to_web_on22" {
  type              = "ingress"
  from_port         = 22 #(all alb runs on port 80)
  to_port           = 22
  protocol          = "tcp"
  # cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.web_sg.sg_id
}
# giving inbound rule i.e accepting all the traffic from internet https to web-alb
 resource "aws_security_group_rule" "interenet_to_web-alb_443" {
  type              = "ingress"
  from_port         = 443 #(all alb runs on port 80)
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  # source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.web-alb_sg.sg_id
}

# giving inbound rule i.e accepting all the traffic from user to redis
 resource "aws_security_group_rule" "redis_user" {
  type              = "ingress"
  from_port         = 6379 #(all alb runs on port 80)
  to_port           = 6379 #redis port no
  protocol          = "tcp"
  # cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.user_sg.sg_id
  security_group_id = module.redis_sg.sg_id
}

# giving inbound rule i.e accepting all the traffic from roboshop-vpn to redis
 resource "aws_security_group_rule" "vpn_to_redis" {
  type              = "ingress"
  from_port         = 22 
  to_port           = 22
  protocol          = "tcp"
  # cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.redis_sg.sg_id
}

# giving inbound rule i.e accepting all the traffic from app-alb to user instances
 resource "aws_security_group_rule" "app-alb_user" {
  type              = "ingress"
  from_port         = 8080 #(all alb runs on port 80)
  to_port           = 8080
  protocol          = "tcp"
  # cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.app-alb_sg.sg_id
  security_group_id = module.user_sg.sg_id
}

# giving inbound rule i.e accepting all the traffic from vpn to user instances
 resource "aws_security_group_rule" "vpn_user" {
  type              = "ingress"
  from_port         = 22 #(all alb runs on port 80)
  to_port           = 22
  protocol          = "tcp"
  # cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.user_sg.sg_id
}