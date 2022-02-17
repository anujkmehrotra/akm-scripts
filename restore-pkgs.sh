#!/bin/bash
set -e
##################################################################################################################
# Author        :   AKM
# Distribution  :   Arch Linux only
##################################################################################################################

#   Backup location pgklist.txt files
bakdir="/mnt/Data/Backup"
#   AUR handler                                                                               (Changable) #
handler="paru"

  echo "================================================================"
  echo "Restoring packages from all repositories ...."
  echo "================================================================"
  sudo pacman -Syy
  sudo pacman -S --needed $(comm -12 <(pacman -Slq|sort) <(sort ${bakdir}/pkglist.txt) )  
  # or  
  #sudo pacman -S --needed $(< ${bakdir}/pkglist.txt)
echo

if pacman -Qi ${handler} &> /dev/null; then

  echo "================================================================"
  echo "Restoring packages AUR ...."
  echo "================================================================"

    sleep 1
    ${handler} -a -S --needed - < ${bakdir}/localpkglist.txt

else

  echo "================================================================"
  echo "Installing AUR handler and restoring AUR packages ...."
  echo "================================================================"

    sudo pacman -S --needed --noconfirm ${handler}
    ${handler} -a -S --needed - < ${bakdir}/localpkglist.txt
fi

echo
  echo "================================================================"
  echo "All repositories and AUR packages restored. Please reboot."
  echo "================================================================"
