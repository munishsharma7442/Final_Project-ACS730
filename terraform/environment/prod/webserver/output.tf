# Print Private IP addresses
output "private_ips" {
  value = aws_instance.my_amazon.*.private_ip
}

# Print Load Balancer URL
output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.lb_dns_name
}