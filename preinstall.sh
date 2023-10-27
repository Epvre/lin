#!/bin/bash

#Check Sign of Distributive
VER=cat()

#Mounting USB
fdisk -l
echo "Write Device name for your USB"
read USB
mkdir /mnt/usb
mount /dev/$USB /mnt/usb

#Try resolve Erroring about coredump
sysctl -w fs.suid_dumpable=0



