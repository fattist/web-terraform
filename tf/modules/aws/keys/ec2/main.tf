variable "key_path" {}
variable "key_name" {
  default = "platform-ec2-key"
}

resource "aws_key_pair" "platform-ec2-key" {
  key_name = "${var.key_name}"
  public_key = "${file(var.key_path)}"
}

## VARIABLES
output "platform-ec2-key-name" {
  value = "${aws_key_pair.platform-ec2-key.key_name}"
}
