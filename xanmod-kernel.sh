#!/bin/bash
set -e
###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM                                                                                 #
# Disribution 	    : ArchLinux with AUR (Tested on ArcoLinux only)                                       #
# Requirement       : AMD/Intel Processor (You can change your Processor type (prockbc) in the script too. #
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
source="https://aur.archlinux.org/${package}.git"
#   Use "tmpfs" location like : (/var/tmp) or (ramdisk) or any other to build package faster
tmpdir="/mnt/RamDisk"
#   Location of the finish package (.zst) file for installation
insdir="/mnt/Data/Kernel"
#  According the file "choose-gcc-optimization.sh" from build dir.
prockbc="14"

#####################  DO NOT EDIT THE FOLLOWING UNTIL YOU KNOW WHAT YOU DOING  ###########################
filet="/etc/sysctl.d/90-override.conf"
#   Checking current kernel version
cver="$(paru -Qi ${package} | grep 'Version' | cut -c 19-27)";
#   Checking available kernel version
nver="$(paru -a -Si ${package} | grep 'Version' | cut -c 19-27)";
#==========================================================================================================

    #   Checking required package
if pacman -Qi paru &> /dev/null; then
	echo "Please wait while we check the status of '${package}' for you."
else
    sudo pacman -S paru --noconfirm
    echo "Please wait while we check the status of '${package}' for you."
fi
    #=====================================================================
        #   On installed and available.
    #=====================================================================
if pacman -Qi ${package} &> /dev/null && [ "${nver}" == "${cver}" ] ; then
        sleep 1
        tput setaf 2
        echo "======================================================================================="
        echo "Kernel '${package}' version'${nver}' is INSTALLED and UP-TO-DATE."
        echo "======================================================================================="
        tput sgr0
else
        sleep 1
        echo "======================================================================================="
        echo "Kernel '${package}' version'${nver}' is NOT installed."
        echo "======================================================================================="
        tput setaf 1
        echo
        echo "WARNING :"
        echo "======================================================================================="
        echo "Wrong selection of 'prockbc' may HANG your system during Kernel building."
        echo "======================================================================================="
        tput sgr0
        echo
        echo "======================================================================================="
        echo "Do you want to install ? (y/n)";
        echo "======================================================================================="
        
        read -r CHOICE
        case $CHOICE in

    y )

        #   Preparing and cloning git repo
        echo
        echo "======================================================================================="
        echo "Preparing Kernel '${package}' version'${nver}' to install ...."
        echo "======================================================================================="
        sleep 1
   
       	cd ${tmpdir}
    	echo
        echo "======================================================================================="
        echo "Cloning Kernel '${package}' from GIT repository ...."
        echo "======================================================================================="
        echo
        if [[ -d "${package}" ]]; then 
        rm -Rf ${package}
        fi
        git clone ${source}
        cd ${package}
        
        env _microarchitecture=${prockbc} use_numa=n use_tracers=n _compress_modules=y use_ns=y makepkg -sc
    
        sleep 1
        rm -f ${insdir}/* && cp -f ${tmpdir}/${package}/${package}* ${insdir}
        echo
        echo "======================================================================================="
        echo "Installing Kernel '${package}' version'${nver}' ...."
        echo "======================================================================================="
    
        #   Kernel installation
        echo
        cd ${insdir} && sudo pacman -U --needed --noconfirm ${package}*
        echo
        echo "======================================================================================="
        echo "Kernel '${package}' version'${nver}' installed. Updating grub ...."
        echo "======================================================================================="
        
        #   Updating Grub
        echo
        sleep 1
        sudo grub-mkconfig -o /boot/grub/grub.cfg

        #   Setting the FQ-PIE Queuing Discipline
    
    if test -f "${filet}"; then
        echo "======================================================================================="
        echo "FQ-PIE Queuing Discipline tweak has already applied, skipping ...."
        echo "======================================================================================="
    else
        echo "======================================================================================="
        echo "Applying tweaks (FQ-PIE Queuing Discipline)."
        echo "======================================================================================="
        echo 'net.core.default_qdisc = fq_pie' | sudo tee /etc/sysctl.d/90-override.conf
    fi
        cd "$HOME"
        echo
        tput setaf 2
        echo "======================================================================================="
        echo "Kernel '${package}' version'${nver}' Installed. Please reboot."
        echo "======================================================================================="
        tput sgr0
    ;;

    n )
        echo
        echo "======================================================================================="
        echo "You chose not to install the Kernel '${package}' version'${nver}' ."
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
