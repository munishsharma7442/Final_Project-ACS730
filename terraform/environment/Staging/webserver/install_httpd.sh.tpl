#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h1>Welcome to our ${prefix} in ${env}! Group9 members: Rodel, Krenessa, Shahab and Munish | Request resolved by $(hostname -f) | Built by Terraform!"  >  /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd