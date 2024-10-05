#!/bin/bash

# Функция для вывода справки
function show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -p, --proc [file]         Работа с директорией /proc"
    echo "  -c, --cpu                 Показать использование процессора"
    echo "  -m, --memory [param]      Показать информацию о памяти"
    echo "  -d, --disks               Показать состояние дисков"
    echo "  -n, --network             Показать сетевую активность"
    echo "  -la, --loadaverage        Показать среднюю нагрузку на систему"
    echo "  -k, --kill <pid> <signal> Отправить сигнал процессу"
    echo "  -o, --output <file>       Сохранить результат в файл"
    echo "  -h, --help                Показать справку"
    echo ""
    echo "Примеры:"
    echo "  $0 -c                     Показать информацию о процессоре"
    echo "  $0 -m total               Показать общую память"
}

# Функция для работы с процессором
function show_cpu() {
    echo "CPU Usage:"
    top -b -n1 | grep "Cpu(s)"
}

# Функция для работы с памятью
function show_memory() {
    case $1 in
        total)
            free -m | awk '/Mem:/ {print "Total Memory: " $2 " MB"}'
            ;;
        available)
            free -m | awk '/Mem:/ {print "Available Memory: " $7 " MB"}'
            ;;
        *)
            free -m
            ;;
    esac
}

# Функция для работы с дисками
function show_disks() {
    echo "Disk Usage:"
    lsblk
}

# Функция для работы с сетью
function show_network() {
    echo "Network Usage:"
    ifstat -t 1 1
}

# Функция для вывода средней нагрузки
function show_load_average() {
    echo "Load Average:"
    uptime
}

# Функция для отправки сигнала процессу
function kill_process() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Error: Нужно указать PID и сигнал"
        exit 1
    fi
    kill -$2 $1
    echo "Процесс $1 завершен с сигналом $2"
}

# Основной цикл обработки аргументов
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -p|--proc)
            if [ -z "$2" ]; then
                echo "Содержимое /proc:"
                ls /proc
            else
                echo "Содержимое файла /proc/$2:"
                cat /proc/$2
            fi
            shift
            ;;
        -c|--cpu)
            show_cpu
            ;;
        -m|--memory)
            show_memory $2
            shift
            ;;
        -d|--disks)
            show_disks
            ;;
        -n|--network)
            show_network
            ;;
        -la|--loadaverage)
            show_load_average
            ;;
        -k|--kill)
            kill_process $2 $3
            shift 2
            ;;
        -o|--output)
            exec > $2 2>&1
            echo "Результаты будут сохранены в $2"
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Неизвестный параметр: $1"
            show_help
            exit 1
            ;;
    esac
    shift
done

# Если нет аргументов - выводим справку
if [ "$#" -eq 0 ]; then
    show_help
fi

