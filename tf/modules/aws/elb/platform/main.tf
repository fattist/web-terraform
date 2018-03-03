variable "services_alb_id" {}
variable "services_subnet_id" {}
variable "internal_subnet_id" {}

resource "aws_elb" "platform" {
  name = "ecs-platform-elb"
  security_groups = ["${var.services_alb_id}"]
  subnets = ["${var.services_subnet_id}"]

  listener {
    instance_port = 3000
    instance_protocol = "tcp"
    lb_port = 80
    lb_protocol = "tcp"
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  /*access_logs {
    bucket = "fattist-operations-logging"
    bucket_prefix = "ecs-platform-elb"
    interval = 5
  }*/

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 10
    timeout = 5
    target = "TCP:22"
    interval = 30
  }

  tags {
    Name = "ecs-platform-elb"
  }
}

## VARIABLES
output "id" {
  value = "${aws_elb.platform.id}"
}
