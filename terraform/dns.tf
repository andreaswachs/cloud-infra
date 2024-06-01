#
# wachs.work
#
resource "aws_route53_zone" "wachswork" {
  name    = "wachs.work"
  comment = "Managed by Terraform - wachs.work"
}

resource "aws_route53_record" "wachswork" {
  name    = "wachs.work"
  zone_id = aws_route53_zone.wachswork.zone_id
  type    = "A"
  ttl     = "300"
  records = ["173.212.235.167"]
}

resource "aws_route53_record" "wildcard_wachswork" {
  name    = "*.wachs.work"
  zone_id = aws_route53_zone.wachswork.zone_id
  type    = "A"
  ttl     = "300"
  records = ["173.212.235.167"]
}

resource "aws_ssm_parameter" "name_servers_wachswork" {
  name  = "/dns/wachswork/name_servers"
  value = jsonencode(aws_route53_zone.wachswork.name_servers)
  type  = "String"
}

#
#  wachs.email
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


resource "aws_ssm_parameter" "name_servers_wachsemail" {
  name  = "/dns/wachsemail/name_servers"
  value = jsonencode(aws_route53_zone.wachsemail.name_servers)
  type  = "String"
}
