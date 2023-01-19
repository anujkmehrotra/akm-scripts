#!/bin/bash
set -e
###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM                                                                                 #
# Disribution 	    : ArchLinux with AUR (Tested on ArcoLinux only)                                       #
# Requirement       : AMD/Intel Processor (You can change your Processor type (cpuver) in the script too. #
###########################################################################################################

############################   EDITING INSTRUCTIONS  ######################################################
## For more specific Processor type read the file "choose-gcc-optimization.sh" from AUR or from build dir
## "AMD" autodetect (according to file "choose-gcc-optimization.sh" = 99)
## "INTEL" autodetect (according to file "choose-gcc-optimization.sh" = 98)
## "GENERIC" (according to file "choose-gcc-optimization.sh" = 0)
## Also confirm the AUR package name with GIT address (source) accordingly

############################   EDIT THE FOLLOWING ACCORDING YOUR NEED  ####################################
# Use only one linux-(xanmod/edge/lts/anbox/tt) name as in AUR
package="linux-xanmod"
#   GIT address for cloning or pulluing
source="https://aur.archlinux.org/$package.git"
#   Use "tmpfs" location like : (/var/tmp) or (ramdisk) or any other to build package faster
tmpdir="/var/tmp"
#   Location of the finish package (.zst) file for installation
insdir="/mnt/Data/Kernel"
#  According the file "choose-gcc-optimization.sh" from build dir.
cpuver="14"

#####################  DO NOT EDIT THE FOLLOWING UNTIL YOU KNOW WHAT YOU DOING  ###########################

#==========================================================================================================

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

#   Preparing and cloning git repo

        echo
        echo "======================================================================================="
        echo "Preparing Kernel '$package' version '$nver' to install ...."
        echo "======================================================================================="
        echo
        cd $tmpdir
        rm -Rf $package
        git clone $source
        cd $package
        echo
        echo "======================================================================================="
        echo "Building Kernel '$package' version '$nver' ...."
        echo "======================================================================================="

#   Building
        env _microarchitecture=${cpuver} use_numa=n use_tracers=n _compress_modules=y use_ns=y makepkg -sc
    
        sleep 1
        echo
        echo "======================================================================================="
        echo "Checking requirement for installation ...."
        echo "======================================================================================="
        echo
        rm -f ${insdir}/* && cp -f $tmpdir/$package/$package* $insdir
        echo
        echo "======================================================================================="
        echo "Installing Kernel '$package' version '$nver' ...."
        echo "======================================================================================="
    
#   Kernel installation
        echo
        cd ${insdir} && sudo pacman -U --needed --noconfirm $package*
        echo
        echo "======================================================================================="
        echo "Updating grub ...."
        echo "======================================================================================="
        
#   Updating Grub (Disabled by default)
        #echo
        #sleep 1
        #sudo grub-mkconfig -o /boot/grub/grub.cfg
        cd "$HOME"
        #echo
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
