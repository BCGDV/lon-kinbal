# Kinbal

Deploy a production-grade EKS cluster on AWS in 15 mins or less. 🚀🐳

## Important Notes

- You must deploy the core EKS cluster by executing `/bin/core/eks.sh` first before adding the plugins.
- You can edit / add / remove the microservices as you wish. For local code changes to propagate to the cluster, you will need to:
    - Rebuild the image e.g. `docker build -t ppanchal97/service1 .`
    - Push the image up to Docker Hub e.g. `docker push ppanchal97/service1`
- If you are using the API-Gateway ingress controller you can add / remove routes - and to propagate the changes to the API gateway and the cluster, you will need to redeploy the ingress:
    - Get the list of ingresses using `kubctl get ingress`
    - Delete the ingress using `kubctl delete ingress INGRESS_NAME`
    - Redeploy the ingress using `kubctl apply -f ./api_ingress` . The ingress deployment should take ~15 minutes. You can check the progress by looking at the logs of the ingress controller pod.
- AWS EKS is excluded from all free-tier discounts and you will be charged to run Kinbal.
- The infrastructure can provision dev / staging / production environments but due to cost constraints, the staging / production modules have been commented out.

## Prerequisites
1. Docker

## Getting Started
- Run the project using Docker by executing the following command `docker run -it --entrypoint /bin/sh ppanchal97/kinbal`
    - The `-it` instructs Docker to allocate a pseudo-TTY connected to the container’s stdin; creating an interactive bash shell in the container
    - The `--entrypoint` overwrites the default ENTRYPOINT of the image and opens shell when the container boots up.
- Once the container boots up, add your credentials to the AWS CLI by executing `aws configure`.
- If you already have a cluster deployed or want to configure kubectl with your newly created cluster - run `aws eks update-kubeconfig --name <CLUSTER_NAME>`

## Core Deployments
### EKS Cluster
The following resources will be created:
- A fully managed Control Plane
- A semi-managed worker node group with 3 EC2 nodes running the Docker runtime and the optimized Amazon Linux 2 AMI. These nodes are provisioned inside of an autoscaling group and the configuration will fully automate the provisioning and lifecycle management of nodes for the EKS cluster.
- A Fargate profile that allows workloads and pods to be run in a serverless fashion. Fargate allocates the right amount of compute resources, eliminating the need to choose instances and scale cluster capacity. Fargate runs each task or pod in its own kernel providing the tasks and pods in their own isolated compute environment (virtual machine).
- An EventBridge Event-bus resource with example pre-configured event routing rules that forms the backbone of the events driven communication architecture for the microservices.

Find more about Kubernetes control plane and worker node components at [https://kubernetes.io/docs/concepts/overview/components/](https://kubernetes.io/docs/concepts/overview/components/)

### Dashboard
- The Kubernetes dashboard running on your Docker container on port 8001.

## Plugin Deployments
### Application Load Balancer (ALB) Ingress Controller

### API-Gateway Ingress Controller

### Kong Gateway

### Fargate Profile

### Istio

- An API-Gateway ingress controller so that traffic from the internet can be correctly routed to the microservices running inside the pod. Every service is configured as an API and is managed using AWS API-Gateway.

- An API-Gateway VPC link - the Ingress resource routes Ingress traffic from the API Gateway to the Kubernetes cluster using a Private Network Load Balancer via API Gateway VPC Link.

## How to Deploy

1. Clone the repo by running `git clone https://github.com/BCGDV/lon-kinbal.git`
2. Make sure you have the prerequisites installed and configured
3. `cd` to the working directory
4. Run `sh deploy.sh`. The script will provision the infrastructure onto your linked AWS account as well as deploy the microservices
5. To open the Kubernetes dashboard, copy the token from stdout and open ‘http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login’. Paste your token for authentication when required on the dashboard.
6. Configure kubectl with the cluster name using the command `kubectl config set-context microenterprise-STAGE` where STAGE can be dev, staging or production depending on which environment you deployed using Terraform

## Verifying Deployment

1. Run `kubectl get pods` to see all of the running pods that have been deployed
2. Run `kubectl get ingress` to see all of the public addresses of the services
3. Connect to a service using cURL to verify deployment

## Teardown
1. Delete the ingresses ⚠️
2. Delete the deployments and services
3. `terraform destroy`
4. `helm ls` and then `helm delete <CHART_NAME>` for all charts that were deployed

## Useful Commands

- View a list of running nodes or pods - `kubectl get pods `
- Inspect a resource - `kubectl describe RESOURCE_NAME`
- Get the public endpoint of a microservice - `kubectl get ingress` to get a list of all the ingresses and then get information on the ingress using `kubectl describe ingress INGRESS_NAME`
- Create a deployment / service or an ingress - `kubectl apply -f ./CONFIGURATION`
- Destroy a deployment / service or an ingress - `kubectl delete-f ./CONFIGURATION`
- Test a microservice deployment - `kubectl port-forward DEPLOYMENT LOCALPORT:CONTAINERPORT`
- Inspect logs of a deployment - `kubectl logs RESOURCE_NAME -f`
- Follow output from kubectl - attach `-w` flag to 'watch' output
- Expand the output of kubectl - attach `-o wide` flag to get detailed output