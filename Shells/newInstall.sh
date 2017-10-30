cd /home/scripts/

# Install: dos2unix
apt-get install -y dos2unix

# Install Mysql
dos2unix server_mysql.sh
chmod +x server_mysql.sh
./server_mysql.sh install
./server_mysql.sh secure

# Install Apache2
dos2unix server_apache2.sh
chmod +x server_apache2.sh
./server_apache2.sh install

# Install Php 5.6
dos2unix server_php5-6.sh
chmod +x server_php5-6.sh
./server_php5-6.sh install

# Install web site

# Install web site PhpMyAdmin

# Install Teamspeak3
dos2unix server_teamspeak3.sh
chmod +x server_teamspeak3.sh
./server_teamspeak3.sh install 1
./server_teamspeak3.sh start 1

# Install Minecraft
dos2unix server_minecraft.sh
chmod +x server_minecraft.sh
./server_minecraft.sh install 1
./server_minecraft.sh java_install
./server_minecraft.sh overviewer_install

# Clean console
history -c
clear