variable "region" {}

resource "aws_iam_role" "services-rds-service-iam-role" {
  name = "${format("services-rds-service-iam-role-%s", "${var.region}")}"
  assume_role_policy = "${file("./modules/aws/iam/json/rds/role.json")}"

  lifecycle {
    ignore_changes = ["force_detach_policies"]
  }
}

resource "aws_iam_role_policy" "services-rds-iam-policy" {
  depends_on = ["aws_iam_role.services-rds-service-iam-role"]
  name = "enhanced-monitoring-attachment-rds"
  role = "${aws_iam_role.services-rds-service-iam-role.name}"
  policy = "${file("./modules/aws/iam/json/rds/policy.json")}"
}

output "services-rds-service-iam-role-arn" {
  value = "${aws_iam_role.services-rds-service-iam-role.arn}"
}
