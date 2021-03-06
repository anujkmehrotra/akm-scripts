# akm-scripts

Useful shell scripts for daily use based on Arch Linux tested on ArcoLinux only.

Do not blinding run any script. It could harm your system. Kindly read throughly.
These scripts can give you some ideas to create or modify scripts according your system.

PLEASE READ THE SCRIPT BEFORE RUNNING & USE AT YOUR OWN RISK

ALSO CHANGE ACCORDINGLY WHERE IT REQUIRES LIKE (location path / package name)

-----------------------------------------------------------------------------------------

Script-1   : backup-pkgs.sh

Usage      : Take backup all repo installed packages to a list.

Command    : Make alias (bakpkg) in '.bashrc-personal' file. and call the script.

             alias bakpkg="sh (location of script file)/backup-pkgs.sh"

Command    : bakpkg

-----------------------------------------------------------------------------------------

Script-2   : backup.sh

Condition  : Always creates fresh backup not incremental.

Usage      : Takes backup of '/' with 'timeshift' and
             '/home' directories with some important System files.

How to use : Make alias (bakup) in '.bashrc-personal' file. and call the script.
             
             alias bakup="sh (location of script file)/backup.sh"

Command    : bakup

-----------------------------------------------------------------------------------------

Script-3   : blockhosts.sh

Condition  : Hosts file with adblockers and others.

Usage      : Blocking ads and other annoyances.

How to use : Make alias (updhosts) in '.bashrc-personal' file. and call the script.
             
             alias updhosts="sh (location of script file)/blockhosts.sh"

Command    : updhosts

-----------------------------------------------------------------------------------------

Script-4   : ck-kernel.sh

Usage      : Build ck Kernel (stable) according your hardware.

How to use:  Make alias (tock) in '.bashrc-personal' file. and call the script.
             
             alias tock="sh (location of script file)/ck-kernel.sh"

Command    : tock

-----------------------------------------------------------------------------------------

Script-5   : freshstart.sh

Condition  : After fresh installation.

Usage      : System tuning according your need after fresh installation.

-----------------------------------------------------------------------------------------

Script-6   : install.sh

Usage      : Some packages for your newly installed System. (Other than ArcoLinux installation ISO)

-----------------------------------------------------------------------------------------

Script-7   : is_installed.sh

Usage      : To check for any installed package in your System. Also it will offer you
             to install the package if it is not.

How to use : Make alias (ckpkg) in '.bashrc-personal' file. and call the script.
             
             alias ckpkg="sh (location of script file)/is_installed.sh"

Command    : ckpkg packagename

-----------------------------------------------------------------------------------------

Script-8   : is_removed.sh

Usage      : To remove any installed package with or without its dependencies.

How to use : Make alias (rmpkg) in '.bashrc-personal' file. and call the script.
             
             alias rmpkg="sh (location of script file)/is_removed.sh"

Command    : rmpkg packagename

-----------------------------------------------------------------------------------------

Script-9   : nvidia.sh

Usage      : Nvidia driver installation script with some extra options.

How to use : Make alias (tonvd) in '.bashrc-personal' file. and call the script.
             
             alias tonvd="sh (location of script file)/nvidia.sh"

Command    : tonvd

-----------------------------------------------------------------------------------------

Script-10   : restore-pkgs.sh

Usage      : Restore all repo installed packages from already backup-ed list.

How to use : Make alias (rstpkg) in '.bashrc-personal' file. and call the script.
             
             alias rstpkg="sh (location of script file)/restore-pkgs.sh"

Command    : rstpkg

-----------------------------------------------------------------------------------------

Script-11   : xanmod-kernel-remove.sh

Usage      : Remove installed Xanmod Kernel (edge / stable / tt / other).

How to use : Make alias (toxan) in '.bashrc-personal' file. and call the script.
             
             alias rmxan="sh (location of script file)/xanmod-kernel-remove.sh"

Command    : rmxan

-----------------------------------------------------------------------------------------

Script-12  : xanmod-kernel.sh

Usage      : Build Xanmod Kernel (edge / stable / tt / other available in aur) according
             your hardware.

How to use:  Make alias (toxan) in '.bashrc-personal' file. and call the script.
             
             alias toxan="sh (location of script file)/xanmod-kernel.sh"

Command    : toxan

-----------------------------------------------------------------------------------------

Question  : Why should I build the Kernel by my own ?

Answer    : All available prebuilt kernel packages are mostly Generic build. But if you
            want to build any specific hardware based like mine ( AMD Ryzen [zenver2] )
            or ( Intel Xeon [Cooper Lake] ) then you must build
            your own.

-----------------------------------------------------------------------------------------

ALL ALIASES MENTIONED ABOVE ARE JUST THE EXAMPLE. YOU CAN CHOOSE YOUR OWN NAME FOR AN ALIAS.
