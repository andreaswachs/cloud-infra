resource "aws_s3_bucket" "my_bucket" {
  bucket = "k8s-app-secrets"
  
  force_destroy = true
}

# Uplad all files in the "../secrets" directory to the S3 bucket
resource "aws_s3_object" "my_bucket_objects" {
  for_each = fileset("../secrets/objects", "**/*")

  force_destroy = true

  bucket = aws_s3_bucket.my_bucket.bucket
  key    = each.value
  source = "../secrets/${each.value}"
}

