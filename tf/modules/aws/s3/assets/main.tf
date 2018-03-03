variable "env" {}
variable "application" {}
variable "environments" {
  type = "list"
  default = [
    "env-assets",
  ]
}

resource "aws_s3_bucket" "assets" {
  count = 1
  bucket = "fatt-${element(var.environments, count.index)}-${var.application}"
  acl = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  lifecycle {
    prevent_destroy = true
  }

  logging {
    target_bucket = "fattist-operations-logging"
    target_prefix = "fattist-${element(var.environments, count.index)}-${var.application}/${var.env}/"
  }

  tags {
    Name = "fatt-${element(var.environments, count.index)}-${var.application}"
  }

  versioning {
    enabled = true
  }
}

## VARIABLES
output "dns" {
  value = "${aws_s3_bucket.assets.bucket_domain_name}"
}
