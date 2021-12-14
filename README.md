# akm-scripts
Useful shell scripts for daily use based on Arch Linux tested on ArcoLinux only.

PLEASE READ THE SCRIPT BEFORE RUNNING & USE AT YOUR OWN RISK
ALSO CHANGE ACCORDINGLY WHERE IT REQUIRES LIKE (locations/packages)
-----------------------------------------------------------------------------------------

Script1   : 0-drivers.sh

Condition : After fresh installation.

Usage     : System tuning according your need after fresh installation.

-----------------------------------------------------------------------------------------

Script2   : backup.sh

Condition : Always creates fresh backup not incremental.

Usage     : Takes backup of '/' with 'timeshift' and
            '/home' directories with some important System files.

-----------------------------------------------------------------------------------------

Script4   : install.sh

Usage     : Some packages for your System. (Other than ArcoLinux installation ISO)

-----------------------------------------------------------------------------------------

Script5   : is_installed.sh

Usage     : To check for any installed package in your System. Also it will offer you
            to install the package if it is not.

How to use: Make alias (ckpkg) in '.bashrc-personal' file. and call the script.

            alias ckpkg="sh (location of script file)/is_installed.sh"

On terminal : ckpkg packagename

-----------------------------------------------------------------------------------------

Script6   : is_removed.sh

Usage     : To remove any installed package with or without its dependencies.

How to use: Make alias (rmpkg) in '.bashrc-personal' file. and call the script.

            alias rmpkg="sh (location of script file)/is_removed.sh"

On terminal : rmpkg packagename

-----------------------------------------------------------------------------------------

Script7   : nvidia.sh

Usage     : Nvidia driver installation script with some extra options.

-----------------------------------------------------------------------------------------

Script3   : xanmod-kernel.sh

Usage     : Build Xanmod Kernel (Edge/Stable/tt/other) according your hardware.
