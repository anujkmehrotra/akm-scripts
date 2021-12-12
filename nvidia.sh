#!/bin/bash

###########################################################################################################
# Author            : AKM
# Disribution 		: ArcoLinux only
# required Pkg      : paru (sudo pacman -S paru-bin)
###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################

# Nvidia Installer
package="nvidia-settings nvidia-utils lib32-nvidia-utils opencl-nvidia lib32-opencl-nvidia egl-wayland eglexternalplatform"
package0="nvidia-settings lib32-nvidia-utils opencl-nvidia lib32-opencl-nvidia egl-wayland eglexternalplatform"
package1="nvidia"
package2="nvidia-dkms"
package3="nvidia-470xx-dkms"
package4="nvidia-390xx-dkms"
package5="nvidia-lts"
package6="nvidia-utils-nvlax"
package7="nvidia-tweaks"

echo
tput setaf 1
echo "============================================================================"
echo "                    Choose only ONE Nvidia driver."
echo "         Existing driver will be overwritten if already installed."
echo "        Existing driver will be replaced if chosen one is different."
echo "============================================================================"
tput sgr0

echo
echo "Only one input allowed at a time:"
echo
echo "1.  Nvidia          (mainline kernel (linux) is required)"
echo
echo "2.  Nvidia   DKMS   (same nvidia pkg with mainline or Custom kernel)"
echo
echo "3.  Nvidia   470    (nvidia-470xx stable with any kernel)"
echo
echo "4.  Nvidia   390    (nvidia-390xx stable with any kernel)"
echo
echo "5.  Nvidia   LTS    (nvidia-lts with linux-lts kernel will be installed)"
echo
echo "Advanced Drivers"
echo
echo "6.  Nvidia   Nvlax  (Nvlax = nvidia-dkms with nvidia-utils-nvlax and cuda on any kernel)"
echo
echo "7.  Nvidia   Tweaks (Tweaks = nvidia-dkms with nvidia-tweaks and cuda on any kernel)"
echo
echo "8.  Exit/Leave      (Do not install Nvidia)"
echo
echo "Type the number..."

read CHOICE

case $CHOICE in

    1 )
## Checking if package is already installed or not
        echo "Checking ${package1} in system."

    check="$(pacman -Qs --color always "${package1}" | grep "local" | grep "${package1} ")";

    if [ -n "${check}" ] ; then
        sleep 3
        echo "${package1} is installed";
    elif [ -z "${check}" ] ; then
        sleep 3
        echo "${package1} is NOT installed";

        tput setaf 2
        echo
		echo "============================================================================"
		echo ""${package1}" is installing ...."
		echo "============================================================================"
		tput sgr0
        echo
        sudo pacman -S ${package1}
        sudo pacman -S --needed ${package}

    fi
    ;;

    2 )
        echo "Checking ${package2} in system."

    check="$(pacman -Qs --color always "${package2}" | grep "local" | grep "${package2} ")";

    if [ -n "${check}" ] ; then
        sleep 3
        echo "${package2} is installed";
    elif [ -z "${check}" ] ; then
        sleep 3
        echo "${package2} is NOT installed";

		tput setaf 2
        echo
		echo "============================================================================"
		echo ""${package2}" is installing ...."
		echo "============================================================================"
		tput sgr0
        echo
        sudo pacman -S ${package2}
        sudo pacman -S --needed ${package}

     fi
     ;;

    3 )
        echo "Checking ${package3} in system."

    check="$(pacman -Qs --color always "${package3}" | grep "local" | grep "${package3} ")";

    if [ -n "${check}" ] ; then
        sleep 3
        echo "${package3} is installed";
    elif [ -z "${check}" ] ; then
        sleep 3
        echo "${package3} is NOT installed";

		tput setaf 2
        echo
		echo "============================================================================"
		echo ""$package3" is installing ...."
		echo "============================================================================"
		tput sgr0
        echo
        sudo pacman -S --noconfirm --needed paru
        paru -a -S ${package3}
        paru -a -S --needed nvidia-470xx-settings nvidia-470xx-utils lib32-nvidia-470xx-utils opencl-nvidia-470xx lib32-opencl-nvidia-470xx

    fi
    ;;

    4 )
        echo "Checking ${package4} in system."

    check="$(pacman -Qs --color always "${package4}" | grep "local" | grep "${package4} ")";

    if [ -n "${check}" ] ; then
        sleep 3
        echo "${package4} is installed";
    elif [ -z "${check}" ] ; then
        sleep 3
        echo "${package4} is NOT installed";

		tput setaf 2
        echo
		echo "============================================================================"
		echo ""${package4}" is installing ...."
		echo "============================================================================"
		tput sgr0
        echo
        sudo pacman -S --noconfirm --needed paru
        paru -a -S ${package4}
        paru -a -S --needed nvidia-390xx-settings nvidia-390xx-utils lib32-nvidia-390xx-utils opencl-nvidia-390xx lib32-opencl-nvidia-390xx

    fi
    ;;


    5 )
        echo "Checking ${package4} in system."

    check="$(pacman -Qs --color always "${package5}" | grep "local" | grep "${package5} ")";

    if [ -n "${check}" ] ; then
        sleep 3
        echo "${package5} is installed";
    elif [ -z "${check}" ] ; then
        sleep 3
        echo "${package5} is NOT installed";

		tput setaf 2
        echo
		echo "============================================================================"
		echo ""$package5" is installing ...."
		echo "============================================================================"
		tput sgr0
        echo
        sudo pacman -S ${package5}
        sudo pacman -S --needed ${package}

    fi
    ;;

    6 )
        echo "============================================================================"
        echo "Checking ${package6} conflict with ${package7} first."
        echo "============================================================================"

    check="$(pacman -Qs --color always "${package7}" | grep "local" | grep "${package7} ")";

    if [ -n "${check}" ] ; then
        sleep 3
        echo "============================================================================"
        echo "Unrequired package ${package7} is installed."
        echo "============================================================================"

        tput setaf 2
        echo
		echo "============================================================================"
		echo ""$package7" is uninstalling ...."
		echo "============================================================================"
        echo
        sudo pacman -R --noconfirm ${package7}
        sudo pacman -S --needed ${package2} ${package6}
        sudo pacman -S --needed ${package0}
        sudo pacman -S --needed cuda

    elif [ -z "${check}" ] ; then
        sleep 3
        echo
		echo "============================================================================"
		echo ""$package6" is installing ...."
		echo "============================================================================"
		echo
		sudo pacman -S --needed $package2 $package6
		sudo pacman -S --needed $package0
        sudo pacman -S --needed cuda

		tput sgr0

    fi
    ;;

    7 )
        echo "============================================================================"
        echo "Checking ${package7} conflict with ${package6} first."
        echo "============================================================================"

    check="$(pacman -Qs --color always "${package6}" | grep "local" | grep "${package6} ")";

    if [ -n "${check}" ] ; then
        sleep 3
        echo "============================================================================"
        echo "Unrequired package ${package6} is installed."
        echo "============================================================================"

        tput setaf 2
        echo
		echo "============================================================================"
		echo ""$package6" is uninstalling ...."
		echo "============================================================================"
        echo
        sudo pacman -S --noconfirm --needed paru
        sudo pacman -Rcns --noconfirm ${package6}
        sudo pacman -S --needed ${package2}
        sudo pacman -S --needed ${package}
        sudo pacman -S --needed cuda
        paru -a -S ${package7}

    elif [ -z "${check}" ] ; then
        sleep 3
        echo
		echo "============================================================================"
		echo ""${package7}" is installing ...."
		echo "============================================================================"
        echo
		sudo pacman -S --noconfirm --needed paru
		sudo pacman -S --needed ${package2}
		sudo pacman -S --needed ${package}
		sudo pacman -S --needed cuda
		paru -a -S ${package7}

		tput sgr0

    fi
    ;;


    8 )
        echo
        echo "============================================================================"
        echo "Exiting now"
        echo "============================================================================"
    sleep 3
        exit
      ;;

    * )
        echo
        echo "============================================================================"
        echo "Choose the correct number. Try again"
        echo "============================================================================"

esac
        echo
        echo "Done."
