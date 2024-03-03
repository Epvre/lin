#!/bin/bash
IN=core_arch_20240301.txt
OUT=core_wget_list.txt
>$OUT

# Цикл для обработки каждой строки в списке
while read -r LINE; do
    # Получить название файла (первое слово в строке)
    FILENAME=$(echo $LINE | awk '{print $1}')
    
    # Добавить ссылку спереди
    URL="https://archive.archlinux.org/repos/month/extra/os/x86_64/$FILENAME"
    
    # Сохранить результат в файл
    echo $URL >> $OUT
done < $INPUT
