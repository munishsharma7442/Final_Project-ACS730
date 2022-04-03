# Print Private IP addresses
output "private_ips" {
  value = aws_instance.my_amazon.*.private_ip
}

