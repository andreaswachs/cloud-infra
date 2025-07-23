# GitHub Actions OIDC integration using manual resource definitions

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]
}

resource "aws_iam_role" "ci_homelab_k8s" {
  name = "ci-homelab-k8s"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          "StringEquals": {
            "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
          },
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:andreaswachs/homelab-k8s:*"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ci_homelab_k8s_attach" {
  role       = aws_iam_role.ci_homelab_k8s.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # Adjust permissions as needed
}

# IAM user for legacy CI with admin access and access keys in SSM Parameter Store

resource "aws_iam_user" "ci_terraform" {
  name = "ci-terraform"
  force_destroy = true
}

resource "aws_iam_user_policy_attachment" "ci_terraform_admin" {
  user       = aws_iam_user.ci_terraform.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_access_key" "ci_terraform" {
  user = aws_iam_user.ci_terraform.name
}

resource "aws_ssm_parameter" "ci_terraform_access_key_id" {
  name  = "/ci-terraform/aws_access_key_id"
  type  = "SecureString"
  value = aws_iam_access_key.ci_terraform.id
}

resource "aws_ssm_parameter" "ci_terraform_secret_access_key" {
  name  = "/ci-terraform/aws_secret_access_key"
  type  = "SecureString"
  value = aws_iam_access_key.ci_terraform.secret
}