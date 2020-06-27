
variable "zone" {
  description = "DNS domain"
  type        = string
}

variable "name_servers" {
  description = "IP or domain name of name servers"
  type        = list(string)
}

variable "ipv4" {
  description = "List of A record target IPs"
  type        = list(string)
}

variable "aliases" {
  description = "List of CNAME aliases"
  type        = list(object({
    subdomain = string
    target    = string
  }))
}

variable "google_site_verification" {
  description = "Verification code used by GSuite to check for ownership"
  type        = string
}

variable "mx" {
  description = "MX records"
  type        = list(string)
}

variable "spf" {
  description = "SPF record"
  type        = string
}

variable "dkim" {
  description = "DKIM record"
  type        = string
}
