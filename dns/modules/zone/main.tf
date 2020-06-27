
locals {
  ttl_ns  = 86400
  ttl_mx  = 28800
  ttl_a   = 10800
  ttl_spf = 3600
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

resource "ovh_domain_zone_record" "mx" {
  count     = length(var.mx)
  zone      = var.zone
  fieldtype = "MX"
  ttl       = local.ttl_mx
  target    = var.mx[count.index]
}

resource "ovh_domain_zone_record" "spf" {
  zone      = var.zone
  fieldtype = "TXT"
  ttl       = local.ttl_spf
  target    = var.spf
}

resource "ovh_domain_zone_record" "dkim" {
  zone      = var.zone
  subdomain = "google._domainkey"
  fieldtype = "TXT"
  ttl       = local.ttl_spf
  target    = var.dkim
}
