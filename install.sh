#!/bin/bash
set -e
##################################################################################################################
# Author        :   AKM
# Disribution   :   ArcoLinux only
# Requirement   :   '0-drivers.sh' run first
##################################################################################################################

    echo "============================================================================"
    echo "                 First time System Update & Install Apps"
    echo "============================================================================"

# System Update
    echo "============================================================================"
    echo "Rating fastest mirrorlist ...."
    echo "============================================================================"
rate-mirrors --allow-root arch | sudo tee /etc/pacman.d/mirrorlist

# Install Terminal based Apps
    echo "============================================================================"
    echo "Installing Terminal apps ...."
    echo "============================================================================"
sleep 3
    sudo pacman -S --noconfirm --needed git tk gitfriend python3 python-pip lshw wttr lolcat ufetch-git sfetch-git pacui rebuild-detector

# Multimedia apps
    echo "============================================================================"
    echo "Installing Multimedia apps ...."
    echo "============================================================================"
sleep 3
     sudo pacman -S --noconfirm --needed mpv smplayer-svn smplayer-skins smplayer-themes qtwebflix-git freetube yt-dlp youtube-dl mediainfo mediainfo-gui krita libmypaint meld inkscape simplescreenrecorder

# GPU (Intel & AMD) Support apps & tools
    echo "============================================================================"
    echo "Installing libraries and tools ...."
    echo "============================================================================"
sleep 3
    sudo pacman -S --noconfirm --needed cpio gputest appmenu-gtk-module mesa lib32-mesa libva lib32-libva libva-utils libva-mesa-driver lib32-libva-mesa-driver libvdpauinfo libvdpau libva-vdpau-driver lib32-libva-vdpau-driver lib32-libvdpau libvdpau-va-gl mesa-demos mesa-vdpau lib32-mesa-vdpau opengl-man-pages opencl-headers opencl-clhpp firefox-appmenu-bin vulkan-headers vulkan-icd-loader lib32-vulkan-icd-loader vulkan-extra-layers vulkan-extra-tools vulkan-swrast vulkan-tools vulkan-validation-layers lib32-vulkan-validation-layers vulkan-mesa-layers lib32-vulkan-mesa-layers spirv-tools openh264 gstreamer gstreamer-meta

# Gnome apps
    echo "============================================================================"
    echo "Installing additional apps ...."
    echo "============================================================================"
sleep 3
    sudo pacman -S --noconfirm --needed gnome-disk-utility gsmartcontrol xterm latte-dock kdenlive xdman flameshot ungoogled-chromium chromium-widevine webapp-manager ktorrent bitwarden libreoffice-fresh libreoffice-fresh-en-gb pstoedit libmythes protonvpn-gui hunspell sonnet aspell hspell libvoikko hunspell-en_gb hunspell-en_us bpytop opencv gst-plugin-opencv gst-plugin-gtk gst-plugin-qmlgl gst-plugin-wpe wpewebkit timeshift dialect ferdi kaccounts-providers kcolorchooser kolourpaint konqueror kalendar kdialog bcprov java-commons-lang pdftk leptonica tesseract tesseract-data-eng tesseract-data-ind

    pip install httpx[http2]

    echo "============================================================================"
    echo "Installing Icons and Themes ...."
    echo "============================================================================"
sleep 3
    sudo pacman -S --noconfirm --needed gtk-engine-murrine sassc numix-circle-icon-theme-git numix-circle-icon-theme-git gnome-theme-extra gnome-icon-theme arcolinux-wallpapers-submicron1-1920x1080-1080hd-git arcolinux-wallpapers-submicron2-1920x1080-1080hd-git adwaita-icon-theme adwaita-qt adwaita-qt6 libadwaita gtk3-nocsd-git

# Hindi font
    echo "============================================================================"
    echo "Installing Fonts ...."
    echo "============================================================================"
sleep 3
    sudo pacman -S --noconfirm --needed ttf-indic-otf ttf-ms-fonts

# AUR packages to build
    echo "============================================================================"
    echo "Installing AUR apps ...."
    echo "============================================================================"
sleep 3
    paru -a -S --noconfirm grive zramd system-monitoring-center colorpicker

# Ramdisk installation
    echo "============================================================================"
    echo "Installing RamDisk and others .... (Optional)"
    echo "============================================================================"
sleep 3
    rm -Rf /mnt/Recovery/ramdisk
    cd /mnt/Recovery
    git clone https://github.com/estarq/ramdisk
    rm -Rf /mnt/Data/Gdrive/RamDisk
    cp -Rf ramdisk /mnt/Data/Gdrive/RamDisk
    cd ramdisk
    sudo python3 install.py
    cd $HOME
    cp -f /mnt/Recovery/Backup/.chromecache ~/
    cp -f /mnt/Recovery/Backup/.config/autostart/chromecache.desktop $XDG_CONFIG_HOME/autostart
    echo " RamDisk successfully installed."

# Some Extra Work
    cd /mnt/Data && tar -zxf /mnt/Data/Pictures.tar.gz
    mv -f /mnt/Data/*.jpg ~/Pictures
    mv -f /mnt/Data/*.png ~/Pictures
    cd $HOME
    sudo systemctl enable --now zramd
echo
echo "============================================================================"
echo "                          Done. Please reboot."
echo "============================================================================"
