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

#Internet Connection
ip link
iwctl
device list
echo "Write name of Device"
read DEVICE
echo "Write name of Adapter"
read ADAPTER
device $DEVICE set-property Powered on
adapter $ADAPTER set-property Powered on
station $DEVICE scan
station $DEVICE get-networks
echo "Write your network name"
read SSID
station $DEVICE connect $SSID
exit

echo "Write your passphrase"
read PASSPHRASE
$ wpa_passphrase $SSID $PASSPHRASE



test2



#Activating this file 
chmod +x $0.sh

