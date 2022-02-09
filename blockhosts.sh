#!/bin/bash

###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM                                                                                 #
# Disribution 	    : Arch Linux (Tested on ArcoLinux only)                                               #
# Instruction       : Choose any 1 METHOD (CUSTOMISED or DIRECT) at a time and keep disable the other.    #
# Requirement       : package 'curl' for METHOD 1 and package 'wget' for METHOD 2                         #
###########################################################################################################
############################   EDIT THE FOLLOWING ACCORDING YOUR NEED  ####################################
###########################################################################################################

#   Any tmps location (like /temp or /var/temp). I prefer ramdisk.

tmpl="/mnt/RamDisk"

###########################################################################################################
#####################  DO NOT EDIT THIS SECTION UNTIL YOU KNOW WHAT YOU DOING  ############################
###########################################################################################################
#   File name
file="hosts"
#   Target file
target="/etc/hosts"
#   System service
service="NetworkManager.service"
#   Web hosts file
filew="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
#   Requirement
package1="curl"
package2="wget"

#   Checking required package
if pacman -Qi ${package1} ${package2} &> /dev/null; then
        echo "======================================================================================="
        echo "Please wait while we update [${target}] file for you ...."
        echo "======================================================================================="
      sleep 1
else
        echo "======================================================================================="
        echo "Installing missing packages ...."
        echo "======================================================================================="

        sudo pacman -S ${package1} ${package2}--noconfirm

fi

###########################################################################################################
######################################  CUSTOMISED METHOD  ################################################
###########################################################################################################

      cd ${tmpl}
      rm -f ${file}
      curl ${filew} -O
      sudo mv -f ${file} ${target}
      sudo systemctl restart ${service}
      echo "======================================================================================="
      echo "File [${target}] successfully updated."
      echo "======================================================================================="
      cd ~

###########################################################################################################
#######################################  DIRECT METHOD ####################################################
###########################################################################################################

      #wget -q https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts -O ${target}
      #sudo systemctl restart ${service}
