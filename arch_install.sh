#!/bin/bash

#DOT=~/.dotfiles
DOT=$(PWD)
SCRIPTS=$DOT/scripts
TMP=$DOT/.temp

# increase package download speed
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
sed -i "s/^#Color$/Color/" /etc/pacman.conf

read -p "Do you need a base installation? [y/n]: " answer
if [[ $answer = y ]] ; then
  chmod u+x $DOT/base_install.sh
  /bin/bash $DOT/base_install.sh
fi

read -p "Do you want to install KDE-Plasma? [y/n]: " answer
if [[ $answer = y ]] ; then
  echo "Installing KDE-Plasma..."
  sudo pacman -Syu xorg plasma-desktop plasma-wayland-session kde-applications --noconfirm && systemctl enable sddm
fi
