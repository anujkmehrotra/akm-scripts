#!/bin/bash
set -e
##################################################################################################################
# Author        :   AKM
# Distribution  :   Arch Linux only
##################################################################################################################
#   Backup location of home folder

loc="/mnt/Data/Backup"
configs="$loc/config"
locals="$loc/local"

echo "################################################################"
echo "###########       Restoring / Installing Apps        ###########"
echo "################################################################"
echo
# Ensure enabling Chaotic Repo
sudo pacman -S --needed ast-firmware amd-ucode freetube-bin google-chrome protonvpn-gui arcolinux-fish-git timeshift profile-cleaner cpuid --noconfirm
echo
echo "==============================================================================="
echo "Restoring '/home/some files' ...."
echo "==============================================================================="
echo
echo "Creating required '/tmp' folders ...."
mkdir /tmp/freetube
mkdir /tmp/google-chrome
mkdir /tmp/mpv
mkdir /tmp/discord
mkdir /tmp/whatsapp
mkdir /tmp/code
mkdir /tmp/thumbnails
echo 'Done'
echo
echo "Coping folders and files to '/home ....'"
cp -f $loc/.chromecache $HOME/
cp -f $loc/.bakpkgs.sh $HOME/
cp -f $loc/.bashrc-personal $HOME/
cp -Rf $loc/.mozilla $HOME/
cp -Rf $loc/.thunderbird $HOME/
cp -Rf $loc/.bogofilter $HOME/
cp -Rf $loc/.vscode $HOME/
cp -f $loc/.zshrc-personal $HOME/
echo "All files and folders restored."
echo
echo "==============================================================================="
echo "Restoring '/home/.config/someapps' ...."
echo "==============================================================================="
cp -Rf $configs/* $HOME/.config/
echo "All apps configuration restored."
echo
echo "==============================================================================="
echo "Restoring '/home/.local/share/someapps' ...."
echo "==============================================================================="
cp -Rf $locals/* $HOME/.local/share/
echo "All local apps restored."
echo
echo "################################################################"
echo "###########        Done. Please reboot           ###############"
echo "################################################################"
