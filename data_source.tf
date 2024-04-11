data "aws_ami" "ubuntu_ami" {
  most_recent = true
  #     owners           = ["self"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "aws_route53_zone" "hosted_zone" {
  name         = "eswarmaganti.com"
  private_zone = false
}
