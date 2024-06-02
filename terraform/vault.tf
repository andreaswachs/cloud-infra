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

data "kubernetes_config_map_v1" "kubernetes_ca_cert" {
  metadata {
    name      = "kube-root-ca.crt"
    namespace = "kube-public"
  }
}

data "kubernetes_secret_v1" "vault_service_account_jwt" {
  metadata {
    name      = "vault-auth"
    namespace = "vault"
  }
}

resource "vault_kubernetes_secret_backend" "config" {
  path                 = "kubernetes"
  description          = "kubernetes secrets engine description"
  kubernetes_host      = var.kubernetes_host
  kubernetes_ca_cert   = data.kubernetes_config_map_v1.kubernetes_ca_cert.data["ca.crt"]
  service_account_jwt  = data.kubernetes_secret_v1.vault_service_account_jwt.data["token"]
  disable_local_ca_jwt = false
}

resource "vault_kubernetes_auth_backend_role" "apps_reader" {
  backend                          = vault_kubernetes_secret_backend.config.path
  bound_service_account_names      = ["*"]
  bound_service_account_namespaces = ["*"]
  role_name                        = "apps_reader"
  token_policies                   = [vault_policy.apps.name]
}

# add KV for developers
resource "vault_mount" "apps" {
  type = "kv"
  options = {
    version = "2"
  }
  path        = "apps"
  description = "KV Store for application secrets"
}

###
#
# Policies
#
###

# Create the data for the policies
data "vault_policy_document" "global_admin" {
  rule {
    path         = "*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description  = "Policy that allows everything. When given to a token in a namespace, will be like a namespace-root token"
  }
}

data "vault_policy_document" "apps" {
  rule {
    path         = "apps/*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = ""
  }
}

data "vault_policy_document" "apps_reader" {
  rule {
    path         = "apps/*"
    capabilities = ["read"]
    description  = ""
  }
}

resource "vault_policy" "apps_reader" {
  name   = "apps_reader"
  policy = data.vault_policy_document.apps_reader.hcl
}

# add the policies
resource "vault_policy" "admin" {
  name   = "admin"
  policy = data.vault_policy_document.global_admin.hcl
}

resource "vault_policy" "apps" {
  name   = "apps"
  policy = data.vault_policy_document.apps.hcl
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
