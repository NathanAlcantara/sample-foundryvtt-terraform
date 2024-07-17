resource "aws_route53_zone" "foundry_hosted_zone" {
  name = var.foundry_domain_name
}

module "acm" {
  source = "terraform-aws-modules/acm/aws"

  domain_name = var.foundry_domain_name
  zone_id     = aws_route53_zone.foundry_hosted_zone.id
}

resource "aws_route53_record" "foundry_record" {
  zone_id = aws_route53_zone.foundry_hosted_zone.zone_id
  name    = var.foundry_domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
