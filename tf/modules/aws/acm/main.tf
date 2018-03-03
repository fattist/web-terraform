data "aws_acm_certificate" "fattist" {
  domain = "*.fatt.ist"
  statuses = ["ISSUED"]
}
