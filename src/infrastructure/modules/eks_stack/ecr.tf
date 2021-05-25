resource "aws_ecr_repository" "microservices_ecr_repository" {
  name                 = "${var.cluster_name}-images"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
