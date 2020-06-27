
variable "zone" {
  description = "DNS domain"
  type        = string
}

variable "name_servers" {
  description = "IP or domain name of name servers"
  type        = list(string)
}

variable "google_site_verification" {
  description = "GSuite site verification code"
  type        = string
}
