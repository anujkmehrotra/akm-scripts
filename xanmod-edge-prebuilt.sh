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

pkg1="linux-xanmod-edge-linux-bin-x64v2"
pkg2="linux-xanmod-edge-linux-headers-bin-x64v2"

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
    sleep 1
fi


## Checking if package is already installed or not

        echo "======================================================================================="
        echo "Checking Kernel status '${pkg1}' in the system ...."
        echo "======================================================================================="
        echo

check="$(pacman -Qs --color always "${pkg1}" | grep "local" | grep "${pkg1} ")";

if [ -n "${check}" ] ; then

        sleep 1

elif [ -z "${check}" ] ; then

        tput setaf 1
        echo "======================================================================================="
        echo "Kernel '$pkg1' is NOT installed. Do you want to install ? (y/n)";
        echo "======================================================================================="
        tput sgr0

        read -r CHOICE
        case $CHOICE in

    y )
        echo
        echo "======================================================================================="
        echo "Installing Kernel '$pkg1' ...."
        echo "======================================================================================="
        echo
        paru -a-S --needed $pkg1 $pkg2 --noconfirm
        echo
        tput setaf 2
        echo "======================================================================================="
        echo "Kernel '$pkg1' installed. Please reboot."
        echo "======================================================================================="
        tput sgr0
    ;;

    n )
        echo
        tput setaf 1
        echo "======================================================================================="
        echo "You chose not to install the Kernel '$pkg1'. Exiting ...."
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

#   Checking current kernel version
    cver="$(paru -Qi $pkg1 | grep 'Version' | awk '{print $3}')";
#   Checking available kernel version
    nver="$(paru -a -Si $pkg1 | grep 'Version' | awk '{print $3}')";

if [ "$nver" == "$cver" ] ; then
        tput setaf 2
        echo "======================================================================================="
        echo "Kernel '$pkg1' version '$cver' is UP-To-Date."
        echo "======================================================================================="
        tput sgr0
        exit 0
else

#   On an update ....

        echo "==================================================================================================="
        echo "Kernel '$pkg1' - $cver needs an update to '$nver'. Update ?? (y/n)";
        echo "==================================================================================================="
        tput sgr0

        read -r CHOICE
        case $CHOICE in

    y )
        echo
        echo "==================================================================================================="
        echo "Updating Kernel '$pkg1' version '$cver' to '$nver' ...."
        echo "==================================================================================================="
        echo
        paru -a-S --needed $pkg1 $pkg2 --noconfirm
        echo
        tput setaf 2
        echo "==================================================================================================="
        echo "Kernel '$pkg1' version '$cver' updated to ''$nver'. Please reboot."
        echo "==================================================================================================="
        tput sgr0
    ;;

    n )
        echo
        tput setaf 1
        echo "==================================================================================================="
        echo "You chose not to install the Kernel '$pkg1' version '$nver' . Exiting ...."
        echo "==================================================================================================="
        tput sgr0

   ;;

    * )
        echo
        tput setaf 1
        echo "==================================================================================================="
        echo "Only allowed 'y/n' to answer. Exiting ...."
        echo "==================================================================================================="
        tput sgr0

    ;;
    esac
fi
fi
