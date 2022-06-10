terraform {
backend "remote" {
        hostname = "krishnajprod.jfrog.io"
        organization = "terraform-backend"
        workspaces {
            prefix = "my-jfrog-"
        }
    }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.36"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

module "app_server" {
  source = "./modules/application"

  ec2_instance_type    = "t2.micro"
  ami = "ami-830c94e3"
  tags = {
    Name = "server for web"
    Env = "dev"
  }
}

module "app_storage" {
  source = "./modules/storage/"

  bucket_name     = "my-jfrog"
  env = "dev"
}
resource "aws_db_instance" "database" {
  allocated_storage = 5
  engine            = "mysql"
  instance_class    = "db.t2.micro"
  username          = var.db_username
  password          = var.db_password


  skip_final_snapshot = true
}
