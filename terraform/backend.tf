terraform {
  backend "s3" {
    bucket                  = "tf-state-files-remote-backend"
    key                     = "cloud-infra"
    region                  = "eu-north-1"
    shared_credentials_file = "~/.aws/credentials"
  }
}

