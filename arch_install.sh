#!/bin/bash

DOT=~/.dotfiles
SCRIPTS=$DOT/scripts
TMP=$DOT/.temp

# increase package download speed
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf

read -p "Do you need a base installation? [y/n]: " answer
if [[ $answer = y ]] ; then
  chmod u+x $DOT/base_install.sh
  .$DOT/base_install.sh
fi

read -p "Do you want to install KDE-Plasma? [y/n]: " answer
if [[ $answer = y ]] ; then
  echo "Installing KDE-Plasma..."
  sudo pacman -Syu xorg plasma plasma-wayland-session kde-applications --noconfirm && systemctl enable sddm
fi
