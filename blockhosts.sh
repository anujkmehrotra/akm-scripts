#!/bin/bash

###########################################################################################################
###############################   PLEASE READ THE SCRIPT BEFORE USING  ####################################
###############################    USE THIS SCRIPT AT YOUR OWN RISK  ######################################
###########################################################################################################
# Author            : AKM                                                                                 #
# Disribution       : Arch Linux                                                                          #
# Requirement       : package 'curl'                                                                      #
###########################################################################################################
############################   EDIT THE FOLLOWING ACCORDING YOUR NEED  ##########################################
###########################################################################################################

#   Any temporary download location (like /tmp or /var/tmp).
tmpl="/tmp"
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
filecheck="$target"
# Adding hostname
#HOSTNAME="$(uname -n)";


#   Checking required package and testing versions
if pacman -Qi "${package}" &> /dev/null ; then


echo "======================================================================================="
echo "Please wait while we update [$target] file for you ...."
echo "======================================================================================="

sleep 1

else

echo "======================================================================================"
echo "Installing missing packages ...."
echo "======================================================================================="

sudo pacman -S  --noconfirm "$package"

fi

#    Downloading hosts file
rm -f $tmpl/$file
$package $filew -o $tmpl/$file

#   Comparing file versions
cver="$(grep -r 'Date:' "${target}" | cut -c 9-25)";
nver="$(grep -r 'Date:' "${tmpl}"/"${file}" | cut -c 9-25)";

if test -f "${filecheck}" && [ "${nver}" == "${cver}" ] ; then
echo

echo "======================================================================================="
echo "File [$target] has already updated to $nver. No need to update."
echo "======================================================================================="

else

sleep 1

sudo sed -e 's|127.0.0.1 localhost|127.0.0.1 localhost akm-ms7c91|g' -i /$tmpl/$file
sudo sed -e 's|::1 localhost|::1 localhost akm-ms7c91|g' -i /$tmpl/$file
sudo sed -e 's|127.0.0.1 localhost akm-ms7c91.localdomain|127.0.0.1 localhost.localdomain|g' -i /$tmpl/$file

if [ -f "/etc/$file.bak" ]; then

sudo cp -f "$tmpl"/"$file" "$target"
sudo systemctl restart "$service"

echo "======================================================================================="
echo "File [$target] successfully updated to $nver."
echo "======================================================================================="

else

#    Creating backup file if no backup or on first run
sudo cp -f $target /etc/$file.bak
echo "======================================================================================"
echo "Hosts file backup created as [/etc/$file.bak]"
echo "======================================================================================"

sleep 1

sudo cp -f "$tmpl"/"$file" "$target"
sudo systemctl restart "$service"
echo
echo "======================================================================================="
echo "File [$target] successfully updated to $nver."
echo "======================================================================================="

fi

fi

