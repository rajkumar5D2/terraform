resource "aws_instance" "module_instance" {
  ami = var.ami-id
  instance_type = var.instances    
} 