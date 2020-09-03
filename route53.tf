data "aws_route53_zone" "hosted_zone" {
  name = var.route53_domain
}
resource "aws_route53_record" "www" {
  # Using the data entry above to retrieve the domain
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "${var.route53_frontend_host}.${var.route53_domain}"
  type    = "CNAME"
  ttl     = "300"
  # The record will be the value of the endpoint URL of the EKS cluster
 # records = ["${module.nlb.this_lb_dns_name}"]
 # records = ["${module.alb-ingress-controller.aws_iam_role_arn}"]
  records = ["${module.eks.cluster_endpoint}"]
}

resource "aws_route53_record" "www-api" {
  # Using the data entry above to retrieve the domain
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "${var.route53_frontend_host}-api.${var.route53_domain}"
  type    = "CNAME"
  ttl     = "300"
  # The record will be the value of the endpoint URL of the EKS cluster
  records = ["${module.eks.cluster_endpoint}"]
}
