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
**To deploy:**
- run `sh /bin/core/EKS/deploy.sh`
**Resources created:**
- A fully managed Control Plane
- A semi-managed worker node group with 3 EC2 nodes running the Docker runtime and the optimized Amazon Linux 2 AMI. These nodes are provisioned inside of an autoscaling group and the configuration will fully automate the provisioning and lifecycle management of nodes for the EKS cluster.
- A Fargate profile that allows workloads and pods to be run in a serverless fashion. Fargate allocates the right amount of compute resources, eliminating the need to choose instances and scale cluster capacity. Fargate runs each task or pod in its own kernel providing the tasks and pods in their own isolated compute environment (virtual machine).
- An EventBridge Event-bus resource with example pre-configured event routing rules that forms the backbone of the events driven communication architecture for the microservices.

Find more about Kubernetes control plane and worker node components at [https://kubernetes.io/docs/concepts/overview/components/](https://kubernetes.io/docs/concepts/overview/components/)

**Verify deployment**
1. Run `kubectl get pods -A` to see all of the running pods that have been deployed
2. Run `kubectl get ingress` to see all of the public addresses of the services

### Dashboard
**To deploy:**
- run `sh /bin/core/dashboard/deploy.sh`
**Resources created:**
- The Kubernetes dashboard running on your Docker container on port 8001.
**Verify deployment**
1. Copy the token from stdout and open ‘http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login’. Paste your token for authentication when required on the dashboard.

## Plugin Deployments
### Application Load Balancer (ALB) Ingress Controller
**To deploy:**
- run `sh /bin/core/plugins/ALB-Ingress-Controller/deploy.sh`
**Resources created:**
- An AWS Application Load Balancer with the necessary rules and listeners pre-configured.
- An ALB ingress controller that allows the Kubernetes cluster to interact with and control the ALB resource.

### API-Gateway Ingress Controller
**To deploy:**
- run `sh /bin/core/plugins/API-Gateway-Ingress-Controller/deploy.sh`
**Resources created:**
- An API deployed onto API-Gateway.
- An API-Gateway ingress controller so that traffic from the internet can be correctly routed to the microservices running inside the pod. Every service is configured as an API and is managed using AWS API-Gateway.
- An API-Gateway-VPC link - the Ingress resource routes Ingress traffic from the API Gateway to the Kubernetes cluster using a Private Network Load Balancer via API Gateway VPC Link.
**Verify deployment**
1. Open API Gateway portal on AWS Console and confirm that the APIs have been deployed
2. Explore a created API and copy it's endpoints. Poll the endpoints using Postman / Insomnia etc...

### Kong Gateway
**To deploy:**
- run `sh /bin/core/plugins/Kong-Gateway/deploy.sh`

### Fargate Profile
**To deploy:**
- run `sh /bin/core/plugins/Fargate-profile/deploy.sh`

### Istio
**To deploy:**
- run `sh /bin/core/plugins/Istio/deploy.sh`

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