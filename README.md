## Final Project Overview (CLO835)

This project is about building, hosting, and deploying a containerized application using Kubernetes (K8s) and Docker while integrating cloud-based tools like Amazon EKS (Elastic Kubernetes Service) and Amazon ECR (Elastic Container Registry).

### Objectives
#### Enhance The Web Application
##### The app is backed by MySQL... Will apply some improvements in:
- Configuration -> environment variables, ConfigMaps
- Security -> secrets management, access control
- Persistent Data -> Persistent Volumes for MySQL data storage

##### Build Docker Images
- Automate the build process with GitHub Actions.
- Publish the Docker image to Amazon ECR (a private registry on AWS). [Docs](https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html)

##### Deploy to Kubernetes on AWS (Amazon EKS)
For this one, we will use AWS EC2 Instance t2.micro as the controller node, since we wouldn't need to run kind or anything in it.
- Set up an Amazon EKS Cluster (AWS-managed Kubernetes).
- Creating... Kubernetes manifests (YAML files for Deployments, Services, Persistent Volumes, etc.).
- Deploy everything using the kubectl command-line tool.

#### Objective
Our objective is to have a virtual machine (EC2) that we can use as a **controller**, to deploy Amazon Elastic Kubernetes Service (EKS). We will automate the following:
1. Pushing the docker images to AWS ECR, using *Github Action*. 
2. Deploying an `EC2 instance` instead of *cloud9* and install all required dependencies such as (kubectl, docker, aws cli and eensure credentials setup).
3. Will clone our github repo that has all the yaml files (manifests) to deploy our cluster node on EKS.
4. Will create a namespace to ensure everything is under its own environment.
5. Start by creating the cluster using the configuration provided.
...
---
## Getting Started
Open Terminal (or Git Bash, VS Code Terminal, ghostty or kitty ;)
Clone the Repository
```bash
git clone https://github.com/omar0ali/clo835-project.git
```

Navigate into the Project Folder

```bash
cd clo835-project
```
---
