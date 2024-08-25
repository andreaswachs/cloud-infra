// Let's create a private s3 bucket for my personal media


resource "aws_s3_bucket" "personal_media_bucket" {
  bucket = "my-personal-media-bucket"
}

resource "aws_s3_bucket_ownership_controls" "personal_media_bucket" {
  bucket = aws_s3_bucket.personal_media_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "personal_media_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.personal_media_bucket]

  bucket = aws_s3_bucket.personal_media_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket" "annemette_disk_dump" {
  bucket = "annemette-disk-dump"
}

resource "aws_s3_bucket_ownership_controls" "annemette_disk_dump" {
  bucket = aws_s3_bucket.annemette_disk_dump.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "annemette_disk_dump" {
  depends_on = [aws_s3_bucket_ownership_controls.annemette_disk_dump]

  bucket = aws_s3_bucket.annemette_disk_dump.id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "annemette_disk_dump" {
  bucket = aws_s3_bucket.annemette_disk_dump.id

  rule {
    id     = "cold_storage_rule"
    status = "Enabled"

    transition {
      days          = 7
      storage_class = "GLACIER_IR"
    }
  }
}

module "storage-am-backups-dump" {
  source      = "./modules/private-s3-storage"
  bucket_name = "annemette-backups-dump-qlftbtzciyn7dzyh"

  use_cold_storage = true
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
