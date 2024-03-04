#!/bin/bash
#CORE
IN=list_arch_core_20240301.txt
OUT=wget_list_arch_core.txt
URL_DIR=https://archive.archlinux.org/repos/2024/03/01/core/os/x86_64/

>$OUT
curl -s $URL_DIR | awk '/\.pkg\.tar\.zst$/{getline url; print url}' > $OUT

# For each line cycle
# while read -r LINE; do
    # Получить название файла (первое слово в строке)
#    FILENAME=$(echo $LINE | awk '{print $1}')
    
    # Добавить ссылку спереди
#    URL="$URL_DIR/$FILENAME"
    
    # Сохранить результат в файл
#    echo $URL >> $OUT
# done < $IN

 
