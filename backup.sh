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
bakhome=/mnt/Data/Backup/KBak
#   Backup location of some System files ( Do not set same as bakhome )
bakloc=/mnt/Data
#   Backup Remote location on local storage that syncs with your favourite cloud storage
bakremote=/mnt/Data/Gdrive
#   Location of any other/personal folder to backup on bakloc/Backup or bakremote
bakother=/mnt/Data/POS
#   Timeshift's commentt
tsc="Backup Script"
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
echo "           '${package}' and '${package1}' before running this."
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

# Deleted all timeshift previous backups
        sudo timeshift --delete-all
        rm -f ${bakremote}/Backup.tar.gz
        rm -f ${bakloc}/Backup.tar.gz
        rm -Rf ${bakhome}

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

#   Removing my manual build pkg (CK kernel) name from the localpkglist
#        sed -i '/linux-ck/d' ${bakloc}/Backup/localpkglist.txt

echo "=============================================================================="
echo "Taking important system files backup ...."
echo "=============================================================================="

#   Important system files backup
#		    cp -f /etc/sddm.conf.d/kde_settings.conf ${bakloc}/Backup
#		    cp -f /etc/sddm.conf ${bakloc}/Backup
		    sudo cp -f /etc/mkinitcpio.d/* ${bakloc}/Backup
		    sudo cp -f /etc/fstab ${bakloc}/Backup
		    sudo cp -f /etc/pacman.conf ${bakloc}/Backup
		    sudo cp -f /etc/default/grub ${bakloc}/Backup
		    sudo cp -f /etc/makepkg.conf ${bakloc}/Backup
		    sudo cp -f /etc/systemd/journald.conf.d/volatile-storage.conf ${bakloc}/Backup
		    sudo cp -f /etc/systemd/journald.conf ${bakloc}/Backup
		    sudo cp -f /etc/udev/rules.d/60-scheduler.rules ${bakloc}/Backup
		    sudo cp -f /etc/sysctl.d/100-archlinux.conf ${bakloc}/Backup
		    sudo cp -f /etc/sysctl.d/9999-disable-core-dump.conf ${bakloc}/Backup
		    sudo cp -f /etc/security/limits.conf ${bakloc}/Backup
#       xanmod kernel config		    
                    sudo cp -f ${bakloc}/linux-xanmod-edge/myconfig ${bakloc}/Backup

echo "=============================================================================="
echo "Taking important folders and files backup from [/home] ...."
echo "=============================================================================="

#   Important folders and files backup from [/home]

        mkdir ${bakhome} && cp -Rf ~/.config .local .bashrc-personal .bashrc .chromecache .mozilla .var .xdman .gnupg .cert .vscode-oss  ${bakhome}

echo "=============================================================================="
echo "Local backup completed in '${bakloc}/Backup'."
echo "=============================================================================="

        sudo timeshift --create --comments "${tsc}"

        cd ${bakloc}
echo
echo "=============================================================================="
echo "Compressing backup ...."
echo "=============================================================================="

        tar -zcf Backup.tar.gz Backup
        mv -f Backup.tar.gz ${bakremote}

echo
echo "Done"
echo
echo "=============================================================================="
echo "Uploading backup ...."
echo "=============================================================================="

        cd ${bakremote}
        grive

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
        ${package2} -a -S --noconfirm ${package}

echo
echo "=============================================================================="
echo "Packages installed. Please configure { $package } & { $package1 } first."
echo "Also set once ' Backup Locations ' in the script accordingly."
echo "For the fast and better response, use ' alias ' mentioned in the script."
echo "After all configurations and changes, re-run this backup script."
echo "=============================================================================="
    fi
