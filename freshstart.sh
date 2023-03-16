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

bakfs="/mnt/Data/FS"
pos="/mnt/Personal/POS"

#/etc/default/grub
#default
#GRUB_CMDLINE_LINUX_DEFAULT='quiet loglevel=3 audit=0 nvme_load=yes'
#new
#GRUB_CMDLINE_LINUX_DEFAULT='amd_pstate=passive quiet loglevel=3 audit=0 nvme_load=yes nvme_core.default_ps_max_latency_us=0'

#sudo grub-mkconfig -o /boot/grub/grub.cfg

#/etc/systemd/journald.conf
#Storage=none

#/etc/systemd/journald.conf.d/volatile-storage.conf
#Storage=none

echo 'vm.vfs_cache_pressure=50
vm.swappiness=10'| sudo tee /etc/sysctl.d/100-archlinux.conf

#/etc/security/limits.conf
#*               soft    core            0
#*               hard    rss             0

echo 'fs.suid_dumpable=0 \
kernel.core_pattern=|/bin/false'| sudo tee /etc/sysctl.d/9999-disable-core-dump.conf

sudo sysctl -p /etc/sysctl.d/9999-disable-core-dump.conf


# Packages to install
echo "============================================================================"
echo 'Installing required packages ....'
echo "============================================================================"

sleep 1
echo
# Ensure Chaotic Repo
sudo pacman -S --noconfirm --needed ast-firmware amd-ucode protonvpn-gui google-chrome nvidia-vaapi-driver-git bogofilter arcolinux-fish-git visual-studio-code-bin gitfiend

paru -a -s chromium-extension-web-store zramd grive
sudo systemctl enable zramd.service --now

# Enable/Disable services
echo
echo "============================================================================"
echo 'Updating required services .... (If you do not have printer & bluetooth)'
echo "============================================================================"

sudo systemctl disable cups.service
sudo systemctl enable fstrim.timer
sudo systemctl enable ufw.service --now

#-----------------------------------------------------------------------------------
#/etc/makepkg.conf
#default
#CFLAGS="-march=x86-64 -mtune=generic -O2 -pipe -fno-plt -fexceptions \
#        -Wp,-D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security \
#        -fstack-clash-protection -fcf-protection"
#CXXFLAGS="$CFLAGS -Wp,-D_GLIBCXX_ASSERTIONS"

#new
#CFLAGS="-march=znver2 -mtune=znver2 -O2 -pipe -fstack-protector-strong \
#        -Wp,-D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security \
#        -fstack-clash-protection -fcf-protection"
#CXXFLAGS="${CFLAGS}"
#-----------------------------------------------------------------------------------
    # Creating Swap file (Optional)
#echo "============================================================================"
#echo "Creating swap file (2 GB) .... ('zramd' is the better alternative)"
#echo "============================================================================"

#sleep 1
#    sudo dd if=/dev/zero of=/swapfile bs=1M count=4096
#    sudo mkswap /swapfile
#    sudo chmod 600 /swapfile
#    sudo swapon /swapfile
#    sudo mount -a
#    echo'/swapfile								  none			swap	defaults 0 0 | sudo tee -a /etc/fstab
#echo
#echo "============================================================================"
#echo "Please see above if any error found, else Swapfile is created successfully."
#echo "============================================================================"
#-----------------------------------------------------------------------------------
#/etc/fstab

#tmpfs									  /tmp			tmpfs   defaults,noatime,mode=1777 0 0
#tmpfs									  /var/log		tmpfs   defaults,noatime,mode=0755 0 0
#tmpfs									  /var/tmp		tmpfs   defaults,noatime,mode=1777 0 0
#-----------------------------------------------------------------------------------

echo "============================================================================"
echo "All apps & changes applied."
echo "Please review and CONFIRM the above changes and then reboot."
echo "============================================================================"
