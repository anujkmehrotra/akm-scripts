#!/bin/bash
set -e
###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM                                                                                 #
# Disribution 	    : ArchLinux with AUR (Tested on ArcoLinux only)                                       #
###########################################################################################################

package="linux-xanmod-edge"

#   Checking required package
    if pacman -Qi ${package} &> /dev/null; then
        echo "Checking current running kernel ...."
    sleep 1
    else
        echo "'${package}' is NOT installed.";
        exit
    fi

#   Checking running kernel status.

kernel="$(uname -r | grep "xanmod" | cut -c 9-14)";
pakage="xanmod"

#   On running kernel

    if [ "${kernel}" == "${pakage}" ]; then
    sleep 1
        echo "Kernel '${package}' is currently running. Removal request denied."

#   On not running kernel

elif [ -z "${check}" ] ; then
    sleep 1
        tput setaf 1
        echo
        echo "======================================================================================="
        echo "Do you want to remove '${package}'? (y/n)";
        echo "======================================================================================="
        tput sgr0

    read CHOICE
    case $CHOICE in

    y )
        echo
        echo "======================================================================================="
        echo "Removing '${package}' ...."
        echo "======================================================================================="

        #sudo pacman -R --noconfirm ${package} ${package}-headers
    sleep 1
        #sudo grub-mkconfig -o /boot/grub/grub.cfg

        echo
        echo "======================================================================================="
        echo "'&{package}' removed. Please reboot."
        echo "======================================================================================="

    ;;

    n )
        echo
        echo "======================================================================================="
        echo "You chose not to remove the Kernel."
        echo "======================================================================================="

    ;;

    * )
        echo
        echo "======================================================================================="
        echo "Only allowed 'y/n' to answer."
        echo "======================================================================================="

    ;;

    esac
fi
