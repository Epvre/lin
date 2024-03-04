#!/bin/bash
#CORE OR EXTRA
TYPE=extra
IN=list_arch_$TYPE_20240301.txt
OUT=wget_list_arch_$TYPE.txt
URL_DIR="https://archive.archlinux.org/repos/2024/03/01/$TYPE/os/x86_64/"

>$OUT
curl -s $URL_DIR | grep -o 'href="[^"]\+"' | sed 's/href="\([^"]\+\)"/\1/g' > $IN



# For each line cycle
while read -r LINE; do
    FILENAME=$(echo $LINE | awk '{print $1}')
    URL="$URL_DIR/$FILENAME"
    echo $URL >> $OUT
done < $IN

 
