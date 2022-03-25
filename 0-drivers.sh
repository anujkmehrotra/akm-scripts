#!/bin/bash
set -e

###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author       		: AKM                                                                                   #
# Disribution 		: ArchLinux (Tested on ArcoLinux only)                                                  #
###########################################################################################################

# Where I take regular backup of my /home directory (other than '/' and '/home')
bakloc="/mnt/Data/Backup"
PKGS=("reflector" "rate-mirrors-bin" "powerpill" "zenpower-dkms-git" "zenmonitor-git" "msr-tools" "amd-ucode" "gufw" "timeshift")
#========================================================================================================================
#echo 'tmpfs	/tmp		tmpfs   defaults,noatime,mode=1777 0 0
#tmpfs	/var/log	tmpfs   defaults,noatime,mode=0755 0 0
#tmpfs	/var/tmp	tmpfs   defaults,noatime,mode=1777 0 0' | sudo tee -a /etc/fstab

#sudo pacman -S --noconfirm --needed gnome-disk-utility
#sudo gnome-disks

#git clone https://github.com/estarq/ramdisk
#cd ramdisk
#sudo python3 install.py
#echo " RamDisk successfully installed."

##  Enable these below commands after above executions
#=====================================================================================
##  Backup
#rm -Rf ${bakloc}/Originals/*
#   Mirrorlist
#cp -f /etc/pacman.d/chaotic-mirrorlist ${bakloc}/Originals
# preset files
#cp -f /etc/mkinitcpio.d/* ${bakloc}/Originals
# fstab file
#cp -f /etc/fstab ${bakloc}/Originals
# pacman file
#cp -f /etc/pacman.conf ${bakloc}/Originals
# grub file
#cp -f /etc/default/grub ${bakloc}/Originals
# aur and other package make file
#cp -f /etc/makepkg.conf ${bakloc}/Originals
# network hosts file
#cp -f /etc/hosts ${bakloc}/Originals
#========================================================================================================================

##  If required for Chaotic repo
#sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com && sudo sudo pacman-key --lsign-key 3056513887B78AEB
#sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
#sudo pacman -Sy --noconfirm chaotic-keyring && sudo pacman -S --noconfirm chaotic-mirrorlist
#sudo pacman -S archlinuxcn-mirrorlist-git archlinuxcn-keyring --noconfirm

#sudo pacman -Syy
#sudo pacman -Rs --noconfirm xf86-video-amdgpu xf86-video-ati xf86-video-fbdev xf86-video-vesa xf86-video-openchrome broadcom-wl-dkms r8168-dkms tlp
#sudo mkinitcpio -p linux
##  For Gnome
##  Disable Color and remove 'Default Samsung Color' from Settings-Color and import 'Standard sRGB' color. Use [!] from the list after removing default.

##  Also make it as startup from chromecache
#nautilus -q || tracker daemon -k || tracker3 daemon -k
#sudo pacman -S --needed mutter-performance nautilus-admin-git
#sudo pacman -Rs --noconfirm epiphany gnome-mplayer gnome-pie gnome-boxes cheese gnome-maps gnome-photos
#sudo pacman -Rcns --noconfirm thunar
sudo pacman -Sy
#sudo pacman -Sy chaotic-keyring
sudo pacman -S --needed "${PKGS[@]}" && echo 'All packages installed.'

sudo systemctl disable cronie.service
sudo systemctl enable fstrim.timer
sudo systemctl enable --now ufw.service
#========================================================================================================================
##  Overwrite files
sudo cp -f $bakloc/Originals/chaotic-mirrorlist /etc/pacman.d
sudo cp -f $bakloc/grub /etc/default
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo cp -f $bakloc/makepkg.conf /etc
sudo cp -f $bakloc/pacman.conf /etc

#Creating some files
sudo cp -f /mnt/Data/Backup/60-scheduler.rules /etc/udev/rules.d
#sudo cp -f /mnt/Data/Backup/100-archlinux.conf /etc/sysctl.d
sudo cp -f /mnt/Data/Backup/9999-disable-core-dump.conf /etc/sysctl.d
sudo sysctl -p /etc/sysctl.d/9999-disable-core-dump.conf
sudo cp -f /mnt/Data/Backup/limits.conf /etc/security
sudo cp -f /mnt/Data/Backup/blacklist.conf /etc/modprobe.d/blacklist.conf
#========================================================================================================================

# Creating Swap file (Optional)
#sleep 1
#    sudo dd if=/dev/zero of=/swapfile bs=1M count=6143
#    sudo mkswap /swapfile
#    sudo chmod 600 /swapfile
#    sudo swapon /swapfile
#    sudo mount -a
#    echo'/swapfile								  none			swap	defaults 0 0 | sudo tee -a /etc/fstab
#========================================================================================================================

##  Do not enable in Gnome if GDM is installed
#sudo cp -f ${bakloc}/kde_settings.conf /etc/sddm.conf.d
#sudo cp -f ${bakloc}/sddm.conf /etc
#========================================================================================================================

sudo chmod u+s /usr/bin/hddtemp
