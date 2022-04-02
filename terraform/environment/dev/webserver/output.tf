# Print public_ip
output "public_ip" {
  value = aws_instance.bastion.public_ip
}

# Print bastion_private_ip
output "bastion_private_ip" {
  value = aws_instance.bastion.private_ip
}

# Print dev_private_ips
output "dev_private_ips" {
  value = aws_instance.my_amazon.*.private_ip
}


