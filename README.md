# Final_Project-ACS730 developed by Group 9
Pre-requisites-
1) Create a S3 public bucket for websites to load images from S3:
 -Create a public bucket with name as mentioned below and upload 2 images from the path (Final_Project-ACS730/terraform/modules/asg/):
  Bucket name - 	website-images-project
  first image name - ilovecats.jpg
  Second image name - ilovedogs.jpg
  
2) Generate a SSH key for dev, prod and Staging and store in below path:
   - cd Final_Project-ACS730/terraform/environment/dev/webserver 
     run command -> ssh-keygen -t rsa -f Group9-dev
   - cd Final_Project-ACS730/terraform/environment/prod/webserver 
     run command -> ssh-keygen -t rsa -f Group9-prod
   - cd Final_Project-ACS730/terraform/environment/Staging/webserver 
     run command -> ssh-keygen -t rsa -f Group9-staging

3) Create S3 buckets using S3 module:
   Navigate to Final_Project-ACS730/terraform/modules/s3
   run the terraform deployment commands as mentioned below:
   - terraform init
   - terraform validate
   - terraform plan
   - terraform apply

Deployment Steps: 
 1) Deploy dev environment
    navigate to Final_Project-ACS730/terraform/environment/dev/network
    run the terraform deployment commands as mentioned below:
    - terraform init
    - terraform validate
    - terraform plan
    - terraform apply
 
    navigate to Final_Project-ACS730/terraform/environment/dev/webserver
    run the terraform deployment commands as mentioned below:
    - terraform init
    - terraform validate
    - terraform plan
    - terraform apply
  
 2) Deploy prod environment
    navigate to Final_Project-ACS730/terraform/environment/prod/network
    run the terraform deployment commands as mentioned below:
    - terraform init
    - terraform validate
    - terraform plan
    - terraform apply
 
    navigate to Final_Project-ACS730/terraform/environment/prod/webserver
    run the terraform deployment commands as mentioned below:
    - terraform init
    - terraform validate
    - terraform plan
    - terraform apply
     
 3) Deploy Staging environment
    navigate to Final_Project-ACS730/terraform/environment/Staging/network
    run the terraform deployment commands as mentioned below:
    - terraform init
    - terraform validate
    - terraform plan
    - terraform apply
 
    navigate to Final_Project-ACS730/terraform/environment/Staging/webserver
    run the terraform deployment commands as mentioned below:
    - terraform init
    - terraform validate
    - terraform plan
    - terraform apply
 
 4) Deploy the peering modules
    navigate to Final_Project-ACS730/terraform/environment/peering-dev-prod
    run the terraform deployment commands as mentioned below:
    - terraform init
    - terraform validate
    - terraform plan
    - terraform apply
    
    navigate to Final_Project-ACS730/terraform/environment/peering-dev-staging
    run the terraform deployment commands as mentioned below:
    - terraform init
    - terraform validate
    - terraform plan
    - terraform apply

Test the webpages:
  Once we are done with the dev, prod and Staging deployment. we can see the dns address of load balancer for all the three environments.
  Copy the dns address and paste it in the browser to test the web servers.
  
Huraah!!!!!!!!!!! We are done !!!! Thanks to this Assignment!!!!!!


Authors -  Munish, Krenessa, Rodel, Shahab