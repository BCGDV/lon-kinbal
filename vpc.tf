# Creates a VPC for the cluster with an opinionated network architecture
module "vpc" {
  source = "git::ssh://git@github.com/reactiveops/terraform-vpc.git?ref=v5.0.1"

  aws_region = "us-east-1"
  az_count   = 3
  aws_azs    = "us-east-1a, us-east-1b, us-east-1c"

  global_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}
