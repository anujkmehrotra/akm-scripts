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
    sudo pacman -Qqen > ${bakdir}/pkglist.txt
    sudo pacman -Qqem > ${bakdir}/localpkglist.txt
    sed -i '/linux-xanmod/d' ${bakdir}/localpkglist.txt
echo
echo 'All packages list backuped.'
echo
echo "################################################################"
echo "###########        Done. Please reboot           ###############"
echo "################################################################"
