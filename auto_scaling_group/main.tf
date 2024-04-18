# Launch Template for Webtier Application
resource "aws_launch_template" "app_launch_template" {
  name          = "webtier-launch-template"
  image_id      = var.app_ami_id
  instance_type = var.app_instance_type
  key_name      = var.ec2_key_name
  user_data = base64encode(
    templatefile(
      "./template_scripts/private_app_init.sh",
      { documentdb_uri = var.documentdb_uri, documentdb_username = var.documentdb_username, documentdb_password = var.documentdb_password }
  ))
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.app_sg_ids
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Application Instance"
    }
  }
}


# Create the AutoScalign Group for Webtier Applications
resource "aws_autoscaling_group" "app_asg" {
  name                      = var.app_asg_name
  desired_capacity          = var.app_asg_desired_capacity
  max_size                  = var.app_asg_max_size
  min_size                  = var.app_asg_min_size
  force_delete              = true
  target_group_arns         = [var.app_tg_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier       = var.private_subnet_ids
  launch_template {
    version = "$Latest"
    id      = aws_launch_template.app_launch_template.id
  }
}

