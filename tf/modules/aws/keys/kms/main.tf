resource "aws_kms_key" "platform-kms-key" {
  description = "platform-kms-key default"
}

output "platform-aws-kms-arn" {
  value = "${aws_kms_key.platform-kms-key.arn}"
}
