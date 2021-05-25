module "eks_cluster" {
  source                             = "./modules/eks_stack"
  cluster_name                       = "${var.cluster_name}-${var.environment}"
  cluster_version                    = "1.18"
  node_group_desired_capacity        = 3
  node_group_max_capacity            = 3
  node_group_min_capacity            = 3
  instance_type                      = var.instance_type
  region                             = var.region
  environment                        = var.environment
  fargate_profile_name               = "${var.cluster_name}-microservices-fargate-profile"
  fargate_profile_selector_namespace = "${var.cluster_name}-microservices"
}
