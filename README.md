# akm-scripts

Useful shell scripts for daily use based on Arch Linux tested on ArcoLinux only.

Do not blinding run any script. It could harm your system. Kindly read throughly.
These scripts can give you some ideas to create or modify scripts according your system.

PLEASE READ THE SCRIPT BEFORE RUNNING & USE AT YOUR OWN RISK

ALSO CHANGE ACCORDINGLY WHERE IT REQUIRES LIKE (location path / package name, etc.)

-----------------------------------------------------------------------------------------

USAGE EXAMPLE THROUGH TERMINAL:

Script-1   : backup-pkgs.sh

Usage      : Take backup all repo installed packages to a list.

Command    : Make alias (bakpkg) in '.bashrc' or '.bashrc-personal' or 'alias.fish' file.

             alias bakpkg="sh (location of script file)/backup-pkgs.sh"

Command    : bakpkg

-----------------------------------------------------------------------------------------

Question  : Why should I build the Kernel by my own ?

Answer    : All available prebuilt kernel packages are mostly 'Generic' build. But if
            you want to build any specific hardware based like mine (AMD Ryzen [zenver2])
            or (Intel Xeon [Cooper Lake]) then you must build by your own.
            
Note      : Sample prebuilt working script for cpu (AMD Ryzen [zenver2]) is added.

-----------------------------------------------------------------------------------------
