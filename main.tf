provider "aws" {
  region                   = "us-east-1"
  profile                  = "vivek"
  shared_config_files      = ["/home/vivek/.aws/config"]
  shared_credentials_files = ["/home/vivek/.aws/credentials"]
}
