

# security group for public bation instance in public subnet
resource "aws_security_group" "security_group_public_bation" {
  name   = var.public_bation_sg_name
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow public Internet acces from pation instance"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ssh on port 22"
  }

  tags = {
    Name = "Public Bation Security Group"
  }
}

# Security Group for webtier application instances
resource "aws_security_group" "app_security_group" {
  name   = var.app_sg_name
  vpc_id = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow public Internet acces from Application Instance"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP on port 80"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS on port 80"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
    description = "Allow ssh on port 22 from VPC"
  }
  tags = {
    Name = "Webtier Application Security Group"
  }
}


# Security Group for RDS Database server
resource "aws_security_group" "security_group_rds_mysql" {
  vpc_id = var.vpc_id
  name   = var.rds_mysql_sg_name
  ingress {

    from_port   = 3306
    to_port     = 3306
    cidr_blocks = [var.vpc_cidr_block]
    protocol    = "tcp"
    description = "Allow port 3306 to enable applications to connect to MySQL DB"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow database server to access the public internet"
  }
  tags = {
    Name = "RDS MySQL DB Security Group"
  }
}
