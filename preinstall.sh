#!/bin/bash

#Mounting USB for reading version
fdisk -l
echo "Write Device name for your USB"
read USB
mkdir /mnt/usb
mount /dev/$USB /mnt/usb

#Check Sign of Distributive
pacman-key --init
FILE = /mnt/usb/arch/version
VER=(cat $FILE)
gpg --keyserver-options auto-key-retrieve --verify archlinux-$VER-x86_64.iso.sig


#Try resolve Erroring about coredump
sysctl -w fs.suid_dumpable=0

#Preparing
ls /usr/share/kbd/keymaps/**/*.map.gz
loadkeys ru
setfont cyr-sun16



#Activating this file 
chmod +x $0.sh

