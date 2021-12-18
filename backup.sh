#!/bin/bash
set -e
##################################################################################################################
# Author        :   AKM
# Distribution  :   ArcoLinux only
# Pkgs Reuired  :   grive (paru -a -S grive), timeshift (paru -S timeshift)
##################################################################################################################

#   Backup location for home (other than /home) folder
bakhome=/mnt/Recovery/Backup/KBak
#   Backup location of some System files ( Do not set same as bakhome )
bakdir=/mnt/Recovery/Backup
#   Backup Remote location on local storage that syncs with your favourite remote server
bakremote=/mnt/Data/Gdrive
#   Location of any other/personal folder to backup on bakdir or bakremote
bakother=/mnt/Data/POS
#   Timeshift's comment
tsc="Created by AKM"
#   Required packages
#   You can use any remote drive's package (Dropbox, Google Drive or other)
package="grive"
#   Do not change package1
package1="timeshift"
#   AUR Handler (yay / paru)
package2="paru"

echo
tput setaf 1
echo "============================================================================"
echo "          This script assumes that you have already configured"
echo "            '${package}' and '${package1}'before running it."
echo "         If not, it will install them. Kindly configure by yourself."
echo
echo "WARNING : This is NOT an incremental backup process."
echo "          It will delete all the previous backups including timeshift."
echo "============================================================================"
tput sgr0

if pacman -Qi ${package} ${package1} ${package2} &> /dev/null; then
    echo "=============================================================================="
    echo "Enter password to continue. Ctrl+C to cancel ...."
    echo "=============================================================================="
    echo
        sudo timeshift --delete-all
    echo
    echo "=============================================================================="
    echo "Removing previous backup and timeshift snapshot ...."
    echo "=============================================================================="
        rm -f ${bakremote}/Backup.tar.gz
        rm -Rf ${bakremote}/POS
        rm -Rf ${bakhome}
sleep 3
    echo
    echo "=============================================================================="
    echo "Removed previous backup. Starting a new ...."
    echo "=============================================================================="
    echo
sleep 3
        pacman -Qqe > ${bakdir}/pkglist.txt && echo 'All packages list backuped.'
        pacman -Qqem > ${bakdir}/localpkglist.txt && echo 'All local packages list backuped.'
        cp -f /etc/mkinitcpio.d/* ${bakdir} && echo 'Files preset backuped.'
        cp -f /etc/sddm.conf.d/kde_settings.conf ${bakdir}/kde_settings.conf && echo 'File kde_settings.conf backuped.'
        cp -f /etc/sddm.conf.d/hidpi.conf ${bakdir}/hidpi.conf && echo 'File hidpi.conf backuped.'
        cp -f /etc/sddm.conf ${bakdir}/sddm.conf && echo 'File sddm.conf backuped.'
        cp -f /etc/fstab ${bakdir}/fstab && echo 'File fstab backuped.'
        cp -f /etc/pacman.conf ${bakdir}/pacman.conf && echo 'File pacman backuped.'
        cp -f /etc/default/grub ${bakdir}/grub && echo 'File grub backuped.'
        cp -f /etc/hosts ${bakdir}/hosts && echo 'File hosts backuped.'
        cp -f /etc/hblock/allow.list ${bakdir}/allow.list && echo 'File allowlist backuped.'
        cp -f /etc/hblock/deny.list ${bakdir}/deny.list && echo 'File denylist backuped.'
        cp -f /mnt/Data/linux-xanmod-edge/myconfig ${bakdir}/myconfig && echo 'File myconfig backuped.'
        cp -Rf /home/* ${bakhome} && echo 'Folder HOME backuped.'
        cp -Rf ${bakother} ${bakremote}/POS && echo 'Folder POS backuped.'
    echo
    echo "=============================================================================="
    echo "Local backup completed in '${bakdir}'."
    echo "=============================================================================="
sleep 3
    echo
    echo "=============================================================================="
    echo "Creating Timeshift Snapshot. Please wait ...."
    echo "=============================================================================="
    echo
        sudo timeshift --create --comments "${tsc}"
    echo
    echo "=============================================================================="
    echo "Creating remote backup on Google Drive ...."
    echo "=============================================================================="
sleep 3
    echo
        tar -zcf ${bakremote}/Backup.tar.gz ${bakdir}
    cd ${bakremote}
    grive
sleep 3
    echo
    echo "=============================================================================="
    echo "Backup process completed."
    echo "=============================================================================="
    echo
    cd $HOME
else
sleep 3
    echo
    echo "=============================================================================="
    echo "Installing required packages ${package} & ${package1} ...."
    echo "=============================================================================="
    echo
        sudo pacman -S --noconfirm --needed ${package1} ${package2}
        paru -a -S --noconfirm ${package}

sleep 3
    echo
    echo "=============================================================================="
    echo "Packages installed. Please configure { $package } & { $package1 } first."
    echo "Also set once ' Backup Locations ' in the script accordingly."
    echo "For the fast and better response, use ' alias ' mentioned in the script."
    echo "After all configurations and changes, re-run this backup script."
    echo "=============================================================================="
    echo

fi

#   To run this script from terminal directly, create the following alias in bashrc
#   or in bashrc-personal.
#   Replace the words (location of this file) with real location.
#   alias bakup="sh location of this file [ backup.sh ]
