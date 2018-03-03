variable "origin_domain" {}
variable "clients" {
  type = "list"
  default = [
    "assets",
  ]
}

resource "aws_cloudfront_distribution" "react-distribution" {
  count = 1
  comment = "env-${element(var.clients, count.index)}-production"
  enabled = true
  price_class = "PriceClass_100"

  aliases = ["fatt.ist"]

  origin {
    domain_name = "${var.origin_domain}"
    origin_id   = "env-${element(var.clients, count.index)}-production"

    custom_origin_config {
      http_port = 80
      https_port = 443
      /*origin_keepalive_timeout = 60*/
      origin_protocol_policy = "http-only"
      /*origin_read_timeout = 60*/
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  cache_behavior {
    path_pattern = "/"
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    compress = true
    target_origin_id = "env-${element(var.clients, count.index)}-production"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl = 14400
    default_ttl = 14400
    max_ttl = 14400
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    compress = true
    target_origin_id = "env-${element(var.clients, count.index)}-production"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl = 14400
    default_ttl = 14400
    max_ttl = 14400
  }

  logging_config {
    include_cookies = false
    bucket          = "fattist-operations-logging.s3.amazonaws.com"
    prefix          = "env-${element(var.clients, count.index)}-production/${element(var.clients, count.index)}/"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  lifecycle {
    ignore_changes = ["aliases", "custom_error_response", "default_root_object", "origin", "viewer_certificate"]
  }

  tags {
    Environment = "env-${element(var.clients, count.index)}-production-${element(var.clients, count.index)}"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
