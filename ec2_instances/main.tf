resource "aws_instance" "public_bation_server" {
    ami = data.aws_ami.ubuntu_ami.id
    instance_type = var.public_bation_server_instance_type
    key_name = var.ec2_key_name
    vpc_security_group_ids = [var.public_bation_sg_id]
    subnet_id = var.public_bation_subnet_id
    tags = {
        Name = "Public Bation Server"    
    }
    user_data = templatefile("./template_scripts/public_bation_init.sh",{})
}

resource "aws_key_pair" "public_bation_server_key_pair" {
    public_key = var.ec2_public_key
    key_name = var.ec2_key_name
}