variable "ec2_bastion_id" {}
variable "services_subnet_id" {}

resource "aws_network_interface" "nat" {
  subnet_id   = "${var.services_subnet_id}"

  attachment {
    instance = "${var.ec2_bastion_id}"
    device_index = 1
  }
}

output "network_interface_nat_id" {
  value = "${aws_network_interface.nat.id}"
}
