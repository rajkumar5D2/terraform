#=============THIS FILE IS FOR TESTING PURPOSE==========================
# output "vpc_id" {
#   value = module.vpc.vpc_id  #SYNTAX-----> module.<<name>>.<<output_var_name>>
# }

# output "vpc_id_local" { #this is for testing local
#   value = local.vpc_id
# }

# output "availabili_zones_from_user_output" { # testing that 2 azs setted by company on "terraform plan command"
#   value = local.availabili_zones_user_local
# }

# output "public-subnet-employee" {
#   value = local.public_subnet_id
# }

# output "private-subnet-employee" {
#   value = local.private_subnet_id
# }

# output "database-subnet-employee" {
#   value = local.database_subnet_id
# }