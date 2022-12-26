# Added useful aliases by AKM

#export LC_CTYPE=en_US.UTF-8
#export LC_ALL=en_US.UTF-8

set MyKernel "linux-xanmod-linux-bin-x64v2"
set bakdir "/mnt/Data/Linux/FS"

# Important aliases

alias nimg="nano /etc/mkinitcpio.conf"
alias nb="nano $HOME/.bashrc"
alias nbp="nano $HOME/.bashrc-personal"
alias nzp="nano $HOME/.zshrc-personal"
alias nfp="nano $HOME/.config/fish/alias.fish"
alias nlog="systemd-analyze cat-config systemd/journald.conf"
alias nmake="sudo nano /etc/makepkg.conf"
alias nkde="sudo nano /etc/sddm.conf.d/kde_settings.conf"
#--------------------------------------------------------------------------------------------------

# System aliases
alias cd~="cd $HOME"
alias x="exit"
alias c="clear"
alias kernel="cat /proc/version"
alias dsk="gnome-disks"
alias os="cat /etc/os-release"
alias tst="sudo /usr/bin/timeshift-launcher"
alias gcz="sudo grub-customizer"
alias keyst="nano /etc/pacman.d/gnupg/gpg.conf"

# Trim fstab disks
alias trimfstab="sudo fstrim -A -v"

# HDD test
alias hddst="sudo smartctl -H /dev/sda"
alias hddscan="sudo umount /dev/sda && sudo fsck -T /dev/sda && sudo mount /dev/sda"
alias hddtest="sudo smartctl --test=short /dev/sda"

# High RAM Usage App List
alias hram="ps -A -ao rss,comm | sort -rn | sed -n '1,5{s/^/\t/;s/ /\t/p}'"

# Chromecache aliases
alias cc="~/.chromecache"
alias ncc="nano ~/.chromecache"

# Edit My Conky alias
alias nck="nano ~/.config/conky/AK-Wiu-Plasma.conkyrc"

# To access Active Network Connections
alias netrestart="sudo systemctl restart NetworkManager.service"
alias netst="nmcli connection show"
alias vpnst="nmcli connection show | grep vpn"
alias netreload="sudo nmcli connection reload"

# To Get Swappiness/Cache Pressure Status
alias swaps="echo -n 'Swappiness = ' && cat /proc/sys/vm/swappiness"
alias swapc="echo -n 'VFS Cache Pressure = ' && cat /proc/sys/vm/vfs_cache_pressure"
alias swapst="swaps && swapc"

# Pacman/Paru/Yay ( if yay cache location is /var/tmp ) Packages and Build Cache clean alias
alias pkgcache="du -h /var/cache/pacman/pkg"
alias pkgclean="pkgcache && sudo pacman -Scc && echo 'Temp Pacman packages removed.'"
# If you have not installed packages from 'pkglist.txt'
alias pkgun="sudo pacman -Qdt"
#alias pkgunrm="sudo pacman -Qdtq |  pacman -Rs -"

# Systemd Core Dump alias
alias dumpst="cd /var/lib/systemd/coredump && ls -al && cd $HOME"
alias dumpclean="cd /var/lib/systemd/coredump && sudo rm -f ./core.* && echo 'Core Dump files removed.' && cd $HOME"
alias coredump="sudo rm -f /var/lib/systemd/coredump/core.* && echo 'Core Dump files removed.'"

# Drive Explorer
alias data="cd /mnt/Data"
alias gdrive="cd /mnt/Data/Gdrive && grive && cd $HOME && echo 'Google drive sync completed.'"
alias pos="cd /mnt/Personal/POS"
alias dwn="cd /mnt/Data/Downloads"

# Custom pkg 'Firefox-appmenu'
#alias toff="sh /mnt/Personal/POS/firefox-appmenu.sh"

# hosts file aliases
#alias blockhosts="pkexec sh /mnt/Personal/POS/blockhosts.sh"
alias bakhosts="sudo cp -f /etc/hosts /etc/hosts.bak && echo 'Hosts file backup done.'"
#alias updhosts="pkexec hblock && netrestart && echo 'Hosts file updated.'"
alias rsthosts="sudo cp -f $bakdir/hosts.bak /etc/hosts && netrestart && echo 'Original hosts file restored.'"
alias nhosts="sudo nano /etc/hosts"

## Create Kernel Image aliases

# Xanmod Kernel
alias mkimgxan="sudo mkinitcpio -p $MyKernel"

# Default Vanilla Kernel
alias mkimglinux="sudo mkinitcpio -p linux"

# Allinone Kernel Image Creation
alias mkimg="mkimglinux && mkimgxan && update-grub && echo 'Image created successfully. Please reboot now.'"

# Remove Old Kernel Modules
alias kml="cd /lib/modules/ && ls && echo 'Select only old Kernel Modules to remove. Do not remove the current using kernel.'"

# Systemctl aliases
alias trimst="systemctl status fstrim.timer"
alias servicest="systemctl status *.service"
alias timerst="systemctl status *.timer"
alias sysfail="systemctl --failed"
alias sysst="systemctl list-unit-files"

# Sign out/Suspend/Sleep
alias so="qdbus org.kde.ksmserver /KSMServer logout 0 0 0"
alias sl="systemctl suspend -i"

# Automatic System Power Update alias
alias up="sudo pacman -Syy"
alias upa="paru -a -Su"
alias upd="update && upa"
# Ventoy/USB alias
alias usb="/opt/ventoy/VentoyGUI.x86_64"
alias usbc="cp -f /mnt/Data/Downloads/*.iso /run/media/akm/Ventoy && echo 'All iso files copied to Ventoy usb.'"
alias usbm="mv -f /mnt/Data/Downloads/*.iso /mnt/Data/Linux && echo 'All iso files moved to ISO's folder."
alias usbu="umount -v /run/media/akm/Ventoy && echo 'Ventoy usb unmounted successfully. Please remove the usb.'"

# Move Videos files to their destination as required
alias ts="mv -f /mnt/Data/Downloads/*.ts /mnt/Data/X/Others && echo 'All ts files moved to /mnt/Data/X/Others.'"
alias mkv="mv -f /mnt/Data/Downloads/*.mkv $pulldir/Videos/Others && echo 'All mkv files moved to [/mnt/Data/X].'"
alias mp4="mv -f /mnt/Data/Downloads/*.mp4 $pulldir/Videos/Others && echo 'All mp4 files moved to [/mnt/Data/X].'"

# Zram
#alias nzram="sudo nano /etc/default/zramd"
#alias zram="zramctl"

# yt-dlp (youtube downloader)
alias ytvd="echo 'Youtube video is going to download at [/tmp/yt-dl] ....' && cd /tmp/yt-dl && echo && ytv-best"
alias ytvm="mv -f /tmp/yt-dl/*.mp4 /mnt/Data/Downloads && echo 'All youtube downloaded files moved to downloads.'"

# Backup
alias bakpkgs="~/.bakpkgs.sh"
alias bakhom="sh /mnt/Personal/POS/backuphome"

# Restore
alias rstpkgmain="sudo pacman -S --needed $bakdir/pkglist.txt"
alias rstpkgopt="sudo pacman -S --asdeps --needed $bakdir/optdeplist.txt"
alias rstpkgaur="paru -a -S --needed - < $bakdir/aurpkglist.txt"
alias rstpkgs="rstpkgmain && rstpkgopt && rstpkgaur && echo 'All packages restored.'"
alias cbin="cp -Rf /etc/skel/.bin ~/.bin && echo '.bin folder restored.'"

# Kernel
#alias toxan="sh /mnt/Personal/POS/xanmod-kernel-new.sh"
#alias rmxan="sh /mnt/Personal/POS/xanmod-kernel-remove.sh"
#alias insxan="sudo pacman -U  --needed /mnt/Data/Kernel/$MyKernel*"
