variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}
variable "host" {
  default = "puppet"
}
variable "domain" {
  default = "opstheater.vm"
}

provider "digitalocean" {
  token = "${var.do_token}"
}
