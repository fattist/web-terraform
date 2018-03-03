provider "aws" {
  access_key = "${var.CREDENTIALS_ACCESS}"
  secret_key = "${var.CREDENTIALS_SECRET}"
  region = "${var.AWS_REGION}"
}

terraform {
  backend "s3" {}
}

module "ec2-key-pair" {
  source = "./modules/aws/keys/ec2"
  key_path = "${lookup(var.INSTANCE_PUB_KEYS, var.AWS_ENVIRONMENT)}"
}

module "kms-key" {
  source = "./modules/aws/keys/kms"
}

# S3
####

module "s3" {
  source = "./modules/aws/s3/ops"
  env = "${var.AWS_ENVIRONMENT}"
}

# NETWORKING - VPC
##################

# module "network" {
#   source = "./modules/aws/networking/services"
#   az_primary = "${lookup(var.AVAILABILITY_ZONES, var.AWS_REGION)}"
#   az_failover = "${lookup(var.FAILOVER_ZONES, var.AWS_REGION)}"
#   region = "${var.AWS_REGION}"
#   subnet_cidr = "${var.SUBNET_CIDR}"
#   subnet_cidr_private = "${var.SUBNET_CIDR_PRIVATE}"
#   vpc_cidr = "${var.VPC_CIDR}"
# }
#
# module "network-security" {
#   source = "./modules/aws/networking/security"
#   internal_subnet_cidr_block = "${var.VPC_CIDR}"
#   services_subnet_cidr_block = "${module.network.services-public-subnet-cidr}"
#   services_subnet_id = "${module.network.services-public-subnet-id}"
#   services_vpc_id = "${module.network.services-vpc-id}"
#   internal_subnet_id = "${module.network.services-private-subnet-id}"
# }

# module "network-db-subnet-group" {
#   source = "./modules/aws/networking/services/db"
#   services_subnet_id = "${module.network.services-public-subnet-id}"
#   internal_subnet_id = "${module.network.services-private-subnet-id}"
# }

# IAM : global
##############

# module "iam-ecr-platform" {
#   source = "./modules/aws/iam/ecr"
#   name = "${module.ecs-platform-ecr.name}"
# }

# module "iam-ecs" {
#   source = "./modules/aws/iam/ecs"
#   account = "${var.AWS_ACCOUNT}"
#   region = "${var.AWS_REGION}"
#   policy_name = "iam-ecs-load-balancer"
#   role_name = "services-ecs-platform-profile"
# }

# module "iam-rds" {
#   source = "./modules/aws/iam/rds"
#   region = "${var.AWS_REGION}"
# }

# CLOUDWATCH
############

# module "cloudwatch-platform-staging" {
#   source = "./modules/aws/cw/platform"
#   environment = "${var.AWS_ENVIRONMENT}"
# }

# ELB
#####

# module "ecs-platform-elb" {
#   source = "./modules/aws/elb/platform"
#   services_subnet_id = "${module.network.services-public-subnet-id}"
#   internal_subnet_id = "${module.network.services-private-subnet-id}"
#   services_alb_id = "${module.network-security.services-application-load-balancer-id}"
# }

# ECR
#####

# module "ecs-platform-ecr" {
#   source = "./modules/aws/ecr"
#   name = "platform"
# }

# EC2
#########

# module "ec2-bastion" {
#   source ="./modules/aws/ec2/bastion"
#   environment = "${var.AWS_ENVIRONMENT}"
#   availability_zone = "${lookup(var.AVAILABILITY_ZONES, var.AWS_REGION)}"
#   region = "${var.AWS_REGION}"
#   key_name = "${module.ec2-key-pair.platform-ec2-key-name}"
#   subnet_id = "${module.network.services-public-subnet-id}"
#   ssh_security_group_id = "${module.network-security.services-ssh-security-group-id}"
#   redis_security_group_id = "${module.network-security.services-redis-security-group-id}"
#   rds_security_group_id = "${module.network-security.services-rds-security-group-id}"
#   service_security_group_id = "${module.network-security.services-application-security-group-id}"
# }

# module "platform-cluster" {
#   source = "./modules/aws/ec2/platform"
#   environment = "${var.AWS_ENVIRONMENT}"
#   availability_zone = "${lookup(var.AVAILABILITY_ZONES, var.AWS_REGION)}"
#   region = "${var.AWS_REGION}"
#   key_name = "${module.ec2-key-pair.platform-ec2-key-name}"
#   subnet_id = "${module.network.services-public-subnet-id}"
#   ecs_ami = "${lookup(var.ECS_AMI, var.AWS_REGION)}"
#   ssh_security_group_id = "${module.network-security.services-ssh-security-group-id}"
#   redis_security_group_id = "${module.network-security.services-redis-security-group-id}"
#   rds_security_group_id = "${module.network-security.services-rds-security-group-id}"
#   smtp_security_group_id = "${module.network-security.services-smtp-security-group-id}"
#   cloudwatch_security_group_id = "${module.network-security.services-cloudwatch-security-group-id}"
#   loggly_security_group_id = "${module.network-security.services-loggly-security-group-id}"
#   service_security_group_id = "${module.network-security.services-application-security-group-id}"
#   iam_instance_profile = "${module.iam-ecs.services-ecs-service-iam-profile-name}"
# }

# RDS
#####

# module "rds-mysql-platform-master" {
#   source = "./modules/aws/rds/platform"
#   availability_zone = "${lookup(var.FAILOVER_ZONES, var.AWS_REGION)}"
#   db_name = "${var.RDS_NAME}"
#   db_password = "${var.RDS_PASSWORD}"
#   db_username = "${var.RDS_USERNAME}"
#   environment = "${var.AWS_ENVIRONMENT}"
#   subnet_rds_name = "${module.network-db-subnet-group.rds-subnet-private-group-name}"
#   monitoring_role_arn = "${module.iam-rds.services-rds-service-iam-role-arn}"
#   security_group_id = "${module.network-security.services-rds-security-group-id}"
#   kms_key_arn = "${module.kms-key.platform-aws-kms-arn}"
# }

# REDIS
#######

# ECS
#####

# module "ecs-platform-service" {
#   source = "./modules/aws/ecs/platform"
#   environment = "${var.AWS_ENVIRONMENT}"
#   ecs_elb_id = "${module.ecs-platform-elb.id}"
#   ecs_iam_role_name = "${module.iam-ecs.services-ecs-service-iam-role-name}"
#   region = "${var.AWS_REGION}"
#   availability_zone = "${lookup(var.AVAILABILITY_ZONES, var.AWS_REGION)}"
#   failover_zone = "${lookup(var.FAILOVER_ZONES, var.AWS_REGION)}"
#   instance_cpu = "${lookup(var.INSTANCE_TYPE_CPU, lookup(var.ECS_INSTANCE_TYPES, var.AWS_ENVIRONMENT))}"
#   instance_memory = "${lookup(var.INSTANCE_TYPE_MEMORY, lookup(var.ECS_INSTANCE_TYPES, var.AWS_ENVIRONMENT))}"
#   cloudwatch_group_name = "${module.cloudwatch-platform-staging.name}"
# }


# CLOUDFRONT : global
#####################

# OUTPUT
########
