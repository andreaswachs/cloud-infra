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
  # Allow the GitHub role to get s3 objects from the k8s-apps-secrets bucket
  statement {
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.my_bucket.arn}/*"]
  }
}

resource "aws_iam_role_policy_attachment" "github" {
  role       = module.my_github_oidc_provider_role.iam_role.name
  policy_arn = aws_iam_policy.github.arn
}

output "github_role_arn" {
  value = module.my_github_oidc_provider_role.iam_role.arn
}
