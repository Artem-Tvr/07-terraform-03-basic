provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}

locals {

  instance_count = {
  stage = 1
  prod = 2
  }

  instance_type = {
  stage = "t3.micro"
  prod = "t3.small"
  }

  for_each_inst_count = {
    stage = { count = 1 }
    prod  = { count = 2 }
  }
}

resource "aws_instance" "hw-terraform-basic" {
    ami = "ami-065deacbcaac64cf2"
    instance_type = terraform.workspace == "default" ? "t2.medium" : "t2.micro"
    count = local.instance_count[terraform.workspace]

    lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "ForEach" {
  ami = "ami-065deacbcaac64cf2"
  instance_type = terraform.workspace == "default" ? "t2.medium" : "t2.micro"
  for_each   = local.for_each_inst_count[terraform.workspace]
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "devops-artem-tf-state-${terraform.workspace}"
    tags = {
      Name = "Bucket"
    }
}