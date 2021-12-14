#!/bin/bash
set -e

###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM                                                                                 #
# Disribution 		: ArchLinux (Tested on ArcoLinux only)                                                #
# Condition         : After Fresh Installation on NVME-SSD (Some changes are only for NVME)               #
###########################################################################################################

############################   EDIT THE FOLLOWING ACCORDING YOUR NEED  ####################################
############################  PUT HASH (#) BEFORE THE LINE TO DISABLE #####################################

# Where I take regular backup of my /home directory (other than '/' and '/home')
bakdir="/mnt/Recovery/Backup/KBak"

echo "============================================================================"
echo "Installing apps & Applying changes to make your system better."
echo "Each file which we change will be backuped in the same directory as (.bak) ."
echo "============================================================================"
echo
echo "============================================================================"
echo "WARNING : DO NOT Open and Run any app during this process."
echo "============================================================================"
echo
sleep 3
#   Coping your bashrc-personal file from the backup directory
    cp -f /$bakdir/.bashrc-personal ~/.bashrc-personal && source ~/.bashrc-personal

#   Uninstall required drivers & Apps
echo
echo "============================================================================"
echo 'Updating pacman.conf .... (Backup file : /etc/pacman.conf.bak)'
echo "============================================================================"
    sudo cp -f /etc/pacman.conf /etc/pacman.conf.bak
echo
    echo'
    [chaotic-aur]
    SigLevel = Required DatabaseOptional
    Include = /etc/pacman.d/chaotic-mirrorlist

    [arcolinux_repo_submicron]
    SigLevel = Required DatabaseOptional
    Include = /etc/pacman.d/arcolinux-mirrorlist' | sudo tee -a /etc/pacman.conf
sleep 3
echo
echo "============================================================================"
echo 'To revert back, please restore from (.bak) file and reboot.'
echo "============================================================================"
echo
echo "============================================================================"
echo 'Updating system repositories ....'
echo "============================================================================"
sleep 3
    sudo pacman -Syy

# If required for Chaotic repo
    pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com && sudo sudo pacman-key --lsign-key 3056513887B78AEB && sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

echo "============================================================================"
echo 'Changing system scheduler (/etc/udev/rules.d/60-ioschedulers.rules) ....'
echo "============================================================================"
sleep 3
echo
    echo'# set scheduler for NVMe
    ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/scheduler}="none"
    # set scheduler for SSD and eMMC
    ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"
    # set scheduler for rotating disks
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"' | sudo tee /etc/udev/rules.d/60-ioschedulers.rules
echo
echo "============================================================================"
echo 'To revert back, please delete the above mentioned file and reboot.'
echo "============================================================================"
echo
echo "============================================================================"
echo 'Changing & Updating Grub .... (Backup file : /etc/default/grub.bak)'
echo "============================================================================"
    sudo cp -f /etc/default/grub /etc/default/grub.bak
sleep 3
    echo
    sudo sed -e 's|GRUB_TIMEOUT=5|GRUB_TIMEOUT=3|g' -i /etc/default/grub
    sudo sed -e 's|GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=5 audit=0"|GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 audit=0 nvme_core.default_ps_max_latency_us=0|g' -i /etc/default/grub

    sudo grub-mkconfig -o /boot/grub/grub.cfg
echo
echo "============================================================================"
echo 'To revert back, please restore from (.bak) file, update grub and reboot.'
echo 'update grub = sudo grub-mkconfig -o /boot/grub/grub.cfg'
echo "============================================================================"
echo
echo "============================================================================"
echo 'Changing makepkg.conf .... (Changes for Xanmod Kernel)'
echo "============================================================================"
sleep 3
    sudo sed -e 's|CFLAGS="-march=x86-64 -mtune=generic -O2 -pipe -fno-plt -fexceptions \|CFLAGS="-march=x86-64 -mtune=generic -O3 -pipe -fno-plt -fexceptions \|g' -i /etc/makepkg.conf

echo
echo "============================================================================"
echo 'Disabling journaling .... (Backup file : /etc/systemd/journald.conf.bak)'
echo "============================================================================"
sleep 3
    sudo cp -f /etc/systemd/journald.conf /etc/systemd/journald.conf.bak
    sudo sed -e 's|Storage=volatile|Storage=none|g' -i /etc/systemd/journald.conf
echo
echo "============================================================================"
echo 'To revert back, please restore from (.bak) file and reboot.'
echo "============================================================================"
echo
echo "============================================================================"
echo 'Changing Net .. (Backup file : /etc/NetworkManager/NetworkManager.conf.bak)'
echo "============================================================================"
    sudo cp -f /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf.bak
echo
    echo'# Configuration file for NetworkManager.
    # See "man 5 NetworkManager.conf" for details.

    [main]
    dns=none
    systemd-resolved=false

    [device]
    wifi.scan-rand-mac-address=no' | sudo tee /etc/NetworkManager/NetworkManager.conf
echo
echo "============================================================================"
echo 'To revert back, please restore from (.bak) file and reboot.'
echo "============================================================================"
echo
echo "============================================================================"
echo 'Changing DNS options .... (Backup file : /etc/resolv.conf.bak)'
echo "============================================================================"
    sudo cp -f /etc/resolv.conf /etc/resolv.conf.bak
    echo'# Generated by NetworkManager
    options timeout:1
    options single-request

    nameserver 1.1.1.2
    nameserver 1.0.0.2'| sudo tee /etc/resolv.conf
echo
echo "============================================================================"
echo 'To revert back, please restore from (.bak) file and reboot.'
echo "============================================================================"
echo
echo "============================================================================"
echo 'Updating system swap handling .... (/etc/sysctl.d/100-archlinux.conf)'
echo "============================================================================"
sleep 3
echo
    echo'vm.vfs_cache_pressure=50
    vm.swappiness=10
    vm.dirty_background_ratio=1     #increase slowly, up to 10%, if CPU gets too busy with compression.
    vm.dirty_ratio=20   #around 20 to 50 percent is fine.' | sudo tee /etc/sysctl.d/100-archlinux.conf
echo
echo "============================================================================"
echo 'To revert back, please delete the above mentioned file and reboot.'
echo "============================================================================"
echo
echo "============================================================================"
echo "Removing Core Dumping .... (Backup file : /etc/security/limits.conf.bak)"
echo "============================================================================"

    sudo cp -f /etc/security/limits.conf /etc/security/limits.conf.bak

    sudo sed -e 's|#*               soft    core            0|*               soft    core            0|g' -i /etc/security/limits.conf
    sudo sed -e 's|#*               hard    rss             10000|*               hard    rss             0|g' -i /etc/security/limits.conf
    echo'fs.suid_dumpable=0
    kernel.core_pattern=|/bin/false' | sudo tee /etc/sysctl.d/9999-disable-core-dump.conf

    sudo sysctl -p /etc/sysctl.d/9999-disable-core-dump.conf
echo
echo "============================================================================"
echo 'To revert back, please restore from (.bak) file and delete the file'
echo "'/etc/sysctl.d/9999-disable-core-dump.conf' and reboot."
echo "============================================================================"
echo
echo "============================================================================"
echo "Removing unrequired packages ...."
echo "============================================================================"

sleep 3
# Packages to remove
echo
    sudo pacman -R --noconfirm xf86-video-amdgpu xf86-video-ati xf86-video-fbdev xf86-video-vesa xf86-video-openchrome firefox tlp broadcom-wl

echo "----------------------------------------------------------------------------"

# Packages to install
echo "============================================================================"
echo 'Installing required packages ....'
echo "============================================================================"

sleep 3
echo
    sudo pacman -S --noconfirm --needed reflector rate-mirrors-bin powerpill gnome-disk-utility amd-ucode-git


# Enable/Disable services
echo
echo "============================================================================"
echo 'Updating required services .... (If you do not have printer & bluetooth)'
echo "============================================================================"

sleep 3
    sudo systemctl disable cups.service
    sudo systemctl disable bluetooth.service
    sudo systemctl disable cronie.service
    sudo systemctl enable fstrim.timer
    sudo systemctl enable ufw.service

# Creating Swap file (Optional)
#echo "============================================================================"
#echo 'Creating swap file (6 GB) .... ('zramd' is the better alternative)'
#echo "============================================================================"

#sleep 3
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

sleep 3
#   Change your drive(s) details. Otherwise your system will not boot after reboot.
echo
echo "============================================================================"
echo 'Updating fstab file with auto-mounting .... (Backup file : /etc/fstab.bak)'
echo "============================================================================"
echo
sleep 3
    echo
    sudo cp -f /etc/fstab /etc/fstab.bak

    echo 'tmpfs									  /tmp			tmpfs   defaults,noatime,mode=1777 0 0
    tmpfs									  /var/log		tmpfs   defaults,noatime,mode=0755 0 0
    tmpfs									  /var/tmp		tmpfs   defaults,noatime,mode=1777 0 0' | sudo tee -a /etc/fstab
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
