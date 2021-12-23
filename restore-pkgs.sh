#!/bin/bash
set -e
##################################################################################################################
# Author        :   AKM
# Distribution  :   Arch Linux only
##################################################################################################################

#   Backup location of some System files
bakdir=/mnt/Recovery/Backup

echo "################################################################"
echo "##########         Restoring packages ....           ###########"
echo "################################################################"
echo
    sudo pacman -S --needed $(comm -12 <(pacman -Slq|sort) <(sort ${bakdir}/pkglist.txt) )
echo
echo "All repositories packages restored."
echo
echo "################################################################"
echo "###########        Done. Please reboot           ###############"
echo "################################################################"
