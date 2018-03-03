variable "region" {}
variable "availability_zone" {}
variable "cloudwatch_group_name" {}
variable "ecs_elb_id" {}
variable "ecs_iam_role_name" {}
variable "environment" {}
variable "failover_zone" {}
variable "instance_cpu" {}
variable "instance_memory" {}
variable "services" {
  type = "list"
  default = [
    "platform"
  ]
}

data "aws_ecs_task_definition" "platform" {
  count = 1
  depends_on = ["aws_ecs_task_definition.platform"]
  task_definition = "${element(aws_ecs_task_definition.platform.*.family, count.index)}"
}

data "template_file" "task_definition" {
  template = "${file("./modules/aws/ecs/platform/tpl/task_definition.tpl")}"

  vars {
    region = "${var.region}"
    cloudwatch_group_name = "${var.cloudwatch_group_name}"
    cpu = "${format("%d", 1 * 1024)}"
    environment = "${var.environment}"
    memory = "6510"
  }
}

resource "aws_ecs_cluster" "platform" {
  count = 1
  name = "${element(var.services, count.index)}-${var.environment}"
}

resource "aws_ecs_task_definition" "platform" {
  count = 1
  family = "${element(var.services, count.index)}-${var.environment}"
  container_definitions = "${data.template_file.task_definition.rendered}"

  volume {
    name = "platform-data",
    host_path = "/mnt/ebs"
  }

  placement_constraints {
    type = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.availability_zone}, ${var.failover_zone}]"
  }
}

resource "aws_ecs_service" "platform" {
  count = 1
  depends_on = ["aws_ecs_task_definition.platform", "data.aws_ecs_task_definition.platform"]

  name = "${element(var.services, count.index)}-${var.environment}"
  iam_role = "${var.ecs_iam_role_name}"
  cluster = "${element(aws_ecs_cluster.platform.*.id, count.index)}"
  task_definition = "${element(aws_ecs_task_definition.platform.*.family, count.index)}:${max("${element(aws_ecs_task_definition.platform.*.revision, count.index)}", "${element(data.aws_ecs_task_definition.platform.*.revision, count.index)}")}"
  desired_count = 1

  load_balancer {
    elb_name = "${var.ecs_elb_id}"
    container_name = "platform"
    container_port = 3000
  }

  placement_constraints {
    type = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.availability_zone}]"
  }
}
