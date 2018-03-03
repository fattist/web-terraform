variable "name" {}

resource "aws_ecr_repository" "repository" {
  name = "${var.name}"
}

## VARIABLES
output "name" {
  value = "${aws_ecr_repository.repository.name}"
}

output "tld" {
  value = "${replace(aws_ecr_repository.repository.repository_url, "https://", "")}"
}
