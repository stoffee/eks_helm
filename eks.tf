data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_availability_zones" "available" {
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper = false
}



module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = local.cluster_name
  subnets      = module.vpc.private_subnets

  tags = {
    Environment = "buildly"
  }

  vpc_id          = module.vpc.vpc_id
  manage_aws_auth = true
  # write_aws_auth_config = true
  cluster_endpoint_public_access = true
  write_kubeconfig               = true
  #config_output_path = "${pathexpand("./kube_config")}/"
  config_output_path     = "./kube/config"
  cluster_delete_timeout = "2h"
  #wait_for_cluster_interpreter = ["curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && ls -lFart . && ls -lFart kube/ && ls -lFart / && /bin/linux/amd64/kubectl --kubeconfig=./kube/config apply -f eks-admin-service-account.yaml"]
  wait_for_cluster_cmd = "for i in `seq 1 60`; do wget --no-check-certificate -O - -q $ENDPOINT/healthz \u003e/dev/null \u0026\u0026 exit 0 || true; sleep 5; done; echo TIMEOUT \u0026\u0026 exit 1"

  worker_groups = [
    {
      name                          = "buildly-workergroup-1"
      instance_type                 = var.workgroup1_instance_size
      additional_userdata           = "Buildly Worker Group 1"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      asg_desired_capacity          = 1
    },
    {
      name                          = "buildly-workergroup-2"
      instance_type                 = var.workgroup2_instance_size
      additional_userdata           = "Buildly Worker Group 2"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
    },
  ]

/*
worker_groups = [
    {
      instance_type        = var.workgroup2_instance_size
      asg_max_size         = 3
      asg_desired_capacity = 3
    }
  ]
*/

  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  map_roles                            = var.map_roles
  map_users                            = var.map_users
  map_accounts                         = var.map_accounts
}

resource "aws_ecr_repository" "buildly" {
  name                 = local.cluster_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "kubernetes_namespace" "buildly" {
  metadata {
    annotations = {
      name = "buildly"
    }
    labels = {
      mylabel = "buildly"
    }
    name = "buildly"
  }
}

resource "kubernetes_cluster_role_binding" "eks-admin" {
  metadata {
    name = "eks-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "User"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "kube-system"
  }
  subject {
    kind      = "Group"
    name      = "system:eks-admin"
    api_group = "rbac.authorization.k8s.io"
  }
 # depends_on = [null_resource.delay]
}
