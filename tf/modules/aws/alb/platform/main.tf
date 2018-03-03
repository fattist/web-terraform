variable "services_vpc_id" {}
variable "services_subnet_id" {}
variable "internal_subnet_id" {}
variable "services_alb_id" {}

resource "aws_alb_target_group" "platform" {
  name = "alb-ecs-platform-group"
  port = 3000
  protocol = "TCP"
  vpc_id = "${var.services_vpc_id}"
}

resource "aws_alb" "platform" {
  name = "alb-ecs-platform"
  subnets = ["${var.services_subnet_id}", "${var.internal_subnet_id}"]
  security_groups = ["${var.services_alb_id}"]
}

resource "aws_alb_listener" "platform" {
  load_balancer_arn = "${aws_alb.platform.arn}"
  port = "80"
  protocol = "TCP"

  default_action {
    target_group_arn = "${aws_alb_target_group.platform.id}"
    type = "forward"
  }
}

## VARIABLES
output "arn" {
  value = "${aws_alb_target_group.platform.arn}"
}

output "dns" {
  value = "${aws_alb.platform.dns_name}"
}
