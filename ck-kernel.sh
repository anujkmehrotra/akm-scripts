#!/bin/bash
set -e

###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ############################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ##############################################
###########################################################################################################
# Author            : AKM                                                                                 #
# Disribution 	    : ArchLinux with AUR (Tested on ArcoLinux only)                                       #
# Requirement   1   : AUR handler (yay/paru). Can be choose manually in the script.                       #
#               2   : package 'modprobed-db' as kernel building helper                                    #
###########################################################################################################
#################### EDIT THE FOLLOWING ACCORDING YOUR NEED. USE PROPER VARIABLES #################################
###########################################################################################################

#   AUR handler (Change if you want to change the whole command in the main process below)
handler="paru"
#   package building location                                                                 (Changable) #
tmpdir="/mnt/RamDisk"
#   location to keep build (.zst) files of kernel to resuse later if needed                   (Changable) #
insdir="/mnt/Data/Kernel"

###########################################################################################################
#####################  DO NOT EDIT THE FOLLOWING UNTIL YOU KNOW WHAT YOU DOING  ##################################
###########################################################################################################

#   Kernel building helper
helper="modprobed-db"

#   Checking required package
if pacman -Qi ${handler} ${helper} &> /dev/null; then
        echo "======================================================================================="
        echo "Please wait while we check the Kernel status for you ...."
        echo "======================================================================================="
      sleep 1
else
        echo "======================================================================================="
        echo "Installing required package(s) and enabling service ...."
        echo "======================================================================================="

        sudo pacman -S --needed --noconfirm ${handler} ${helper}
        systemctl --user enable --now ${helper}.service
        ${helper} list
fi

#   Kernel name as in AUR
package="linux-ck"

#   Comparing kernel versions
cver="$(${handler} -Qi ${package} | grep "Version" | cut -c 19-27)"
nver="$(${handler} -a -Si ${package} | grep "Version" | cut -c 19-27)"

#   Checking kernel status
if pacman -Qi ${package} &> /dev/null && [ "${nver}" == "${cver}" ]; then
        tput setaf 2
          echo "======================================================================================="
          echo "Kernel '${package}' version '${nver}' is already installed."
          echo "======================================================================================="
        tput sgr0
	        exit 1;

else
      tput setaf 1
          echo "======================================================================================="
          echo "Kernel '${package}' version '${nver}' is not installed."
	        echo
          echo "Do you want to install ? (y/n)";
          echo "======================================================================================="
        tput sgr0

      read CHOICE
      case $CHOICE in

      y )
          echo "======================================================================================="
          echo "Updating modprobe moudules ....."
          echo "======================================================================================="

          ${helper} store

          echo "======================================================================================="
          echo "Building kernel '${package}' version '${nver}' . Please wait ....."
          echo "======================================================================================="

          ${handler} -a -S ${package} ${package}-headers

          echo "======================================================================================="
          echo "Updating grub ...."
          echo "======================================================================================="
        sleep 1
          sudo grub-mkconfig -o /boot/grub/grub.cfg

          echo "======================================================================================="
          echo "Completing installation ...."
          echo "======================================================================================="

          rm -f ${insdir}/*
          mv -f ${tmpdir}/${handler}/${package}/${package}* ${insdir}

          echo "======================================================================================="
   	  echo "Building kernel '${package}' version '${nver}' completed. Please reboot."
 	  echo "======================================================================================="

      ;;

      n )
          echo "======================================================================================="
          echo "You chose not to install the Kernel '${package}' version '${nver}' ."
          exit 1;
          echo "======================================================================================="

      ;;

      * )
          echo "======================================================================================="
          echo "Only allowed 'y/n' to answer. Retry again."
          echo "======================================================================================="
      ;;

      esac
fi
