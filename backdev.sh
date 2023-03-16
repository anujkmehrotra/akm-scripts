#!/bin/bash

###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM
###########################################################################################################

#   Backup location for developer's folder
bakpos="/mnt/Personal/POS"

#cp -f $HOME/akm-kbackup.kbp $bakpos
cp -f $HOME/.bakpkgs.sh $bakpos
cp -f $HOME/.bashrc-personal $bakpos
cp -f $HOME/.chromecache $bakpos
cp -f $HOME/.zshrc-personal $bakpos
cp -f $HOME/.config/fish/alias.fish $bakpos
echo 'Done'
