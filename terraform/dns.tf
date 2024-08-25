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
}

#
# wachs.work
#
resource "aws_route53_zone" "wachswork" {
  name    = "wachs.work"
  comment = "Managed by Terraform"
}

resource "aws_route53_record" "wachswork_ipv4" {
  name    = "wachs.work"
  zone_id = aws_route53_zone.wachswork.zone_id
  type    = "A"
  ttl     = "300"
  records = local.github_ips_A
}

resource "aws_route53_record" "wachswork_ipv6" {
  name    = "wachs.work"
  zone_id = aws_route53_zone.wachswork.zone_id
  type    = "AAAA"
  ttl     = "300"
  records = local.github_ips_AAAA
}

resource "aws_route53_record" "www_wachswork" {
  name    = "www.wachs.work"
  zone_id = aws_route53_zone.wachswork.zone_id
  type    = "CNAME"
  ttl     = "300"
  records = ["andreaswachs.github.io/wachswork"]
}

#
#  wachs.email - ProtonMail
#

resource "aws_route53_zone" "wachsemail" {
  name    = "wachs.email"
  comment = "Managed by Terraform - wachs.email"
}

resource "aws_route53_record" "wachsemail_txt_proton_wachs_email" {
  name    = "wachs.email"
  zone_id = aws_route53_zone.wachsemail.zone_id
  type    = "TXT"
  ttl     = "300"
  records = ["protonmail-verification=fc87f29172f1c3f306c6047de68a915122729e16", "v=spf1 include:_spf.protonmail.ch ~all", "v=DMARC1; p=quarantine"]
}

resource "aws_route53_record" "wachsemail_mx_1" {
  name    = "wachs.email"
  zone_id = aws_route53_zone.wachsemail.zone_id
  type    = "MX"
  ttl     = "300"
  records = ["10 mail.protonmail.ch", "20 mailsec.protonmail.ch"]
}

resource "aws_route53_record" "wachsemail_dkim_1" {
  name    = "protonmail._domainkey"
  zone_id = aws_route53_zone.wachsemail.zone_id
  type    = "CNAME"
  ttl     = "300"
  records = ["protonmail.domainkey.dr6a3pp5hnutjxzamczsmsnfmtqpv3l5dewazmjo7vxyow6efxn2q.domains.proton.ch."]
}

resource "aws_route53_record" "wachsemail_dkim_2" {
  name    = "protonmail2._domainkey"
  zone_id = aws_route53_zone.wachsemail.zone_id
  type    = "CNAME"
  ttl     = "300"
  records = ["protonmail2.domainkey.dr6a3pp5hnutjxzamczsmsnfmtqpv3l5dewazmjo7vxyow6efxn2q.domains.proton.ch."]
}

resource "aws_route53_record" "wachsemail_dkim_3" {
  name    = "protonmail3._domainkey"
  zone_id = aws_route53_zone.wachsemail.zone_id
  type    = "CNAME"
  ttl     = "300"
  records = ["protonmail3.domainkey.dr6a3pp5hnutjxzamczsmsnfmtqpv3l5dewazmjo7vxyow6efxn2q.domains.proton.ch."]
}
