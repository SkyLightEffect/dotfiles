# increase package download speed
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
#sed -i "s/^#Color$/Color/" /etc/pacman.conf

#pacman --noconfirm -Sy archlinux-keyring
loadkeys de-latin1
timedatectl set-ntp true
lsblk
read -p "Enter the drive: " drive
cfdisk $drive
read -p "Enter the linux partition: " partition
mkfs.ext4 $partition
mount $partition /mnt
read -p "Did you also create efi partition? [y/n]: " answer
if [[ $answer = y ]] ; then
  read -p "Enter EFI partition: " efipartition
  mkfs.ext4 $efipartition
  mkdir /boot/efi
  mount $efipartition /mnt/boot
fi
pacstrap /mnt base base-devel linux linux-firmware sudo vim
genfstab -U /mnt >> /mnt/etc/fstab
sed '1,/^#part2$/d' `basename $0` > /mnt/arch_install2.sh
chmod +x /mnt/arch_install2.sh
arch-chroot /mnt ./arch_install2.sh
exit

#part2
pacman -S --noconfirm sed
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
# time zone
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
# locales
echo "LC_ALL=de_DE.UTF-8" >> /etc/environment
echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=de_DE.UTF-8" >> /etc/locale.conf && locale-gen de_DE.UTF-8
echo "KEYMAP=de-latin1" > /etc/vconsole.conf

echo "Hostname: " 
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >> /etc/hosts
#mkinitcpio -P
passwd
pacman --noconfirm -S grub networkmanager
lsblk
read -p "Enter the disk name grub should be installed on: " efipartition
#mkdir /boot/efi
#mount $efipartition /boot/efi
#grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-install $efipartition
#sed -i 's/quiet/pci=noaer/g' /etc/default/grub
#sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager

# create new user with sudo privileges
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
read -p "Enter username: " username
useradd -m -G wheel -s /bin/bash $username
passwd $username

echo "Pre-installation finished. Reboot now."
# move 3rd install script
ai3_path=/home/$username/arch_install3.sh
sed '1,/^#part3$/d' arch_install2.sh > $ai3_path
chown $username:$username $ai3_path
chmod +x $ai3_path
su -c $ai3_path -s /bin/sh $username

exit

#part3
cd $HOME

read -p "Do you want to install KDE-Plasma? [y/n]: " answer
if [[ $answer = y ]] ; then
  echo "Installing KDE-Plasma..."
  sudo pacman -Syu xorg plasma plasma-wayland-session kde-applications --noconfirm && systemctl enable sddm
fi
