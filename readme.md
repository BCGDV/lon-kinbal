# Kinbal

Automatically deploy a production-grade Kubernetes cluster on AWS with 0 hassle in 30 mins or less. 🚀

## About

Deploying Kinbal will create the following resources into a specified AWS region:

- A fully managed Kubernetes control plane running on EKS that includes the following fully managed components over 3 availability zones:
    - kube-apiserver
    - etcd stores
    - kube-scheduler
    - kube-controller-manager
    - cloud-controller-manager
- A semi-managed worker node group with 3 nodes (Amazon EC2 instances) running the Docker container runtime and the optimized Amazon Linux 2 AMI. These nodes are provisioned inside of an autoscaling group and the configuration will fully automate the provisioning and lifecycle management of nodes for the EKS cluster.
- A Fargate profile that allows workloads and pods to be run in a serverless fashion. Fargate allocates the right amount of compute resources, eliminating the need to choose instances and scale cluster capacity. Fargate runs each task or pod in its own kernel providing the tasks and pods in their own isolated compute environment (virtual machine).
- 3 exemplar microservices that are built using Javascript (Node), Go and Python that are deployed onto the worker nodes. These microservices have the following characteristics and components:
    - Health check endpoints
    - Example persistence layer interactions
    - Example events layer interactions
    - Containerised using Docker
    - Contain their own deployment configuration files that provision services, deployments and ingresses
- A persistence layer - PostgreSQL databases that are coupled with the services.
- The Kubernetes dashboard running on your local machine on port 8001.
- An API-Gateway ingress controller so that traffic from the internet can be correctly routed to the microservices running inside the pod. Every service is configured as an API and is managed using AWS API-Gateway.
- An API-Gateway VPC link - the Ingress resource routes Ingress traffic from the API Gateway to the Kubernetes cluster using a Private Network Load Balancer via API Gateway VPC Link.
- An EventBridge Event-bus resource with example pre-configured event routing rules that forms the backbone of the events driven communication architecture for the microservices.

Find more about Kubernetes control plane and worker node components at [https://kubernetes.io/docs/concepts/overview/components/](https://kubernetes.io/docs/concepts/overview/components/)

## Prerequisites

1. AWS-CLI installed and configured using your credentials
2. Kubectl
3. Terraform
4. Docker

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

## Important Notes

- You can edit / add / remove the microservices - and for local code changes to propagate to the cluster, you will need to:
    - Rebuild the image e.g. `docker build -t ppanchal97/service1 .`
    - Push the image up to Docker Hub e.g. `docker push ppanchal97/service1`
- You can add / remove routes - and to propagate the changes to the API gateway and the cluster, you will need to redeploy the ingress:
    - Get the list of ingresses using `kubctl get ingress`
    - Delete the ingress using `kubctl delete ingress INGRESS_NAME`
    - Redeploy the ingress using `kubctl apply -f ./api_ingress` . The ingress deployment should take ~15 minutes. You can check the progress by looking at the logs of the ingress controller pod.
- AWS EKS is excluded from all free-tier discounts and you will be charged to run Kinbal.
- The infrastructure can provision dev / staging / production environments but due to cost constraints, the staging / production modules have been commented out.

## Microservices

### Service 1

**Technology** - Javascript (Node)

**Architecture** - N/A (basic)

**Endpoints** 

- **/service/info (GET)**

Functionality: Returns information regarding the service.

Parameters: N/A.

Response 200:

```
{
    "service" : "service-1",
    "res" :: TIMESTAMP
}
```

- **/ping (GET)**

Functionality: Health check endpoint

Parameters: N/A.

Response 200:

```
{
    "service" : "service-1",
    "res" :: "PONG"
}
```

- **/orders/get (GET)**

Functionality: Demonstrates persistence layer functionality by connecting to the microservice database and fetching list of orders.

Parameters: N/A.

Response 200:

```
{
    "orders" : ORDERS
}
```

- **/orders/create (POST)**

Functionality: Demonstrates persistence functionality by connecting to the microservice database and creating a new order. Demonstrates events layer functionality by firing off order created event into event-bus.

Parameters: N/A.

Body: 

```
{
    "item": "Pork Pies",
    "quantity": 1,
    "userid": "fq3dq3t-x3T4QVB-qcr4t3byec-5y3tc4w"
}
```

Response 200:

```
{
    "res" :: ORDER
}
```

### Service 2

**Technology** - Go

**Architecture** - N/A (basic)

**Endpoints**

- **/ping (GET)**

Functionality: Health check endpoint 

Parameters: N/A

Response 200:

```
{
    "res" :: "PONG"
}
```

- **/service/info (GET)**

Functionality: Returns information regarding the service.

Parameters: N/A.

Response 200:

```
{
    "service" : "service-2",
    "res" :: TIMESTAMP
}
```

### Service 3

**Technology** - Flask (Python)

**Architecture** - N/A (basic)

**Endpoints** 

- **/ping (GET)**

Functionality: Health check endpoint 

Parameters: N/A

Response 200:

```
{
    "service": 'service-3',
    "res": 'PONG'
}
```

- **/service/info (GET)**

Functionality: Returns information regarding the service.

Parameters: N/A.

Response 200:

```
{
    "service" : "service-3",
    "res" :: TIMESTAMP
}
```

## Architecture
![Kinbal%20973f0a3ede1d4f78918c0c478b33951d/Kinbal_(1).png](https://d2908q01vomqb2.cloudfront.net/fe2ef495a1152561572949784c16bf23abb28057/2020/02/20/api_ingress_controller_overview.png "Architecture")

## Explanation
- The API Gateway Ingress Controller watches for Ingress events from the API server. When it finds Ingress resources that satisfy its requirements, it begins the creation of AWS resources.
- API Gateway API is created, and the specified API Gateway stages outlined in Ingress annotations are created.
- A Private Network Load Balancer is created for the Ingress resource, and Listeners are created for every port specified in paths configuration.
- For the API Gateway to communicate to the Private Network Load Balancer, a Private API Gateway VPC Link is created.
- A TargetGroup is created for the reverse proxies specified in the Ingress resource.
- The API Gateway Ingress Controller deploys NGINX as the reverse proxy, and the reverse proxy Rules are created for each path specified in the Ingress resource. This ensures that traffic to a specific path is routed to the correct pod.

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