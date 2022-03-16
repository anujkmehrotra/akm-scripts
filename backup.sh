#!/bin/bash
set -e
###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM
# Disribution 	    : ArchLinux with AUR (Tested on ArcoLinux only)
# Pkgs Required     : grive, timeshift and AUR Handler
###########################################################################################################

#   Backup location for home (other than /home) folder
bakhome="/mnt/Data/Backup/KBak"
#   Backup location of some System files ( Do not set same as bakhome )
bakloc="/mnt/Data"
#   Backup Remote location on local storage that syncs with your favourite cloud storage
bakremote="/mnt/Data/Gdrive"
#   Timeshift's commentt
tsc="Backup Script"

#########################  DO NOT EDIT THE FOLLOWING UNTIL YOU KNOW WHAT YOU DOING  ##############################
#   Required packages
#   You can use any remote drive's package (Dropbox, Google Drive or other)
package="grive"
#   Do not change package1
package1="timeshift"
#   AUR Handler (yay / paru)
package2="paru"
#   Ignore temporarily packages
ignpkg="$(du -h /var/cache/pacman/pkg | cut -c '1-4')";
# Home Folders and Files
FOLFL=("Calibre Library" ".config" ".local" ".bin" ".bashrc-personal" ".bashrc" ".chromecache" ".mozilla" ".var" ".xdman" ".Xresources" ".gnupg" ".cert" ".vscode-oss")

echo "=============================================================================="
echo "This script assumes that you have already configured"
echo "the packages '${package}' and '${package1}' before running this."
echo "if not, this script will install them. Kindly configure them by yourself."
echo "=============================================================================="
echo
        tput setaf 1
echo "=============================================================================="        
echo "WARNING : This is NOT an incremental backup process."
echo "It will delete all the previous backups including timeshift."
echo "=============================================================================="
        tput sgr0

if pacman -Qi ${package} ${package1} ${package2} &> /dev/null; then

        echo
        echo "=============================================================================="
        echo "Enter password to remove old backups and snapshots. Ctrl+C to cancel."
        echo "=============================================================================="

        # Deleted all timeshift previous backups
        #sudo timeshift --delete-all
        
        echo "=============================================================================="
        echo "Removed previous backup. Starting a new ...."
        echo "=============================================================================="
        rm -f ${bakremote}/Backup.tar.gz
        rm -f ${bakloc}/Backup.tar.gz
        rm -Rf ${bakhome:?}/*
        rm -Rf ${bakremote}/POS/*
        echo "Done"
        echo
        echo "=============================================================================="
        echo "Ignoring '${ignpkg}' temporarily packages from backup process ...."
        echo "=============================================================================="
        echo
        echo "=============================================================================="
        echo "Taking important system files backup ...."
        echo "=============================================================================="

        #   Local and AUR packages backup
        rm -f ${bakloc}/Backup/pkglist.txt
        rm -f ${bakloc}/Backup/localpkglist.txt
        pacman -Qnq > ${bakloc}/Backup/pkglist.txt
        pacman -Qmq > ${bakloc}/Backup/localpkglist.txt

        #   Removing my manual build pkg (CK kernel) name from the localpkglist
        sed -i '/linux-xanmod/d' ${bakloc}/Backup/localpkglist.txt
        sed -i '/linux-xanmod/d' ${bakloc}/Backup/pkglist.txt
     
        #   Important system files backup
        #		    cp -f /etc/sddm.conf.d/kde_settings.conf ${bakloc}/Backup
        #		    cp -f /etc/sddm.conf ${bakloc}/Backup
	cp -f /etc/mkinitcpio.d/* ${bakloc}/Backup
	cp -f /etc/fstab ${bakloc}/Backup
	cp -f /etc/pacman.conf ${bakloc}/Backup
	cp -f /etc/default/grub ${bakloc}/Backup
	cp -f /etc/makepkg.conf ${bakloc}/Backup
	cp -f /etc/systemd/journald.conf.d/volatile-storage.conf ${bakloc}/Backup
	cp -f /etc/systemd/journald.conf ${bakloc}/Backup
	cp -f /etc/udev/rules.d/60-scheduler.rules ${bakloc}/Backup
	cp -f /etc/sysctl.d/100-archlinux.conf ${bakloc}/Backup
	cp -f /etc/sysctl.d/9999-disable-core-dump.conf ${bakloc}/Backup
	cp -f /etc/security/limits.conf ${bakloc}/Backup
        echo "Done"
        echo
        echo "=============================================================================="
        echo "Taking important folders and files backup from [/home] ...."
        echo "=============================================================================="

        #   Important folders and files backup from [/home]
        #mkdir ${bakhome}
        
        cp -Rf ~/"${FOLFL[@]}" ${bakhome}

        echo "=============================================================================="
        echo "Local backup completed in [${bakloc}/Backup]."
        echo "=============================================================================="

        sudo timeshift --create --comments "${tsc}"
        cd ${bakloc}
        echo "=============================================================================="
        echo "Compressing backup ...."
        echo "=============================================================================="

        tar -zcf Backup.tar.gz Backup
        mv -f Backup.tar.gz ${bakremote}

        echo "Done"
        echo
        echo "=============================================================================="
        echo "Uploading backup ...."
        echo "=============================================================================="

        cp -Rf ${bakloc}/POS/* ${bakremote}/POS
        cd ${bakremote}
        grive

        echo "=============================================================================="
        echo "Backup process completed."
        echo "=============================================================================="
        cd "$HOME"

else

        sleep 1

        echo "=============================================================================="
        echo "Installing required packages '${package}' & '${package1}' ...."
        echo "=============================================================================="
        
        sudo pacman -S --noconfirm --needed ${package1} ${package2}
        ${package2} -a -S --noconfirm ${package}

        echo "=============================================================================="
        echo "Packages installed. Please configure { $package } & { $package1 } first."
        echo "After all configurations and changes, re-run this backup script."
        echo "=============================================================================="
fi
