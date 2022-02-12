#!/bin/bash
set -e

###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM                                                                                 #
# Disribution 		  : ArcoLinux only                                                                      #
# Condition         : After Fresh Installation on NVME-SSD (Some changes are only for NVME)               #
###########################################################################################################

############################   EDIT THE FOLLOWING ACCORDING YOUR NEED  ####################################
############################  PUT HASH (#) BEFORE THE LINE TO DISABLE #####################################

# Where I take regular backup of my /home directory (other than '/' and '/home')
#bakdir="/mnt/Recovery/Backup/KBak"

echo "============================================================================"
echo "Installing apps & Applying changes to make your system better."
echo "Each file which we change will be backuped in the same directory as (.bak) ."
echo "============================================================================"
echo
echo "============================================================================"
echo "WARNING : DO NOT Open and Run any app during this process."
echo "============================================================================"
echo
sleep 1
#   Coping your bashrc-personal file from the backup directory
#    cp -f /$bakdir/.bashrc-personal ~/.bashrc-personal && source ~/.bashrc-personal

#   Uninstall required drivers & Apps

echo "============================================================================"
echo 'To revert back, please restore from (.bak) file and reboot.'
echo "============================================================================"
echo
echo "============================================================================"
echo 'Updating system repositories ....'
echo "============================================================================"
sleep 1
echo
    sudo pacman -Syy
echo
echo "============================================================================"
echo 'Changing system scheduler (/etc/udev/rules.d/60-ioschedulers.rules) ....'
echo "============================================================================"
sleep 1
echo
    echo'# set scheduler for NVMe
    ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/scheduler}="none"
    # set scheduler for SSD and eMMC
    ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"
    # set scheduler for rotating disks
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"' | sudo tee /etc/udev/rules.d/60-ioschedulers.rules
echo
echo "============================================================================"
echo 'Updating system swap handling .... (/etc/sysctl.d/100-archlinux.conf)'
echo "============================================================================"
sleep 1
echo
    echo'vm.vfs_cache_pressure=50
    vm.swappiness=10
    vm.dirty_background_ratio=1     #increase slowly, up to 10%, if CPU gets too busy with compression.
    vm.dirty_ratio=20   #around 20 to 50 percent is fine.' | sudo tee /etc/sysctl.d/100-archlinux.conf
echo
echo "============================================================================"
echo 'To revert back, please restore from (.bak) file and delete the file'
echo "'/etc/sysctl.d/9999-disable-core-dump.conf' and reboot."
echo "============================================================================"
echo
echo "============================================================================"
echo "Removing unrequired packages ...."
echo "============================================================================"
sleep 1
# Packages to remove
echo
    sudo pacman -R --noconfirm xf86-video-amdgpu xf86-video-ati xf86-video-fbdev xf86-video-vesa xf86-video-openchrome firefox tlp broadcom-wl variety arcolinux-variety-autostart-git arcolinux-variety-git thunar
echo
echo "============================================================================"

# Packages to install
echo "============================================================================"
echo 'Installing required packages ....'
echo "============================================================================"

sleep 1
echo
    sudo pacman -S --noconfirm --needed reflector rate-mirrors-bin powerpill gnome-disk-utility amd-ucode-git


# Enable/Disable services
echo
echo "============================================================================"
echo 'Updating required services .... (If you do not have printer & bluetooth)'
echo "============================================================================"

sleep 1
    sudo systemctl disable cups.service
    sudo systemctl disable cronie.service
    sudo systemctl enable fstrim.timer
    sudo systemctl enable ufw.service

# Creating Swap file (Optional)
#echo "============================================================================"
#echo 'Creating swap file (6 GB) .... ('zramd' is the better alternative)'
#echo "============================================================================"

#sleep 1
#    sudo dd if=/dev/zero of=/swapfile bs=1M count=6143
#    sudo mkswap /swapfile
#    sudo chmod 600 /swapfile
#    sudo swapon /swapfile
#    sudo mount -a
#    echo'/swapfile								  none			swap	defaults 0 0 | sudo tee -a /etc/fstab
#echo
#echo "============================================================================"
#echo "Please see above if any error found, else Swapfile is created successfully."
#echo "============================================================================"

sleep 1
#   Change your drive(s) details. Otherwise your system will not boot after reboot.
echo
echo "============================================================================"
echo 'Updating fstab file with auto-mounting .... (Backup file : /etc/fstab.bak)'
echo "============================================================================"
echo
sleep 1
echo
    sudo cp -f /etc/fstab /etc/fstab.bak

echo 'tmpfs									  /tmp			tmpfs   defaults,noatime,mode=1777 0 0
tmpfs									  /var/log		tmpfs   defaults,noatime,mode=0755 0 0
tmpfs									  /var/tmp		tmpfs   defaults,noatime,mode=1777 0 0 | sudo tee -a /etc/fstab
echo
echo "============================================================================"
echo 'To revert back, please restore from (.bak) file and reboot.'
echo "============================================================================"
echo
echo "============================================================================"
echo "All apps & changes applied."
echo "Please review and CONFIRM the above changes and then reboot."
echo "Revert back, if you need, as mentioned above."
echo "============================================================================"
