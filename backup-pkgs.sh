#!/bin/bash
set -e
##################################################################################################################
# Author        :   AKM
# Distribution  :   Arch Linux only
##################################################################################################################

#   Backup location of some System files
    bakdir=/mnt/Data/Backup
    rm -f ${bakdir}/pkglist.txt && rm -f ${bakdir}/localpkglist.txt

# Repos list
    pacman -Qnq >> ${bakdir}/pkglist.txt
# AUR list
    pacman -Qmq >> ${bakdir}/localpkglist.txt
# Remove self build packages
    sed -i '/linux-xanmod/d' ${bakdir}/localpkglist.txt
    
    echo "All packages from repositories and aur backuped."
