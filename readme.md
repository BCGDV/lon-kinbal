# Kinbal

Spin up a fully managed Kubernetes cluster on AWS with 0 hassle in 15 mins or less 🚀

## About

Deploying Kinbal will automatically create the following components into an AWS region of your choice:

- A fully managed Kubernetes control plane that includes the following fully managed components over 3 availability zones:
    - kube-apiserver
    - etcd stores
    - kube-scheduler
    - kube-controller-manager
    - cloud-controller-manager

Find more about Kubernetes control plane components at [https://kubernetes.io/docs/concepts/overview/components/](https://kubernetes.io/docs/concepts/overview/components/)

- A semi-managed worker node group with 3 nodes running the Docker container runtime and the optimized Amazon Linux 2 AMI. The nodes are provisioned inside of an autoscaling group and the configuration will fully automate the provisioning and lifecycle management of nodes (Amazon EC2 instances) for the EKS cluster
- A Fargate profile that allows workloads and pods to be run in a serverless fashion as well as allocates the right amount of compute resources, eliminating the need to choose instances and scale cluster capacity. Fargate runs each task or pod in its own kernel providing the tasks and pods their own isolated compute environment
- 3 exemplar microservices that are built using Javascript (Node), Go and Python that are deployed using Fargate. These microservices have the following characteristics and components:
    - Health check endpoints
    - Containerised using Docker
    - Contain their own deployment configuration files that provision services, deployments and ingresses
- An Application Load Balancer (ALB) and an ALB ingress-controller so that traffic from the internet can be correctly routed to the microservices running inside the pod
- An EventBridge Event-bus resource without any pre-configured event routing rules that forms the backbone of the events driven communication architecture for the microservices

## Patterns Used

- Highly decoupled event driven microservices that communicate with each other using pub-sub based message passing via an event-bus

## Microservices

### Service 1

**Technology** - Javascript (Node)

**Architecture** - N/A (basic)

**Endpoints**

## Architecture

![Kinbal%20973f0a3ede1d4f78918c0c478b33951d/Kinbal_(1).png](https://i.imgur.com/qIRhzIu.png "Architecture")