#!/bin/bash
#Mount and folder creation
MNT=/mnt/sdb1

DATE=2024/03/01
TYPE=extra


REPO_DIR=$MNT_DIR/repos/$DATE/$TYPE/os/x86_64/

mkdir -p $REPO_DIR


#IN and OUT creation

IN=list_arch_$TYPE_20240301.txt
OUT=wget_list_arch_$TYPE.txt

DOMAIN=https://archive.archlinux.org
URL_DIR=$DOMAIN/repos/$DATE/$TYPE/os/x86_64/

>$OUT

#Extract links from http
pacman -S aria2 
curl -s $URL_DIR | grep -o 'href="[^"]\+"' | sed 's/href="\([^"]\+\)"/\1/g' > $IN

#curl -s $URL_DIR  | grep -o 'href="[^"]\+"' | sed 's/href="\([^"]\+\)"/\1/g' | aria2c -j8 -i - -d $REPO_DIR
wget -e robots=off --recursive --no-clobber --page-requisites --html-extension --convert-links --domains www.example.org --no-parent www.example.org/Public/


# Create wget-list
while read -r LINE; do
    FILENAME=$(echo $LINE | awk '{print $1}')
    URL="$URL_DIR/$FILENAME"
    echo $URL >> $OUT
done < $IN

#Downloading by wget-list
aria2c -j8 -i - -d $REPO_DIR
#pacman -S  paralell
#parallel -j 8 wget < $OUT

 
