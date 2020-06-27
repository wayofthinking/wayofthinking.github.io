
locals {
  ttl_ns  = 86400
  ttl_a   = 10800
}

resource "ovh_domain_zone_record" "ns" {
  count     = length(var.name_servers)
  zone      = var.zone
  fieldtype = "NS"
  ttl       = local.ttl_ns
  target    = var.name_servers[count.index]
}

resource "ovh_domain_zone_record" "google_site_verification" {
  zone      = var.zone
  fieldtype = "TXT"
  ttl       = local.ttl_a
  target    = "\"google-site-verification=${var.google_site_verification}\""
}

