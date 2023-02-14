terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.5.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  region  = "ap-south-1"
  profile = "default"
}

module "ec2" {
  source = "./ec2"
}

module "rds" {
  source      = "./rds"
  instance_sg = module.ec2.instance_sg_id
}