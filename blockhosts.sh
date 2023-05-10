#!/bin/bash

###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM                                                                                 #
# Disribution       : Arch Linux                                                                          #
# Requirement       : tool 'curl'                                                                         #
###########################################################################################################
############################   EDIT THE FOLLOWING ACCORDING YOUR NEED  ####################################
###########################################################################################################

###########################################################################################################
#####################  DO NOT EDIT THIS SECTION UNTIL YOU KNOW WHAT YOU DOING  ############################
###########################################################################################################

#   Temp file name
file="StevenBlackHosts"
#file="DanPolluckHosts"

#   Target file
target="/etc/hosts"

#   System service
service="NetworkManager.service"

#   Web hosts file (Most Advanced 1Lac+ lines)
filew="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
#filew="https://someonewhocares.org/hosts/zero/hosts"

#   Checking hosts file existence
filecheck="$target"

# Adding hostname
#HOSTNAME="$(uname -n)";


#   Checking required tool and testing versions
if pacman -Qi curl &> /dev/null ; then
    sleep 1
else
    sudo pacman -S  --noconfirm curl
fi

#   Removing old and Downloading new hosts file
rm -f /tmp/$file
    sleep 1
curl $filew -s -o /tmp/$file

#   OR alternative command with
#wget -q $filew -O /tmp/$file

#   Comparing file versions
cver="$(grep -r 'Date:' "$target" | cut -c 9-25)";
#cver="$(grep -r 'Last updated:' "${target}" | cut -c 17-50)";
nver="$(grep -r 'Date:' "/tmp/$file" | cut -c 9-25)";
#nver="$(grep -r 'Last updated:' "/tmp/${file}" | cut -c 17-50)";

if test -f "$filecheck" && [ "$nver" == "$cver" ] ; then
rm -f /tmp/$file
echo
echo "============================================================================================="
echo "File [$target] has already updated to $nver. No need to update."
echo "============================================================================================="

else

#   Some minor edits and deltions
#sudo sed -i '3,5d' //tmp/$file
#sudo sed -i '8,12d' //tmp/$file
#sudo sed -i '22,27d' //tmp/$file
#sudo sed -e 's|127.0.0.1 localhost|127.0.0.1 localhost akm-ms7c91|g' -i //tmp/$file
#sudo sed -e 's|::1 localhost|::1 localhost akm-ms7c91|g' -i //tmp/$file
#sudo sed -e 's|127.0.0.1 localhost akm-ms7c91.localdomain|127.0.0.1 localhost.localdomain|g' -i //tmp/$file
#sed -i '12,68d' /tmp/$file
sleep 1

#   Checking backup file status
if [ -f "$target.bak" ]; then

sudo cp -f /tmp/$file $target
sudo systemctl restart $service
rm -f /tmp/$file
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

sudo cp -f /tmp/$file $target
sudo systemctl restart $service
rm -f /tmp/$file
echo
echo "======================================================================================="
echo "File [$target] successfully updated to $nver."
echo "======================================================================================="

fi

fi

