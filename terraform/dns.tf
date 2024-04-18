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

resource "aws_route53_record" "wildcard" {
  name    = "*.wachs.work"
  zone_id = aws_route53_zone.wachswork.zone_id
  type    = "A"
  ttl     = "300"
  records = ["173.212.235.167"]
}

output "name_servers" {
  value = aws_route53_zone.wachswork.name_servers
}
