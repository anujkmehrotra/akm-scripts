#!/bin/bash

###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM
###########################################################################################################

bakdir="/mnt/Data/FS"

echo "==============================================================================="
echo 'Listing all installed packages respectively to their files ....'
echo "==============================================================================="
# Pkgs Listing
rm -f $bakdir/pkglist.txt && pacman -Qnq > $bakdir/pkglist.txt
echo "All repositories packages listed in the file 'pkglist'."
rm -f $bakdir/optdeplist.txt && comm -13 <(pacman -Qqdt | sort) <(pacman -Qqdtt | sort) > $bakdir/optdeplist.txt
echo "All optional packages listed in the file 'optdeplist'."
rm -f $bakdir/aurpkglist.txt && pacman -Qmq > $bakdir/aurpkglist.txt
echo "All aur built packages listed in the file 'aurpkglist'."

#   Removing my manual build pkg (xanmod) name from the localpkglist
#sed -i '/firefox-appmenu/d' $bakdir/aurpkglist.txt
sed -i '/linux-amd-znver2/d' $bakdir/pkglist.txt

echo
echo "==============================================================================="
echo 'Coping important system files ....'
echo "==============================================================================="
# Important files
cp -f /etc/default/grub $bakdir
echo "File 'grub' copied."
cp -f /etc/pacman.conf $bakdir
echo "File 'pacman.conf' copied."
cp -f /etc/fstab $bakdir
echo "File 'fstab' copied."
cp -f /etc/sddm.conf.d/kde_settings.conf $bakdir
echo "File 'kde_settings.conf' copied."
cp -f /etc/sddm.conf $bakdir
echo "File 'sddm.conf' copied."
cp -f /etc/mkinitcpio.d/* $bakdir
echo "Files of '/etc/mkinitcpio.d' copied."
