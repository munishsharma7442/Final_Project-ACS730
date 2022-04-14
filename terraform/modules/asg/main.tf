# Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Local variables
locals {
  default_tags = merge(
    var.default_tags,
    { "Env" = var.env }
  )
  prefix      = var.prefix
  name_prefix = "${var.prefix}-${var.env}"
}

# Create AWS Launch Configuration
resource "aws_launch_configuration" "web" {
  name            = "web-${var.env}"
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = lookup(var.instance_type, var.env)
  key_name        = var.public_key
  security_groups = var.security_groups
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env    = upper(var.env),
      prefix = upper(local.prefix)
    }
  )
}

# Create ASG for Webserver
resource "aws_autoscaling_group" "web_asg" {
  name                 = "web_asg-${var.env}"
  min_size             = 1
  max_size             = 4
  desired_capacity     = var.desired_size
  launch_configuration = aws_launch_configuration.web.name
  vpc_zone_identifier  = var.vpc_zone_identifier[*]
  lifecycle {
    ignore_changes = [desired_capacity, target_group_arns]
  }

  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-auto-scaled-node"
    propagate_at_launch = true
  }
}

# Create autoscaling attachment
resource "aws_autoscaling_attachment" "web_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
  lb_target_group_arn    = var.lb_target_group_arn
}

# Create auto-scaling policy for scaling in
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "web_scale_in"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 900
}

# Create cloud watch alarm to scale in if cpu util load is below 5%
resource "aws_cloudwatch_metric_alarm" "scale_in" {
  alarm_description   = "Monitors CPU utilization for Web ASG"
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]
  alarm_name          = "web_scale_in"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "5"
  evaluation_periods  = "2"
  period              = "600"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}

# Create auto-scaling policy for scaling out
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "web_scale_out"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 60
}

# Create cloud watch alarm to scale out if cpu util if the load is above 10%
resource "aws_cloudwatch_metric_alarm" "scale_out" {
  alarm_description   = "Monitors CPU utilization for Web ASG"
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]
  alarm_name          = "web_scale_out"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "10"
  evaluation_periods  = "2"
  period              = "60"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}