#!/bin/bash

###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM                                                                                 #
# Disribution       : Arch Linux                                                                          #
###########################################################################################################

#   Backup location of some System files
    bakdir=/mnt/Data/Backup
    rm -f ${bakdir}/pkglist.txt && rm -f ${bakdir}/localpkglist.txt

# Repos list
    pacman -Qnq >> ${bakdir}/pkglist.txt
# AUR list
    pacman -Qmq >> ${bakdir}/localpkglist.txt
# Remove self build packages
    sed -i '/linux-xanmod/d' ${bakdir}/localpkglist.txt
    sed -i '/linux-xanmod/d' ${bakdir}/pkglist.txt
    echo "All packages from repositories and aur backuped."
