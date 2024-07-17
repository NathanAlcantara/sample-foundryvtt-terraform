output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnets" {
  value = module.vpc.public_subnets
}
output "alb_zone_id" {
  value = module.alb.zone_id
}
output "alb_dns_name" {
  value = module.alb.dns_name
}
