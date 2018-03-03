variable "environment" {}
variable "availability_zone" {}
variable "region" {}
variable "key_name" {}
variable "subnet_id" {}
variable "ecs_ami" {}
variable "ssh_security_group_id" {}
variable "redis_security_group_id" {}
variable "rds_security_group_id" {}
variable "service_security_group_id" {}
variable "smtp_security_group_id" {}
variable "cloudwatch_security_group_id" {}
variable "loggly_security_group_id" {}
variable "iam_instance_profile" {}

data "template_file" "user_data" {
  template = "${file("./modules/aws/ec2/platform/scripts/ecs.tpl")}"

  vars {
    ecs_family = "platform-${var.environment}"
  }
}

resource "aws_instance" "platform" {
  ami = "${var.ecs_ami}"
  subnet_id = "${var.subnet_id}"
  instance_type = "m3.medium"
  key_name = "${var.key_name}"
  availability_zone = "${var.availability_zone}"
  vpc_security_group_ids = [
    "${var.rds_security_group_id}",
    "${var.ssh_security_group_id}",
    "${var.service_security_group_id}",
    "${var.smtp_security_group_id}",
    "${var.cloudwatch_security_group_id}"
  ]

  iam_instance_profile = "${var.iam_instance_profile}"
  user_data = "${data.template_file.user_data.rendered}"

  associate_public_ip_address = true
  lifecycle {
    ignore_changes = [
      "associate_public_ip_address",
    ]
  }

  tags {
    Name = "${var.environment}-platform-${var.environment}"
  }
}

## VARIABLES
output "ec2-ecs-platform-id" {
  value = "${aws_instance.platform.id}"
}
