variable "aws_access_key" {
  description = "access key"
}

variable "aws_secret_key" {
  description = "secret key"
}

variable "aws_region" {
  default = "us-west-2"
}

variable "workstation-external-cidr" {
  description = "The cider block of your remote workstation that will conenct to the EKS cluster. By default this is an ALLOW ALL INBOUND Rule 0.0.0.0/0"
  default     = "0.0.0.0/0"
}

variable "route53_domain" {
  default = "buildly.io"
}

variable "route53_frontend_host" {
  default = "tp-dev"
}

variable "workgroup1_instance_size" {
  default = "t2.small"
}

variable "workgroup2_instance_size" {
  default = "t2.small"
}

variable "db_password" {
  default = "buildly123!"
  type    = string
}

variable "db_username" {
  default = "buildlyadmin"
  type    = string
}

variable "db_name" {
  default = "buildlydb"
  type    = string
}

variable "db_instance_class" {
  default = "db.t3.small"
  type    = string
}

variable "namespace" {
  default = "buildly"
}

variable "replicas" {
  default = "3"
}

variable "acme_server_url" {
  default = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "email_address" {
  description = "Email addressed used for Let's Encrypt!"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "777777777777",
    "888888888888",
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
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

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
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
