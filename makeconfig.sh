#!/bin/bash 
# https://wiki.merionet.ru/articles/poshagovoe-rukovodstvo-kak-sobrat-yadro-linux-s-nulya/
# https://habr.com/ru/articles/122179/
# https://soft.lafibre.info/
# sudo apt-get install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison

FILES=( $(find ./ -type f -name "linux*.tar*" | sed 's/^.\///') )
#FILES=( $(ls -a | grep "*.tar*") )

for ((i=0; i<${#FILES[@]}; i++)); do
    echo "${i}: ${FILES[i]}"
done

# Запрашиваем номер из массива
#read -p "Select number of linux archive" N
echo "Select linux archive" 
read N	

# Записываем выбранный архив в переменную L
LINUX_ARCHIVE=${FILES[N]}

echo "Selected linux archive: $LINUX_ARCHIVE"


#Unziping
rmdir -r config
mkdir ./config	
tar xvf $LINUX_ARCHIVE -C ./config
unzip $LINUX_ARCHIVE ./config


cd ./config
LINUX=( $(ls) )
echo "
$LINUX"
cd $LINUX
ls; 

#Configuration
#make defconfig;
#	cp -v /boot/config-$(uname -r) .config
make menuconfig 

#make 

