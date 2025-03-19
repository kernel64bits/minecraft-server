# Définir les providers et fixer les versions
terraform {
required_version    = ">= 0.14.0"                    # Prend en compte les versions de terraform à partir de la 0.14.0
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.42.0"
    }

    ovh = {
      source  = "ovh/ovh"
      version = ">= 0.13.0"
    }
  }
}

# Configure le fournisseur OpenStack hébergé par OVHcloud
provider "openstack" {
  auth_url    = "https://auth.cloud.ovh.net/v3/"    # URL d'authentification
  domain_name = "default"                           # Nom de domaine - Toujours à "default" pour OVHcloud
  alias       = "ovh"                               # Un alias
}

provider "ovh" {
  alias              = "ovh"
  endpoint           = "ovh-eu"
  application_key    = "201eed5b67295fc0"
  application_secret = "df0b6a1836b9cb61caa3ed635f24ccb1"
  consumer_key       = "8daf45591ade2a912dc6c7955c2f82a9"
}
