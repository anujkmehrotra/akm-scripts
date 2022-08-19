#!/bin/bash
set -e
###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM                                                                                 #
# Disribution 	    : ArchLinux with AUR (Tested on ArcoLinux only)                                       #
###########################################################################################################

package="linux-xanmod"

#   Checking required package
    if pacman -Qi ${package} &> /dev/null; then
        echo "Checking current running kernel ...."
    sleep 1
    else
        echo "'${package}' is NOT installed.";
        exit 1
    fi

#   Checking running kernel status.

kernel="$(uname -r | cut -b 9,10,11,12,13,14)";
pakage="xanmod"

#   On running kernel

    if [ "${kernel}" == "${pakage}" ]; then
    sleep 1
        tput setaf 1
		echo "======================================================================================="
        echo "Xanmod Kernel is currently running. Removal request denied."
        echo "You must boot from a different kernel to remove it."
		echo "======================================================================================="
        tput sgr0
		exit 1
#   On not running kernel

elif [ -z "${check}" ] ; then
    sleep 1
        tput setaf 2
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

        sudo pacman -R --noconfirm ${package} ${package}-headers
    sleep 1
        sudo grub-mkconfig -o /boot/grub/grub.cfg

        echo
        echo "======================================================================================="
        echo "'${package}' removed. Please reboot."
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
