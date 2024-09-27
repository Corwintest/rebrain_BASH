#!/bin/bash

# Проверяем, передан ли аргумент
if [ -z "$1" ]; then
    echo "Usage: $0 <path_to_file>"
    exit 1
fi

# Проверяем, существует ли файл
if [ ! -f "$1" ]; then
    echo "File not found!"
    exit 1
fi

# Получаем размер файла в байтах
file_size=$(stat -c%s "$1")

# Проверяем размер файла
if [ "$file_size" -le 1024 ]; then
    echo "OK"
else
    echo "FAIL"
fi

