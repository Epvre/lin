#!/bin/bash
#CORE
IN=list_arch_core_20240301.txt
OUT=wget_list_arch_core.txt
>$OUT

# Цикл для обработки каждой строки в списке
while read -r LINE; do
    # Получить название файла (первое слово в строке)
    FILENAME=$(echo $LINE | awk '{print $1}')
    
    # Добавить ссылку спереди
    URL="https://archive.archlinux.org/repos/2024/03/01/core/os/x86_64/$FILENAME"
    
    # Сохранить результат в файл
    echo $URL >> $OUT
done < $IN

#EXTRA
IN=list_arch_extra_20240301.txt
OUT=wget_list_arch_extra.txt
>$OUT

# Цикл для обработки каждой строки в списке
while read -r LINE; do
    # Получить название файла (первое слово в строке)
    FILENAME=$(echo $LINE | awk '{print $1}')
    
    # Добавить ссылку спереди
    URL="https://archive.archlinux.org/repos/2024/03/01/extra/os/x86_64/$FILENAME"
    
    # Сохранить результат в файл
    echo $URL >> $OUT
done < $IN

