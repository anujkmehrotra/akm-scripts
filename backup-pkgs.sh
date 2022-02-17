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
    sudo pacman -Qnq >> ${bakdir}/pkglist.txt
# AUR list
    sudo pacman -Qmq >> ${bakdir}/localpkglist.txt
# Remove AUR Packages
    #sed -i '/adwaita-dark/d' ${bakdir}/pkglist.txt
    #sed -i '/chromium-extension-web-store/d' ${bakdir}/pkglist.txt
    #sed -i '/chromium-extension-web-store/d' ${bakdir}/pkglist.txt
    #sed -i '/fragments-git/d' ${bakdir}/pkglist.txt
    #sed -i '/gnome-session-properties/d' ${bakdir}/pkglist.txt
    #sed -i '/grive/d' ${bakdir}/pkglist.txt
    #sed -i '/kora-icon-theme/d' ${bakdir}/pkglist.txt
    #sed -i '/system-monitoring-center/d' ${bakdir}/pkglist.txt
    #sed -i '/zramd/d' ${bakdir}/pkglist.txt

    echo "All packages from repositories and aur backuped."
