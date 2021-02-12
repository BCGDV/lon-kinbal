variable "cluster_name" {
  default = "my-cluster"
}

variable "cluster_version" {
  default = "1.18"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "region" {
  default = "us-east-1"
}

variable "node_group_desired_capacity" {
  default = 3
}

variable "node_group_max_capacity" {
  default = 3
}

variable "node_group_min_capacity" {
  default = 3
}

variable "fargate_profile_name" {
  default = "microservices"
}

variable "fargate_profile_selector_namespace" {
  default = "microservices"
}