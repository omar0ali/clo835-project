>[!NOTE]
Before starting at kubernetes, must try running docker locally, please visit `clo835-project/dockerfiles` follow the readme file carefully.

### Requirements
- [x] Cluster Config **TESTED**
- [x] Namespace Config name (final)
- [x] Secrets Config
- [x] Deployments
    - webapp: for the website
    - mysql: for the database
    - **NOTE:** both single replica
    - [x] **TEST**: will need some testing
- [x] Services
    - webapp: Load Balancer / External Connection
    - mysql: ClusterIP / Local Connection
- [x] ConfigMap
- [x] PVC
- [x] Service Account


Creating a cluster node using eksctl `create cluster -f cluster-config.yaml`, path at `/home/ec2-user/clo835-project/k8s-config`

### Here are some useful commands:
1. `kubectl get nodes` only after cluster is deployed.
2. `kubectl get storageclass` EKS usually creates a default one named gp2 or gp3.
    - This should let us know that we can just create a `PVC` we will ensure to update the pvc.yaml file and apply the correct setting.
3. When it comes to secrets, we will use the following commands to convert literial words to base64 and only use that into the secrets file.

```bash
echo -n 'mysql' | base64
echo -n 'password' | base64
```

### To pull the images from ECR we need the following setup
Before running, also need to set the secret to be able to download the image.

```bash
aws ecr get-login-password --region us-east-1 > ecr-pass.txt
```

```bash
kubectl create secret docker-registry ecr-secret --docker-server=184549016595.dkr.ecr.us-east-1.amazonaws.com --docker-
username=AWS --docker-password="$(cat ecr-pass.txt)" -n final
```


### We also need CSI Driver to bind with the pvc volume

```bash
eksctl create addon --name aws-ebs-csi-driver --cluster clo835 --region us-east-1 --force
```

### Execute the following objects in-order:
1. namespace
2. ecr-secret (all the secrets)
3. configMap
4. pvc
5. mysql-deployment
6. mysql-service
7. webapp-deployment
8. webapp-service

>[IMPORTANT]
Must wait for at least 3-5 minutes before trying and accessing the loadbalancer DNS.

Here are some commands will be used to help understand whats going on and ensure everything is working as intended

1. `kubectl get nodes`
2. `kubectl get svc -n final`
3. `kubectl get pods -n final`
4. `kubectl get deployments -n final`
5. `kubectl get secrets -n final`
6. `kubectl logs <pod-name> -n final`
7. `kubectl describe [pod, deployment, svc ..etc.] <name> -n final`
