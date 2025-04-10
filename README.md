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
- Deploy everything using the *eksctl* command-line tool and managment using *kubectl*.

#### Objective
Our objective is to have a virtual machine (EC2) that we can use as a **controller**, to deploy Amazon Elastic Kubernetes Service (EKS). We will automate the following:
1. Pushing the docker images to AWS ECR, using *Github Action*.
2. Deploying an `EC2 instance` instead of *cloud9* and install all required dependencies such as (kubectl, eksctl, docker, aws cli and eensure credentials setup). [terraform deployment](https://github.com/omar0ali/clo835-project/blob/main/terraform/main.tf)
    - This will ensure to prepare an updated .aws/credentials file copied from the host machine, to speed things up.
3. Will clone our github repo that has all the yaml files (manifests) to deploy our cluster node on EKS.
4. Start by creating the cluster using the configuration provided.
5. Will create a namespace to ensure everything is under its own environment.
6. Create configMap and Secrets
7. Deployments (webapp and mysql)
8. Services
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

### GitHub Action Requirements
Here is the list of required secrets for the action to work.
1. `AWS_ACCESS_KEY_ID`
2. `AWS_SECRET_ACCESS_KEY`
3. `AWS_SESSION_TOKEN`
4. `SSH_PRIVATE_KEY` 
    - NOTE: Must include the content of the whole file, including the header and footer of the key.
5. `EC2_HOST`


### Tests
- [x] Pushing the images to ECR successfully!
    - [x] GitHub Action should SSH to the EC2 instance and pull the images before we ssh manually, to speed the process.
    - **IMPORTANT:** This will require to have the EC2 instance running before running the action.
- [x] Creating a cluster node using `eksctl create cluster -f eks-cluster-config.yaml`, path at `/home/ec2-user/clo835-project/k8s-config`
    - NOTE: to delete `eksctl delete cluster --region=us-east-1 --name=clo835`
- [ ] Creating Deployments, this is dependeing on configMap and secrets as well as the ECR Images.
    - configMap
    - secrets
    - deployments (mysql, web app)
    - services (mysql(clusterIP), webapp(loadbalancer))
