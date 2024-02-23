#!/bin/bash

#Updating
#apt update
#apt install yacc
#apt install bison
#apt install bash 
#apt install texi*
#apt install bash*
#apt install bzip2
#apt install grub
#apt install docbook*
#pacman -S docbook-utils
#pacman -S docbook-xml
#pacman -S docbook-xls
#pacman -S wget

#Enviroment
#mkdir /mnt/alf
#mount /dev/sda2 /mnt/alf
#mkdir /mnt/alf/SRC_ARCHIVE
#mkdir /mnt/alf/lfs02

#Pacages
#cp wget-list-sysv md5sums /mnt/alf/SRC_ARCHIVE
#cd /mnt/alf/SRC_ARCHIVE
#wget --input-file=wget-list-sysv --continue
#rm -R *mpc*

#pushd /mnt/alf/SRC_ARCHIVE
#md5sum -c md5sums
#popd
#cat /mnt/alf/config-6-4
#rm -v /mnt/alf/SRC_ARCHIVE/mpc-1.3.1.tar.gz

#Make config
#tar -xvf /mnt/alf/SRC_ARCHIVE/linux-6.4.12.tar.xz
cd /mnt/alf/SRC_ARCHIVE/linux-6.4.12 
make mrpropper
make defconfig
cat -v .config>/mnt/alf/.config
#rm /mnt/alf/SRC_ARCHIVE/linux-6.4.12

