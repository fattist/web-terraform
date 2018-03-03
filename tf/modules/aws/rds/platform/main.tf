variable "availability_zone" {}
variable "db_name" {}
variable "db_password" {}
variable "db_username" {}
variable "environment" {}
variable "subnet_rds_name" {}
variable "monitoring_role_arn" {}
variable "security_group_id" {}
variable "kms_key_arn" {}

resource "aws_db_instance" "platform-master" {
  allocated_storage = 100
  engine = "mysql"
  engine_version = "5.7.19"
  port = 5432
  identifier = "platform-master"
  instance_class = "db.m4.large"
  storage_encrypted = true
  storage_type = "io1"
  kms_key_id = "${var.kms_key_arn}"
  final_snapshot_identifier = "platform-encrypted-master"
  copy_tags_to_snapshot = true
  name = "${var.db_name}"
  password = "${var.db_password}"
  username = "${var.db_username}"
  availability_zone = "${var.availability_zone}"
  multi_az = false
  backup_retention_period = 7
  backup_window = "03:00-06:00"
  maintenance_window = "Sun:00:00-Sun:03:00"
  iops = 1000
  publicly_accessible = false

  db_subnet_group_name = "${var.subnet_rds_name}"
  vpc_security_group_ids = ["${var.security_group_id}"]
  monitoring_role_arn = "${var.monitoring_role_arn}"
  monitoring_interval = 15

  lifecycle {
    prevent_destroy = true
    ignore_changes = ["password"]
  }
}
