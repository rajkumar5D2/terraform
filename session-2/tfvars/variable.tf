variable "ami-id"{
  # type = string #optional
  default = "ami-03265a0778a880afb" #key and value
}

variable "instances"{ # USING FOR LOOP
  type = map
  default = {
    mongodb = "t3.medium"
    mysql = "t3.medium"
    user = "t2.micro"
    web = "t2.micro"
    cart = "t2.micro"
    redit = "t2.micro"
    rabbitmq = "t2.micro"
    shipping = "t2.micro"
    payment = "t2.micro"
    dispatch = "t2.micro"
    catalogue = "t2.micro"
  }
}

variable "hosted_id"{
  default = "Z015891316744TYEO5D3K"
}

variable "sg_name"{
  default = "allow-all-terraform"
}