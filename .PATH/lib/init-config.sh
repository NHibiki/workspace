#!/bin/bash

# Install docker first, run as root

echo "[YServerInit] Please run this script as root"
echo "[YServerInit] Building Swap"
dd if=/dev/zero of=/swapfile bs=1M count=2048
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

echo "[YServerInit] Configuring Swap"
echo 'vm.swappiness=10' | tee -a /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' | tee -a /etc/sysctl.conf
echo 'fs.inotify.max_user_watches=524288' | tee -a /etc/sysctl.conf
sysctl -p

curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod a+x /usr/local/bin/docker-compose

