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

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.30.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }

  }
}
