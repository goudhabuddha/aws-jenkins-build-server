data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id  = data.aws_caller_identity.current.account_id
  region      = data.aws_region.current.name
  name_prefix = "serverless-jenkins"

  tags = {
    team     = "devops"
    solution = "jenkins"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

module "myip" {
  source  = "4ops/myip/http"
  version = "1.0.0"
}

// Bring your own ACM cert for the Application Load Balancer
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name = "${var.jenkins_dns_alias}.${var.route53_domain_name}"
  zone_id     = var.route53_zone_id

  tags = local.tags
}

// KMS key
resource "aws_kms_key" "efs_kms_key" {
  description = "KMS key used to encrypt Jenkins EFS volume"
}

module "serverless_jenkins" {
  source                        = "./modules/jenkins"
  name_prefix                   = local.name_prefix
  tags                          = local.tags
  vpc_id                        = var.vpc_id
  efs_kms_key_arn               = aws_kms_key.efs_kms_key.arn
  efs_subnet_ids                = var.efs_subnet_ids
  jenkins_controller_subnet_ids = var.jenkins_controller_subnet_ids
  alb_subnet_ids                = var.alb_subnet_ids
  alb_ingress_allow_cidrs       = ["${module.myip.address}/32"]
  alb_acm_certificate_arn       = module.acm.acm_certificate_arn
  route53_create_alias          = true
  route53_alias_name            = var.jenkins_dns_alias
  route53_zone_id               = var.route53_zone_id
}

