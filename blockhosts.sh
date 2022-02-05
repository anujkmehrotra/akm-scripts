#!/bin/bash

tmpl="/mnt/RamDisk"
file="hosts"
target="/etc/hosts"
service="NetworkManager.service"

cd ${tmpl}
rm -f ${file}
curl https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts -O
sudo mv -f ${file} ${target}
sudo systemctl restart ${service}
echo "Hosts file updated successfully."
cd ~
