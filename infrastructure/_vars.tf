# REQUIRED - CUSTOMIZABLE
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "specifies the region for deployment"
}

# REQUIRED - CUSTOMIZABLE
variable "account_id" {
  type        = string
  default     = "212285161954"
  description = "specifies the unique AWS account number for deployment"
}

# REQUIRED - CUSTOMIZABLE
variable "cluster_name" {
  default     = "microenterprise"
  description = "specifies the unique eks cluster name"
}

# REQUIRED - CUSTOMIZABLE
variable "cluster_version" {
  default     = "1.18"
  description = "specifies the eks k8s cluster version"
}

# OPTIONAL - EXTENDABLE
variable "map_accounts" {
  description = "Specifies additional AWS account numbers to add to the aws-auth configmap"
  type        = list(string)

  default = [
    "111111111111",
    "222222222222",
  ]

}
# OPTIONAL - EXTENDABLE
variable "map_roles" {
  description = "Specifies additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
}

# OPTIONAL - EXTENDABLE
variable "map_users" {
  description = "Specifies additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]
}
