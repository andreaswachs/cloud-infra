
provider "aws" {
  region = "eu-north-1"


  default_tags {
    tags = {
      "repo-link": "https://github.com/andreaswachs/cloud-infra"
      "managed-by": "terraform"
    }
  }
}
