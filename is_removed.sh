#!/bin/bash

##################################################################################################################
# Author            : AKM
# Disribution 		: ArchLinux only
##################################################################################################################

## Simple but not accurate with full matching pkg names (linux, linux-xanmod)

#paru -R $1
#if [ $? -eq 0 ]; then
#    echo "Package $1 has removed!"
#else
#    echo "Package $1 has NOT removed!"
#fi

## More Accurate
#   Check pkg is installed or not, then remove.

package="$1"

if pacman -Qi $package &> /dev/null ; then

    pactree -d 1 "${package}"
    
    echo "============================================================================"
    echo "See pactree for the ${package} above :"
    echo "Do you want to remove ${package} with its all dependencies?"
        tput setaf 1
    echo "Proceed with cautions!! (y/n)" ;
        tput sgr0
    echo "============================================================================"
            
    read -r CHOICE
    case $CHOICE in

    y )
        sudo pacman -Rnsudd "${package}"
    ;;

    n )
        sudo pacman -Rdd "${package}"
    ;;

    * )
    echo "============================================================================"
    echo "Type y/n only."
    echo "============================================================================"
    ;;

    esac

else

    echo "============================================================================"
    echo "${package} is NOT installed."
    echo "Please type pkg name correctly or choose installed pkg only."
    echo "============================================================================"
     
fi
