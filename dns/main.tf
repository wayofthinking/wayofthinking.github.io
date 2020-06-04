
provider "ovh" {
  endpoint           = "ovh-eu"
  version            = "~> 0.5"
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}

locals {
  zone_net = "wayofthinking.net"
  zone_be  = "wayofthinking.be"
  zone_eu  = "wayofthinking.eu"

  # OVH does not accept a TTL lower than 60 !
  ttl_mx  = 28800
  ttl_a   = 10800
  ttl_ns  = 86400
  ttl_spf = 3600

  ovh_ip = "213.186.33.5"

  ns_records = [
    "dns109.ovh.net.",
    "ns109.ovh.net."
  ]

  gsuite_mx_records_for_be = [
    "1 aspmx.l.google.com.",
    "3 alt1.aspmx.l.google.com.",
    "3 alt2.aspmx.l.google.com.",
    "5 aspmx2.googlemail.com.",
    "5 aspmx3.googlemail.com."
  ]

  gsuite_mx_records_for_net = concat(local.gsuite_mx_records_for_be, [
    "5 aspmx4.googlemail.com.",
    "5 aspmx5.googlemail.com."
  ])

  gsuite_cname_records = [
    { subdomain = "calendar", target = "ghs.googlehosted.com." },
    { subdomain = "drive", target = "ghs.googlehosted.com." },
    { subdomain = "mail", target = "ghs.googlehosted.com." }
  ]

  spf_record = "\"v=spf1 include:_spf.google.com ~all\""
}

resource "ovh_domain_zone_record" "net_name_server" {
  count     = length(local.ns_records)
  zone      = local.zone_net
  fieldtype = "NS"
  ttl       = local.ttl_ns
  target    = local.ns_records[count.index]
}

resource "ovh_domain_zone_record" "net_wayofthinking" {
  count     = length(var.website_ip)
  zone      = local.zone_net
  fieldtype = "A"
  ttl       = local.ttl_a
  target    = var.website_ip[count.index]
}

resource "ovh_domain_zone_record" "net_wayofthinking_www" {
  zone      = local.zone_net
  subdomain = "www"
  fieldtype = "CNAME"
  ttl       = local.ttl_a
  target    = "wayofthinking.github.io."
}

resource "ovh_domain_zone_record" "net_gsuite_site_verification" {
  zone      = local.zone_net
  fieldtype = "TXT"
  ttl       = local.ttl_a
  target    = "\"google-site-verification=2V4XwMeXE8SYmcHAQ30NlAUArvR8NFgotefUmO-4x2c\""
}

resource "ovh_domain_zone_record" "net_spf" {
  zone      = local.zone_net
  fieldtype = "SPF"
  ttl       = local.ttl_spf
  target    = local.spf_record
}

resource "ovh_domain_zone_record" "net_gsuite_mail" {
  count     = length(local.gsuite_mx_records_for_net)
  zone      = local.zone_net
  fieldtype = "MX"
  ttl       = local.ttl_mx
  target    = local.gsuite_mx_records_for_net[count.index]
}

resource "ovh_domain_zone_record" "net_gsuite_cname" {
  count     = length(local.gsuite_cname_records)
  zone      = local.zone_net
  subdomain = local.gsuite_cname_records[count.index].subdomain
  fieldtype = "CNAME"
  ttl       = local.ttl_a
  target    = local.gsuite_cname_records[count.index].target
}

resource "ovh_domain_zone_record" "be_name_server" {
  count     = length(local.ns_records)
  zone      = local.zone_be
  fieldtype = "NS"
  ttl       = local.ttl_ns
  target    = local.ns_records[count.index]
}

resource "ovh_domain_zone_record" "be_wayofthinking" {
  zone      = local.zone_be
  fieldtype = "A"
  ttl       = local.ttl_a
  target    = local.ovh_ip
}

resource "ovh_domain_zone_record" "be_wayofthinking_www" {
  zone      = local.zone_be
  subdomain = "www"
  fieldtype = "CNAME"
  ttl       = local.ttl_a
  target    = "${local.zone_be}."
}

resource "ovh_domain_zone_redirection" "be_wayofthinking" {
  zone      = local.zone_be
  subdomain = ""
  type      = "visiblePermanent"
  target    = "http://wayofthinking.net"
}

resource "ovh_domain_zone_record" "be_gsuite_site_verification" {
  zone      = local.zone_be
  fieldtype = "TXT"
  ttl       = local.ttl_a
  target    = "\"google-site-verification=Z85qsHhGDqO317DaUZRgMeCGH44FlJz333T_wgRjiPE\""
}

resource "ovh_domain_zone_record" "be_spf" {
  zone      = local.zone_be
  fieldtype = "SPF"
  ttl       = local.ttl_spf
  target    = local.spf_record
}

resource "ovh_domain_zone_record" "be_gsuite_mail" {
  count     = length(local.gsuite_mx_records_for_be)
  zone      = local.zone_be
  fieldtype = "MX"
  ttl       = local.ttl_mx
  target    = local.gsuite_mx_records_for_be[count.index]
}

resource "ovh_domain_zone_record" "eu_name_server" {
  count     = length(local.ns_records)
  zone      = local.zone_eu
  fieldtype = "NS"
  ttl       = local.ttl_ns
  target    = local.ns_records[count.index]
}

resource "ovh_domain_zone_record" "eu_wayofthinking" {
  zone      = local.zone_eu
  fieldtype = "A"
  ttl       = local.ttl_a
  target    = local.ovh_ip
}

resource "ovh_domain_zone_record" "eu_wayofthinking_www" {
  zone      = local.zone_eu
  subdomain = "www"
  fieldtype = "CNAME"
  ttl       = local.ttl_a
  target    = "${local.zone_eu}."
}

resource "ovh_domain_zone_redirection" "eu_wayofthinking" {
  zone      = local.zone_eu
  subdomain = ""
  type      = "visiblePermanent"
  target    = "http://wayofthinking.net"
}

resource "ovh_domain_zone_record" "eu_gsuite_site_verification" {
  zone      = local.zone_eu
  fieldtype = "TXT"
  ttl       = local.ttl_a
  target    = "\"google-site-verification=jncyCZipyOxhCFlrpp1UgSVFeqWAXBCp7Dowv8vnZ_w\""
}

resource "ovh_domain_zone_record" "eu_spf" {
  zone      = local.zone_eu
  fieldtype = "SPF"
  ttl       = local.ttl_spf
  target    = local.spf_record
}

resource "ovh_domain_zone_record" "eu_gsuite_mail" {
  count     = length(local.gsuite_mx_records_for_be)
  zone      = local.zone_eu
  fieldtype = "MX"
  ttl       = local.ttl_mx
  target    = local.gsuite_mx_records_for_be[count.index]
}
