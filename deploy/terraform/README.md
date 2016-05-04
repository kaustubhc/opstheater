Use like this:

0. Make sure you have installed terraform locally (https://www.terraform.io/intro/getting-started/install.html)

1. Create a token at Digital Ocean

2. Create a passwordless ssh key and upload the public key to digital ocean, then note down the fingerprint

3. Run a command like the following:

```
terraform apply \
  -var "do_token=_yourtokenhere_" \
  -var "pub_key=/Users/johndoe/.ssh/od_digitalocean_passwordless.pub" \
  -var "pvt_key=/Users/johndoe/.ssh/od_digitalocean_passwordless" \
  -var "ssh_fingerprint=67:98:56:a4:f9:cf:6a:ba:ad:1d:e6:9d:17:a5:bf:c4" \
  -var "host=myhost.example.com"
```
