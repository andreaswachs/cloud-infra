
provider "aws" {
  region = "eu-north-1"
}

provider "vault" {
  address = "https://vault.wachs.work"
  token   = var.vault_root_token
}
