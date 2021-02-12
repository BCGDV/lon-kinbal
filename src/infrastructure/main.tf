module "eks_cluster_dev" {
  source                             = "./modules/eks_stack"
  cluster_name                       = "microenterprise-dev"
  cluster_version                    = "1.18"
  node_group_desired_capacity        = 3
  node_group_max_capacity            = 3
  node_group_min_capacity            = 3
  instance_type                      = "m5.large"
  region                             = "us-east-1"
  fargate_profile_name               = "microservices-fargate-profile"
  fargate_profile_selector_namespace = "microservices"
}

# module "eks_cluster_staging" {
#   source                             = "./modules/eks_stack"
#   cluster_name                       = "microenterprise-staging"
#   cluster_version                    = "1.18"
#   node_group_desired_capacity        = 3
#   node_group_max_capacity            = 3
#   node_group_min_capacity            = 3
#   instance_type                      = "t2.micro"
#   region                             = "us-east-1"
#   fargate_profile_name               = "microservices-fargate-profile"
#   fargate_profile_selector_namespace = "microservices"
# }

# module "eks_cluster_production" {
#   source                             = "./modules/eks_stack"
#   cluster_name                       = "microenterprise-production"
#   cluster_version                    = "1.18"
#   node_group_desired_capacity        = 3
#   node_group_max_capacity            = 3
#   node_group_min_capacity            = 3
#   instance_type                      = "t2.micro"
#   region                             = "us-east-1"
#   fargate_profile_name               = "microservices-fargate-profile"
#   fargate_profile_selector_namespace = "microservices"
# }