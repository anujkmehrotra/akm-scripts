#!/bin/bash
set -e
##################################################################################################################
# Author        :   AKM
# Distribution  :   Arch Linux only
##################################################################################################################

#   Backup location of some System files
bakdir=/mnt/Recovery/Backup

echo "################################################################"
echo "##########         Backing up packages ....          ###########"
echo "################################################################"
sudo pacman -Qqe > ${bakdir}/pkglist.txt
echo
echo 'All packages list backuped.'
echo
echo "################################################################"
echo "###########        Done. Please reboot           ###############"
echo "################################################################"
