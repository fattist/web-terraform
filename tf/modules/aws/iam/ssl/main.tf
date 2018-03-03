resource "aws_iam_server_certificate" "fattist" {
  name = "iam-ssl-fatt-ist"
  certificate_body = "${file("./modules/aws/iam/ssl/certs/STAR_fatt_ist.ca-bundle")}"
  private_key = "${file("./modules/aws/iam/ssl/certs/private-key.pem")}"

  lifecycle {
    create_before_destroy = true
  }
}

output "fatt_ist_arn" {
  value = "${aws_iam_server_certificate.fattist.arn}"
}
