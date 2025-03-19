# Création d'une ressource de paire de clés SSH
resource "openstack_compute_keypair_v2" "alpine" {
  provider   = openstack.ovh             # Nom du fournisseur déclaré dans provider.tf
  name       = "keypair_alpine_terraform"            # Nom de la clé SSH à utiliser pour la création
  public_key = file("../../credentials/id_ed25518.pub") # Chemin vers votre clé SSH précédemment générée
}

# Création d'une instance
resource "openstack_compute_instance_v2" "minecraft-server" {
  name        = "minecraft-server" 
  provider    = openstack.ovh
  # image_name  = "Ubuntu 24.04"
  image_name  = "minecraft-server"
  flavor_name = "d2-2"
  key_pair    = openstack_compute_keypair_v2.alpine.name
  user_data   = file("cloud-init-server-lite.sh")
  network {
    name      = "Ext-Net" # Ajoute le composant réseau pour atteindre votre instance
  }
    lifecycle {
    # OVHcloud met régulièrement à jour l’image de base d’un OS donné afin que le client ait moins de paquets à mettre à jour après le lancement d’une nouvelle instance
    # Pour éviter que terraform ne rencontre des problèmes avec cela, la commande ignore_changes suivante est requise.
    ignore_changes = [
      image_name
    ]
  }
}

resource "openstack_compute_volume_attach_v2" "attach" {
  instance_id = openstack_compute_instance_v2.minecraft-server.id
  volume_id   = "b71c740d-7f1a-4c57-8def-0584962042ef"
}

