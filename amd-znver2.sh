#!/bin/bash
set -e
###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM                                                                                 #
# Disribution 	    : ArchLinux with AUR (Tested on ArcoLinux only)                                       #
# Requirement       : AMD Processor (You can change your Processor type (cpuver) in the script too.       #
###########################################################################################################

############################   EDIT THE FOLLOWING ACCORDING YOUR NEED  ####################################

# Use only one linux-(For Zen3 cpu use 'linux-amd') name as in AUR
package="linux-amd-znver2"

#####################  DO NOT EDIT THE FOLLOWING UNTIL YOU KNOW WHAT YOU DOING  ###########################

    #   Checking required package
if pacman -Qi paru &> /dev/null; then
    sleep 1
else
    echo "Missing required package, installing ...."
    sudo pacman -S paru --noconfirm
    sleep 1
fi


#   Checking current kernel version
cver="$(paru -Qi $package | grep 'Version' | awk '{print $3}')";
#   Checking available kernel version
nver="$(paru -a -Si $package | grep 'Version' | awk '{print $3}')";

#   On installed

if pacman -Qi $package &> /dev/null && [ "$nver" == "$cver" ] ; then
        tput setaf 2
        echo "======================================================================================="
        echo "Kernel '$package' version '$nver' is Installed and UP-TO-DATE."
        echo "======================================================================================="
        tput sgr0
        exit 0
else

#   On fresh installation.

        tput setaf 1
        echo "==============================================================================================="
        echo "Kernel '$package' version '$nver' is NOT installed. Do you want to install ? (y/n)";
        echo "==============================================================================================="
        tput sgr0

        read -r CHOICE
        case $CHOICE in

    y )

#   Kernel installation
        paru -a -S --noconfirm $package $package-headers --needed

        tput setaf 2
        echo "======================================================================================="
        echo "Kernel '$package' version '$nver' Installed. Please reboot."
        echo "======================================================================================="
        tput sgr0
    ;;

    n )
        echo
        tput setaf 1
        echo "======================================================================================="
        echo "You chose not to install the Kernel '$package' version '$nver' . Exiting ...."
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
