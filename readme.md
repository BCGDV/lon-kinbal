# Kinbal

Spin up a fully managed production grade Kubernetes cluster with multiple environments on AWS with 0 hassle in 15 mins or less 🚀

## About

Deploying Kinbal will automatically create the following components into an AWS region of your choice:

- A fully managed Kubernetes control plane that includes the following fully managed components over 3 availability zones:
    - kube-apiserver
    - etcd stores
    - kube-scheduler
    - kube-controller-manager
    - cloud-controller-manager
- A semi-managed worker node group with 3 nodes running the Docker container runtime and the optimized Amazon Linux 2 AMI. The nodes are provisioned inside of an autoscaling group and the configuration will fully automate the provisioning and lifecycle management of nodes (Amazon EC2 instances) for the EKS cluster
- A Fargate profile that allows workloads and pods to be run in a serverless fashion as well as allocates the right amount of compute resources, eliminating the need to choose instances and scale cluster capacity. Fargate runs each task or pod in its own kernel providing the tasks and pods their own isolated compute environment
- 3 exemplar microservices that are built using Javascript (Node), Go and Python that are deployed using Fargate. These microservices have the following characteristics and components:
    - Health check endpoints
    - Containerised using Docker
    - Contain their own deployment configuration files that provision services, deployments and ingresses
- The Kubernetes dashboard running on your local maching on port 8001
- An Application Load Balancer (ALB) and an ALB ingress-controller so that traffic from the internet can be correctly routed to the microservices running inside the pod
- An EventBridge Event-bus resource without any pre-configured event routing rules that forms the backbone of the events driven communication architecture for the microservices

Find more about Kubernetes control plane and worker node components at [https://kubernetes.io/docs/concepts/overview/components/](https://kubernetes.io/docs/concepts/overview/components/)

## Prerequisites
1. AWS-CLI installed and configured using your credentials
2. Kubectl
3. Terraform
4. Docker

## How to Deploy
1. Clone the repo by running `git clone https://github.com/BCGDV/lon-kinbal.git`
2. Make sure you have Terraform, aws-cli, kubectl installed
3. Navigate to the working directory
4. Run `sh deploy.sh`. The script will provision the infrastructure onto your linked AWS account as well as deploy the microservices
5. To open the Kubernetes dashboard, copy the token from stdout and open 'http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login'. Paste your token for authentication when required on the dashboard.
6. Configure kubectl with the cluster name using the command `kubectl config set-context microenterprise-STAGE` where STAGE can be dev, staging or production depending on which environment you deployed using Terraform

## Verifying Deployment
1. Run `kubectl get pods -n microservices` to see all of the running pods that have been deployed into the `microservices` namespace
2. Run `kubectl get ingress -n microservices` to see all of the public addresses of the services
3. Connect to a service using cURL to verify deployment

## Notes
- AWS EKS is excluded from all free-tier discounts and you will be charged to run Kinbal
- The infrastructure can provision dev / staging / production environments but due to cost constraints the staging / production modules have been commented out

## Patterns Used

- Highly decoupled event driven microservices that communicate with each other using pub-sub based message passing via an event-bus

## Microservices

### Service 1

**Technology** - Javascript (Node)

**Architecture** - N/A (basic)

**Endpoints**
#### / (GET)

Returns informaion regarding the service

Parameters: N/A

Response 200:

```
{
    "service" : "service-1",
    "res" :: TIMESTAMP
}
```

#### /ping (GET)

Health check endpooint

Parameters: N/A

Response 200:

```
{
    "service" : "service-1",
    "res" :: "PONG"
}
```

### Service 2

**Technology** - Go

**Architecture** - N/A (basic)

**Endpoints**
#### /ping (GET)

Health check endpooint

Parameters: N/A

Response 200:

```
{
    "res" :: "PONG"
}
```

### Service 3

**Technology** - Python3

**Architecture** - N/A (basic)

**Endpoints**
#### /ping (GET)

Health check endpooint

Parameters: N/A

Response 200:

```
{
    "res" :: "PONG"
}
```

## Architecture

![Kinbal%20973f0a3ede1d4f78918c0c478b33951d/Kinbal_(1).png](https://i.imgur.com/qIRhzIu.png "Architecture")