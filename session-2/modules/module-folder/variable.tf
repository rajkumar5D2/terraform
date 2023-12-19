variable "ami-id"{
  # type = string #optional
  default = "ami-03265a0778a880afb" #key and value
}

variable "instances"{ # USING FOR LOOP
  type = string
  default =  "t2.micro"
   
  
}

variable "hosted_id"{
  default = "Z015891316744TYEO5D3K"
}

variable "sg_name"{
  default = "allow-all-terraform"
}