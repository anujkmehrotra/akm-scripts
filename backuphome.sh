#!/bin/bash
set -e

loc="/mnt/Data/Backup"
configs="$loc/config"
locals="$loc/local"

    tput setaf 1
echo "==============================================================================="
echo "Do you want to create backup of '/home' ? (y/n)";
echo "==============================================================================="
    tput sgr0
    read -r CHOICE
    case $CHOICE in

    y )

#   Deleting previous backup
rm -Rf $loc/*
sleep 3
mkdir $configs
mkdir $locals

echo "==============================================================================="
echo "Compacting apps data ...."
echo "==============================================================================="
echo
echo "Closing required apps first ...."
pkill -e google-chrome-stable && pkill -e firefox && pkill -e thunderbird
echo "Running profile cleaning ...."
profile-cleaner gc && profile-cleaner f && profile-cleaner t
echo "Done"
echo
echo "==============================================================================="
echo "Creating backup of '/home/somefolders and files' ...."
echo "==============================================================================="
echo
cp -Rf $HOME/.mozilla $loc
cp -Rf $HOME/.thunderbird $loc
cp -Rf $HOME/.bogofilter $loc
cp -Rf $HOME/.vscode $loc
cp -Rf $HOME/.chromecache $loc
cp -Rf $HOME/.bakpkgs.sh $loc
cp -Rf $HOME/.zshrc-personal $loc
cp -Rf $HOME/.bashrc-personal $loc

echo
echo "==============================================================================="
echo "Creating backup of '/home/.config/someapps' ...."
echo "==============================================================================="
echo
cp -Rf $HOME/.config/alacritty $configs
cp -Rf $HOME/.config/autostart $configs
cp -Rf $HOME/.config/Bitwarden $configs
cp -Rf $HOME/.config/google-chrome $configs
cp -Rf $HOME/.config/GitFiend $configs
cp -Rf $HOME/.config/Code $configs
cp -Rf $HOME/.config/discord $configs
cp -Rf $HOME/.config/mpv $configs
cp -Rf $HOME/.config/vlc $configs
cp -Rf $HOME/.config/omf $configs
cp -Rf $HOME/.config/fish $configs
cp -Rf $HOME/.config/FreeTube $configs
cp -Rf $HOME/.config/protonvpn $configs
cp -Rf $HOME/.config/libreoffice $configs
cp -Rf $HOME/.config/ookla $configs
cp -Rf $HOME/.config/whatsapp-nativefier-d40211 $configs
cp -Rf $HOME/.config/yt-dlg $configs

echo
echo "==============================================================================="
echo "Creating backup of '/home/.loc/Backupal/share/someapps' ...."
echo "==============================================================================="
echo
cp -Rf $HOME/.local/share/applications $locals
cp -Rf $HOME/.local/share/fish $locals
cp -Rf $HOME/.local/share/omf $locals
cp -Rf $HOME/.local/share/TelegramDesktop $locals

    #kbackup --autobg $HOME/akm-kbackup.kbp
;;

    n )
echo
    tput setaf 1
echo "==============================================================================="
echo "You chose not to create backup of '/home'. Exiting ...."
echo "==============================================================================="
    tput sgr0

;;

    * )
echo
    tput setaf 1
echo "==============================================================================="
echo "Only allowed 'y/n' to answer. Exiting ...."
echo "==============================================================================="
    tput sgr0

;;
    esac
echo
echo "==============================================================================="
echo "'/home' backup completed."
echo "==============================================================================="

    tput setaf 1
echo
echo "==============================================================================="
echo "Do you want to create a timeshift stamp ? (y/n)";
echo "==============================================================================="

    tput sgr0
    read -r CHOICE
    case $CHOICE in

    y )
echo
echo "==============================================================================="
echo "Please enter root password to create timeshift stamp ...."
echo "==============================================================================="

sudo timeshift --create --comments "Manual" --tags D
    echo 'Done'
;;

    n )
echo
    tput setaf 1
echo "==============================================================================="
echo "You chose not to create timeshift stamp."
echo "==============================================================================="
    tput sgr0

;;

    * )
echo
    tput setaf 1
echo "==============================================================================="
echo "Only allowed 'y/n' to answer. Exiting ...."
echo "==============================================================================="
    tput sgr0

;;
    esac

#   Running pkgs backup script
sh $HOME/.bakpkgs.sh

echo "==============================================================================="
echo "Task completed."
echo "==============================================================================="
