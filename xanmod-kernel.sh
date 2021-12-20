#!/bin/bash
set -e
###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM                                                                                 #
# Disribution 		: ArchLinux with AUR (Tested on ArcoLinux only)                                       #
# Requirement #1    : AMD/Intel Processor (You can change your Processor type (proc) in the script too.   #
#             #2    : File 'myconfig' (Whole configuration of Kernel according the Processor)             #
#                   : If 'myconfig' is not available then it will be created after package build.         #
#             #3    : AUR Handler (yay / paru / Other ). Can be choose manual in the script.              #
###########################################################################################################
## There are several pauses added due to long building process and you might not see them after
## building the Kernel. These pauses will help to understand better what is happening.

############################   EDITING INSTRUCTIONS  ######################################################

## For more specific Processor type read the file "choose-gcc-optimization.sh" from AUR or from build dir
## Kernel Building Category for "AMD" autodetect (according file "choose-gcc-optimization.sh" = 99)
## Kernel building Category for "INTEL" autodetect (according file "choose-gcc-optimization.sh" = 98)
## Kernel building Category for "GENERIC" (according file "choose-gcc-optimization.sh" = 0)
## Use only one linux-(xanmod/edge/lts/anbox/tt) name as AUR package name
## Also confirm the AUR package name with GIT address (source) accordingly

############################   EDIT THE FOLLOWING ACCORDING YOUR NEED  ####################################

package="linux-xanmod-edge"
#   GIT address for cloning or pulluing
source=https://aur.archlinux.org/${package}.git
#   Use "tmps" file sysyem based location like : /var/tmp or Ramdisk or any other to build package faster
tmpdir=/mnt/RamDisk
#   Location where you keep your build directory after installation
pulldir=/mnt/Data
#   Backup location For "myconfig" file incase of build directory deletion and first time installation
bakdir=/mnt/Recovery/Backup
#   Location of finish package (.zst) and for installation
insdir=/mnt/Personal/Kernel
#   AUR handler (yay / paru / other)
handler="paru"

######################## Very Important to set according to your Processor ###############################

#   " Kernel Build Category " as per detected Processor architecture and file "choose-gcc-optimization.sh"
prockbc=14

#####################  DO NOT EDIT THE FOLLOWING UNITL YOU KNOW WHAT YOU DOING  ###########################


#   Auto Processor type detection
proc="$(cat /proc/cpuinfo | grep 'model name' | sed -e 's/model name.*: //'| uniq | cut -c 1-24)"
#   Auto Processor architecture detection
procarch="$(gcc -c -Q -march=native --help=target | grep march | awk '{print $2}' | head -1)"
#   Custom kernel building helper
package1="modprobed-db"
#   To check existing build directory with PKGBUILD
FILE=$pulldir/${package}/PKGBUILD


#   Checking required package
if pacman -Qi ${handler} &> /dev/null; then
        echo "Please wait while we check the status of '${package}' for you."
else
        echo "No specific AUR Handler found in the system."
        echo "Installing AUR Handler '${handler}' ...."
        sudo pacman -S ${handler} --noconfirm --needed
        echo "AUR Handler '${handler}' installed."
        echo
        echo "Please wait while we check the status of '${package}' for you."
fi

#   Checking installed and available status of the package.

check="$(pacman -Qs --color always "${package}" | grep "local" | grep "${package}")";
cver="$(${handler} -Qi ${package} | grep 'Version' | cut -c 19-27)"
nver="$(${handler} -Si ${package} | grep 'Version' | cut -c 19-27)"

#   On installed and available.

if [ -n "${check}" ] && [ "${nver}" == "${cver}" ]; then
    sleep 3
        echo "Kernel '${package}' Version '${nver}' is INSTALLED and UP-TO-DATE."
        echo

#   On not installed but available.
elif [ -z "${check}" ] ; then
    sleep 3
        tput setaf 1
        echo
        echo "======================================================================================="
        echo "Kernel '${package}' Version '${nver}' is NOT installed."
        echo
        echo "Detected CPU is '${proc}' and Architecture is '${procarch}'"
        echo "Your choosen 'Kernel Build Category' is '${prockbc}' in the script."
        echo "Kindly change if it does not match according with the below mentioned file"
        echo "'${tmpdir}/${package}/choose-gcc-optimization.sh'"
        echo
        echo "WARNING :"
        echo "Wrong selection of 'Kernel Build Category' may HANG your system during Kernel building."
        echo
        echo "Do you want to install? (y/n)"; read CHOICE
        echo "======================================================================================="

    case $CHOICE in

    y )

#   Preparing and pulling git repo
        echo
        echo "======================================================================================="
        echo "Preparing Kernel '${package}' Version '${nver}' to install ...."
        echo "======================================================================================="
    sleep 2
    if test -f "${FILE}"; then

        mv -f ${pulldir}/${package} ${tmpdir}
        cd ${tmpdir}/${package}
        rm -Rf src
		rm -f ${package}*
		echo
        echo "======================================================================================="
        echo "Found PKGBUILD. Pulling Kernel '${package}' from GIT repository ...."
        echo "======================================================================================="
        echo
    sleep 2
		git pull ${source}
    else
    	cd ${tmpdir}
    	echo
		echo "======================================================================================="
        echo "Cloning Kernel '${package}' from GIT repository ...."
        echo "======================================================================================="
        echo
    sleep 2
        rm -Rf ${package}
		git clone ${source}
		cp -f ${bakdir}/myconfig ${package}/myconfig
		cd ${package}
    fi

    if pacman -Qi ${package1} &> /dev/null; then

    sleep 2
        echo
        echo "======================================================================================="
        echo "Updating modprobe moudules ....."
        echo "======================================================================================="
        echo
        ${package1} store
    sleep 2
        echo
        echo "======================================================================================="
        echo "Building Kernel '${package}' Version '${nver}' . Please wait ....."
        echo "======================================================================================="
        echo

#   Added use_pds=n & use_cachy=y to enhance the package building process
        env _microarchitecture=${prockbc} use_numa=n use_tracers=n use_pds=n use_ns=y use_cachy=y makepkg -sc

#   Suggested by AUR package maintainer
    #env _microarchitecture=${prockbc} use_numa=n use_tracers=n use_ns=y _localmodcfg=y makepkg -sc

    else
    sleep 2
        echo
        echo "======================================================================================="
        echo "Installing and listing modprobe moudules ....."
        echo "======================================================================================="
        echo
        sudo pacman -S --noconfirm ${package1}
        systemctl --user enable --now ${package1}.service
        ${package1} list
        echo
    sleep 2
        echo
        echo "======================================================================================="
        echo "Building Kernel '${package}' Version '${nver}' . Please wait ....."
        echo "======================================================================================="
        echo

#   Added use_pds=n & use_cachy=y to enhance the package building process
        env _microarchitecture=${prockbc} use_numa=n use_tracers=n use_pds=n use_ns=y use_cachy=y makepkg -sc

#   Suggested by AUR package maintainer
    #env _microarchitecture=${prockbc} use_numa=n use_tracers=n use_ns=y _localmodcfg=y makepkg -sc

    fi
#   Preparing installation with local 'myconfig' file in tmpdir
        echo
        echo "======================================================================================="
        echo "Building process for Kernel '${package}' Version '${nver}' completed."
        echo "======================================================================================="
    sleep 3
		rm -f ${insdir}/* && cp -f ${tmpdir}/${package}/${package}* ${insdir}
        mv -f config.last myconfig
		cp -f myconfig ${bakdir}/myconfig
        echo
        echo "======================================================================================="
        echo "Installing Kernel '${package}' Version '${nver}' ...."
        echo "======================================================================================="
    sleep 3
#   Kernel installation
        echo
		cd ${insdir} && sudo pacman -U --noconfirm ${package}*
		echo
        echo "======================================================================================="
        echo "Kernel "${package}" Version "${nver}" installed. Updating grub ...."
        echo "======================================================================================="
    sleep 1
#   Updating Grub
        echo
		sudo grub-mkconfig -o /boot/grub/grub.cfg
#   Setting the FQ-PIE Queuing Discipline
		echo
		echo "======================================================================================="
        echo "Applying tweaks (FQ-PIE Queuing Discipline)."
        echo "======================================================================================="
    sleep 3
        echo
        echo 'net.core.default_qdisc = fq_pie' | sudo tee /etc/sysctl.d/90-override.conf
        echo
		echo "======================================================================================="
        echo "Tweaks (FQ-PIE Queuing Discipline) applied."
        echo "======================================================================================="
        echo
        echo "======================================================================================="
        echo "Please, DO NOT DELETE the build directory."
        echo "It will be used to update the Kernel in future."
        echo "======================================================================================="
        cd $HOME
        rm -Rf ${pulldir}/${package}
        mv -f ${tmpdir}/${package} ${pulldir}
    sleep 2
        echo
        echo "======================================================================================="
        echo "Kernel '${package}' Version '${nver}' Installed. Please reboot."
        echo "======================================================================================="
        tput sgr0

    ;;

    n )
        echo
        echo "======================================================================================="
        echo "You chose not to install the Kernel '${package}' Version '${nver}' ."
        echo "======================================================================================="

    ;;

    * )
        echo
        echo "======================================================================================="
        echo "Only allowed 'y/n' to answer."
        echo "======================================================================================="

    ;;

    esac

else
    sleep 3
#   On update available.

        tput setaf 2
        echo
        echo "======================================================================================="
        echo "A new Version '${nver}' is available over the Current Version '${cver}'"
        echo "Do you want to update '${package}' Version '${nver}' ? (y/n)"; read CHOICE
        echo "======================================================================================="

    case $CHOICE in

    y )
        echo
        echo "======================================================================================="
        echo "Preparing Kernel '${package}' Version '${nver}' to update ...."
        echo "======================================================================================="
    sleep 2

#   Preparing and pulling git repo

    if test -f "${FILE}"; then
        mv -f ${pulldir}/${package} ${tmpdir}
        cd ${tmpdir}/${package}
        rm -Rf src
		rm -f ${package}*
        echo
        echo "======================================================================================="
        echo "Found PKGBUILD. Pulling Kernel '${package}' from GIT repository ...."
        echo "======================================================================================="
    sleep 2
        echo
		git pull ${source}
    else
    	cd ${tmpdir}
        echo
		echo "======================================================================================="
        echo "Cloning Kernel '${package}' from GIT repository ...."
        echo "======================================================================================="
    sleep 2
        echo
        rm -Rf ${package}
		git clone ${source}
		cp -f ${bakdir}/myconfig ${package}/myconfig
		cd ${package}
    fi

#   Checking for package modprobed-db (Updating available moudules list)

    if pacman -Qi ${package1} &> /dev/null; then

    sleep 2
        echo
        echo "======================================================================================="
        echo "Updating modprobe moudules ....."
        echo "======================================================================================="

        ${package1} store
        echo
        echo "======================================================================================="
        echo "Building Kernel '${package}' Version '${nver}' . Please wait ....."
        echo "======================================================================================="
    sleep 2
        echo

#   Added use_pds=n & use_cachy=y to enhance the package building process
        env _microarchitecture=${prockbc} use_numa=n use_tracers=n use_pds=n use_ns=y use_cachy=y makepkg -sc

#   Suggested by AUR package maintainer
    #env _microarchitecture=${prockbc} use_numa=n use_tracers=n use_ns=y _localmodcfg=y makepkg -sc

    else
    sleep 2
#   In case of missing modprobed-db file (Installing & Preparing)
        echo
        echo "======================================================================================="
        echo "Installing and listing modprobe moudules ....."
        echo "======================================================================================="
        echo
    sleep 2
        echo
        sudo pacman -S --noconfirm --needed ${package1}
        systemctl --user enable --now ${package1}.service
        ${package1} list
        echo
        echo "======================================================================================="
        echo "Building Kernel '${package}' Version '${nver}' . Please wait ....."
        echo "======================================================================================="
    sleep 2
        echo

#   Added use_pds=n & use_cachy=y to enhance the package building process
        env _microarchitecture=${prockbc} use_numa=n use_tracers=n use_pds=n use_ns=y use_cachy=y makepkg -sc

#   Suggested by AUR package maintainer
    #env _microarchitecture=${prockbc} use_numa=n use_tracers=n use_ns=y _localmodcfg=y makepkg -sc

    fi
#   Preparing installation with local 'myconfig' file in tmpdir
        echo
        echo "======================================================================================="
        echo "Building process for Kernel '${package}' Version '${nver}'completed."
        echo "======================================================================================="
    sleep 3
#   Preparing installation
		rm -f ${insdir}/* && cp -f ${tmpdir}/${package}/${package}* ${insdir}
		mv -f config.last myconfig
		cp -f myconfig ${bakdir}/myconfig
        echo
        echo "======================================================================================="
        echo "Updating Kernel '${package}' Version '${nver}' ...."
        echo "======================================================================================="
    sleep 3
#   Kernel installation
        echo
		cd ${insdir} && sudo pacman -U --noconfirm --needed ${package}*
#   Updating Grub
    sleep 3
        echo
		sudo grub-mkconfig -o /boot/grub/grub.cfg
        echo
		echo "======================================================================================="
        echo "Please, DO NOT DELETE the build directory."
        echo "It will be used to update the Kernel '${package} in future."
        echo "======================================================================================="
        cd $HOME
		rm -Rf ${pulldir}/${package}
		mv -f ${tmpdir}/${package} ${pulldir}
    sleep 2
		echo
        echo "======================================================================================="
        echo "Kernel '${package}' Version '${nver}' updated. Please reboot."
        echo "======================================================================================="
        tput sgr0

    ;;

    n )
        echo
        echo "======================================================================================="
        echo "You chose not to update the Kernel '${package}' Version '${nver}' ."
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
