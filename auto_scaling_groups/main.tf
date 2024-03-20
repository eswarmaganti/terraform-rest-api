# Creating a launch template for web-tier instances
resource "aws_launch_template" "web-tier-template" {
  name                   = "webtier-launch-template"
  instance_type          = var.webtier_instance_type
  image_id               = var.webtier_ami_id
  vpc_security_group_ids = var.webtier_security_group_ids
  key_name               = var.ec2_key_name
  network_interfaces {
    associate_public_ip_address = true
  }
  tags = {
    Name = "Webtier EC2 Instances"
  }
  user_data = filebase64("./template_scripts/webtier_init.sh", )
}

# Creating Auto Scaling Group for Webtier Instances
resource "aws_autoscaling_group" "webtier-asg" {
  name                = var.webtier_asg_name
  max_size            = var.webtier_asg_max_size
  min_size            = var.webtier_asg_min_size
  desired_capacity    = var.webtier_asg_desired_capacity
#   availability_zones  = var.availability_zones
  vpc_zone_identifier = var.public_subnet_ids
  launch_template {
    version = "$Latest"
    id      = aws_launch_template.web-tier-template.id
  }
}



# Creating a launch template for Application Tier instances
resource "aws_launch_template" "app-tier-template" {
  name                   = "apptier-launch-template"
  instance_type          = var.apptier_instance_type
  image_id               = var.apptier_ami_id
  vpc_security_group_ids = var.apptier_security_group_ids
  key_name               = var.ec2_key_name
  tags = {
    Name = "App Tier EC2 Instances"
  }
  user_data = filebase64("./template_scripts/apptier_init.sh")
}

# Creating Auto Scaling Group for Webtier Instances
resource "aws_autoscaling_group" "apptier-asg" {
  name             = var.apptier_asg_name
  max_size         = var.apptier_asg_max_size
  min_size         = var.apptier_asg_min_size
  desired_capacity = var.apptier_asg_desired_capacity
  #   availability_zones  = var.availability_zones
  vpc_zone_identifier = var.private_subnet_ids
  launch_template {
    version = "$Latest"
    id      = aws_launch_template.web-tier-template.id
  }
}
