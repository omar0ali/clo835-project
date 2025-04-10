### Requirements
- [x] Cluster Config **TESTED**
- [x] Namespace Config name (final)
- [x] Secrets Config
- [x] Deployments
    - webapp: for the website
    - mysql: for the database
    - **NOTE:** both single replica
    - [ ] **TEST**: will need some testing
- [x] Services
    - webapp: Load Balancer / External Connection
    - mysql: ClusterIP / Local Connection
- [ ] ConfigMap
- [x] PVC
- [x] Service Account


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
username=AWS --docker-password="$(cat ecr-pass.txt)"
```

