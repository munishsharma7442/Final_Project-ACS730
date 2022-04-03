# Add output variables
output "public_ip" {
  value = aws_instance.bastion.public_ip
}

output "private_ip_webserver_1" {
  value = aws_instance.webserver1.private_ip
}


output "private_ip_webserver_2" {
  value = aws_instance.webserver2.private_ip
}