# Creating a public bation server to access other resources in VPC in a secure way
resource "aws_instance" "public_bation_server" {
  ami                    = var.ec2_ami_id
  instance_type          = var.public_bation_server_instance_type
  key_name               = var.ec2_key_name
  vpc_security_group_ids = [var.public_bation_sg_id]
  subnet_id              = var.public_bation_subnet_id
  tags = {
    Name = "Public Bation Server"
  }
  user_data = templatefile("./template_scripts/public_bation_init.sh", {})
}

# creating the key pair for bation server
resource "aws_key_pair" "public_bation_server_key_pair" {
  public_key = var.ec2_public_key
  key_name   = var.ec2_key_name
}

# creating Elastic IP and assigning it to public bation instance
resource "aws_eip" "elastic_ip" {
  domain     = "vpc"
  instance   = aws_instance.public_bation_server.id
  depends_on = [aws_instance.public_bation_server, var.nat_gateway]
}


# resource "null_resource" "file_provisioner" {
#   connection {
#     host        = aws_eip.elastic_ip.public_ip
#     user        = "ubuntu"
#     type        = "ssh"
#     private_key = file("/Users/eswarmaganti/.ssh/ec2_public_bation")
#   }
#   provisioner "file" {
#     source      = "/Users/eswarmaganti/.ssh/ec2_public_bation"
#     destination = ".ssh/ec2_public_bation"
#   }
# }



