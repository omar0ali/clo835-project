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
