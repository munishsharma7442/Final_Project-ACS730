# Print public_ip
output "public_ip" {
  value = aws_instance.bastion.public_ip
}


# Print staging_private_ips
output "staging_private_ips" {
  value = aws_instance.my_amazon.*.private_ip
}


