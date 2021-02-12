provider "aws" {
  region = var.region
}

# Expose important cluster attributes
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_availability_zones" "available" {
}

# Creates the managed control plane
module "eks" {
  source          = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=v12.2.0"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets

  # The Node groups - for static EC2 instances
  node_groups = {
    eks_nodes = {
      desired_capacity = var.node_group_desired_capacity
      max_capacity     = var.node_group_max_capacity
      min_capaicty     = var.node_group_min_capacity

      instance_type = var.instance_type
    }
  }
  manage_aws_auth             = false
  workers_additional_policies = [aws_iam_policy.worker_policy.arn]
}

# Fargate Profile
resource "aws_eks_fargate_profile" "aws_eks_fargate_profile1" {

  depends_on = [module.eks]

  cluster_name           = var.cluster_name
  fargate_profile_name   = var.fargate_profile_name
  pod_execution_role_arn = aws_iam_role.iam_role_fargate.arn
  subnet_ids             = module.vpc.private_subnets
  selector {
    namespace = var.fargate_profile_selector_namespace
  }
}
