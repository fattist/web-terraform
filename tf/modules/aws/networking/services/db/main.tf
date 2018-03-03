variable "internal_subnet_id" {}
variable "services_subnet_id" {}

resource "aws_db_subnet_group" "services-subnet-private-group" {
  name = "services-subnet-private-group"
  subnet_ids = ["${var.services_subnet_id}", "${var.internal_subnet_id}"]

  tags {
    Name = "Services Subnet Private Group"
  }
}

resource "aws_db_subnet_group" "services-subnet-public-group" {
  name = "services-subnet-public-group"
  subnet_ids = ["${var.services_subnet_id}", "${var.internal_subnet_id}"]

  tags {
    Name = "Services Subnet Public Group"
  }
}

resource "aws_elasticache_subnet_group" "services-subnet-private-group" {
    name = "services-subnet-private-group"
    subnet_ids = ["${var.services_subnet_id}", "${var.internal_subnet_id}"]
}

### VARIABLES

output "elasticache-subnet-private-group-name" {
  value = "${aws_elasticache_subnet_group.services-subnet-private-group.name}"
}

output "rds-subnet-private-group-name" {
  value = "${aws_db_subnet_group.services-subnet-private-group.name}"
}
