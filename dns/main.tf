
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

  name_servers = [
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

  spf        = "\"v=spf1 include:_spf.google.com ~all\""
  dkim_net   = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCobrYREvBte0muos5K/UJSErNMG0vC3KYpMIvvCP9cXtl0y6xK+2GipfKWQ3Oc0nGng9kxqI6WYyOjJ4nH6+Nc0OhfyEg2YnyBbBtBYqzdxQSoovgE2cGcpCk7X1jeXgVv60RQwNQ2C9ZlGj5v+pVW0JcPSH9s9Gtuf5y/t150cQIDAQAB"
  dkim_be    = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCsbmGNLcdeTBfyhkk/tcLodYqKQkg3KoGJtNEuiByI+ESg0i/QzbKTqBvwRF77RDgXE79iooFfWp/Kb/UTNgmUK7V+maqO/r+R8o/TfcK/C2sKRc6+QXXSDBXflYsKe1tpyKu/j3oGAGl8HMt1kcnunOtkMYNPF+Ic5A4PFmReJQIDAQAB"
  dkim_eu    = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCEu0esc/eS0zVBXpvHUQNSKM6nxRWDbOfn56BwB10ou3qwv8K81GFpGKqp3gDMRkbDuw6eRc2RTaHxKGrQreGRvGVv1RLF5TMcjVFKXOihukuRoVt4uPV8pzG5nGgBkPHZgqh1ZDHOFgFrtCVbxxBF45EyuloZu6cOEy9GnAM7fQIDAQAB"
}

module "net" {
  source = "./modules/zone"

  zone                     = local.zone_net
  name_servers             = local.name_servers
  google_site_verification = "2V4XwMeXE8SYmcHAQ30NlAUArvR8NFgotefUmO-4x2c"
  mx = local.gsuite_mx_records_for_net
  spf = local.spf
  dkim = local.dkim_net
}

module "be" {
  source = "./modules/zone"

  zone         = local.zone_be
  name_servers = local.name_servers
  google_site_verification = "Z85qsHhGDqO317DaUZRgMeCGH44FlJz333T_wgRjiPE"
  mx = local.gsuite_mx_records_for_be
  spf = local.spf
  dkim = local.dkim_be
}

module "eu" {
  source = "./modules/zone"

  zone         = local.zone_eu
  name_servers = local.name_servers
  google_site_verification = "jncyCZipyOxhCFlrpp1UgSVFeqWAXBCp7Dowv8vnZ_w"
  mx = local.gsuite_mx_records_for_be
  spf = local.spf
  dkim = local.dkim_eu
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

resource "ovh_domain_zone_record" "net_gsuite_cname" {
  count     = length(local.gsuite_cname_records)
  zone      = local.zone_net
  subdomain = local.gsuite_cname_records[count.index].subdomain
  fieldtype = "CNAME"
  ttl       = local.ttl_a
  target    = local.gsuite_cname_records[count.index].target
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
