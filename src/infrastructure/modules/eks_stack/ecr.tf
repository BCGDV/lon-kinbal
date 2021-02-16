resource "aws_ecr_repository" "microservices-ecr-repository" {
  name                 = "${var.cluster_name}-images"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
