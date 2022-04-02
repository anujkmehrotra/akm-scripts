#!/bin/bash
set -e
##################################################################################################################
# Author        :   AKM
# Disribution   :   ArcoLinux only
# Requirement   :   /mnt/Data/POS/0-drivers.sh run first
##################################################################################################################

PKGS=("git" "tk" "gitfiend" "python3" "python-pip" "lshw" "lolcat" "ufetch-git" "rebuild-detector"
"qtwebflix-git" "freetube" "yt-dlp" "youtube-dl" "mediainfo" "mediainfo-gui" "meld" "inkscape" "simplescreenrecorder"
"mpv" "cpio" "gputest" "mesa" "lib32-mesa" "libva" "lib32-libva" "libva-utils" "libva-mesa-driver" "lib32-libva-mesa-driver"
"libvdpau" "libva-vdpau-driver" "lib32-libva-vdpau-driver" "lib32-libvdpau" "libvdpau-va-gl" "mesa-demos"
"mesa-vdpau" "lib32-mesa-vdpau" "opengl-man-pages" "opencl-headers" "opencl-clhpp" "vulkan-headers" "vulkan-icd-loader"
"lib32-vulkan-icd-loader" "vulkan-extra-layers" "vulkan-extra-tools" "vulkan-tools"
"vulkan-mesa-layers" "lib32-vulkan-mesa-layers" "openh264" "gstreamer" "gst-plugin-opencv-cuda" "gst-plugin-qmlgl" "meson"
"gsmartcontrol" "xterm" "xdman"  "webapp-manager" "chromium-widevine" "ungoogled-chromium"
"hunspell" "hunspell-en_gb" "hunspell-en_us" "bpytop" "timeshift" "ventoy-bin" "etcher-bin"
"bitwarden" "libreoffice-fresh" "libreoffice-fresh-en-gb" "pstoedit" "libmythes" "hunspell" "sonnet" "aspell"
"gtk-engine-murrine" "sassc" "numix-circle-icon-theme-git" "adwaita-icon-theme"
"gnome-icon-theme" "gnome-icon-theme-extras" "gnome-icon-theme-symbolic" "ttf-indic-otf" "ttf-ms-fonts"
"latte-dock" "plasma5-applets-latte-seprator" "plasma5-applets-latte-side-button-git" "plasma5-applets-latte-spacer"
"plasma5-applets-window-appmenu-git" "plasma5-applets-kpplemenu-git" "plasma5-applets-window-title" "plasma5-applets-netspeed"
"nvidia-settings" "nvidia-utils" "lib32-nvidia-utils" "opencl-nvidia" "lib32-opencl-nvidia" "egl-wayland" "eglexternalplatform")


# Install  Apps
echo "============================================================================"
echo "Installing apps from existing repositories ...."
echo "============================================================================"

sudo pacman -S --asdeps --noconfirm --needed "${PKGS[@]}"
echo "All repositories packages installed."

# AUR packages to build
echo "============================================================================"
echo "Building AUR apps ...."
echo "============================================================================"

paru -a -S --asdeps grive zramd
paru -a -S --asdeps --noconfirm chromium-extension-web-store protonvpn-gui plasma5-applets-betterinlineclock-git plasma5-applets-weather-widget-2

# Configuring zramd
sudo sed -e 's|# ALGORITHM=zstd|ALGORITHM=zstd|g' -i /etc/default/zramd
sudo sed -e 's|# NUM_DEVICES=1|NUM_DEVICES=8|g' -i /etc/default/zramd
sudo sed -e 's|# SKIP_VM=false|SKIP_VM=false|g' -i /etc/default/zramd

sudo systemctl enable --now zramd

# Some Extra Work
sudo cp -Rf /mnt/Data/Theme/UOS-Dark /usr/share/icons
#sudo cp -Rf /mnt/Data/Theme/Adwaita-dark-shell /usr/share/themes

cd /mnt/Data && tar -zxf /mnt/Data/Pictures.tar.gz
mv -f /mnt/Data/*.jpg ~/Pictures
mv -f /mnt/Data/*.png ~/Pictures
cd "$HOME"
echo
echo "============================================================================"
echo "Please configure sensors and reboot."
echo "============================================================================"
sudo sensors-detect
