#!/bin/bash

###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM                                                                                 #
# Disribution       : Arch Linux                                                                          #
# Requirement       : tool 'curl'                                                                      #
###########################################################################################################
############################   EDIT THE FOLLOWING ACCORDING YOUR NEED  ##########################################
###########################################################################################################

#   Any temporary download location (like /tmp or /var/tmp).
tmpl="/tmp"
###########################################################################################################
#####################  DO NOT EDIT THIS SECTION UNTIL YOU KNOW WHAT YOU DOING  ####################################
###########################################################################################################
#   File name
file="StevenBlackHosts"
#   Target file
target="/etc/hosts"
#   System service
service="NetworkManager.service"
#   Web hosts file (Most Advanced 1Lac+ lines)
filew="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
# Compact hosts file 11k+ lines
#filew="https://someonewhocares.org/hosts/zero"
#   Requirement
tool="curl"
#   Checking hosts file existence
filecheck="$target"
# Adding hostname
#HOSTNAME="$(uname -n)";


#   Checking required tool and testing versions
if pacman -Qi $tool &> /dev/null ; then


echo "======================================================================================="
echo "Please wait while we update [$target] file for you ...."
echo "======================================================================================="

sleep 1

else

echo "======================================================================================="
echo "Installing missing package ...."
echo "======================================================================================="

sudo pacman -S  --noconfirm $tool

fi

#   Removing old and Downloading new hosts file
sudo rm -f $tmpl/$file
sleep 1
$tool $filew -s -o $tmpl/$file

#   OR alternative command with
#wget -q $filew -O /$tmpl

#   Comparing file versions
cver="$(grep -r 'Date:' "${target}" | cut -c 9-25)";
#cver="$(grep -r 'Last updated:' "${target}" | cut -c 17-50)";
nver="$(grep -r 'Date:' "${tmpl}"/"${file}" | cut -c 9-25)";
#nver="$(grep -r 'Last updated:' "${tmpl}"/"${file}" | cut -c 17-50)";

if test -f "${filecheck}" && [ "${nver}" == "${cver}" ] ; then
echo

echo "======================================================================================="
echo "File [$target] has already updated to $nver. No need to update."
echo "======================================================================================="

else

#   Some minor edits and deltions
sudo sed -i '3,5d' /$tmpl/$file
sudo sed -i '8,12d' /$tmpl/$file
sudo sed -i '22,27d' /$tmpl/$file

sudo sed -e 's|127.0.0.1 localhost|127.0.0.1 localhost akm-ms7c91|g' -i /$tmpl/$file
sudo sed -e 's|::1 localhost|::1 localhost akm-ms7c91|g' -i /$tmpl/$file
sudo sed -e 's|127.0.0.1 localhost akm-ms7c91.localdomain|127.0.0.1 localhost.localdomain|g' -i /$tmpl/$file

#   Checking backup file status
if [ -f "$target.bak" ]; then

sudo cp -f $tmpl/$file $target
sudo systemctl restart $service
echo
echo "======================================================================================="
echo "File [$target] successfully updated to $nver."
echo "======================================================================================="

else

#    Creating backup file if no backup or on first run
sudo cp -f $target $target.bak
echo
echo "======================================================================================="
echo "Hosts file backup created as [/etc/$file.bak]"
echo "======================================================================================="

sudo cp -f $tmpl/$file $target
sudo systemctl restart $service
echo
echo "======================================================================================="
echo "File [$target] successfully updated to $nver."
echo "======================================================================================="

fi

fi

