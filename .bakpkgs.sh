#!/bin/bash

bakdir="/mnt/Data/Linux/FS"

# Pkgs List
rm -f $bakdir/pkglist.txt && pacman -Qnq > $bakdir/pkglist.txt
echo "All repositories packages listed in the file 'pkglist'."
rm -f $bakdir/optdeplist.txt && comm -13 <(pacman -Qqdt | sort) <(pacman -Qqdtt | sort) > $bakdir/optdeplist.txt
echo "All optional packages listed in the file 'optdeplist'."
rm -f $bakdir/aurpkglist.txt && pacman -Qmq > $bakdir/aurpkglist.txt
echo "All aur built packages listed in the file 'aurpkglist'."
#   Removing my manual build pkg (CK kernel) name from the localpkglist
sed -i '/linux-xanmod/d' $bakdir/aurpkglist.txt
#sed -i '/linux-xanmod/d' $bakdir/pkglist.txt

# Important files
cp -f /etc/default/grub $bakdir
echo "File 'grub' copied."
cp -f /etc/pacman.conf $bakdir
echo "File 'pacman.conf' copied."
cp -f /etc/fstab $bakdir
echo "File 'fstab' copied."
