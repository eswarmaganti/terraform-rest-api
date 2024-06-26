variable "vpc_cidr_block" {
  type        = string
  description = "The cidr block of application vpc"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "The cidr blocks corresponding to public subnets"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "The cidr blocks corresponding to private subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "The availability zones corresponding to subnets"
}

variable "ec2_public_key" {
  type        = string
  description = "The public key to ssh into public bation ec2 instance"
}

variable "ec2_key_name" {
  type        = string
  description = "The key name to create a new key pair for public bation instance"
}

variable "app_domain_name" {
  type = string
  description = "The domain name of the application"
}
variable "docdb_master_username" {
  type = string
  description = "The username of document db"
}
variable "docdb_master_password" {
  type = string
  sensitive = true
  description = "The password of Document DB"
}