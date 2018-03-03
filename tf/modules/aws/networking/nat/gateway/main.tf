variable "region" {}
variable "internal_subnet_id" {}
variable "nat_eip_id" {}
variable "services_vpc_id" {}
variable "services_route_table_id" {}
variable "services_subnet_id" {}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${var.nat_eip_id}"
  subnet_id = "${var.services_subnet_id}"
}

resource "aws_route_table" "services-route-table-nat" {
  vpc_id = "${var.services_vpc_id}"

  tags {
    Name = "Service Route Table Private"
  }

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat.id}"
  }
}

resource "aws_route_table_association" "services-route-table-association-nat" {
  subnet_id = "${var.internal_subnet_id}"
  route_table_id = "${aws_route_table.services-route-table-nat.id}"
}

## Access to S3
resource "aws_vpc_endpoint" "services-endpoint-s3" {
  vpc_id = "${var.services_vpc_id}"
  service_name = "${format("com.amazonaws.%s.s3", "${var.region}")}"
  route_table_ids = ["${aws_route_table.services-route-table-nat.id}"]
}
