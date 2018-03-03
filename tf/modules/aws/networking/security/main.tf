variable "internal_subnet_cidr_block" {}
variable "services_subnet_cidr_block" {}
variable "services_subnet_id" {}
variable "services_vpc_id" {}
variable "internal_subnet_id" {}

resource "aws_security_group" "services-efs-security-group" {
  name = "services-efs-security-group"
  description = "Allow EFS outbound requests to subnet"

  vpc_id = "${var.services_vpc_id}"

  tags {
    Name = "Service Subnet EFS Security Group"
  }

  ingress {
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    from_port = 0
    to_port = 65535
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 2049
    to_port = 2049
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 111
    to_port = 111
  }
}

resource "aws_security_group" "services-elb-security-group" {
  name = "services-elb-security-group"
  description = "Allow ELB outbound requests to subnet"

  vpc_id = "${var.services_vpc_id}"

  tags {
    Name = "Service Subnet ELB Security Group"
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    from_port = 22
    to_port = 22
  }
}

resource "aws_security_group" "services-redis-security-group" {
  name = "services-redis-security-group"
  description = "Allow REDIS requests through subnet"

  vpc_id = "${var.services_vpc_id}"

  tags {
    Name = "Service Subnet REDIS Security Group"
  }

  ingress {
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    from_port = 6379
    to_port = 6379
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    from_port = 6379
    to_port = 6379
  }
}

resource "aws_security_group" "services-rds-security-group" {
  name = "services-rds-security-group"
  description = "Allow RDS requests to subnet"

  vpc_id = "${var.services_vpc_id}"

  tags {
    Name = "Service Subnet RDS Security Group"
  }

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 3306
    to_port = 3306
  }

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 5432
    to_port = 5432
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 3306
    to_port = 3306
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 5432
    to_port = 5432
  }
}

resource "aws_security_group" "services-ssh-security-group" {
  name = "services-ssh-security-group"
  description = "Allow inbound requests to 22"

  vpc_id = "${var.services_vpc_id}"

  tags {
    Name = "Service SSH Security Group"
  }

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    from_port = 22
    to_port = 22
  }
}

resource "aws_security_group" "services-smtp-security-group" {
  name = "services-smtp-security-group"
  description = "Allow outbound requests to common SMTP protocols"

  vpc_id = "${var.services_vpc_id}"

  tags {
    Name = "Service SMTP Request Security Group"
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 25
    to_port = 25
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 465
    to_port = 465
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 587
    to_port = 587
  }
}

resource "aws_security_group" "services-webrequest-security-group" {
  name = "services-webrequest-security-group"
  description = "Allow outbound requests to 80/443"

  vpc_id = "${var.services_vpc_id}"

  tags {
    Name = "Service Web Request Security Group"
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443
    to_port = 443
  }
}


resource "aws_security_group" "services-application-security-group" {
  name = "services-application-security-group"
  description = "Allow requests to standard application ports"

  vpc_id = "${var.services_vpc_id}"

  tags {
    Name = "Service Application Security Group"
  }

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 3000
    to_port = 3000
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443
    to_port = 443
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 7687
    to_port = 7687
  }
}

resource "aws_security_group" "services-cloudwatch-security-group" {
  name = "services-cloudwatch-security-group"
  description = "Allow requests to 53"

  vpc_id = "${var.services_vpc_id}"

  tags {
    Name = "Service Cloudwatch Security Group"
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 53
    to_port = 53
  }
}

resource "aws_security_group" "services-loggly-security-group" {
  name = "services-loggly-security-group"
  description = "Allow requests to 514"

  vpc_id = "${var.services_vpc_id}"

  tags {
    Name = "Service Loggly Security Group"
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 514
    to_port = 514
  }
}

resource "aws_security_group" "services-neo-security-group" {
  name = "services-neo-security-group"
  description = "Allow requests to Neo ports"

  vpc_id = "${var.services_vpc_id}"

  tags {
    Name = "Service Neo Security Group"
  }

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 7474
    to_port = 7474
  }

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 7687
    to_port = 7687
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 7687
    to_port = 7687
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 7474
    to_port = 7474
  }
}

resource "aws_security_group" "services-application-load-balancer" {
  name = "services-application-load-balancer"
  description = "Allow requests to ECS clusters via ELB"

  vpc_id = "${var.services_vpc_id}"

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 7687
    to_port = 7687
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

## VARIABLES
output "services-application-security-group-id" {
  value = "${aws_security_group.services-application-security-group.id}"
}

output "services-redis-security-group-id" {
  value = "${aws_security_group.services-redis-security-group.id}"
}

output "services-rds-security-group-id" {
  value = "${aws_security_group.services-rds-security-group.id}"
}

output "services-ssh-security-group-id" {
  value = "${aws_security_group.services-ssh-security-group.id}"
}

output "services-application-load-balancer-id" {
  value = "${aws_security_group.services-application-load-balancer.id}"
}

output "services-loggly-security-group-id" {
  value = "${aws_security_group.services-loggly-security-group.id}"
}

output "services-cloudwatch-security-group-id" {
  value = "${aws_security_group.services-cloudwatch-security-group.id}"
}

output "services-neo-security-group-id" {
  value = "${aws_security_group.services-neo-security-group.id}"
}

output "services-webrequest-security-group-id" {
  value = "${aws_security_group.services-webrequest-security-group.id}"
}

output "services-smtp-security-group-id" {
  value = "${aws_security_group.services-smtp-security-group.id}"
}

output "services-efs-security-group-id" {
  value = "${aws_security_group.services-efs-security-group.id}"
}
