##################################################
# main.tf – using a standalone aws_launch_template
##################################################

provider "aws" {
  region = var.region
}

# Lookup your Target Group by name
data "aws_lb_target_group" "app_tg" {
  name = "tg-umat-haash"
}

# ----------------------------------------
# 1) your reusable EC2 Launch Template
# ----------------------------------------
resource "aws_launch_template" "custom" {
  name_prefix   = "custom-lt-"
  image_id      = var.ami_id
  instance_type = "t2.micro"

  # (optional) example of passing user_data
  # user_data = base64encode(file("${path.module}/bootstrap.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      # will show up on each EC2
      Name = "custom-server"
    }
  }

  lifecycle {
    # to avoid conflicts on updates
    create_before_destroy = true
  }
}

# ----------------------------------------
# 2) three ASGs that all reference it
# ----------------------------------------
resource "aws_autoscaling_group" "dor" {
  count                = 3
  name                 = "dor-asg-${count.index + 1}"
  max_size             = 3
  min_size             = 0
  desired_capacity     = 0
  vpc_zone_identifier  = var.subnets
  health_check_type    = "EC2"

  launch_template {
    id      = aws_launch_template.custom.id
    version = "$Latest"
  }

  target_group_arns = [
    data.aws_lb_target_group.app_tg.arn
  ]

  tag {
    key                 = "Name"
    value               = "dor-asg-${count.index + 1}"
    propagate_at_launch = true
  }
}

terraform {
 backend "s3" {
  bucket = "imtec-tf-backend"
  key = "dor-il-central-1"
  region = "il-central-1"
 }
}
