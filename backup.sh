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
bakhome=/mnt/Recovery/Backup/KBak
#   Backup location of some System files ( Do not set same as bakhome )
bakloc=/mnt/Recovery
#   Backup Remote location on local storage that syncs with your favourite cloud storage
bakremote=/mnt/Data/Gdrive
#   Location of any other/personal folder to backup on bakloc/Backup or bakremote
bakother=/mnt/Data/POS
#   Timeshift's commentt
tsc="Created by AKM"
#   Required packages
#   You can use any remote drive's package (Dropbox, Google Drive or other)
package="grive"
#   Do not change package1
package1="timeshift"
#   AUR Handler (yay / paru)
package2="paru"

#######  DO NOT EDIT THE FOLLOWING UNTIL YOU KNOW WHAT YOU DOING  ######################

#   Ignore temporarily packages
ignpkg="$(du -h /var/cache/pacman/pkg | cut -c '1-4')"

echo
tput setaf 1
    echo "=============================================================================="
    echo "          This script assumes that you have already configured"
    echo "            '${package}' and '${package1}'before running it."
    echo "         If not, it will install them. Kindly configure by yourself."
    echo
    echo "WARNING : This is NOT an incremental backup process."
    echo "          It will delete all the previous backups including timeshift."
    echo "=============================================================================="
tput sgr0

if pacman -Qi ${package} ${package1} ${package2} &> /dev/null; then
    echo
    echo "=============================================================================="
    echo "Enter password to remove old backups and snapshots. Ctrl+C to cancel."
    echo "=============================================================================="
        sudo timeshift --delete-all
        rm -f ${bakremote}/Backup.tar.gz
        rm -f ${bakloc}/Backup.tar.gz
        rm -Rf ${bakhome}
sleep 1
    echo
    echo "=============================================================================="
    echo "Removed previous backup. Starting a new ...."
    echo "=============================================================================="
    echo
    echo "=============================================================================="
    echo "Ignoring '${ignpkg}' temporarily packages from backup process ...."
    echo "=============================================================================="
    echo
#   Local and AUR packages backup
        pacman -Qqen > ${bakloc}/Backup/pkglist.txt
        pacman -Qqem > ${bakloc}/Backup/localpkglist.txt
#   Removing my manual build pkg (xanmod kernel) name from the localpkglist
        sed -i '/linux-xanmod/d' ${bakloc}/Backup/localpkglist.txt
#   Important system files backup
        cp -f /etc/mkinitcpio.d/* ${bakloc}/Backup
        cp -f /etc/sddm.conf.d/kde_settings.conf ${bakloc}/Backup/kde_settings.conf
        cp -f /etc/sddm.conf.d/hidpi.conf ${bakloc}/Backup/hidpi.conf
        cp -f /etc/sddm.conf ${bakloc}/Backup/sddm.conf
        cp -f /etc/fstab ${bakloc}/Backup/fstab
        cp -f /etc/pacman.conf ${bakloc}/Backup/pacman.conf
#   Added backup of my custom mirrorlist for archlinuxcn's repo
        cp -f /etc/pacman.d/archlinuxcn-mirrorlist ${bakloc}/Backup
        cp -f /etc/default/grub ${bakloc}/Backup/grub
        cp -f /etc/hosts ${bakloc}/Backup/hosts
        cp -f /etc/hblock/allow.list ${bakloc}/Backup/allow.list
        cp -f /etc/hblock/deny.list ${bakloc}/Backup/deny.list
#   Custom config file backup for (xanmod kernel manual build pkg)
        cp -f /mnt/Data/linux-xanmod-edge/myconfig ${bakloc}/Backup/myconfig
#   HOME folder backup
        cp -Rf /home/* ${bakhome}

    echo "=============================================================================="
    echo "Local backup completed in '${bakloc}/Backup'."
    echo "=============================================================================="
sleep 1
    sudo timeshift --create --comments "${tsc}"
    echo
    echo "=============================================================================="
    echo "Backing up on cloud storage ...."
    echo "=============================================================================="
sleep 1
    cd ${bakloc}
    echo
    echo "=============================================================================="
    echo "Compressing backup ...."
    echo "=============================================================================="
    tar -zcf Backup.tar.gz Backup
    mv -f Backup.tar.gz ${bakremote}
    echo
    echo "=============================================================================="
    echo "Uploading backup ...."
    echo "=============================================================================="
    cd ${bakremote}
    grive
sleep 1
    echo
    echo "=============================================================================="
    echo "Backup process completed."
    echo "=============================================================================="
    cd "$HOME"
else
sleep 1
    echo
    echo "=============================================================================="
    echo "Installing required packages '${package}' & '${package1}' ...."
    echo "=============================================================================="
    echo
        sudo pacman -S --noconfirm --needed ${package1} ${package2}
sleep 2
        ${package2} -a -S --noconfirm ${package}

sleep 1
    echo
    setaf 1
    echo "=============================================================================="
    echo "Packages installed. Please configure { $package } & { $package1 } first."
    echo "Also set once ' Backup Locations ' in the script accordingly."
    echo "For the fast and better response, use ' alias ' mentioned in the script."
    echo "After all configurations and changes, re-run this backup script."
    echo "=============================================================================="
    sgr0
fi
