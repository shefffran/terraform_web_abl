resource "aws_acm_certificate" "ssl_cert" {
  domain_name = "www.shefffran.click"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "SSL certification for www.shefffran.com"
  }
}

resource "aws_route53_record" "cert_dns" {
  allow_overwrite = true
  name =  tolist(aws_acm_certificate.ssl_cert.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.ssl_cert.domain_validation_options)[0].resource_record_value]
  type = tolist(aws_acm_certificate.ssl_cert.domain_validation_options)[0].resource_record_type
  zone_id = "Z06165763RPN23YUK73H4"
  ttl = 60
}

resource "aws_acm_certificate_validation" "cert_validate" {
  certificate_arn = aws_acm_certificate.ssl_cert.arn
  validation_record_fqdns = [aws_route53_record.cert_dns.fqdn]
}

output "certification_arn" {
  value = aws_acm_certificate_validation.cert_validate.certificate_arn
}