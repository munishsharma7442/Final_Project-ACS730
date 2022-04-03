# Add output variables
#public subnet output
output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

#private subnet output
output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

#vpc output
output "vpc_id" {
  value = aws_vpc.main.id
}
