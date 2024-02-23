##!/bin/bash
#source https://habr.com/ru/companies/ruvds/articles/702570/
LINUX_V=v2.6
LINUX=linux-2.6.39
BUSYBOX=busybox-1.36.1
COREUTILS=coreutils

#1. Устанавливаем необходимые пакеты для сборки.
read -n 1 -p "1. Устанавливаем необходимые пакеты для сборки? (y/[a]): " AMSURE 
[ "$AMSURE" = "y" ] || exit
echo "" 1>&2
AMSURE=()

mkdir -p simple-linux/build/sources
mkdir -p simple-linux/build/downloads
mkdir -p simple-linux/build/out
mkdir -p simple-linux/linux
sudo apt update
sudo apt install --yes make build-essential bc bison flex libssl-dev libelf-dev wget cpio fdisk extlinux dosfstools qemu-system-x86

#2. Загружаем из интернета исходный код для ядра Linux и BusyBox.
read -n 1 -p "
2. Загружаем из интернета исходный код для ядра Linux и BusyBox? (y/[a]): " AMSURE 
[ "$AMSURE" = "y" ] || exit
echo "" 1>&2
AMSURE=()

cd simple-linux/build
wget -P downloads https://cdn.kernel.org/pub/linux/kernel/$LINUX_V/$LINUX.tar.xz 
wget -P downloads https://busybox.net/downloads/$BUSYBOX.tar.bz2
wget -P downloads https://github.com/coreutils/$COREUTILS.git

#3. Распаковываем архивы с исходным кодом.
read -n 1 -p "3. Распаковываем архивы с исходным кодом? (y/[a]): " AMSURE 
[ "$AMSURE" = "y" ] || exit
echo "" 1>&2
AMSURE=()

tar -xvf downloads/$LINUX.tar.xz -C sources
tar -xjvf downloads/$BUSYBOX.tar.bz2 -C sources
tar -xjvf downloads/$COREUTILS.tar.bz2 -C sources

#4. Собираем бинарные файлы BusyBox и для ядра Linux. Этот процесс займёт достаточно много времени, порядка 10 минут и даже больше, поэтому не пугайтесь.
read -n 1 -p "
4. Cобираем бинарные файлы BusyBox и для ядра Linux. Этот процесс займёт достаточно много времени, порядка 10 минут и даже больше, поэтому не пугайтесь? (y/[a]): " AMSURE 
[ "$AMSURE" = "y" ] || exit
echo "" 1>&2
AMSURE=()

cd sources/$BUSYBOX
echo "*******make oldconfig"
make oldconfig
echo "*******make LDFLAGS=-static"
make LDFLAGS=-static
echo "*******make busybox ../../out/"
cp busybox ../../out/
echo "*******make cd ../$LINUX"
cd ../$LINUX
echo "*******make -j8 || exit"
#make defconfig
make -j8 || exit
echo "cp arch/x86_64/boot/bzImage ~/simple-linux/linux/vmlinuz-$LINUX"
cp arch/x86_64/boot/bzImage ~/simple-linux/linux/vmlinuz-$LINUX

#5. Создаём файл init.
read -n 1 -p "
5. Создаём файл init? (y/[a]): " AMSURE 
[ "$AMSURE" = "y" ] || exit
echo "" 1>&2
AMSURE=()


mkdir -p ~/simple-linux/build/initrd
cd ~/simple-linux/build/initrd
echo "#! /bin/sh
mount -t sysfs sysfs /sys
mount -t proc proc /proc
mount -t devtmpfs udev /dev
sysctl -w kernel.printk="2 4 1 7"
/bin/sh
poweroff -f" > init

#6. Cоздаём структуру директорий и файлов.
read -n 1 -p "
6. Cоздаём структуру директорий и файлов? (y/[a]): " AMSURE 
[ "$AMSURE" = "y" ] || exit
echo "" 1>&2
AMSURE=()

chmod 777 init
mkdir -p bin dev proc sys
cd bin
cp ~/simple-linux/build/out/busybox ./
for prog in $(./busybox --list); do ln -s /bin/busybox $prog; done

#7. Помещаем структуру в файл initrd, который у нас является cpio-архивом.
read -n 1 -p "
7. Помещаем структуру в файл initrd, который у нас является cpio-архивом? (y/[a]): " AMSURE 
[ "$AMSURE" = "y" ] || exit
echo "" 1>&2
AMSURE=()

cd ..
find . | cpio -o -H newc > ~/simple-linux/linux/initrd-$BUSYBOX.img

#8. Запускаем собранный образ в эмуляторе qemu.
read -n 1 -p "
8. Запускаем собранный образ в эмуляторе qemu? (y/[a]): " AMSURE 
[ "$AMSURE" = "y" ] || exit
echo "" 1>&2
AMSURE=()

$ cd ~/simple-linux/linux
$ qemu-system-x86_64 -kernel vmlinuz-$LINUX -initrd initrd-$BUSYBOX.img -nographic -append 'console=ttyS0'
