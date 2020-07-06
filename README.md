## terraform-docker-fargate-aws-nodejs project 2020 ##

===========

##  Project 1 description  ##
```
This a nodejs web app thats been built using Docker
When an end user browse to the website, the web server takes that request
and calls the requested api as described in the server.js file
e.g /api/users endpoint. which will then load & display all the information 
from the db.json file on a web browser. 
```
##  high level technical explanation  ##
```
==== Docker part
* download a node base image & built the custom image on top 
* docker exposes port 3000, configure the container then start the app (see dockerfile) 

==== Terraform part
* created an ECR repo 
* tagged my docker image to the uri for the ECR repo 
* pushed the image to the ECR for ECS to run it as docker container
* the ECS cluster will be running the image which is located in the ECR repo
* built an ECS cluster (fargate) with 3 docker instances for my app
* The ALB will be placed in front of the service to route, split users requests
  accross the 4 configured containers (ECS cluster).
* auto scaling has been configured to run at least 4 EC2 instances & when the cpu threshold
  goes above 80% the instances will scale up. min at a time =3 and max will be 10.
* scale down , when the cpu util. goes below 20% the instances will scale down the instances
  (cost effective & performance efficient)
* I've also configured the ECS to send logs to cloudwatch dashboard, cloudwatch triggers will
  help us know the auto scaling policies 
* The docker image is stored in the docker repo called ecs-service in aws (private image repo)
  
==== what happens in the case of a software upgrade ?
* whenever there is a new image, all i have to do, is to push that image to the ecr with a new
  version.
```
##  other important technical definitions to better understand this project  ##
```
* ECR: elastic container registry 
ECR gives you an environment where you can configure your docker container to execute it in aws 
it handles everything from installing the docker deamon for the container to run , task def etc. 
ECR is integrated with ECS & transfers your container images over HTTPS and automatically encrypts
your images at rest.You can easily push your container images to Amazon ECR using the Docker CLI
from your development machine, and Amazon ECS can pull them directly for production deployments.

* ECS: elastic container service 
Highly scalable, high performance container management service that supports Docker containers
and allows you to easily run applications on a managed cluster of Amazon EC2 instances
ECS eliminates the need for you to install, operate, and scale your own cluster management 
infrastructure.Amazon ECS maintains application availability and allows you to scale your 
containers up or down to meet your application's capacity requirements.
```

## ECS is implemented in aws in two ways: EC2 & Fargate ##
```
1. EC2:
launch a docker container on aws with ecs
has support for ALB & ASG
user should provision ec2 where container will be run by ecs 

2. Fargate:
amazon proviison your ec2 (serverless)
no need to worry about ec2 instances
so you no longer have to provision, configure and scale clusters of VMs to run containers 

```

##  Project 2 (simple terraform challenge)  ##
```
1. created an ec2
2. created a sec. group with the below rules using variables
   2a. ingress rules:80,443,25,3306,3389,8080
   2b. ingress rules:443,8443
3. attached a public IP
4. created an elastic IP
5. terraform will output the below
   5a. output the public IP
   5b. check the expected ports to be open
   5c. confirm open port
```
