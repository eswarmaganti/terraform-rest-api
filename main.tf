

# Networking module setup
module "networking" {
    source = "./networking"
    vpc_cidr_block = var.vpc_cidr_block
    availability_zones =  var.availability_zones
    vpc_public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
    vpc_private_subnet_cidr_blocks =  var.private_subnet_cidr_blocks
}


