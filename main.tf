provider "aws" {
  region  = var.region
  # profile = "vivek"
}

terraform {
  backend "s3" {
    bucket         = "python-deployment-backend"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    # dynamodb_table = "terraform_state"
  }
}