# Configure the AWS Provider
provider "aws" {
  profile                  = "default"
  shared_config_files      = ["/home/zedan/.aws/config"]
  shared_credentials_files = ["/home/zedan/.aws/credentials"]
}