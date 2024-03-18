# Networking module setup
module "networking" {
    source = "./networking"
    vpc_cidr_block = var.vpc_cidr_block
    availability_zones =  var.availability_zones
    vpc_public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
    vpc_private_subnet_cidr_blocks =  var.private_subnet_cidr_blocks
}


# Security Groups module Setup
module "security_groups" {
    source = "./security_groups"
    vpc_id = module.networking.vpc_id
    vpc_cidr_block = var.vpc_cidr_block
    public_bation_sg_name = "public-bation-security-group"
    private_application_sg_name = "private-application-security-group"
    rds_mysql_sg_name = "rds-mysql-security-group"
}

# EC2 Instance Setup
module "ec2_instances" {
    source = "./ec2_instances"
    ec2_public_key = var.ec2_public_key
    ec2_key_name = var.ec2_key_name
    public_bation_sg_id = module.security_groups.public_bation_sg_id
    public_bation_subnet_id = module.networking.public_subnet_ids[0]
    public_bation_server_instance_type = "t3.micro"
    application_server_instance_type = "t3.micro"
}