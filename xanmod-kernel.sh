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
package="linux-xanmod-edge"
#   GIT address for cloning or pulluing
source="https://aur.archlinux.org/$package.git"
#   Use "tmpfs" location like : (/var/tmp) or (ramdisk) or any other to build package faster
tmpdir="/var/tmp"
#   Location of the finish package (.zst) file for installation
insdir="/mnt/Data/Kernel"
#  According the file "choose-gcc-optimization.sh" from build dir.
cpuver="14"

#####################  DO NOT EDIT THE FOLLOWING UNTIL YOU KNOW WHAT YOU DOING  ###########################
#   Checking current kernel version
cver="$(paru -Qi $package | grep 'Version' | awk '{print $3}')";
#   Checking available kernel version
nver="$(paru -a -Si $package | grep 'Version' | awk '{print $3}')";
#==========================================================================================================

    #   Checking required package
if pacman -Qi paru &> /dev/null; then
    sleep 1
else
    echo "Missing required package, installing ...."
    sudo pacman -S paru --noconfirm
    sleep 1
fi

#   On installed.

if [ "$nver" == "$cver" ] ; then
        tput setaf 2
        echo "======================================================================================="
        echo "Kernel '$package' version '$cver' is UP-TO-DATE."
        echo "======================================================================================="
        tput sgr0

#   On update available.

elif pacman -Qi $package &> /dev/null ; then
        tput setaf 2
        echo "======================================================================================="
        echo "Kernel '$package' version '$cver' is already INSTALLED."
        echo "======================================================================================="
        tput sgr0
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
        sleep 1
   
        cd ${tmpdir}
    	echo
        echo "======================================================================================="
        echo "Cloning Kernel '$package' from GIT repository ...."
        echo "======================================================================================="
        echo
        echo "======================================================================================="
        echo "Removing the old build directory if it exists ...."
        echo "======================================================================================="
        echo

        [ -d $package ] && rm -rf $package
        git clone $source
        cd $package
        echo
        echo "======================================================================================="
        echo "Building Kernel '$package' version '$nver' ...."
        echo "======================================================================================="

#   Keys in case required.

        #sudo gpg --recv-keys ABAF11C65A2970B130ABE3C479BE3E4300411886
        #sudo gpg --recv-keys 647F28654894E3BD457199BE38DBBDC86092693E

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
