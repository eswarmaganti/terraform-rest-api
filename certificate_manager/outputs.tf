output "ssl_certificate_arn" {
  value = aws_acm_certificate.app_certificate.arn
}