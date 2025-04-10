### Docker Local Testing
For testing we will be needing some prior configuration for it to work. So first we will need to ensure we have all environment variables ready

Will need to ensure the following are added to the `.bashrc`

>[!NOTE]
Ensure that all the images are already been pulled `docker images`.

```bash
# Docker local testing
export BACKGROUND_IMAGE_URL=s3://clo835bucketlife/field-corn-air-frisch-158827.png
export DBHOST=172.17.0.2
export DBPWD=pw
export DBUSER=root
export DBPORT=3306
export DATABASE=employees
```

Also, we will need to have the aws credentials within the environment

```bash
# These variables are required to be passed to docker container when running the webapp.
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_SESSION_TOKEN=""
```

##### The commands to be executed
###### For mysql
```bash
docker run -d -e MYSQL_ROOT_PASSWORD=pw -p 3306:3306 <id>.dkr.ecr.us-east-1.amazonaws.com/mysql:v0.1
```
###### For webapp
```bash
docker run -d -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD -e BACKGROUND_IMAGE_URL=$BACKGROUND_IMAGE_URL -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN -p 80:81 <id>.dkr.ecr.us-east-1.amazonaws.com/app:v0.1
```

**Check the containers if anything happened**
```bash
docker logs <name>
```
or use
```bash
docker exec -it <name> bash
```
