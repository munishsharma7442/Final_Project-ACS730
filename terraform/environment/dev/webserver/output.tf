# Add output variables
output "public_ip" {
  value = aws_instance.bastion.public_ip
}

output "private_ips" {
  value = aws_instance.webserver.*.private_ip
}

# Add output variables
output "target_group_id" {
  value = aws_lb_target_group.target_group.arn
}