variable "env" {}
variable "environments" {
  type = "list"
  default = [
    "svc-platform",
  ]
}

resource "aws_s3_bucket" "resources-log-bucket" {
  bucket = "fattist-operations-logging"
  acl = "log-delivery-write"
}

resource "aws_s3_bucket" "resources-platform-bucket" {
  count = 1
  bucket = "fattist-${element(var.environments, count.index)}"
  acl = "private"

  lifecycle {
    prevent_destroy = true
  }

  logging {
    target_bucket = "fattist-operations-logging"
    target_prefix = "fattist-${element(var.environments, count.index)}/${var.env}/"
  }

  tags {
    Name = "fattist-${element(var.environments, count.index)}"
  }

  versioning {
    enabled = true
  }
}
