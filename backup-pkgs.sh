#!/bin/bash
set -e
##################################################################################################################
# Author        :   AKM
# Distribution  :   Arch Linux only
##################################################################################################################

#   Backup location of some System files
bakdir=/mnt/Data/Backup

    sudo pacman -Qqen > ${bakdir}/pkglist.txt
    sudo pacman -Qqem > ${bakdir}/localpkglist.txt
    sed -i '/linux-ck/d' ${bakdir}/localpkglist.txt

echo 'All packages list backuped.'
