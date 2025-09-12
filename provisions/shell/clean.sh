#!/bin/bash

# Обновляем индекс пакетов
sudo apt-get update

# Очистка кэша apt для уменьшения размера образа
sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

# Очистка временных файлов
sudo rm -rf /tmp/*
sudo rm -f /var/log/*.log
sudo rm -f /var/log/*.log.?
sudo rm -f /var/log/*.log.??

# Создаем файл motd с информацией о образе
echo "##########################################################" | sudo tee /etc/motd
echo "# Packer-built Debian Image"                                | sudo tee -a /etc/motd
echo "# Created: $(date)"                                         | sudo tee -a /etc/motd
echo "##########################################################" | sudo tee -a /etc/motd
