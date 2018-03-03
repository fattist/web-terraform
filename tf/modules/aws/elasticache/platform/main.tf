variable "environment" {}
variable "node_type" {}
variable "subnet_group_name" {}
variable "security_group_id" {}
variable "nodes" {
  type = "map"
  default = {
    "platform" = 1
  }
}

resource "aws_elasticache_cluster" "elasticache" {
  count = 1
  cluster_id = "platform-${var.environment}"
  engine = "redis"
  node_type = "${var.node_type}"
  num_cache_nodes = "${lookup(var.nodes, "platform")}"
  parameter_group_name = "default.redis3.2"
  port = 6379
  subnet_group_name = "${var.subnet_group_name}"
  security_group_ids = ["${var.security_group_id}"]
}
