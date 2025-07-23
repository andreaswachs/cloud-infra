module "cloudnative_pg_backups" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  bucket = "cloudnative-pg-backups-xg72mkogtqfzx7jd"

  force_destroy = false

  versioning = {
    enabled = false
  }

  lifecycle_rule = [
    {
      id = "Delete after 30 days"
      status = "Enabled"

      expiration = {
          days = 30
      }
    }
  ]

  tags = {
    Name        = "cloudnative_pg_backups"
    Environment = "production"
  }
}

# This is the one we're migrating to
module "cloudnative_pg_db_backups" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  bucket = "wachs-work-shared-db-backups"

  force_destroy = false

  versioning = {
    enabled = false
  }

  lifecycle_rule = [
    {
      id = "Delete after 30 days"
      status = "Enabled"

      expiration = {
          days = 30
      }
    }
  ]

  tags = {
    Name        = "cloudnative_pg_backups"
    Environment = "production"
  }
}

# IAM user for CloudNative PG backups
resource "aws_iam_user" "pg_backup_user" {
  name = "cloudnative-pg-backup-user"
  tags = {
    Name        = "cloudnative_pg_backup_user"
    Environment = "production"
  }
}

# IAM policy for S3 bucket access
resource "aws_iam_policy" "pg_backup_policy" {
  name        = "cloudnative-pg-backup-policy"
  description = "Policy for CloudNative PG backup user to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = [
          "${module.cloudnative_pg_backups.s3_bucket_arn}",
          "${module.cloudnative_pg_backups.s3_bucket_arn}/*",
          "${module.cloudnative_pg_db_backups.s3_bucket_arn}",
          "${module.cloudnative_pg_db_backups.s3_bucket_arn}/*"

        ]
      }
    ]
  })
}

# Attach policy to user
resource "aws_iam_user_policy_attachment" "pg_backup_policy_attachment" {
  user       = aws_iam_user.pg_backup_user.name
  policy_arn = aws_iam_policy.pg_backup_policy.arn
}

# Create access keys for the user
resource "aws_iam_access_key" "pg_backup_access_key" {
  user = aws_iam_user.pg_backup_user.name
}

# Store the bucket ID in SSM
resource "aws_ssm_parameter" "pg_backup_bucket_id" {
  name        = "/cloudnative-pg/backup/bucket_id"
  description = "Bucket ID for CloudNativePG backups"
  type        = "String"
  value       = module.cloudnative_pg_backups.s3_bucket_id
  tags = {
    Environment = "production"
  }
}

# Store access key ID and secret in Parameter Store
resource "aws_ssm_parameter" "pg_backup_access_key_id" {
  name        = "/cloudnative-pg/backup/access_key_id"
  description = "Access Key ID for CloudNative PG backup user"
  type        = "String"
  value       = aws_iam_access_key.pg_backup_access_key.id
  tags = {
    Environment = "production"
  }
}

resource "aws_ssm_parameter" "pg_backup_secret_access_key" {
  name        = "/cloudnative-pg/backup/secret_access_key"
  description = "Secret Access Key for CloudNative PG backup user"
  type        = "SecureString"
  value       = aws_iam_access_key.pg_backup_access_key.secret
  tags = {
    Environment = "production"
  }
}
