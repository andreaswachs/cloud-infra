locals {
  subdomains = []
}

module "acm" {
  for_each = toset(local.subdomains)

  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name               = local.domain_name
  zone_id                   = aws_route53_zone.wachswork.id
  subject_alternative_names = ["${each.key}.${local.domain_name}"]
}
