#!/bin/bash

##################################################################################################################
# Author            : AKM
# Disribution 		: ArchLinux only
##################################################################################################################

## Simple but not accurate

#pacman -Qs $1 &> /dev/null

#if [ $? -eq 0 ]; then
#    echo "Package $1 is installed!"
#else
#    echo "Package $1 is NOT installed!"
#fi

## More Accurate

package="$1";

check="$(pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";

if [ -n "${check}" ] ; then
    sleep 3
        echo "============================================================================"
        echo "${package} is ALREADY installed."
        echo "============================================================================"

elif [ -z "${check}" ] ; then
    sleep 3
        echo "============================================================================"
        echo "${package} is NOT installed. Do you want to install? (y/n)"; read CHOICE
        echo "============================================================================"
fi

case $CHOICE in

    y )
        echo "============================================================================"
        echo "Installing $package..."
        echo "============================================================================"
        paru -S $package

    ;;

    n )
        echo "============================================================================"
        echo "You chose not to install $package."
        echo "============================================================================"
    ;;

    * )
        echo "============================================================================"
        echo "Type y/n only."
        echo "============================================================================"

    ;;

esac
