
locals {
  ttl_ns  = 86400
}

resource "ovh_domain_zone_record" "ns" {
  count     = length(var.name_servers)
  zone      = var.zone
  fieldtype = "NS"
  ttl       = local.ttl_ns
  target    = var.name_servers[count.index]
}
