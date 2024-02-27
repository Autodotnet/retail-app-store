Retail APP Store

My intention here was to use the code borrowed and adapted from the repo below to demosntrate how to deploy an application in GCP using GKE( Google Kubernetes Engine) and also microservices concept. 

Also, I used a persistent disk and Auto Scaling to provide resilience. The app is well splited on 11 microservices using the manifests in yaml. 

To create the infrastructure it was used Terraform as well as to deploy the application manifests to the GKE.

The locust.py script was used to test the Auto Scaling emulating a surge of users requesting the application, causing the application to scale its components.





The Repo that I took as reference to this project:

https://github.com/GoogleCloudPlatform/microservices-demo.git
