locals { 
  vpc_id = module.vpc.vpc_id #saving for future purpose
  availabili_zones_user_local = module.vpc.azs_vpc_output # here getting only 2 azs setted by company
  public_subnet_id = module.vpc.public_subnet_id #saving for future purpose
  private_subnet_id = module.vpc.private_subnet_id #saving for future purpose
  database_subnet_id = module.vpc.database_subnet_id #saving for future purpose
  allow_all_sg_id = module.allow-all-sg.sg_id
  ips = module.ec2_instance
}

