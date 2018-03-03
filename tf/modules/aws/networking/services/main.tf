variable "az_primary" {}
variable "az_failover" {}
variable "region" {}
variable "subnet_cidr" {}
variable "subnet_cidr_private" {}
variable "vpc_cidr" {}

## Create a VPC
resource "aws_vpc" "services-vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "Service VPC"
  }
}

## Create a subnet
resource "aws_subnet" "services-subnet-public" {
  availability_zone = "${var.az_primary}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.services-vpc.id}"
  cidr_block = "${var.subnet_cidr}"

  tags {
    Name = "Service Public Subnet"
  }
}

resource "aws_subnet" "services-subnet-private" {
  availability_zone = "${var.az_failover}"
  map_public_ip_on_launch = false
  vpc_id = "${aws_vpc.services-vpc.id}"
  cidr_block = "${var.subnet_cidr_private}"

  tags {
    Name = "Service Private Subnet"
  }
}

## Connection to the outside world!
resource "aws_internet_gateway" "services-gateway" {
  vpc_id = "${aws_vpc.services-vpc.id}"

  tags {
    Name = "Service Gateway"
  }
}

## Access to S3
resource "aws_vpc_endpoint" "services-endpoint-s3" {
  vpc_id = "${aws_vpc.services-vpc.id}"
  service_name = "${format("com.amazonaws.%s.s3", "${var.region}")}"
  route_table_ids = ["${aws_route_table.services-route-table-public.id}"]
}

## Map the VPC to the gateway
resource "aws_route_table" "services-route-table-public" {
  vpc_id = "${aws_vpc.services-vpc.id}"

  tags {
    Name = "Service Route Table Public"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.services-gateway.id}"
  }
}

resource "aws_route_table_association" "services-route-table-association-public" {
  subnet_id = "${aws_subnet.services-subnet-public.id}"
  route_table_id = "${aws_route_table.services-route-table-public.id}"
}

### VARIABLES

output "services-public-subnet-cidr" {
  value = "${aws_subnet.services-subnet-public.cidr_block}"
}

output "services-private-subnet-id" {
  value = "${aws_subnet.services-subnet-private.id}"
}

output "services-public-subnet-id" {
  value = "${aws_subnet.services-subnet-public.id}"
}

output "services-vpc-id" {
  value = "${aws_vpc.services-vpc.id}"
}
