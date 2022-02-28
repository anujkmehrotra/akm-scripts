#!/bin/bash
set -e
###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM                                                                                 #
# Disribution 	    : ArchLinux with AUR (Tested on ArcoLinux only)                                       #
# Requirement #1    : AMD/Intel Processor (You can change your Processor type (proc) in the script too.   #
#             #2    : File 'myconfig' (Whole configuration of Kernel according the Processor)             #
#            	    : If 'myconfig' is not available then it will be created after package build.         #
#             #3    : AUR Helper (paru). Can be choose manually in the script.             		  #
###########################################################################################################
## There are several pauses added due to long building process and you might not see them after
## building the Kernel. These pauses will help to understand better what is happening.
############################   EDITING INSTRUCTIONS  ######################################################
## For more specific Processor type read the file "choose-gcc-optimization.sh" from AUR or from build dir
## Kernel Building Category for "AMD" autodetect (according to file "choose-gcc-optimization.sh" = 99)
## Kernel building Category for "INTEL" autodetect (according to file "choose-gcc-optimization.sh" = 98)
## Kernel building Category for "GENERIC" (according to file "choose-gcc-optimization.sh" = 0)
## Also confirm the AUR package name with GIT address (source) accordingly

############################   EDIT THE FOLLOWING ACCORDING YOUR NEED  ####################################
# Use only one linux-(xanmod/edge/lts/anbox/tt) name as in AUR
package="linux-xanmod-edge"
#   GIT address for cloning or pulluing
source="https://aur.archlinux.org/${package}.git"
#   Use "tmpfs" location like : (/var/tmp) or (ramdisk) or any other to build package faster
tmpdir="/mnt/RamDisk"
#   Location where you want to keep your build directory after installation
pulldir="/mnt/Data"
#   Backup location For "myconfig" file incase of build directory deletion and first time installation
bakdir="/mnt/Data/Backup"
#   Location of the finish package (.zst) file for installation
insdir="/mnt/Data/Kernel"
#  KBC= " Kernel Build Category " according the file "choose-gcc-optimization.sh" from build dir.
prockbc="14"

#####################  DO NOT EDIT THE FOLLOWING UNTIL YOU KNOW WHAT YOU DOING  ###########################
#   AUR helper (only paru)
helper="paru"
#   Custom kernel building helper
package1="modprobed-db"
#   To check existing build directory with the file 'PKGBUILD'
file="$pulldir/${package}/PKGBUILD"
#   To check tweak file
filet="/etc/sysctl.d/90-override.conf"
#   Checking current kernel version
cver="$(${helper} -Qi ${package} | grep 'Version' | cut -c 19-27)"
#   Checking available kernel version
nver="$(${helper} -a -Si ${package} | grep 'Version' | cut -c 19-27)"

    #=====================================================================
    #   Checking required package
if pacman -Qi ${helper} &> /dev/null; then
	echo "Please wait while we check the status of '${package}' for you."
else
        echo "Installing AUR Helper '${helper}' ...."
        sudo pacman -S ${helper} --noconfirm
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
        echo "Wrong selection of 'Kernel Build Category' may HANG your system during Kernel building."
        echo "======================================================================================="
        tput sgr0
        echo
        echo "======================================================================================="
        echo "Do you want to install ? (y/n)";
        echo "======================================================================================="
        
        read -r CHOICE
        case $CHOICE in

    y )

        #   Preparing and pulling git repo
        echo
        echo "======================================================================================="
        echo "Preparing Kernel '${package}' version'${nver}' to install ...."
        echo "======================================================================================="
        sleep 1

        #=====================================================================
        #   Checking previous build dir status
    if test -f "${file}"; then
        mv -f ${pulldir}/${package} ${tmpdir}
        cd ${tmpdir}/${package}
        rm -Rf src
        rm -f ${package}*
        echo
        echo "======================================================================================="
        echo "Found PKGBUILD. Pulling Kernel '${package}' from GIT repository ...."
        echo "======================================================================================="
        echo
        git pull ${source}
    else
    	cd ${tmpdir}
    	echo
        echo "======================================================================================="
        echo "Cloning Kernel '${package}' from GIT repository ...."
        echo "======================================================================================="
        echo
        rm -Rf ${package}
        git clone ${source}
        cp -f ${bakdir}/myconfig ${package}/myconfig
        cd ${package}
    fi
        #=====================================================================
        #   Checking modprobed-db pkg status
        #=====================================================================
    if pacman -Qi ${package1} &> /dev/null; then

        echo "======================================================================================="
        echo "Updating modprobe moudules ....."
        echo "======================================================================================="
        echo

        ${package1} store

        echo "======================================================================================="
        echo "Building Kernel '${package}' version'${nver}' . Please wait ....."
        echo "======================================================================================="
        echo
        
        env _microarchitecture=${prockbc} use_numa=n use_tracers=n use_pds=n use_ns=y use_cachy=y makepkg -sc
    
    else
    
        echo "======================================================================================="
        echo "Installing and listing modprobe moudules ....."
        echo "======================================================================================="
        
        sudo pacman -S --noconfirm ${package1}
        systemctl --user enable --now ${package1}.service
        ${package1} list

        echo "======================================================================================="
        echo "Building Kernel '${package}' version'${nver}' . Please wait ....."
        echo "======================================================================================="
        echo
     
        env _microarchitecture=${prockbc} use_numa=n use_tracers=n use_pds=n use_ns=y use_cachy=y makepkg -sc
    
    fi
        #=====================================================================
        #   Preparing installation with local 'myconfig' file in tmpdir
        sleep 1
        rm -f ${insdir}/* && cp -f ${tmpdir}/${package}/${package}* ${insdir}
        mv -f config.last myconfig
        cp -f myconfig ${bakdir}
        echo
        echo "======================================================================================="
        echo "Installing Kernel '${package}' version'${nver}' ...."
        echo "======================================================================================="
    
        #   Kernel installation
        echo
        cd ${insdir} && sudo pacman -U --noconfirm ${package}*
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
        rm -Rf "${pulldir}"/"${package}"
        mv -f "${tmpdir}"/"${package}" "${pulldir}"
        echo
        tput setaf 2
        echo "======================================================================================="
        echo "Kernel '${package}' version'${nver}' Installed. Please reboot."
        echo "======================================================================================="
        tput sgr0
        echo
        echo "INFO"
        echo "======================================================================================="
        echo "DO NOT DELETE the build directory. It can be used to update the kernel in future."
        echo "======================================================================================="
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
