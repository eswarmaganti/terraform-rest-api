variable "vpc_ic" {}
variable "vpc_cidr_block" {}
variable "public_bation_sg_name" {}

variable "private_application_sg_name" {}

# security group for public bation instance in public subnet
resource "aws_security_group" "security_group_public_bation" {
    name = var.public_bation_sg_name
    vpc_id = var.vpc_id
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow public Internet acces from pation instance"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "HTTP"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP on port 80"
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "HTTPS"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTPS on port 80"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow ssh on port 22"
    }
}

# Security Group for application running in private subnet
resource "aws_security_group" "security_group_application" {
    vpc_id = var.vpc_id
    ingress {
        to_port = 5000
        from_port = 5000
        cidr_blocks = var.vpc_cidr_block
        protocol = "tcp"
        description = "Allow port 5000 to access the application"
    }
}