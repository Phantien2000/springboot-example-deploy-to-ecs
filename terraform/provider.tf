terraform {
  required_providers{
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.20"
    }
  }
#  backend "s3" {
#    bucket = "******"
#    key = "******"
#    region = "ap-south-1"
#  }
}

provider "aws" {
  region = "us-east-1"
}
