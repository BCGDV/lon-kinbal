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

variable "database_instance_allocated_storage" {
  default = 20
}

variable "database_instance_storage_type" {
  default = "gp2"
}

variable "database_instance_engine" {
  default = "postgres"
}

variable "database_instance_class" {
  default = "db.t2.micro"
}

variable "database_name" {
  default = "microenterprise-db"
}

variable "database_username" {
  default = ""
}

variable "database_password" {
  default = ""
}
