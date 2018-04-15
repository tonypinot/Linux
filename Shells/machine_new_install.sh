#!/bin/sh

# Required files
source /home/scripts/voidCore.sh

# Scripts directory
cd /home/scripts/

# Install: dos2unix
InstallPackageAPT dos2unix

# Install: proftpd
dos2unix server_proftpd.sh
chmod +x server_proftpd.sh
./server_proftpd.sh install
./server_proftpd.sh enableDefaultDirectory
./server_proftpd.sh reload

# Install Mysql
dos2unix server_mysql.sh
chmod +x server_mysql.sh
./server_mysql.sh install
./server_mysql.sh secure

# Install Apache2
dos2unix server_apache2.sh
chmod +x server_apache2.sh
./server_apache2.sh install
./server_apache2.sh configuration
./server_apache2.sh restart

# Install Php 5.6
dos2unix server_php5-6.sh
chmod +x server_php5-6.sh
./server_php5-6.sh install

# Install .NetCore 2
dos2unix sdk_dotnetcore2x.sh
chmod +x sdk_dotnetcore2x.sh
./sdk_dotnetcore2x.sh install

#------------------------------------------------------------#
# Game servers
#------------------------------------------------------------#

# Install: screen
InstallPackageAPT screen

# Install Teamspeak3
dos2unix server_teamspeak3.sh
chmod +x server_teamspeak3.sh
./server_teamspeak3.sh install 1
./server_teamspeak3.sh start 1

# Install Steam
dos2unix server_steam.sh
chmod +x server_steam.sh
./server_steam.sh steam install

# Install CSGO Server
./server_steam.sh csgo update 1

# Install Minecraft
dos2unix server_minecraft.sh
chmod +x server_minecraft.sh
./server_minecraft.sh install 1
./server_minecraft.sh java_install
./server_minecraft.sh overviewer_install

# Clean console
history -c
clear