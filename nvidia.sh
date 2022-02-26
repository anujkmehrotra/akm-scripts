#!/bin/bash

###########################################################################################################
# Author            : AKM
# Disribution 	    : Arch Linux only
# required Pkg      : paru (sudo pacman -S paru)
###########################################################################################################
###############################  PLEASE READ THE SCRIPT BEFORE USING  #####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################

# Nvidia Installer
handler="paru"
package1="nvidia-settings nvidia-utils lib32-nvidia-utils opencl-nvidia lib32-opencl-nvidia egl-wayland eglexternalplatform"
package2="nvidia-dkms"
package3="nvidia-tweaks"

#   Checking required package
if pacman -Qi ${handler} &> /dev/null; then
        echo "All required packages are now installed. Loading Nvidia installer ...."
else
        echo "Installing AUR Handler '${handler}' ...."
        sudo pacman -S ${handler} --noconfirm
fi

echo "============================================================================"
echo "               Choose only ONE Nvidia driver at a time."
echo "                     AUR support is required."
echo "============================================================================"
echo
echo "1.  Nvidia   DKMS   (only nvidia-dkms with required pkgs)"
echo
tput setaf 1
echo "---------------------------Advanced--------------------------"
echo
echo "2.  Nvidia   Tweaks (nvidia-dkms with nvidia-tweaks)"
echo "Info : nvidia tweaks may not work with Gnome desktop"
echo "-------------------------------------------------------------"
tput sgr0
echo
echo "3.  Remove Nvidia   (DKMS with or without Tweaks)"
echo
echo "4.  Exit / Leave      (Do not install Nvidia)"
echo
echo "Type the number..."

read CHOICE

case $CHOICE in

    1 )
## Checking if package is already installed or not
        echo "Checking ${package2} in system ...."

    check="$(pacman -Qs --color always "${package2}" | grep "local" | grep "${package2} ")";

    if [ -n "${check}" ] ; then
        sleep 1
        echo "${package2} is already installed";
    elif [ -z "${check}" ] ; then
        sleep 1
        echo "${package2} is NOT installed"

        tput setaf 2
        echo
	echo "============================================================================"
	echo "${package2} is installing ...."
	echo "============================================================================"
	tput sgr0
        echo
        sudo pacman -S --needed ${package2}
        sudo pacman -S --needed ${package1}
        echo "Nvidia has successfully installed in the system."

    fi
    ;;

    2 )
##  Checking if package is already installed or not
        echo "Checking ${package3} in system ...."

    check="$(pacman -Qs --color always "${package3}" | grep "local" | grep "${package3} ")";

    if [ -n "${check}" ] ; then
        sleep 1
        echo "${package3} is already installed";
    elif [ -z "${check}" ] ; then
        sleep 1
        echo "${package3} is NOT installed"

        tput setaf 2
        echo
	echo "============================================================================"
	echo "'${package3}' is installing ...."
	echo "============================================================================"
	tput sgr0
        echo
        sudo pacman -S ${package2}
        sudo pacman -S --needed ${package1}
        ${handler} -a -S ${package3}
        echo "Nvidia Tweaks and others packages have successfully installed in the system. Reboot now. "

    fi
    ;;

    3 )
## Checking if package is already installed or not
        echo "Checking ${package2} in system ...."

    check="$(pacman -Qs --color always "${package2}" | grep "local" | grep "${package2} ")";

    if [ -n "${check}" ] ; then
        sleep 1
        echo "${package2} is installed"

        tput setaf 3

        echo "============================================================================"
        echo "Do you want to remove ${package2} from the system?"
        echo "Proceed with cautions!! (y/n)";
        echo "============================================================================"
        echo
    read CHOICE
    case $CHOICE in

    y )
        echo "============================================================================"
	echo "${package2} is uninstalling ...."
	echo "============================================================================"
        sudo pacman -Rcns ${package2} --noconfirm
        sudo pacman -R ${package1} --noconfirm
        echo "Nvidia package has successfully removed from the system."
        echo "Info : Rebooting without any graphical driver can cause a blank screen."
        tput sgr0
    ;;

    n )
        echo "You chose not to remove the ${package2} from the system."
        exit
    ;;

    * )
        echo "============================================================================"
        echo "Type y/n only."
        echo "============================================================================"
    ;;

    esac

    elif [ -z "${check}" ] ; then
        echo "${package2} is NOT installed";
    fi
    ;;

    4 )
        echo
        echo "============================================================================"
        echo "Exiting now"
        echo "============================================================================"
        exit 1
        exit
    ;;

    * )
        echo
        echo "============================================================================"
        echo "Choose the correct number. Try again"
        echo "============================================================================"
    ;;
esac
