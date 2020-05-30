
provider "ovh" {
  endpoint           = "ovh-eu"
  version            = "~> 0.5"
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}

locals {
  # OVH does not accept a TTL lower than 60 !
  ttl     = 86400
  net_zone = "wayofthinking.net"
  be_zone = "wayofthinking.be"
  eu_zone = "wayofthinking.eu"

  ip = "213.186.33.5"

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

  gsuite_mx_records_for_net = concat(local.gsuite_mx_records_for_be,
  [
    "5 aspmx4.googlemail.com.",
    "5 aspmx5.googlemail.com."
  ])

  gsuite_cname_records = [
    { subdomain = "calendar", target = "ghs.googlehosted.com." },
    { subdomain = "drive", target = "ghs.googlehosted.com." },
    { subdomain = "mail", target = "ghs.googlehosted.com." }
  ]

  net_records = [
    { subdomain = "_autodiscover._tcp", fieldtype = "SRV", target = "0 0 443 mailconfig.ovh.net." },
    { subdomain = "_imaps._tcp", fieldtype = "SRV", target = "0 0 993 ssl0.ovh.net." },
    { subdomain = "_submission._tcp", fieldtype = "SRV", target = "0 0 465 ssl0.ovh.net." },
    { subdomain = "www", fieldtype = "TXT", target = "\"3|welcome\"" },
  ]

  be_records = [
    { subdomain = "_autodiscover._tcp", fieldtype = "SRV", target = "0 0 443 mailconfig.ovh.net." },
    { subdomain = "_imaps._tcp", fieldtype = "SRV", target = "0 0 993 ssl0.ovh.net." },
    { subdomain = "_submission._tcp", fieldtype = "SRV", target = "0 0 465 ssl0.ovh.net." },
    { subdomain = "autoconfig", fieldtype = "CNAME", target = "mailconfig.ovh.net." },
    { subdomain = "autodiscover", fieldtype = "CNAME", target = "mailconfig.ovh.net." },
    { subdomain = "ftp", fieldtype = "CNAME", target = "wayofthinking.be." },
    { subdomain = "imap", fieldtype = "CNAME", target = "ssl0.ovh.net." },
    { subdomain = "mail", fieldtype = "CNAME", target = "ssl0.ovh.net." },
    { subdomain = "pop3", fieldtype = "CNAME", target = "ssl0.ovh.net." },
    { subdomain = "smtp", fieldtype = "CNAME", target = "ssl0.ovh.net." },
  ]

  eu_records = [
    { subdomain = "_autodiscover._tcp", fieldtype = "SRV", target = "0 0 443 mailconfig.ovh.net." },
    { subdomain = "_imaps._tcp", fieldtype = "SRV", target = "0 0 993 ssl0.ovh.net." },
    { subdomain = "_submission._tcp", fieldtype = "SRV", target = "0 0 465 ssl0.ovh.net." },
    { subdomain = "autoconfig", fieldtype = "CNAME", target = "mailconfig.ovh.net." },
    { subdomain = "autodiscover", fieldtype = "CNAME", target = "mailconfig.ovh.net." },
    { subdomain = "ftp", fieldtype = "CNAME", target = "wayofthinking.eu." },
    { subdomain = "imap", fieldtype = "CNAME", target = "ssl0.ovh.net." },
    { subdomain = "mail", fieldtype = "CNAME", target = "ssl0.ovh.net." },
    { subdomain = "pop3", fieldtype = "CNAME", target = "ssl0.ovh.net." },
    { subdomain = "smtp", fieldtype = "CNAME", target = "ssl0.ovh.net." },
  ]
}

resource "ovh_domain_zone_record" "net_name_server" {
  count     = length(local.ns_records)
  zone      = local.net_zone
  fieldtype = "NS"
  ttl       = 0
  target    = local.ns_records[count.index]
}

resource "ovh_domain_zone_record" "net_wayofthinking" {
  count     = length(var.website_ip)
  zone      = local.net_zone
  fieldtype = "A"
  ttl       = 0
  target    = var.website_ip[count.index]
}

resource "ovh_domain_zone_record" "net_wayofthinking_www" {
  zone      = local.net_zone
  subdomain = "www"
  fieldtype = "CNAME"
  ttl       = 0
  target    = "wayofthinking.github.io."
}

resource "ovh_domain_zone_record" "net_gsuite_site_verification" {
  zone      = local.net_zone
  fieldtype = "TXT"
  ttl       = 60
  target    = "\"google-site-verification=2V4XwMeXE8SYmcHAQ30NlAUArvR8NFgotefUmO-4x2c\""
}

resource "ovh_domain_zone_record" "net_gsuite_mail" {
  count     = length(local.gsuite_mx_records_for_net)
  zone      = local.net_zone
  fieldtype = "MX"
  ttl       = 0
  target    = local.gsuite_mx_records_for_net[count.index]
}

resource "ovh_domain_zone_record" "net_gsuite_cname" {
  count     = length(local.gsuite_cname_records)
  zone      = local.net_zone
  subdomain = local.gsuite_cname_records[count.index].subdomain
  fieldtype = "CNAME"
  ttl       = 10800
  target    = local.gsuite_cname_records[count.index].target
}

resource "ovh_domain_zone_record" "net_wayofthinking_records" {
  count     = length(local.net_records)
  zone      = local.net_zone
  subdomain = local.net_records[count.index].subdomain
  fieldtype = local.net_records[count.index].fieldtype
  ttl       = 0
  target    = local.net_records[count.index].target
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
  target    = local.ip
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

resource "ovh_domain_zone_record" "be_gsuite_mail" {
  count     = length(local.gsuite_mx_records_for_be)
  zone      = local.be_zone
  fieldtype = "MX"
  ttl       = 0
  target    = local.gsuite_mx_records_for_be[count.index]
}

resource "ovh_domain_zone_record" "be_wayofthinking_records" {
  count     = length(local.be_records)
  zone      = local.be_zone
  subdomain = local.be_records[count.index].subdomain
  fieldtype = local.be_records[count.index].fieldtype
  ttl       = 0
  target    = local.be_records[count.index].target
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
  target    = local.ip
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

resource "ovh_domain_zone_record" "eu_gsuite_mail" {
  count     = length(local.gsuite_mx_records_for_be)
  zone      = local.eu_zone
  fieldtype = "MX"
  ttl       = 0
  target    = local.gsuite_mx_records_for_be[count.index]
}

resource "ovh_domain_zone_record" "eu_wayofthinking_records" {
  count     = length(local.eu_records)
  zone      = local.eu_zone
  subdomain = local.eu_records[count.index].subdomain
  fieldtype = local.eu_records[count.index].fieldtype
  ttl       = 0
  target    = local.eu_records[count.index].target
}
