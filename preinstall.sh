#!/bin/bash
FILENAME=$BASH_SOURCE

#Mounting USB for reading version
fdisk -l
echo "Write Device name for your USB"
read USB
mkdir /mnt/usb
mount /dev/$USB /mnt/usb

#Check Sign of Distributive
VER=cat /mnt/usb/arch/version

#Try resolve Erroring about coredump
sysctl -w fs.suid_dumpable=0




#Activating this file 
chmod +x $FILENAME

