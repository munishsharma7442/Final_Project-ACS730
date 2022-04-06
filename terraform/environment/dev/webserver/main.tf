#  Define the provider
provider "aws" {
  region = "us-east-1"
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

# Use remote state to retrieve network data
data "terraform_remote_state" "network" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "tf-${var.env}s3-final-project-acs730" // Bucket from where to GET Terraform State
    key    = "${var.env}/network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                            // Region where bucket created
  }
}

# # Use remote state to retrieve vpcpeering data
# data "terraform_remote_state" "vpcpeering" { // This is to use Outputs from Remote State
#   backend = "s3"
#   config = {
#     bucket = "peering-acs730-final-project"           // Bucket where to SAVE Terraform State
#     key    = "peering-network/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
#     region = "us-east-1"                         // Region where bucket is created
#   }
# }

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix       = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${var.env}"
}

# Retrieve global variables from the Terraform module
module "globalvars" {
  source = "../../../modules/globalvars"
}

# webserver EC2 instance
resource "aws_instance" "webserver" {
  count                       = var.ec2_count
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.private_subnet_ids[count.index]
  security_groups             = [aws_security_group.webserver_sg.id]
  associate_public_ip_address = false
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env    = upper(var.env),
      prefix = upper(local.prefix)
    }
  )

  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-webserver-${count.index + 1}"
    }
  )
}

# Create another EBS volume
resource "aws_ebs_volume" "web_ebs" {
  count             = var.ec2_count
  availability_zone = data.aws_availability_zones.available.names[count.index]
  size              = 4
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-EBS"
    }
  )
}

# Attach EBS volume
resource "aws_volume_attachment" "ebs_att" {
  count       = var.ec2_count
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.web_ebs[count.index].id
  instance_id = aws_instance.webserver[count.index].id
}


# Adding SSH key to Amazon EC2
resource "aws_key_pair" "web_key" {
  key_name   = local.name_prefix
  public_key = file("${local.name_prefix}.pub")
}


# Security Group of webserver
resource "aws_security_group" "webserver_sg" {
  name        = "allow_http_ssh_webserver"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description     = "HTTP from Bastion"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
  ingress {
    description     = "HTTP from LB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-webserver-sg"
    }
  )
}


# Bastion host EC2 instance
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids[1]
  security_groups             = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-bastion"
    }
  )
}
# Security Group of Bastion host
resource "aws_security_group" "bastion_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_public_ip}/32", "${var.my_private_ip}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-bastion-sg"
    }
  )
}

#######################################################
# Using AWS Application Load balancer (alb) module
#######################################################

module "alb" {
  source          = "../../../modules/alb"
  env             = var.env
  vpc_id          = data.terraform_remote_state.network.outputs.vpc_id
  security_groups = [aws_security_group.lb_sg.id]
  subnets         = data.terraform_remote_state.network.outputs.public_subnet_ids[*]
  prefix          = var.prefix
  default_tags    = var.default_tags
}

resource "aws_security_group" "lb_sg" {
  name        = "allow_http_lb"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description      = "HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTP from everywhere"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-lb-sg"
    }
  )
}

# Create AWS Launch Configuration
resource "aws_launch_configuration" "web" {
  name            = "web-${var.env}"
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = lookup(var.instance_type, var.env)
  key_name        = aws_key_pair.web_key.key_name
  security_groups = [aws_security_group.webserver_sg.id]
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
  desired_capacity     = 2
  launch_configuration = aws_launch_configuration.web.name
  vpc_zone_identifier  = data.terraform_remote_state.network.outputs.private_subnet_ids[*]
  lifecycle {
    ignore_changes = [desired_capacity, target_group_arns]
  }

  #   dynamic "tag" {
  #     for_each = local.default_tags

  #     content {
  #       key                 = tag.key
  #       value               = tag.value
  #       propagate_at_launch = true
  #     }
  #   }
  # }

  # Tag for correction
  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-auto-scaled-node"
    propagate_at_launch = true
  }
}

# Create autoscaling attachment
resource "aws_autoscaling_attachment" "web_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
  lb_target_group_arn    = module.alb.target_group_arns[0]
}

# Create auto-scaling policy for scaling in
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "web_scale_in"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

# Create cloud wathc alarm to scale in if cpu util load is below 5%
resource "aws_cloudwatch_metric_alarm" "scale_in" {
  alarm_description   = "Monitors CPU utilization for Web ASG"
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]
  alarm_name          = "web_scale_in"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "5"
  evaluation_periods  = "2"
  period              = "120"
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
  cooldown               = 120
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
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}