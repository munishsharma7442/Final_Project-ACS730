#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h1>Welcome to our ${prefix} in ${env}! <font color="turquoise"> This is Group9 with the following members: Rodel, Krenessa, Shahab and Munish </font></h1><br>Built by Terraform!"  >  /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd