locals {
  # IPv4 addresses for github.com
  github_ips_A = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153"
  ]

  # IPv6 addresses for github.com
  github_ips_AAAA = [
    "2606:50c0:8000::153",
    "2606:50c0:8001::153",
    "2606:50c0:8002::153",
    "2606:50c0:8003::153"
  ]

  domain_name = "wachs.work"
}

#
# wachs.work
#
resource "aws_route53_zone" "wachswork" {
  name    = "wachs.work"
  comment = "Managed by Terraform"
}

resource "aws_route53_zone" "wachsemail" {
  name    = "wachs.email"
  comment = "Managed by Terraform - wachs.email"
}

locals {
  dns_zones_ids = {
    "wachs.work"  = aws_route53_zone.wachswork.zone_id
    "wachs.email" = aws_route53_zone.wachsemail.zone_id
  }

  dns_records = yamldecode(file("${path.module}/dns_records.yaml"))
}

resource "aws_route53_record" "records" {
  for_each = { for r in local.dns_records.records : "${r.name}:${sha256(yamlencode(r))}" => r }

  name    = each.value.name
  zone_id = local.dns_zones_ids[each.value.zone]
  type    = each.value.type
  ttl     = lookup(each.value, "ttl", 300)
  records = each.value.records
}
