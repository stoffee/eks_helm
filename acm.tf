resource "aws_acm_certificate" "cert" {
  domain_name       = "stoffee.io"
  validation_method = "DNS"
}

data "aws_route53_zone" "zone" {
  name         = "stoffee.io."
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
  zone_id = data.aws_route53_zone.zone.zone_id
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}

#resource "aws_lb_listener" "front_end" {
  # [...]
  # refence this line below to use the cert
#  certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
#}