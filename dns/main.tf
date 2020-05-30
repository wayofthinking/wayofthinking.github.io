
provider "ovh" {
  endpoint           = "ovh-eu"
  version            = "~> 0.5"
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}

locals {
  zone_net = "wayofthinking.net"
  be_zone  = "wayofthinking.be"
  eu_zone  = "wayofthinking.eu"

  # OVH does not accept a TTL lower than 60 !
  ttl    = 86400
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
}

resource "ovh_domain_zone_record" "net_name_server" {
  count     = length(local.ns_records)
  zone      = local.zone_net
  fieldtype = "NS"
  ttl       = 0
  target    = local.ns_records[count.index]
}

resource "ovh_domain_zone_record" "net_wayofthinking" {
  count     = length(var.website_ip)
  zone      = local.zone_net
  fieldtype = "A"
  ttl       = 0
  target    = var.website_ip[count.index]
}

resource "ovh_domain_zone_record" "net_wayofthinking_www" {
  zone      = local.zone_net
  subdomain = "www"
  fieldtype = "CNAME"
  ttl       = 0
  target    = "wayofthinking.github.io."
}

resource "ovh_domain_zone_record" "net_gsuite_site_verification" {
  zone      = local.zone_net
  fieldtype = "TXT"
  ttl       = 60
  target    = "\"google-site-verification=2V4XwMeXE8SYmcHAQ30NlAUArvR8NFgotefUmO-4x2c\""
}

resource "ovh_domain_zone_record" "net_spf" {
  zone      = local.zone_net
  fieldtype = "SPF"
  ttl       = 0
  target    = "\"v=spf1 +all\""
}

resource "ovh_domain_zone_record" "net_gsuite_mail" {
  count     = length(local.gsuite_mx_records_for_net)
  zone      = local.zone_net
  fieldtype = "MX"
  ttl       = 0
  target    = local.gsuite_mx_records_for_net[count.index]
}

resource "ovh_domain_zone_record" "net_gsuite_cname" {
  count     = length(local.gsuite_cname_records)
  zone      = local.zone_net
  subdomain = local.gsuite_cname_records[count.index].subdomain
  fieldtype = "CNAME"
  ttl       = 10800
  target    = local.gsuite_cname_records[count.index].target
}

resource "ovh_domain_zone_record" "be_name_server" {
  count     = length(local.ns_records)
  zone      = local.be_zone
  fieldtype = "NS"
  ttl       = 0
  target    = local.ns_records[count.index]
}

resource "ovh_domain_zone_record" "be_wayofthinking" {
  zone      = local.be_zone
  fieldtype = "A"
  ttl       = 0
  target    = local.ovh_ip
}

resource "ovh_domain_zone_record" "be_wayofthinking_www" {
  zone      = local.be_zone
  subdomain = "www"
  fieldtype = "CNAME"
  ttl       = 0
  target    = "${local.be_zone}."
}

resource "ovh_domain_zone_redirection" "be_wayofthinking" {
  zone      = local.be_zone
  subdomain = ""
  type      = "visiblePermanent"
  target    = "http://wayofthinking.net"
}

resource "ovh_domain_zone_record" "be_gsuite_site_verification" {
  zone      = local.be_zone
  fieldtype = "TXT"
  ttl       = 60
  target    = "\"google-site-verification=Z85qsHhGDqO317DaUZRgMeCGH44FlJz333T_wgRjiPE\""
}

resource "ovh_domain_zone_record" "be_spf" {
  zone      = local.be_zone
  fieldtype = "SPF"
  ttl       = 0
  target    = "\"v=spf1 +all\""
}

resource "ovh_domain_zone_record" "be_gsuite_mail" {
  count     = length(local.gsuite_mx_records_for_be)
  zone      = local.be_zone
  fieldtype = "MX"
  ttl       = 0
  target    = local.gsuite_mx_records_for_be[count.index]
}

resource "ovh_domain_zone_record" "eu_name_server" {
  count     = length(local.ns_records)
  zone      = local.eu_zone
  fieldtype = "NS"
  ttl       = 0
  target    = local.ns_records[count.index]
}

resource "ovh_domain_zone_record" "eu_wayofthinking" {
  zone      = local.eu_zone
  fieldtype = "A"
  ttl       = 0
  target    = local.ovh_ip
}

resource "ovh_domain_zone_record" "eu_wayofthinking_www" {
  zone      = local.eu_zone
  subdomain = "www"
  fieldtype = "CNAME"
  ttl       = 0
  target    = "${local.eu_zone}."
}

resource "ovh_domain_zone_redirection" "eu_wayofthinking" {
  zone      = local.eu_zone
  subdomain = ""
  type      = "visiblePermanent"
  target    = "http://wayofthinking.net"
}

resource "ovh_domain_zone_record" "eu_gsuite_site_verification" {
  zone      = local.eu_zone
  fieldtype = "TXT"
  ttl       = 60
  target    = "\"google-site-verification=jncyCZipyOxhCFlrpp1UgSVFeqWAXBCp7Dowv8vnZ_w\""
}

resource "ovh_domain_zone_record" "eu_spf" {
  zone      = local.eu_zone
  fieldtype = "SPF"
  ttl       = 0
  target    = "\"v=spf1 +all\""
}

resource "ovh_domain_zone_record" "eu_gsuite_mail" {
  count     = length(local.gsuite_mx_records_for_be)
  zone      = local.eu_zone
  fieldtype = "MX"
  ttl       = 0
  target    = local.gsuite_mx_records_for_be[count.index]
}
