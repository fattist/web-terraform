variable "environment" {}

resource "aws_cloudwatch_log_group" "platform" {
  name = "platform-${var.environment}"
  retention_in_days = 30

  tags {
    Environment = "${var.environment}"
    Application = "platform"
  }
}

resource "aws_cloudwatch_log_group" "dmesg" {
  name = "/var/log/dmesg"
  retention_in_days = 30

  tags {
    Environment = "${var.environment}"
    Application = "platform"
  }
}

resource "aws_cloudwatch_log_group" "messages" {
  name = "/var/log/messages"
  retention_in_days = 30

  tags {
    Environment = "${var.environment}"
    Application = "platform"
  }
}

resource "aws_cloudwatch_log_group" "docker" {
  name = "/var/log/docker"
  retention_in_days = 30

  tags {
    Environment = "${var.environment}"
    Application = "platform"
  }
}

resource "aws_cloudwatch_log_group" "init" {
  name = "/var/log/ecs/ecs-init.log"
  retention_in_days = 30

  tags {
    Environment = "${var.environment}"
    Application = "platform"
  }
}

resource "aws_cloudwatch_log_group" "agent" {
  name = "/var/log/ecs/ecs-agent.log"
  retention_in_days = 30

  tags {
    Environment = "${var.environment}"
    Application = "platform"
  }
}

resource "aws_cloudwatch_log_group" "audit" {
  name = "/var/log/ecs/audit.log"
  retention_in_days = 30

  tags {
    Environment = "${var.environment}"
    Application = "platform"
  }
}

## VARIABLES
output "name" {
  value = "platform-${var.environment}"
}
