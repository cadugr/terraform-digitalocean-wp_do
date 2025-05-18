terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~>2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

module "wp_stack" {
  source  = "cadugr/wp_do/digitalocean"
  version = "1.0.0"

  region      = var.region
  wp_vm_count = var.wp_vm_count
  vms_ssh     = digitalocean_ssh_key.ssh-key.fingerprint
}

resource "digitalocean_ssh_key" "ssh-key" {
  name       = "wp-ssh"
  public_key = file("~/.ssh/aula-terraform.pub")
}