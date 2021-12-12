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
    sudo pacman -S --noconfirm --needed git gitg python3 python-pip lshw wttr lolcat ufetch-git sfetch-git pacui

# Multimedia apps
    echo "============================================================================"
    echo "Installing Multimedia apps ...."
    echo "============================================================================"
sleep 3
    sudo pacman -S --noconfirm --needed mpv smplayer-svn smplayer-skins smplayer-themes qtwebflix-git freetube yt-dlp youtube-dl youtube-dl-gui-git mediainfo mediainfo-gui krita krita-plugin-gmic meld inkscape simplescreenrecorder

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
    sudo pacman -S --noconfirm --needed gnome-disk-utility gsmartcontrol xterm latte-dock kdenlive xdman flameshot ungoogled-chromium chromium-widevine webapp-manager ktorrent qbittorrent-enhanced-git bitwarden thunar thunar-volman thunar-archive thunar-archive-plugin thunar-media-tags libreoffice-fresh libreoffice-fresh-en-gb pstoedit libmythes protonvpn-gui hunspell sonnet aspell hspell libvoikko hunspell-en_gb hunspell-en_us bpytop opencv gst-plugin-opencv gst-plugin-gtk gst-plugin-qmlgl gst-plugin-wpe wpewebkit timeshift dialect ferdi kaccounts-providers kcolorchooser kolourpaint konqueror kalendar-git

    pip install httpx[http2]

    echo "============================================================================"
    echo "Installing Icons and Themes ...."
    echo "============================================================================"
sleep 3
    sudo pacman -S --noconfirm --needed gtk-engine-murrine numix-circle-icon-theme-git numix-circle-icon-theme-git gnome-theme-extra gnome-icon-theme arcolinux-wallpapers-submicron1-1920x1080-1080hd-git arcolinux-wallpapers-submicron2-1920x1080-1080hd-git

# Hindi font
    echo "============================================================================"
    echo "Installing Fonts ...."
    echo "============================================================================"
sleep 3
    sudo pacman -S --noconfirm --needed ttf-indic-otf ttf-ms-fonts

# AUR packages to build
    echo "============================================================================"
    echo "Installing Google Drive and KDE apps ...."
    echo "============================================================================"
sleep 3
    paru -a -S --noconfirm grive kalk zramd

# Ramdisk installation
    echo "============================================================================"
    echo "Installing Ramdisk ...."
    echo "============================================================================"
sleep 3
    rm -Rf /mnt/Recovery/ramdisk
    cd /mnt/Recovery
    git clone https://github.com/estarq/ramdisk && rm -Rf /mnt/Data/Gdrive/RamDisk && cp -Rf ramdisk /mnt/Data/Gdrive/RamDisk && cd ramdisk && sudo python3 install.py && cd ~
    cp -f /mnt/Recovery/Backup/.chromecache ~/ && cp -f /mnt/Recovery/Backup/.config/autostart/chromecache.desktop ~/.config/autostart/chromecache.desktop && echo " RamDisk successfully installed."

# Some Extra Work
    cd /mnt/Data && tar -zxf /mnt/Data/Pictures.tar.gz && mv -f /mnt/Data/*.jpg ~/Pictures && mv -f /mnt/Data/*.png ~/Pictures && cd ~
    sudo systemctl enable --now zramd
echo
echo "============================================================================"
echo "                                  Done"
echo "============================================================================"
