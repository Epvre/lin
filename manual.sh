#!/bin/bash
# https://habr.com/ru/articles/709528/
# https://habr.com/ru/articles/709528/
# https://superuser.com/questions/519718/linux-on-uefi-how-to-reboot-to-the-uefi-setup-screen-like-windows-8-can
# https://selectel.ru/blog/directory-structure-linux/
# title           Arch Linux
# linux           /vmlinuz-linux
# initrd          /initramfs-linux.img
# options         root=/dev/sdb2 rw iommu=soft 
# EFI diretroot
# efibootmgr -c -d /dev/sda -p 2 -l /vmlinuz-linux.efi -L "Arch Linux" -u "initrd=intel-ucode.img initrd=initramfs-linux.img root=LABEL=ROOT rw rootflags=noatime,nodiratime" [\code]
# Проблема скорее в том, что некоторые прошивки грузят ядро, только если добавить к имени расширение .efi
# https://lib.clodo.ru/network/setting-ip-linux.html
# https://wiki.archlinux.org/title/udev_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)


#IN

echo "Name of 1st menu point"
read NAME

#UNIVERSL DISK SELECTOR
lsblk 
echo "lsblk"

while true; do 
echo "Type full name of USB device for burning in format /dev/sd*"
read VAR	
	if [[ ! $VAR =~ ^/dev/ ]]; then
	continue
	fi
echo "Selected USB devise $VAR"
	break
done

USB=$VAR 
#END


#BODY
#Добавление загрузчика UEFI. 
#Для добавления загрузчика UEFI понадобятся файлы, которые могут отсутствовать на компьютере. Чтобы их получить, необходимо установить ряд пакетов:

apt update
apt install grub-efi-amd64-bin dosfstools mtools xorriso isolinux syslinux-common


#Далее в каталоге livecd необходимо создать вспомогательные файлы:
echo "set timeout=3
menuentry $NAME {
    $NAME    /$NAME
    initrd /init.ram
}
" > grub.cfg

echo "search --file --set=root /grub.cfg
if [ -e ($root)/grub.cfg ]; then
	set prefix=($root)
	configure $prefix/grub.cfg
else
	echo can't find grub.cfg
fi" > grub-inst.cfg


#Загрузчик добавляется командой:
mkdir ./iso
cp grub.cfg iso/grub.cfg
mkdir -p EFI/BOOT
grub-mkimage --prefix '' --config "grub-inst.cfg" -O x86_64-efi -o 'EFI/BOOT/bootx64.efi' acpi appleldr boot configfile efi_gop efi_uga elf fat fixvideo font gettext gfxmenu gfxterm gfxterm_background gfxterm_menu iso9660 linux memdisk minicmd normal part_gpt part_msdos search sleep usb video video_bochs video_cirrus video_fb videotest
mkdosfs -F12 -n "EFI" -C iso/efiboot.img 2048
mcopy -s -i iso/efiboot.img EFI ::
rm -r EFI
#В результате в каталоге iso появятся два файла: grub.cfg и efiboot.img.

#Добавление загрузчика BIOS
#На древних компьютерах UEFI отсутствует. Вместо этого там используется BIOS. Чтобы создаваемый диск мог загружаться на таких компьютерах тоже, необходимо добавить загрузчик BIOS. Для получения файлов необходимо установить ряд пакетов:
#apt install isolinux syslinux-common

#Далее в каталоге livecd необходимо создать вспомогательный файл
echo "UI menu.c32
PROMPT 0
TIMEOUT 1
MENU TITLE Boot Menu
LABEL default
	MENU LABEL LINUX LIVE USB
	$NAME $NAME
	initrd init.ram" > syslinux.cfg

#После этого нужно выполнить команды:
cp syslinux.cfg iso
cp /usr/lib/ISOLINUX/isolinux.bin iso
cp /usr/lib/syslinux/modules/bios/{ldlinux.c32,menu.c32,libutil.c32,libcom32.c32} iso

#Создание образа и диска
#Образ (файл livecd.iso) создается командой:
#-->OUT
#Удалить linux с флешки и отформатировать ее обратно можно командой:
#wipefs -a /dev/sdz
#mkfs.exfat /dev/sdz
#--->OUT

#Добавление ядра Linux
#Ядро Linux обычно хранится в каталоге /boot и представляет собой файл с названием «vmlinuz-XXX», где XXX — версия ядра. Добавить текущее ядро в создаваемый образ можно командой:
#cp $(ls -t /boot/vmlinuz-$(uname -r) | head -n 1) iso/linux
#Or copy other 

cp ./vmlinuz-$NAME  iso/$NAME
#-->OUT

#Добавление файловой системы
#В данной статье в качестве корневой файловой системы рассматривается использование временной файловой системы, которая размещается в оперативной памяти (initramfs). Для ее создания необходимо создать в каталоге livecd подкаталог initramfs, в нем пустой файл с названием init. Файл с таким названием почему-то обязательно должен быть и находиться в корне файловой системы, иначе ядро проигнорирует такую initramfs. Далее необходимо выполнить команды
mkdir initramfs


#Минимальный работающий init
#В каталоге initramfs нужно создать следующую структуру файлов:
#├─lib (каталог с двумя файлами)
#│ ├─ ld-linux-x86-64.so.2 (из /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2)
#│ └─ libc.so.6 (из /lib/x86_64-linux-gnu/libc.so.6)
#├─lib64 (символическая ссылка на lib)
#└─init (из /bin/dash)

#Coping
mkdir ./initramfs/lib
cp /lib64/ld-linux-x86-64.so.2  ./initramfs/lib
cp /lib32/libc.so.6  ./initramfs/lib
chmod u+x ./initramfs/lib/ld-linux-x86-64.so.2
chmod u+x ./initramfs/lib/lib32/libc.so.6 

#Symbol link
ln -s ./initramfs/lib lib64

#Простой программой здесь называется программа, состоящая из одного исполняемого файла, например dash, mkdir, mount. В противоположность сложные программы содержат большое количество обязательных дополнительных файлов, например: текстовые, аудио и видеоредакторы, браузеры и т.п.
#По сложившейся традиции программы размещаются в каталоге bin. В каталоге initramfs нужно создать подкаталог bin и скопировать туда файл ls из одноименного каталога работающей системы.
mkdir ./initramfs/bin
cp /bin/ls ./initramfs/bin
cp /usr/lib/x86_64-linux-gnu/libselinux.so.1 ./initramfs/lib
cp /usr/lib/x86_64-linux-gnu/libpcre2-8.so.0.11.2 ./initramfs/lib
mv ./initramfs/lib/libpcre2-8.so.0.11.2 ./initramfs/lib/libpcre2-8.so.0.11.0


#Многие программы в своей работе используют вспомогательные so-файлы (программные библиотеки), без которых они не запустятся. Узнать, какие so-файлы нужны программе, можно с помощью уже упоминавшейся команды objdump -p <имя файла>.
#Вывод команды «objdump -p ls»:
#Динамический раздел:
#NEEDED libselinux.so.1
#NEEDED libc.so.6


#OUT
chmod u+x ./initramfs/lib/*
chmod u+x ./initramfs/lib/lib32/*

cd initramfs
find . | cpio -o -H newc --owner=root.root | gzip -9 > ../iso/init.ram
cd ..
xorriso -as mkisofs -r -o $NAME.iso -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin -partition_offset 16 -J -l -joliet-long -c boot.cat -b isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e efiboot.img -no-emul-boot -isohybrid-gpt-basdat iso

umount $USB
sudo mkfs -t vfat -n LINUX_LIVE_CD $USB
dd if=$NAME.iso of=$USB
