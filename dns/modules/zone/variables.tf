
variable "zone" {
  description = "DNS domain"
  type        = string
}

variable "name_servers" {
  description = "IP or domain name of name servers"
  type        = list(string)
}

variable "google_site_verification" {
  description = "Verification code used by GSuite to check for ownership"
  type        = string
}

variable "spf" {
  description = "SPF record"
  type        = string
}
