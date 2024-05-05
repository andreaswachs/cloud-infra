terraform {
  backend "s3" {
    bucket = "tf-state-files-remote-backend"
    key    = "cloud-infra"
    region = "eu-north-1"
  }

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.2"
    }
  }
}
