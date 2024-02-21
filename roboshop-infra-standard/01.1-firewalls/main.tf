# creating VPN security group------------------------------------------------------------------------------------------------------------------
 module "vpn_sg" {
  source = "../../aws-security-group-module"
  sg_name = "roboshop-vpn"
  sg_description = "allowing all port from my home ip address"
  vpc_id = data.aws_vpc.default.id
  common_tags = merge(var.common_tags,{
    Name = "Roboshop-vpn",
    Component = "VPN"
  })
 }

#inbound rule for vpn
#   resource "aws_security_group_rule" "vpn" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "tcp"
#   cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
#   security_group_id = module.vpn_sg.sg_id
# }

# creating mongodb security group-------------------------------------------------------------------------------------------------------------
module "mongodb_sg" {
  source = "../../aws-security-group-module"
  sg_name = "roboshop-mongodb"
  sg_description = "allowing traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(var.common_tags,{
    Name = "mongodb_sg",
    Component = "mongodb"
  })
 }
#  #inbound rules for mongodb
#  # giving inbound rule to mongodb_sg i.e accepting all the traffic from all instances created in catalogue component
#  resource "aws_security_group_rule" "catalogue_to_mongodb" {
#   type              = "ingress"
#   from_port         = 27017
#   to_port           = 27017
#   protocol          = "tcp"
#   source_security_group_id = module.catalogue_sg.sg_id
#   security_group_id = module.mongodb_sg.sg_id
# }


#  # giving inbound rule i.e accepting all the traffic from user to mongodb instances
#  resource "aws_security_group_rule" "user_mongodb" {
#   type              = "ingress"
#   from_port         = 27017 #(all alb runs on port 80)
#   to_port           = 27017
#   protocol          = "tcp"
#   source_security_group_id = module.user_sg.sg_id
#   security_group_id = module.mongodb_sg.sg_id
# }

# # giving inbound rule i.e accepting all the traffic from all instances created in vpn component
#  resource "aws_security_group_rule" "vpn_to_mongodb" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   source_security_group_id = module.vpn_sg.sg_id
#   security_group_id = module.mongodb_sg.sg_id
# }


# creating catalogue security group--------------------------------------------------------------------------------------------------------------------------------
module "catalogue_sg" {
  source = "../../aws-security-group-module"
  sg_name = "roboshop-catalogue"
  sg_description = "allowing traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value

 common_tags = merge(var.common_tags,{
    Name = "catalogue_sg",
    Component = "catalogue"
  })
 }
# # inbound for catalogue-------------------------------------
# # giving inbound rule i.e accepting all the traffic from all instances created in vpn component to catalogue instances
#  resource "aws_security_group_rule" "vpn_to_catalogue" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   source_security_group_id = module.vpn_sg.sg_id
#   security_group_id = module.catalogue_sg.sg_id
# }


# # giving inbound rule i.e accepting all the traffic from catalogue to alb
#  resource "aws_security_group_rule" "app-alb_to_catalogue" {
#   type              = "ingress"
#   from_port         = 8080 #(catalogue port)
#   to_port           = 8080
#   protocol          = "tcp"
#   source_security_group_id = module.app-alb_sg.sg_id
#   security_group_id = module.catalogue_sg.sg_id
# }

# creating web security group--------------------------------------------------------------------------------------------------------------------------------
module "web_sg" {
  source = "../../aws-security-group-module"
  sg_name = "roboshop-web"
  sg_description = "allowing traffic "
  vpc_id = data.aws_ssm_parameter.vpc_id.value
 common_tags = merge(var.common_tags,{
    Name = "web_sg",
    Component = "web"
  })
 }

#  # giving inbound rule i.e accepting all the traffic from web-alb instance to web 
#  resource "aws_security_group_rule" "web-alb_to_web" {
#   type              = "ingress"
#   from_port         = 80 #(all alb runs on port 80)
#   to_port           = 80
#   protocol          = "tcp"
#   source_security_group_id = module.web-alb_sg.sg_id
#   security_group_id = module.web_sg.sg_id
# }

# # # giving inbound rule i.e accepting all the traffic from roboshop-vpn to web
#  resource "aws_security_group_rule" "vpn_to_web" {
#   type              = "ingress"
#   from_port         = 80 #(all alb runs on port 80)
#   to_port           = 80
#   protocol          = "tcp"
#   source_security_group_id = module.vpn_sg.sg_id
#   security_group_id = module.web_sg.sg_id
# }

# # giving inbound rule i.e accepting all the traffic from roboshop-vpn to web
#  resource "aws_security_group_rule" "vpn_to_web_on22" {
#   type              = "ingress"
#   from_port         = 22 #(all alb runs on port 80)
#   to_port           = 22
#   protocol          = "tcp"
#   source_security_group_id = module.vpn_sg.sg_id
#   security_group_id = module.web_sg.sg_id
# }

 # creating app(private) application Load Balancer(ALB) security group------------------------------------------------------------------------------------------------
module "app-alb_sg" {
  source = "../../aws-security-group-module"
  sg_name = "app-alb"
  sg_description = "allowing traffic "
  vpc_id = data.aws_ssm_parameter.vpc_id.value
 common_tags = merge(var.common_tags,{
    Component = "app",
    Name = "app-alb"
  })
 }

# # giving inbound rule i.e accepting all the traffic from vpn to app-alb 
#  resource "aws_security_group_rule" "vpn_to_app-alb" {
#   type              = "ingress"
#   from_port         = 80 #(all alb runs on port 80)
#   to_port           = 80
#   protocol          = "tcp"
#   source_security_group_id = module.vpn_sg.sg_id
#   security_group_id = module.app-alb_sg.sg_id
# }


# # giving inbound rule i.e accepting all the traffic from web to app-alb 
#  resource "aws_security_group_rule" "web_to_app-alb" {
#   type              = "ingress"
#   from_port         = 80 #(all alb runs on port 80)
#   to_port           = 80
#   protocol          = "tcp"
#   source_security_group_id = module.web_sg.sg_id
#   security_group_id = module.app-alb_sg.sg_id
# }

# resource "aws_security_group_rule" "catalogue_to_app-alb" {
#   type              = "ingress"
#   description = "Allowing port number 80 from catalogue"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   source_security_group_id = module.catalogue_sg.sg_id
#   #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
#   #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
#   security_group_id = module.app-alb_sg.sg_id
# }

# resource "aws_security_group_rule" "user_to_app-alb" {
#   type              = "ingress"
#   description = "Allowing port number 80 from user"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   source_security_group_id = module.user_sg.sg_id
#   #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
#   #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
#   security_group_id = module.app-alb_sg.sg_id
# }

# resource "aws_security_group_rule" "app-alb_to_cart" {
#   type              = "ingress"
#   description = "Allowing port number 80 from APP ALB"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   source_security_group_id = module.cart_sg.sg_id
#   security_group_id = module.app-alb_sg.sg_id
# }
  # creating web(public) application Load Balancer(ALB) security group------------------------------------------------------------------------------------------------
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
 
# # giving inbound rule i.e accepting all the traffic from internet (http) to web-alb
#  resource "aws_security_group_rule" "interenet_to_web-alb" {
#   type              = "ingress"
#   from_port         = 80 #(all alb runs on port 80)
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = module.web-alb_sg.sg_id
# }

# # giving inbound rule i.e accepting all the traffic from internet https to web-alb
#  resource "aws_security_group_rule" "interenet_to_web-alb_443" {
#   type              = "ingress"
#   from_port         = 443 #(all alb runs on port 80)
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = module.web-alb_sg.sg_id
# }

# creating redis security group--------------------------------------------------------------------------------------------------------------------------------
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
# resource "aws_security_group_rule" "cart_to_redis" {
#   type              = "ingress"
#   description = "Allowing port number 6379 from cart"
#   from_port         = 6379
#   to_port           = 6379
#   protocol          = "tcp"
#   source_security_group_id = module.cart_sg.sg_id
#   security_group_id = module.redis_sg.sg_id
# }
# # giving inbound rule i.e accepting all the traffic from user to redis
#  resource "aws_security_group_rule" "redis_user" {
#   type              = "ingress"
#   from_port         = 6379 
#   to_port           = 6379 #redis port no
#   protocol          = "tcp"
#   source_security_group_id = module.user_sg.sg_id
#   security_group_id = module.redis_sg.sg_id
# }

# # giving inbound rule i.e accepting all the traffic from roboshop-vpn to redis
#  resource "aws_security_group_rule" "vpn_to_redis" {
#   type              = "ingress"
#   from_port         = 22 
#   to_port           = 22
#   protocol          = "tcp"
#   source_security_group_id = module.vpn_sg.sg_id
#   security_group_id = module.redis_sg.sg_id
# }
  # creating user security group--------------------------------------------------------------------------------------------------------------------------------

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

# # giving inbound rule i.e accepting all the traffic from app-alb to user instances
#  resource "aws_security_group_rule" "app-alb_user" {
#   type              = "ingress"
#   from_port         = 8080 #(all alb runs on port 80)
#   to_port           = 8080
#   protocol          = "tcp"
#   source_security_group_id = module.app-alb_sg.sg_id
#   security_group_id = module.user_sg.sg_id
# }

# # giving inbound rule i.e accepting all the traffic from vpn to user instances
#  resource "aws_security_group_rule" "vpn_user" {
#   type              = "ingress"
#   from_port         = 22 #(all alb runs on port 80)
#   to_port           = 22
#   protocol          = "tcp"
#   source_security_group_id = module.vpn_sg.sg_id
#   security_group_id = module.user_sg.sg_id
# }

#creating cart security group--------------------------------------------------------------------------------------------------------------------------------

module "cart_sg" {
  source = "../../aws-security-group-module"
  project_name = var.project_name
  sg_name = "cart"
  sg_description = "Allowing traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
        Component = "cart",
        Name = "cart"
    }
  )
}
# resource "aws_security_group_rule" "cart_to_app-alb" {
#   type              = "ingress"
#   description = "Allowing port number 8080 from APP ALB"
#   from_port         = 8080
#   to_port           = 8080
#   protocol          = "tcp"
#   source_security_group_id = module.app-alb_sg.sg_id
#   security_group_id = module.cart_sg.sg_id
# }
# resource "aws_security_group_rule" "vpn_to_cart" {
#   type              = "ingress"
#   description = "Allowing port number 22 from vpn"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   source_security_group_id = module.vpn_sg.sg_id
#   security_group_id = module.cart_sg.sg_id
# }

#creating mysql security group-----------------------------------------------------------------------------------------------------------------
module "mysql_sg" {
  source = "../../aws-security-group-module"
  project_name = var.project_name
  sg_name = "mysql"
  sg_description = "Allowing traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
        Component = "mysql",
        Name = "mysql"
    }
  )
}

# #giving inbound rules 
# resource "aws_security_group_rule" "vpn_to_mysql" {
#   type              = "ingress"
#   description = "Allowing port number 22 from vpn"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   source_security_group_id = module.vpn_sg.sg_id
#   #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
#   #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
#   security_group_id = module.mysql_sg.sg_id
# }


#------------SIR'S INGRESS-----------------------------------------------------------------------------------
resource "aws_security_group_rule" "vpn" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.vpn_sg.sg_id
}

# This is allowing connections from all catalogue instances to MongoDB
resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  description = "Allowing port number 27017 from catalogue"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mongodb_sg.sg_id
}

# this is allowing traffic from VPN on port no 22 for trouble shooting
resource "aws_security_group_rule" "mongodb_vpn" {
  type              = "ingress"
  description = "Allowing port number 22 from VPN"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mongodb_sg.sg_id
}

resource "aws_security_group_rule" "mongodb_user" {
  type              = "ingress"
  description = "Allowing port number 27017 from user"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.user_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mongodb_sg.sg_id
}

resource "aws_security_group_rule" "redis_vpn" {
  type              = "ingress"
  description = "Allowing port number 22 from VPN"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.redis_sg.sg_id
}

resource "aws_security_group_rule" "redis_user" {
  type              = "ingress"
  description = "Allowing port number 6379 from user"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.user_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.redis_sg.sg_id
}

resource "aws_security_group_rule" "redis_cart" {
  type              = "ingress"
  description = "Allowing port number 6379 from cart"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.cart_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.redis_sg.sg_id
}

resource "aws_security_group_rule" "mysql_vpn" {
  type              = "ingress"
  description = "Allowing port number 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mysql_sg.sg_id
}

resource "aws_security_group_rule" "mysql_shipping" {
  type              = "ingress"
  description = "Allowing port number 3306 from vpn"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.shipping_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mysql_sg.sg_id
}

resource "aws_security_group_rule" "rabitmq_payment" {
  type              = "ingress"
  description = "Allowing port number 5672 from payment"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  source_security_group_id = module.payment_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.rabitmq_sg.sg_id
}

resource "aws_security_group_rule" "rabitmq_vpn" {
  type              = "ingress"
  description = "Allowing port number 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.rabitmq_sg.sg_id
}


resource "aws_security_group_rule" "catalogue_vpn" {
  type              = "ingress"
  description = "Allowing port number 22 from VPN"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.catalogue_sg.sg_id
}

resource "aws_security_group_rule" "catalogue_app_alb" {
  type              = "ingress"
  description = "Allowing port number 8080 from APP ALB"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app-alb_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.catalogue_sg.sg_id
}

resource "aws_security_group_rule" "user_app_alb" {
  type              = "ingress"
  description = "Allowing port number 8080 from APP ALB"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app-alb_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.user_sg.sg_id
}

resource "aws_security_group_rule" "user_vpn" {
  type              = "ingress"
  description = "Allowing port number 22 from VPN"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.user_sg.sg_id
}

resource "aws_security_group_rule" "cart_vpn" {
  type              = "ingress"
  description = "Allowing port number 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.cart_sg.sg_id
}

resource "aws_security_group_rule" "cart_app_alb" {
  type              = "ingress"
  description = "Allowing port number 8080 from APP ALB"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app-alb_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.cart_sg.sg_id
}

resource "aws_security_group_rule" "shipping_vpn" {
  type              = "ingress"
  description = "Allowing port number 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.shipping_sg.sg_id
}

resource "aws_security_group_rule" "shipping_app_alb" {
  type              = "ingress"
  description = "Allowing port number 8080 from APP ALB"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app-alb_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.shipping_sg.sg_id
}

resource "aws_security_group_rule" "payment_vpn" {
  type              = "ingress"
  description = "Allowing port number 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.payment_sg.sg_id
}

resource "aws_security_group_rule" "payment_app_alb" {
  type              = "ingress"
  description = "Allowing port number 22 from vpn"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app-alb_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.payment_sg.sg_id
}


resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  description = "Allowing port number 80 from VPN"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app-alb_sg.sg_id
}

resource "aws_security_group_rule" "app_alb_web" {
  type              = "ingress"
  description = "Allowing port number 80 from Web"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app-alb_sg.sg_id
}

resource "aws_security_group_rule" "app_alb_catalogue" {
  type              = "ingress"
  description = "Allowing port number 80 from catalogue"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.catalogue_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app-alb_sg.sg_id
}

resource "aws_security_group_rule" "app_alb_user" {
  type              = "ingress"
  description = "Allowing port number 80 from user"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.user_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app-alb_sg.sg_id
}

resource "aws_security_group_rule" "app_alb_cart" {
  type              = "ingress"
  description = "Allowing port number 80 from cart"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.cart_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app-alb_sg.sg_id
}

resource "aws_security_group_rule" "app_alb_shipping" {
  type              = "ingress"
  description = "Allowing port number 80 from shipping"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.shipping_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app-alb_sg.sg_id
}

resource "aws_security_group_rule" "app_alb_payment" {
  type              = "ingress"
  description = "Allowing port number 80 from payment"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.payment_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app-alb_sg.sg_id
}

resource "aws_security_group_rule" "web_vpn" {
  type              = "ingress"
  description = "Allowing port number 80 from VPN"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.web_sg.sg_id
}

resource "aws_security_group_rule" "web_vpn_ssh" {
  type              = "ingress"
  description = "Allowing port number 22 from VPN"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.web_sg.sg_id
}

resource "aws_security_group_rule" "web_web_alb" {
  type              = "ingress"
  description = "Allowing port number 80 from Web ALB"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web-alb_sg.sg_id
    #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.web_sg.sg_id
}

resource "aws_security_group_rule" "web_alb_internet" {
  type              = "ingress"
  description = "Allowing port number 80 from Internet"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.web-alb_sg.sg_id
}

resource "aws_security_group_rule" "web_alb_internet_https" {
  type              = "ingress"
  description = "Allowing port number 443 from Internet"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.web-alb_sg.sg_id
}