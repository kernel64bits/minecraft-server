#!/bin/bash
# Monte le volume persistent, configure dyndns, met à jour les paquets, install docker, et lancer le serveur minecraft 

mount /dev/sdb /mnt
# Update dynDNS
curl -m 5 --user "LOGIN:PASSWORD" "https://www.ovh.com/nic/update?system=dyndns&hostname=<SERVICE_FQDN>&myip=$(curl -s https://api.ipify.org)"

apt-get -y update
apt-get upgrade -y

apt-get -y install ca-certificates curl
apt purge -y docker.io docker-compose docker-compose-v2 docker-doc podman-docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

docker compose -f /mnt/docker-compose.yaml up -d
