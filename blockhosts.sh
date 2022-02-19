#!/bin/bash

###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM                                                                                 #
# Disribution       : Arch Linux (Tested on ArcoLinux only)                                               #
# Instruction       : Choose any 1 METHOD (CUSTOMISED or DIRECT) at a time and keep disable the other.    #
# Requirement       : package 'curl' for METHOD 1 and package 'wget' for METHOD 2                         #
###########################################################################################################
############################   EDIT THE FOLLOWING ACCORDING YOUR NEED  ##########################################
###########################################################################################################

#   Any temporary download location (like /temp or /var/temp). I prefer ramdisk.
tmpl="/mnt/RamDisk"
###########################################################################################################
#####################  DO NOT EDIT THIS SECTION UNTIL YOU KNOW WHAT YOU DOING  ####################################
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
package="curl"
#   Checking hosts file existence
filecheck="${target}"

#   Checking required package and testing versions
if pacman -Qi "${package}" &> /dev/null ; then

        echo "======================================================================================="
        echo "Please wait while we update [${target}] file for you ...."
        echo "======================================================================================="
      sleep 1
else
        echo "======================================================================================="
        echo "Installing missing packages ...."
        echo "======================================================================================="

        sudo pacman -S  --noconfirm "${package}"
fi

#    Downloading hosts file
rm -f "${tmpl}"/"${file}"
"${package}" "${filew}" -o "${tmpl}"/"${file}"

#   Comparing file versions
cver="$(grep -r 'Date:' "${target}" | cut -c 9-25);"
nver="$(grep -r 'Date:' "${tmpl}"/"${file}" | cut -c 9-25);"

if test -f "${filecheck}" && [ "${nver}" == "${cver}" ] ; then
      echo
      echo "======================================================================================="
      echo "File [${target}] has already updated to ${nver}. No need to update."
      echo "======================================================================================="
else
      sleep 1
      sudo cp -f "${tmpl}"/"${file}" "${target}"
      sudo systemctl restart "${service}"
      echo
      echo "======================================================================================="
      echo "File [${target}] successfully updated to ${nver}."
      echo "======================================================================================="
fi
