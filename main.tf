# Networking module setup
module "networking" {
  source                         = "./networking"
  vpc_cidr_block                 = var.vpc_cidr_block
  availability_zones             = var.availability_zones
  vpc_public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  vpc_private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
}


# Security Groups module Setup
module "security_groups" {
  source                      = "./security_groups"
  vpc_id                      = module.networking.vpc_id
  vpc_cidr_block              = var.vpc_cidr_block
  public_bation_sg_name       = "public-bation-security-group"
  webtier_sg_name             = "webtier-application-security-group"
  private_application_sg_name = "private-application-security-group"
  rds_mysql_sg_name           = "rds-mysql-security-group"
}

# EC2 Instance Setup
module "ec2_instances" {
  source                             = "./ec2_instances"
  ec2_ami_id                         = data.aws_ami.ubuntu_ami.id
  ec2_public_key                     = var.ec2_public_key
  ec2_key_name                       = var.ec2_key_name
  public_bation_sg_id                = module.security_groups.public_bation_sg_id
  public_bation_subnet_id            = module.networking.public_subnet_ids[0]
  public_bation_server_instance_type = "t3.micro"
  application_server_instance_type   = "t3.micro"
  nat_gateway                        = module.networking.nat_gateway
}


# Auto Scaling Groups Setup for Webtier and Apptier Instancess
module "auto_scaling_groups" {
  source = "./auto_scaling_groups"

  # Webtier Instances Arguments
  webtier_instance_type        = "t2.micro"
  webtier_security_group_ids   = [module.security_groups.webtier_application_sg_id]
  webtier_ami_id               = data.aws_ami.ubuntu_ami.id
  webtier_asg_name             = "webtier-application-asg"
  webtier_asg_min_size         = 2
  webtier_asg_max_size         = 5
  webtier_asg_desired_capacity = 2

  # Apptier Instances Arguments
  apptier_instance_type        = "t2.micro"
  apptier_security_group_ids   = [module.security_groups.private_application_sg_id]
  apptier_ami_id               = data.aws_ami.ubuntu_ami.id
  apptier_asg_name             = "apptier-application-asg"
  apptier_asg_min_size         = 2
  apptier_asg_max_size         = 5
  apptier_asg_desired_capacity = 2

  availability_zones = var.availability_zones
  ec2_key_name       = var.ec2_key_name
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
}


# Target Group setup for Load Balencer
module "load_balencer_target_group" {
  source = "./load_balencer_target_group"
  vpc_id = module.networking.vpc_id

  webtier_asg_id            = module.auto_scaling_groups.webtier_asg_id
  webtier_asg_arn           = module.auto_scaling_groups.webtier_asg_arn
  webtier_target_group_name = "webtier-lb-target-group"
  webtier_target_group_port = 80

  apptier_asg_id            = module.auto_scaling_groups.apptier_asg_id
  apptier_asg_arn           = module.auto_scaling_groups.apptier_asg_arn
  apptier_target_group_name = "apptier-lb-target-group"
  apptier_target_group_port = 5000

}

