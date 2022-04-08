#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat > /var/www/html/index.html <<EOL
<html>
<head>
    <meta charset="utf-8">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <h1> <p style="color:yellow;">Welcome to our ${prefix} in ${env}! developed by Group9 members: Rodel, Krenessa, Shahab and Munish</h1>
</head>
<style media="screen">
  body {
          background-color: #4c724c;
          font-size: 50pt;
          color: white;
    }
</style>
<body>
    <div class="container-fluid">
      <div id="one" class="text-center">
        <span><h1>"Request resolved by $(hostname -f)"</h1></span>
      </div>
      <div class="row">
        <div class="col-md-6 text-center">
         <img src="https://website-images-project.s3.amazonaws.com/ilovecats.jpg" width="400" height="400" alt="..." class="img-rounded">
        </div>
        <div class="col-md-6 text-center">
          <img src="https://website-images-project.s3.amazonaws.com/ilovedogs.jpg" width="400" height="400" alt="..." class="img-rounded">
        </div>
      </div>
    </div>
</body>
</html>
EOL
sudo systemctl start httpd
sudo systemctl enable httpd