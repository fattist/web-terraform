variable "AWS_ACCOUNT" {}
variable "AWS_BUCKET" {}
variable "AWS_ENVIRONMENT" {}
variable "AWS_REGION" {}
variable "CREDENTIALS_ACCESS" {}
variable "CREDENTIALS_SECRET" {}

variable "PROFILE" {
  type = "string"
  default = "recess"
}

variable "AVAILABILITY_ZONES" {
	default = {
    us-west-1 = "us-west-1b"
    us-west-2 = "us-west-2a"
	}
}

variable "ECS_AMI" {
  default = {
    us-west-1 = "ami-74262414"
    us-west-2 = "ami-decc7fa6"
  }
}

variable "PRIVATE_INSTANCE_TYPES" {
  default = {
    production = "t2.micro"
  }
}

variable "ECS_INSTANCE_TYPES" {
  default = {
    production = "t2.medium"
    staging = "t2.micro"
  }
}

/*http://www.ec2instances.info/?region=us-west-1&selected=c3.xlarge,c4.xlarge*/
variable "ECS_NEO_INSTANCE_TYPES" {
  default = {
    production = "t2.medium"
  }
}

variable "FAILOVER_ZONES" {
	default = {
    us-west-1 = "us-west-1c"
    us-west-2 = "us-west-2b"
	}
}

variable "INSTANCE_PUB_KEYS" {
  default = {
    production = "../secrets/terraform/ssh/production/terraform.pub"
  }
}

variable "INSTANCE_TYPE_MEMORY" {
  # https://github.com/hashicorp/terraform/issues/10778
  default = {
    t2.medium = 6227
    t2.micro = 995
  }
}

variable "INSTANCE_TYPE_CPU" {
  default = {
    t2.medium = 2
    t2.micro = 1
  }
}

variable "REDIS_INSTANCE_TYPES" {
  default = {
    production = "cache.t2.medium"
    staging = "cache.t2.micro"
  }
}

variable "VPC_CIDR" {
	default = "10.0.0.0/16"
}

variable "SUBNET_CIDR" {
	default = "10.0.0.0/24"
}

variable "SUBNET_CIDR_PRIVATE" {
	default = "10.0.1.0/24"
}
