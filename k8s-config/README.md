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

Here is an example of a secret yaml file.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
  namespace: final
type: Opaque
data:
  username: bXlzcWw=        # base64 encoded 'mysql'
  password: cGFzc3dvcmQ=    # base64 encoded 'password'
```
