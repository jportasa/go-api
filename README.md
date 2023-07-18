# Prima home assesment test, SRE

## Pre-requisites
Docker, terraform, go installed in your local.

## Create the kind cluster via Terraform
```
cd terraform/kind
terraform init
terraform apply
cd ../..
```

## Add Ingress to give external visibility to the API
Nginx Ingress Controller install:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```
Please wait until it is created.


### Create Mysql server in k8s kind via Terraform
Have to say that easiest way to create it is directly in k8s with yaml, but Prima team considered is not IaC.

Point out that this:

- will create the k8s namespace "prima" 
- the mysql server, you can see that the terraform module mysql initializes as well the database with contents.
- for simlicity I have disabled authentication to access the RDS, this can be done through k8s Secrets, using aws-external-secret controller for AWS,...

```
cd terraform/mysql
terraform init
terraform apply
cd ../..
```

## Create API app

This will create the binary for linux amd64, then the docker container and will push it to kind.
```
make binary
make build
kubectl apply -f ./k8s/api/ -n prima
```

# Operation with the API
Get all users from mysql:
```
curl http://localhost/users
```

This will output:
```
[{"id":"1","name":"Joan Porta"},{"id":"2","name":"John McEnroe"}]
```

Add a user to mysql:

```
curl -d '{"id":"3","name":"Eva Cano"}' -H "Content-Type: application/json" -X POST http://localhost/user
```

This will output:
```
[{"id":"1","name":"Joan Porta"},{"id":"2","name":"John McEnroe"},{"id":"3","name":"Eva Cano"}]
```