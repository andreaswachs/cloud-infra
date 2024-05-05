# Configuration for the vault server cloud resources\

module "s3_bucket" {
  count = 1

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4"

  bucket = "vault-storage-vcpzpo6cs8fd6zbpcc00pnrelhftytpqnxg"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = false
  }
}

# Create user that has permission to read and write to the S3 bucket
resource "aws_iam_user" "vault_storage" {
  name = "vault-storage"
}

resource "aws_iam_access_key" "vault_storage" {
  user = aws_iam_user.vault_storage.name
}

resource "aws_iam_user_policy" "vault_storage" {
  name = "vault-storage"

  depends_on = [module.s3_bucket]

  user = aws_iam_user.vault_storage.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = [
          module.s3_bucket[0].s3_bucket_arn,
          "${module.s3_bucket[0].s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

# Put the vault_storage user's access key and secret key into SSM Parameters'
resource "aws_ssm_parameter" "vault_storage_access_key" {
  name  = "/vault/storage/access_key"
  value = aws_iam_access_key.vault_storage.id
  type  = "SecureString"
}

resource "aws_ssm_parameter" "vault_storage_secret_key" {
  name  = "/vault/storage/secret_key"
  value = aws_iam_access_key.vault_storage.secret
  type  = "SecureString"
}

resource "aws_ssm_parameter" "vault_storage_bucket_name" {
  name  = "/vault/storage/bucket_name"
  value = module.s3_bucket[0].s3_bucket_id
  type  = "SecureString"
}

resource "aws_ssm_parameter" "vault_root_token" {
  name  = "/vault/root_token"
  value = var.vault_root_token
  type  = "SecureString"
}
