#!/bin/bash

# check if run as root
if [[ $(id -u) -ne 0 ]] ; then 
    echo "Please run as root"
    exit 1 
fi

# update sources.list
# cp /etc/apt/sources.list /etc/apt/sources.bak
# cp sources.list /etc/apt/sources.list

# if [[ -f /etc/apt/sources.list.d/orginal.list ]]; then
#     mv /etc/apt/sources.list.d/orginal.list /etc/apt/sources.list.d/orginal.bak
# fi

# update system
apt update
apt dist-upgrade -y

# upgrade release
sed -i "s/Prompt=lts/Prompt=normal/" /etc/update-manager/release-upgrades # switch to short term releases
do-release-upgrade -f DistUpgradeViewNonInteractive

# install packages
apt install -y \
    adb \
    aisleriot \
    alsa-utils \
    ark \
    bash-completion \
    bsdmainutils \
    cpu-x \
    cryptsetup \
    cups \
    curl \
    fastboot \
    ffmpeg \
    flatpak \
    fwupd \
    gcc \
    gdebi \
    git \
    gnome-cards-data \
    gnome-keyring \
    gwenview \
    htop \
    intel-media-va-driver-non-free \
    kde-plasma-desktop \
    language-pack-kde-sv \
    make \
    materia-gtk-theme \
    materia-kde \
    mpv \
    muon \
    neofetch \
    network-manager \
    openssh-server \
    paper-icon-theme \
    perl \
    plasma-discover-backend-flatpak \
    plasma-nm \
    python3-pip \
    rsync \
    sddm-theme-breeze \
    software-properties-gtk \
    system-config-printer \
    tmux \
    ufw \
    update-notifier

# install chrome browser
curl -L https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o $HOME/google-chrome-stable_current_amd64.deb
dpkg -i $HOME/google-chrome-stable_current_amd64.deb
apt install -f -y

: '
# install gdal stuff
apt install -y \
    gdal-bin \
    libgdal-dev \
    libprotobuf-dev \
    osmium-tool \
    osmosis \
    protobuf-compiler \
    python3-gdal \
    python3-protobuf
'

# remove old intel driver
apt remove xserver-xorg-video-intel -y

# flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# install rclone
curl https://rclone.org/install.sh | bash
rclone genautocomplete bash

# install yt-dlp
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
chmod a+rx /usr/local/bin/yt-dlp  # Make executable

# setup firewall
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw enable

# customisations
sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/" /$HOME/.bashrc
timedatectl set-timezone Europe/Stockholm

echo "Install complete!"
sleep 5
reboot
