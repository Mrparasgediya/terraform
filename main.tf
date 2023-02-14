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
data "aws_vpc" "default_vpc_data" {
  default = true
}

data "aws_subnet" "default_subnet" {
  id     = "subnet-034e185bc2d4644cb" // AZ: ap-south-1
  vpc_id = data.aws_vpc.default_vpc_data.id
}

module "ec2" {
  source    = "./ec2"
  subnet_id = data.aws_subnet.default_subnet.id
}

module "rds" {
  source      = "./rds"
  instance_sg = module.ec2.instance_sg_id
}