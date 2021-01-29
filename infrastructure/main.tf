module "eks_cluster_dev" {
  source                             = "./modules/eks"
  cluster_name                       = "microenterprise-dev"
  cluster_version                    = "1.18"
  node_group_desired_capacity        = 3
  node_group_max_capacity            = 3
  node_group_min_capacity            = 3
  instance_type                      = "t2.micro"
  region                             = "us-east-1"
  fargate_profile_name               = "microservices-fargate-profile"
  fargate_profile_selector_namespace = "microservices"
  database_instance_allocated_storage = 20
  database_instance_storage_type = "gp2"
  database_instance_engine = "postgres"
  database_instance_class = "db.t2.micro"
  database_name = "microenterprise-dev-db"
  database_username = "adsrewdgerwq3EFW9G*HEO" # use secrets manager for this
  database_password = "qp73rcn37nw89qmw8erw" # use secrets manager for this
}

# module "eks_cluster_staging" {
#   source                             = "./modules/eks"
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
#   source                             = "./modules/eks"
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