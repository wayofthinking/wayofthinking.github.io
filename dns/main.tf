
provider "ovh" {
  endpoint           = "ovh-eu"
  version            = "~> 0.5"
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}

locals {
  # OVH does not accept a TTL lower than 60 !
  ttl      = 86400
  net_zone = "wayofthinking.net"
  be_zone  = "wayofthinking.be"
  eu_zone  = "wayofthinking.eu"

  ns_records = [
    "dns109.ovh.net.",
    "ns109.ovh.net."
  ]

  records = [
    { subdomain = "_autodiscover._tcp", fieldtype = "SRV", target = "0 0 443 mailconfig.ovh.net." },
    { subdomain = "_imaps._tcp", fieldtype = "SRV", target = "0 0 993 ssl0.ovh.net." },
    { subdomain = "_submission._tcp", fieldtype = "SRV", target = "0 0 465 ssl0.ovh.net." },
    { subdomain = "autoconfig", fieldtype = "CNAME", target = "mailconfig.ovh.net." },
    { subdomain = "autodiscover", fieldtype = "CNAME", target = "mailconfig.ovh.net." },
    { subdomain = "ftp", fieldtype = "CNAME", target = "wayofthinking.net." },
    { subdomain = "imap", fieldtype = "CNAME", target = "ssl0.ovh.net." },
    { subdomain = "mail", fieldtype = "CNAME", target = "ssl0.ovh.net." },
    { subdomain = "pop3", fieldtype = "CNAME", target = "ssl0.ovh.net." },
    { subdomain = "smtp", fieldtype = "CNAME", target = "ssl0.ovh.net." },
    { subdomain = "www", fieldtype = "TXT", target = "\"3|welcome\"" },
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
  target    = "${local.net_zone}."
}

resource "ovh_domain_zone_redirection" "net_wayofthinking" {
  zone      = local.net_zone
  subdomain = ""
  type      = "visible"
  target    = "www.wayofthinking.net"
}

resource "ovh_domain_zone_record" "net_wayofthinking_records" {
  count     = length(local.records)
  zone      = local.net_zone
  subdomain = local.records[count.index].subdomain
  fieldtype = local.records[count.index].fieldtype
  ttl       = 0
  target    = local.records[count.index].target
}
