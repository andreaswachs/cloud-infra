module "my_github_oidc_provider_role" {
  source  = "voquis/github-actions-oidc-role/aws"
  version = "0.0.3"

  federated_subject_claims = [
    "repo:andreaswachs/cloud-infra:*",
  ]
}

resource "aws_iam_policy" "github" {
  description = "Permissions granted to github once the github role is assumed"
  name        = "github"
  policy      = data.aws_iam_policy_document.github.json
}

data "aws_iam_policy_document" "github" {
  # Allow to assume the role
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    resources = [
      module.my_github_oidc_provider_role.iam_role.arn,
    ]
  }
}

resource "aws_iam_role_policy_attachment" "github" {
  role       = module.my_github_oidc_provider_role.iam_role.name
  policy_arn = aws_iam_policy.github.arn
}

resource "aws_ssm_parameter" "github_role_arn" {
  name  = "/github/role/arn"
  value = module.my_github_oidc_provider_role.iam_role.arn
  type  = "SecureString"
}
