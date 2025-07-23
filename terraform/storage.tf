module "storage_media_01" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  bucket = "personal-media-d163odf2gjrcaplolwj94vj4nnvvvcp5"

  force_destroy = false

  versioning = {
    enabled = false
  }

  lifecycle_rule = [{

    enabled = true
    id      = "straight-to-glacier"

    transition = [
      {
        days          = 1
        storage_class = "GLACIER_IR"
      },
    ]
  }]

  tags = {
    Name        = "media-01"
    Environment = "production"
  }
}

#
# Storage for Annemette
#

module "storage_am" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  bucket = "storage-hie1b5vwcggsmjllgecmvovb0l8bo7u"

  force_destroy = false

  versioning = {
    enabled = false
  }

  lifecycle_rule = [{

    enabled = true
    id      = "straight-to-glacier"

    transition = [
      {
        days          = 1
        storage_class = "GLACIER_IR"
      },
    ]
  }]

  tags = {
    Name        = "annemette-disk-dump"
    Environment = "production"
  }
}

module "self_hosted_irsa_discovery_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  bucket = "irsa-discovery-bucket-umsreupygnuy7rbjvdv1qrfxzhxbgii"

  force_destroy = false

  versioning = {
    enabled = false
  }

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  tags = {
    Name        = "self_hosted_irsa_discovery_bucket"
    Environment = "production"
  }
}


