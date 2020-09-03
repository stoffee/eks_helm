#
# Provider Configuration
#

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
  version    = ">= 2.60.0"
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11.1"
}

provider "kubernetes" {
  alias = "eks"
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

resource "local_file" "eks_admin" {
  # HACK: depends_on for the helm provider
  # Passing provider configuration value via a local_file
  content  = <<-EKSADMIN
  "apiVersion: v1]
kind: ServiceAccount
metadata:
  name: eks-admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: eks-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: eks-admin
  namespace: kube-system
"
  EKSADMIN
  filename = "eks-admin-service-account.yaml"
}

provider "helm" {
  version = "~> 1.1.1"
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    load_config_file       = false
  }
  # kubernetes {
  #   config_path = "./kube_config"
  # }
}

provider "random" {
  version = "~> 2.2.1"
}

provider "local" {
  version = "~> 1.4.0"
}

provider "null" {
  version = "~> 2.1.2"
}

provider "template" {
  version = "~> 2.1.2"
}

provider "http" {}

provider "acme" {
  server_url = var.acme_server_url
}

locals {
  cluster_name = "buildly-${random_string.suffix.result}"
}