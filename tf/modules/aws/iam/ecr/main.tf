variable "name" {}

resource "aws_ecr_repository_policy" "org-ecr" {
  repository = "${var.name}"
  policy = "${file("./modules/aws/iam/json/ecr/policy.json")}"
}

## VARIABLES

output "name" {
  value = "${aws_ecr_repository_policy.org-ecr.repository}"
}
