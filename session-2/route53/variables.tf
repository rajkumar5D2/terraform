variable "ami-id"{
  type = string #optional
  default = "ami-03265a0778a880afb" #key and value
}

variable "instance_names"{
  type = list
  default = ["web","cart","reddis","catalogue","user","rabbitmq","dispatch","shipping","payment","mongodb","mysql"]
}

variable "hosted_id"{
  default = "Z09633341N26AMIC7NJRO"
}

