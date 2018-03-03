variable "id" {}
variable "subnet" {}
variable "efs_security_group_id" {}

resource "aws_efs_mount_target" "mount" {
  file_system_id = "${var.id}"
  subnet_id = "${var.subnet}"
  security_groups = ["${var.efs_security_group_id}"]
}

## VARIABLES
output "services-efs-mount-dns" {
  value = "${aws_efs_mount_target.mount.dns_name}"
}
