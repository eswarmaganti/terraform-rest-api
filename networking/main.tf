

# VPC Setup
resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "Application VPC"
  }
}


# VPC Public subnet setup
resource "aws_subnet" "app_vpc_public_subnets" {
  vpc_id            = aws_vpc.app_vpc.id
  count             = length(var.vpc_public_subnet_cidr_blocks)
  cidr_block        = element(var.vpc_public_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "Application VPC Public Subnet - ${count.index}"
  }
}


# VPC Public subnet setup
resource "aws_subnet" "app_vpc_private_subnets" {
  vpc_id            = aws_vpc.app_vpc.id
  count             = length(var.vpc_private_subnet_cidr_blocks)
  cidr_block        = element(var.vpc_private_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "Application VPC Private Subnet - ${count.index}"
  }
}


# Internet Gateway Setup
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "Application Internet Gateway"
  }
}

# Route Table Setup for Public Subnets

resource "aws_route_table" "app_vpc_public_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }

  tags = {
    Name = "Application VPC Public Route Table"
  }
}


# Route Table Association for Public Subnets Setup
resource "aws_route_table_association" "public_route_table_association" {
  #     for_each = { for item in aws_subnet.app_vpc_public_subnets: item.id => item }
  count          = length(var.vpc_public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.app_vpc_public_subnets[count.index].id
  route_table_id = aws_route_table.app_vpc_public_route_table.id
}


# creating elastic ip for nat gateway
resource "aws_eip" "nat_gtw_eip" {
  domain = "vpc"
  tags = {
    Name = "Elastic IP for NAT Gateway"
  }
  depends_on = [aws_internet_gateway.app_igw]
}

# creating a NAT Gateway in public subnet
resource "aws_nat_gateway" "nat_gtw" {
  subnet_id     = aws_subnet.app_vpc_public_subnets[0].id
  allocation_id = aws_eip.nat_gtw_eip.id

  depends_on = [aws_eip.nat_gtw_eip]

  tags = {
    Name = "Nat Gateway for Private Application Servers"
  }
}

# Route Table Setup for Private Subnets
resource "aws_route_table" "app_vpc_private_route_table" {
  vpc_id = aws_vpc.app_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gtw.id
  }

  depends_on = [aws_nat_gateway.nat_gtw]

  tags = {
    Name = " Application VPC Private Route Table"
  }
}


# Route Table Association for Private Subnets Setup
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.vpc_private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.app_vpc_private_subnets[count.index].id
  route_table_id = aws_route_table.app_vpc_private_route_table.id
}


# Create Database subnets
resource "aws_docdb_subnet_group" "doocdb_subnet_group" {

  name       = "docdb-subnet-group"
  subnet_ids = [aws_subnet.app_vpc_private_subnets[0].id, aws_subnet.app_vpc_private_subnets[1].id]

  tags = {
    Name = "My docdb subnet group"
  }
}
# create route table for database subnets

# create route table association for db subnets
