# Table of contents
1. [Introduction](#introduction)
1. [Important Notes](#important-notes)
1. [Prerequisites](#prerequisites)
1. [Getting Started](#getting-started)
    1. [Use as a Docker image](#use-as-a-docker-image)
    1. [Use as a Github template / terraform module](#use-as-a-github-template---terraform-module)
    1. [Dashboard](#dashboard)
1. [Plugin Deployments](#plugin-deployments)
    1. [API-Gateway Ingress Controller](#api-gateway-ingress-controller)
    1. [Application Load Balancer (ALB) Ingress Controller](#application-load-balancer--alb--ingress-controller)
    1. [Kong Gateway](#kong-gateway)
    1. [Fargate Profile](#fargate-profile)
    1. [Istio](#istio)
1. [Teardown](#teardown)
1. [Useful Commands](#useful-commands)

## Introduction
Kinbal allows you to deploy a production-grade EKS cluster on AWS in 15 mins or less. 🚀🐳

## Important Notes
- You must deploy the core EKS cluster by executing `sh ./bin/core/EKS/deploy.sh` first before adding the plugins.
- You can edit / add / remove the microservices as you wish. For local code changes to propagate to the cluster, you will need to:
    - Rebuild the image e.g. `docker build -t ppanchal97/service1 .`
    - Push the image up to Docker Hub e.g. `docker push ppanchal97/service1`
- If you are using the API-Gateway ingress controller you can add / remove routes - and to propagate the changes to the API gateway and the cluster, you will need to redeploy the ingress:
    - Get the list of ingresses using `kubectl get ingress`
    - Delete the ingress using `kubectl delete ingress INGRESS_NAME`
    - Redeploy the ingress using `kubectl apply -f ./api_ingress` . The ingress deployment should take ~15 minutes. You can check the progress by looking at the logs of the ingress controller pod.
- AWS EKS is excluded from all free-tier discounts and you will be charged to run Kinbal.
- The infrastructure can provision dev / staging / production environments but due to cost constraints, the staging / production modules have been commented out.

## Prerequisites
1. Docker

## Getting Started
There are two ways in which you can use this tool: as a Docker image or a Github template / terraform module. The first one is the simpler of the two and it does not require installing `terraform` or `kubectl`.

### Use as a Docker image
1. Create a configuration file to configure Kinbal and save as `cluster.config`.
```
CLUSTER_NAME={name of the cluster to be created}
REGION={AWS region to create the cluster in}
ENVIRONMENT={name of the environment you're deploying (e.g. dev, production)}
AWS_PROFILE={optional, if you use named profiles}
```
2. Run the project using Docker by executing the following command. It will drop you into a basic shell, preconfigured with `terraform` and `kubectl`.
```
docker run --rm -it --env-file cluster.config -v ~/.aws:/root/.aws ppanchal97/kinbal
```
3. If your IAM user has MFA enabled, create a new session.
```bash
eval $(bin/aws-login-with-mfa [IAM user name] [token])
```
4. Deploy the core EKS cluster (this step will take a while)
```
sh ./bin/core/EKS/deploy.sh
```
5. Verify deployment
```bash
kubectl get pods -A # to see all of the running pods that have been deployed
kubectl get ingress # to see all of the public addresses of the services
```

🎉 Done! Kinbal has just created the following for you:
- A fully managed Control Plane
- A semi-managed worker node group with 3 EC2 nodes running the Docker runtime and the optimized Amazon Linux 2 AMI. These nodes are provisioned inside of an autoscaling group and the configuration will fully automate the provisioning and lifecycle management of nodes for the EKS cluster.
- A Fargate profile that allows workloads and pods to be run in a serverless fashion. Fargate allocates the right amount of compute resources, eliminating the need to choose instances and scale cluster capacity. Fargate runs each task or pod in its own kernel providing the tasks and pods in their own isolated compute environment (virtual machine).
- An EventBridge Event-bus resource with example pre-configured event routing rules that forms the backbone of the events driven communication architecture for the microservices.
- Private ECR repository and a corresponding IAM user for your CI pipeline to push images to

Find more about Kubernetes control plane and worker node components at [https://kubernetes.io/docs/concepts/overview/components/](https://kubernetes.io/docs/concepts/overview/components/)

### Use as a Github template / terraform module
Coming soon 📝

### Dashboard
**To deploy:**
- run `sh ./bin/core/dashboard/deploy.sh`
**Resources created:**
- The Kubernetes dashboard running on your Docker container on port 8001.
**Verify deployment**
1. Copy the token from stdout and open ‘http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login’. Paste your token for authentication when required on the dashboard.

## Plugin Deployments
### API-Gateway Ingress Controller
**To deploy:**
- run `sh ./bin/plugins/API-Gateway-Ingress-Controller/deploy.sh`
**Resources created:**
- An API deployed onto API-Gateway.
- An API-Gateway ingress controller so that traffic from the internet can be correctly routed to the microservices running inside the pod. Every service is configured as an API and is managed using AWS API-Gateway.
- An API-Gateway-VPC link - the Ingress resource routes Ingress traffic from the API Gateway to the Kubernetes cluster using a Private Network Load Balancer via API Gateway VPC Link.
**Verify deployment**
1. Open API Gateway portal on AWS Console and confirm that the APIs have been deployed
2. Explore a created API and copy it's endpoints. Poll the endpoints using Postman / Insomnia etc...

### Application Load Balancer (ALB) Ingress Controller
**To deploy:**
- run `sh ./bin/plugins/ALB-Ingress-Controller/deploy.sh`
**Resources created:**
- An AWS Application Load Balancer with the necessary rules and listeners pre-configured.
- An ALB ingress controller that allows the Kubernetes cluster to interact with and control the ALB resource.

### Kong Gateway
**To deploy:**
- run `sh ./bin/plugins/Kong-Gateway/deploy.sh`

### Fargate Profile
**To deploy:**
- run `sh ./bin/plugins/Fargate-profile/deploy.sh`

### Istio
**To deploy:**
- run `sh ./bin/plugins/Istio/deploy.sh`

## Teardown
**Note**
- Please follow these steps before destroying the infrastructure with Terraform
1. ⚠️ Delete the ingresses first. Run `kubectl get ingress -A` to list and then `kubectl delete ingress <INGRESS_NAME>` to delete the created ingresses.
2. Delete the deployments. Run `kubectl get deployments -A` to list and then `kubectl delete deployment <DEPLOYMENT_NAME>` to delete the created deployments.
3. Delete the services. Run `kubectl get svc -A` to list and then `kubectl delete svc <SERVICE_NAME>` to delete the created services.
4. Delete all deployed helm charts. Run `helm ls` to list and then `helm delete <CHART_NAME>` to delete the charts.
Verify that no ingresses, deployments, services or charts exist before running the following command ⚠️
5. Teardown the infrastructure by running `terraform destroy`

## Useful Commands
- Configure kubectl to interact with your Kubernetes cluster `aws eks update-kubeconfig --name <CLUSTER_NAME>`
- View a list of running nodes or pods - `kubectl get pods `
- Inspect a resource - `kubectl describe RESOURCE_NAME`
- Get the public endpoint of a microservice - `kubectl get ingress` to get a list of all the ingresses and then get information on the ingress using `kubectl describe ingress INGRESS_NAME`
- Create a deployment / service or an ingress - `kubectl apply -f ./CONFIGURATION`
- Destroy a deployment / service or an ingress - `kubectl delete-f ./CONFIGURATION`
- Test a microservice deployment - `kubectl port-forward DEPLOYMENT LOCALPORT:CONTAINERPORT`
- Inspect logs of a deployment - `kubectl logs RESOURCE_NAME -f`
- Follow output from kubectl - attach `-w` flag to 'watch' output
- Expand the output of kubectl - attach `-o wide` flag to get detailed output
