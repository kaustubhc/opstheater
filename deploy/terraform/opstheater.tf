resource "digitalocean_droplet" "host" {
    image = "centos-7-0-x64"
    name = "${var.host}.${var.domain}"
    region = "ams2"
    size = "512mb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]
  connection {
      user = "root"
      type = "ssh"
      key_file = "${var.pvt_key}"
      timeout = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo yum update -y -q",
      "/bin/yum install -y -q epel-release http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm",
      "/bin/yum install -y -q puppet-agent",
      "/opt/puppetlabs/bin/puppet config set --section main server ${var.host}.${var.domain}",
      "/opt/puppetlabs/bin/puppet agent -t || true"
    ]
  }
}
