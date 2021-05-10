variable "cluster_name" {
  type = string
}

variable "environment" {
  default = "dev"
  type    = string
}

variable "region" {
  type = string
}

variable "instance_type" {
  default = "t3.medium"
  type    = string
}
