# webtier instances inputs
variable "webtier_instance_type" {}
variable "webtier_ami_id" {}
variable "webtier_security_group_ids" {}
variable "webtier_asg_name" {}
variable "webtier_asg_max_size" {}
variable "webtier_asg_min_size" {}
variable "webtier_asg_desired_capacity" {}

# Apptier instances inputs
variable "apptier_instance_type" {}
variable "apptier_ami_id" {}
variable "apptier_security_group_ids" {}
variable "apptier_asg_name" {}
variable "apptier_asg_max_size" {}
variable "apptier_asg_min_size" {}
variable "apptier_asg_desired_capacity" {}

variable "availability_zones" {}
variable "ec2_key_name" {}
variable "public_subnet_ids" {}
variable "private_subnet_ids" {}
