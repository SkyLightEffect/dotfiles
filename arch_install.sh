read -p "Do you want to install KDE-Plasma? [y/n]: " answer
if [[ $answer = y ]] ; then
	echo "Installing KDE-Plasma..."
	sudo pacman -Syu xorg plasma plasma-wayland-session kde-applications --noconfirm
fi
