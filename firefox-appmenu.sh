#!/bin/bash
set -e
###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author                   : AKM                                                                          #
# Disribution 	           : ArchLinux with AUR (Tested on ArcoLinux only)                                #

package="firefox-appmenu"
loc="/var/tmp"

#   Checking required package
if pacman -Qi paru &> /dev/null; then
       sleep 1
else
echo "======================================================================================="
echo "Missing required package; installing ...."
echo "======================================================================================="
echo
sudo pacman -S paru --noconfirm
fi

#####################################################################################################################

#   Checking and comparing current app version with AUR
cver="$(paru -Qi $package | grep 'Version' | awk '{print $3}')";
nver="$(paru -a -Si $package | grep 'Version' | awk '{print $3}')";
# Source repository
source="https://builds.garudalinux.org/repos/chaotic-aur/x86_64"

#   Checking required package
if [ $cver == $nver ] ; then
        tput setaf 2
echo "==============================================================================="
echo "$package is UP-To-Date. Exiting ...."
echo "==============================================================================="
        tput sgr0
        exit 0

elif pacman -Qi $package &> /dev/null; then
        echo
        tput setaf 2
echo "==============================================================================="
echo "'$package' is downloading. Please wait ...."
echo "==============================================================================="
        tput sgr0
cd $loc
rm -f $package*

wget -q $source/$package-$nver-x86_64.pkg.tar.zst
        echo
sudo pacman -U $package* --needed --noconfirm
        cd "$HOME"

else
        tput setaf 1
echo "==============================================================================="
        echo "'$package' is NOT installed. Do you want to install ? (y/n)";
echo "==============================================================================="
        tput sgr0

        read -r CHOICE
        case $CHOICE in

    y )

        echo
echo "==============================================================================="
        echo "Installing '$package'. Please wait ...."
echo "==============================================================================="
        echo
cd $loc
rm -f $package*

wget -q $source/$package-$nver-x86_64.pkg.tar.zst
        echo
sudo pacman -U $package* --noconfirm
cd "$HOME"
        echo

        tput setaf 2
echo "==============================================================================="
        echo "'$package' installed."
echo "==============================================================================="
        tput sgr0
    ;;

    n )

        echo
        tput setaf 1
echo "==============================================================================="
        echo "You chose not to install the '$package'. Exiting ...."
echo "==============================================================================="
        tput sgr0
   ;;

    * )

        echo
        tput setaf 1
echo "==============================================================================="
        echo "Only allowed 'y/n' to answer. Exiting ...."
echo "==============================================================================="
        tput sgr0

    ;;
    esac
fi
