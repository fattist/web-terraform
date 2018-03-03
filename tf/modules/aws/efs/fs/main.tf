variable "name" {}

resource "aws_efs_file_system" "fs" {
  creation_token = "${var.name}"

  tags {
    Name = "${var.name}"
  }
}

## VARIABLES
output "services-efs-service-id" {
  value = "${aws_efs_file_system.fs.id}"
}
