#!/bin/bash

zzgrep() {
    local archive_file="$1"
    local search_pattern="$2"
    
    # Проверяем наличие архива
    if [ ! -f "$archive_file" ]; then
        echo "Архив не найден: $archive_file"
        return 1
    fi
    
    # Создаем временную директорию
    mkdir -p temp

    # Разархивируем архив в директорию temp
    tar -xzf "$archive_file" -C temp

    # Выполняем рекурсивный поиск по шаблону в разархивированной директории
    grep -r "$search_pattern" temp

    # Удаляем временную директорию temp
    rm -rf temp
}

