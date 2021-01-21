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
      desired_capacity = 3
      max_capacity     = 3
      min_capaicty     = 3

      instance_type = "t2.small"
    }
  }
  manage_aws_auth             = false
  workers_additional_policies = [aws_iam_policy.worker_policy.arn]
}

# Fargate Profile
resource "aws_eks_fargate_profile" "aws_eks_fargate_profile1" {

  depends_on = [module.eks]

  cluster_name           = var.cluster_name
  fargate_profile_name   = "microservices"
  pod_execution_role_arn = aws_iam_role.iam_role_fargate.arn
  subnet_ids             = module.vpc.private_subnets
  selector {
    namespace = "microservices"
  }
}

# IAM Role for the Fargate profile
resource "aws_iam_role" "iam_role_fargate" {
  name = "eks-fargate-profile-example"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# Attach a managed IAM Policy to an IAM role
resource "aws_iam_role_policy_attachment" "example-AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.iam_role_fargate.name
}

resource "aws_iam_policy" "worker_policy" {
  name        = "${var.cluster_name}-worker-policy"
  description = "Worker policy for the ALB Ingress"

  policy = file("iam-policy.json")
}
