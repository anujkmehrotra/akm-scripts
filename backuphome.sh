#!/bin/bash

bakloc="/mnt/Data/Backup"

    tput setaf 1
echo "==============================================================================="
echo "Do you want to create backup of '/home' ? (y/n)";
echo "==============================================================================="
    tput sgr0
    read -r CHOICE
    case $CHOICE in

    y )
echo
echo "==============================================================================="
echo "Removing old backup ...."
echo "==============================================================================="
    rm -f $bakloc/*.tar
    echo 'Done'
echo
echo "==============================================================================="
echo "Creating backup of '/home' as 'HomeBak_*.tar' to '$bakloc' ...."
echo "==============================================================================="
echo
    kbackup --autobg $HOME/akm-kbackup.kbp
    echo 'Done'
echo

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
#   Delete old snapshots
echo
sudo timeshift --delete
echo
echo "==============================================================================="
echo "Task completed."
echo "==============================================================================="
