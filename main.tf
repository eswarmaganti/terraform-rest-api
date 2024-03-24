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
  source                = "./security_groups"
  vpc_id                = module.networking.vpc_id
  vpc_cidr_block        = var.vpc_cidr_block
  public_bation_sg_name = "public-bation-security-group"
  app_sg_name           = "application-security-group"
  rds_mysql_sg_name     = "rds-mysql-security-group"
}

# Public Bation Instance Setup
module "ec2_instances" {
  source                             = "./ec2_instances"
  ec2_ami_id                         = data.aws_ami.ubuntu_ami.id
  ec2_public_key                     = var.ec2_public_key
  ec2_key_name                       = var.ec2_key_name
  public_bation_sg_id                = module.security_groups.public_bation_sg_id
  public_bation_subnet_id            = module.networking.public_subnet_ids[0]
  public_bation_server_instance_type = "t3.micro"
  nat_gateway                        = module.networking.nat_gateway
}

# LoadBalencer Target Group Setup
module "loadbalencer_target_group" {
  source          = "./loadbalencer_target_group"
  vpc_id          = module.networking.vpc_id
  app_tg_port     = 80
  app_tg_protocol = "HTTP"
}


# Auto Scaling Groups Setup for Webtier and Apptier Instancess
module "auto_scaling_group" {
  source                   = "./auto_scaling_group"
  vpc_id                   = module.networking.vpc_id
  app_ami_id               = data.aws_ami.ubuntu_ami.id
  app_instance_type        = "t3.micro"
  ec2_key_name             = var.ec2_key_name
  app_sg_ids               = [module.security_groups.app_sg_id]
  app_asg_name             = "application-auto-scaling-group"
  app_asg_desired_capacity = 3
  app_asg_max_size         = 5
  app_asg_min_size         = 2
  app_tg_arn               = module.loadbalencer_target_group.app_tg_arn
  private_subnet_ids       = module.networking.private_subnet_ids
}


module "elastic_load_balencer" {
  source                    = "./elastic_load_balencer"
  app_lb_name               = "application-load-balencer"
  app_lb_type               = "application"
  internal                  = "false"
  app_sg_ids                = [module.security_groups.app_sg_id]
  public_subnet_ids        = module.networking.public_subnet_ids
  app_http_listner_port     = 80
  app_http_listner_protocol = "HTTP"
  app_tg_arn                = module.loadbalencer_target_group.app_tg_arn

}
