variable "region" {}
variable "destination_bucket_arn" {}
variable "source_bucket_arn" {}

data "template_file" "policy" {
  template = "${file("./modules/aws/iam/tpl/s3/policy.tpl")}"

  vars {
    source_bucket_arn = "${var.source_bucket_arn}"
    destination_bucket_arn = "${var.destination_bucket_arn}"
  }
}

resource "aws_iam_role" "services-s3-platform-service-iam-role" {
  name = "${format("services-s3-platform-service-iam-role-%s", "${var.region}")}"
  assume_role_policy = "${file("./modules/aws/iam/json/s3/role.json")}"
}
