# Add output variables
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "webserver_private_ips" {
  value = aws_instance.webserver.*.private_ip
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.lb_dns_name
}
