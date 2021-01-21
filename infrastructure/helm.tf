provider "helm" {
  version = "1.3.1"
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    load_config_file       = false
  }
}

resource "helm_release" "ingress" {
  name       = "ingress"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  values = [<<EOF
  clusterName: ${var.cluster_name}
  region: ${var.region}
  namespace: "microservices"
  vpcId: ${module.vpc.aws_vpc_id}
  hostNetwork: true
  EOF
  ]

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
}
