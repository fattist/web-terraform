variable "environment" {}
variable "availability_zone" {}
variable "region" {}
variable "key_name" {}
variable "subnet_id" {}
variable "rds_security_group_id" {}
variable "redis_security_group_id" {}
variable "ssh_security_group_id" {}
variable "service_security_group_id" {}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "bastion" {
  ami = "${data.aws_ami.ubuntu.id}"
  availability_zone = "${var.availability_zone}"
  disable_api_termination = false
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.rds_security_group_id}", "${var.ssh_security_group_id}", "${var.service_security_group_id}", "${var.redis_security_group_id}"]
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true

  root_block_device {
    volume_size = 32
    delete_on_termination = false
  }

  lifecycle {
    ignore_changes = ["ami"]
  }

  tags {
    Name = "${var.environment}-bastion"
  }
}

output "instance_id" {
  value = "${aws_instance.bastion.id}"
}
