#!/bin/bash
set -e
###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM                                                                                 #
# Disribution 	    : ArchLinux with AUR (Tested on ArcoLinux only)                                       #
###########################################################################################################

############################   EDIT THE FOLLOWING ACCORDING YOUR NEED  ####################################

package="linux-xanmod"
subpkg="linux"
verpkg="bin-x64v2"
#####################  DO NOT EDIT THE FOLLOWING UNTIL YOU KNOW WHAT YOU DOING  ###########################

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

#==========================================================================================================

#   Checking current kernel version
cver="$(paru -Qi "$package-$subpkg-$verpkg" | grep 'Version' | awk '{print $3}')";
#   Checking available kernel version
nver="$(paru -a -Si "$package-$subpkg-$verpkg" | grep 'Version' | awk '{print $3}')";

## Checking if package is already installed or not

echo "======================================================================================="
        echo "Checking Kernel status '${package}' in the system ...."
echo "======================================================================================="
        echo

if pacman -Qi $package &> /dev/null ; then

echo "======================================================================================="
        echo "Kernel '$package' is installed. Checking updates ...." ;
echo "======================================================================================="

elif [ "$nver" == "$cver" ] ; then

        tput setaf 2
echo "======================================================================================="
        echo "Kernel '$package' version '$cver' is UP-To-Date." ;
echo "======================================================================================="
        tput sgr0
        exit 0

else

        tput setaf 1
        echo
echo "==============================================================================================================="
        echo "Kernel '$package' version '$nver' is NOT installed. Do you want to install ? (y/n)";
echo "==============================================================================================================="
        tput sgr0

        read -r CHOICE
        case $CHOICE in

    y )
        echo
echo "======================================================================================="
        echo "Installing Kernel '$package' ...."
echo "======================================================================================="
        echo
paru -a -S --noconfirm $package-$subpkg-$verpkg $package-$subpkg-headers-$verpkg
        echo
        tput setaf 1
echo "======================================================================================="
        echo "Kernel '$package' installed. Please reboot."
echo "======================================================================================="
        tput sgr0
    ;;

    n )
        echo
        tput setaf 1
echo "======================================================================================="
        echo "You chose not to install the Kernel '$package'. Exiting ...."
echo "======================================================================================="
        tput sgr0

   ;;

    * )
        echo
        tput setaf 1
echo "======================================================================================="
        echo "Only allowed 'y/n' to answer. Exiting ...."
echo "======================================================================================="
        tput sgr0

    ;;
    esac

fi
