variable "account" {}
variable "region" {}
variable "policy_name" {}
variable "role_name" {}

data "template_file" "iam-role" {
  template = "${file("./modules/aws/iam/json/ecs/role.tpl")}"

  vars {
    account = "${var.account}"
  }
}

resource "aws_iam_role" "services-ecs-service-iam-role" {
  name = "${format("services-ecs-service-iam-role-%s", "${var.region}")}"
  assume_role_policy = "${data.template_file.iam-role.rendered}"

  lifecycle {
    ignore_changes = ["force_detach_policies"]
  }
}

resource "aws_iam_role_policy" "services-ecs-iam-policy" {
  depends_on = ["aws_iam_role.services-ecs-service-iam-role"]
  name = "${var.policy_name}"
  role = "${aws_iam_role.services-ecs-service-iam-role.name}"
  policy = "${file("./modules/aws/iam/json/ecs/policy.json")}"
}

resource "aws_iam_instance_profile" "services-ecs-platform-profile" {
  name = "${var.role_name}"
  roles = ["${aws_iam_role.services-ecs-service-iam-role.name}"]
}

## VARIABLES
output "services-ecs-service-iam-role-name" {
  value = "${aws_iam_role.services-ecs-service-iam-role.name}"
}

output "services-ecs-service-iam-profile-name" {
  value = "${aws_iam_instance_profile.services-ecs-platform-profile.name}"
}
