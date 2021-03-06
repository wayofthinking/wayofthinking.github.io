
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

  spf      = "\"v=spf1 include:_spf.google.com ~all\""
  dkim_net = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCobrYREvBte0muos5K/UJSErNMG0vC3KYpMIvvCP9cXtl0y6xK+2GipfKWQ3Oc0nGng9kxqI6WYyOjJ4nH6+Nc0OhfyEg2YnyBbBtBYqzdxQSoovgE2cGcpCk7X1jeXgVv60RQwNQ2C9ZlGj5v+pVW0JcPSH9s9Gtuf5y/t150cQIDAQAB"
  dkim_be  = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCsbmGNLcdeTBfyhkk/tcLodYqKQkg3KoGJtNEuiByI+ESg0i/QzbKTqBvwRF77RDgXE79iooFfWp/Kb/UTNgmUK7V+maqO/r+R8o/TfcK/C2sKRc6+QXXSDBXflYsKe1tpyKu/j3oGAGl8HMt1kcnunOtkMYNPF+Ic5A4PFmReJQIDAQAB"
  dkim_eu  = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCEu0esc/eS0zVBXpvHUQNSKM6nxRWDbOfn56BwB10ou3qwv8K81GFpGKqp3gDMRkbDuw6eRc2RTaHxKGrQreGRvGVv1RLF5TMcjVFKXOihukuRoVt4uPV8pzG5nGgBkPHZgqh1ZDHOFgFrtCVbxxBF45EyuloZu6cOEy9GnAM7fQIDAQAB"
  dmarc    = "v=DMARC1; p=none; rua=mailto:admin@wayofthinking.be"
}

module "net" {
  source = "./modules/zone"

  zone         = local.zone_net
  name_servers = local.name_servers
  ipv4         = var.website_ip
  aliases = [
    { subdomain = "www", target = "wayofthinking.github.io." },
    { subdomain = "calendar", target = "ghs.googlehosted.com." },
    { subdomain = "drive", target = "ghs.googlehosted.com." },
    { subdomain = "mail", target = "ghs.googlehosted.com." }
  ]

  google_site_verification = "2V4XwMeXE8SYmcHAQ30NlAUArvR8NFgotefUmO-4x2c"

  mx    = local.gsuite_mx_records_for_net
  spf   = local.spf
  dkim  = local.dkim_net
  dmarc = local.dmarc
}

module "be" {
  source = "./modules/zone"

  zone         = local.zone_be
  name_servers = local.name_servers
  ipv4         = [local.ovh_ip]
  aliases = [
    { subdomain = "www", target = "${local.zone_be}." }
  ]
  redirections = [
    { subdomain = "", type = "visiblePermanent", target = "http://wayofthinking.net" }
  ]

  google_site_verification = "Z85qsHhGDqO317DaUZRgMeCGH44FlJz333T_wgRjiPE"

  mx    = local.gsuite_mx_records_for_be
  spf   = local.spf
  dkim  = local.dkim_be
  dmarc = local.dmarc
}

module "eu" {
  source = "./modules/zone"

  zone         = local.zone_eu
  name_servers = local.name_servers
  ipv4         = [local.ovh_ip]
  aliases = [
    { subdomain = "www", target = "${local.zone_eu}." }
  ]
  redirections = [
    { subdomain = "", type = "visiblePermanent", target = "http://wayofthinking.net" }
  ]

  google_site_verification = "jncyCZipyOxhCFlrpp1UgSVFeqWAXBCp7Dowv8vnZ_w"

  mx    = local.gsuite_mx_records_for_be
  spf   = local.spf
  dkim  = local.dkim_eu
  dmarc = local.dmarc
}
