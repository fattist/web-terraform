resource "aws_iam_server_certificate" "fattist" {
  name = "iam-ssl-fatt-ist"
  certificate_body = "${file("./modules/aws/iam/ssl/certs/STAR_com.crt")}"
  private_key = "${file("./modules/aws/iam/ssl/certs/server.key.rsa")}"

  lifecycle {
    create_before_destroy = true
  }
}

output "fatt_ist_arn" {
  value = "${aws_iam_server_certificate.fattist.arn}"
}
