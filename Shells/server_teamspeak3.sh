#!/bin/sh

#------------------------------------------------------------#
# REQUIRED FILES
#------------------------------------------------------------#
source /home/scripts/voidCore.sh

#------------------------------------------------------------#
# ACTIONS
#------------------------------------------------------------#
action=$1
case $action in

	#------------------------------#
	# INSTALL
	#------------------------------#
	install)
		# Get parameters
		serverID=$2
	
		# Create teamspeak user
		CreateUser teamspeak -m teamspeak true
		
		# Create mysql database
		#ts3Label=$4
		#ts3UID=$5
		#ts3passwd=$6
		# mysql -u root -p$MySQL_mdp -e "CREATE DATABASE IF NOT EXISTS TS3_$ts3Libelle;"
		# mysql -u root -p$MySQL_mdp -e "GRANT ALL ON  TS3_$ts3Libelle.* TO '$ts3UID'@'localhost' IDENTIFIED BY '$ts3mdp;'"
		
		# Download and extract Teamspeak3 server files (http://dl.4players.de/ts/releases/)
		
		su teamspeak -c "cd /home/teamspeak/;wget http://dl.4players.de/ts/releases/3.0.13/teamspeak3-server_linux_amd64-3.0.13.tar.bz2 -O teamspeakServer.tar.bz2"
		su teamspeak -c "cd /home/teamspeak/;tar jxf teamspeakServer.tar.bz2"
		su teamspeak -c "cd /home/teamspeak/;mv teamspeak3-server_linux_amd64 server$serverID;rm -R teamspeakServer.tar.bz2"
		
		# Server Configuration
		#ts3Port=$3
	;;
	
	#------------------------------#
	# START
	#------------------------------#
	start)
		serverID=$2;
		su teamspeak -c "cd /home/teamspeak/server$serverID/;./ts3server_startscript.sh start"
	;;
	
	#------------------------------#
	# STOP
	#------------------------------#
	stop)
		serverID=$2;
		su teamspeak -c "cd /home/teamspeak/server$serverID/;./ts3server_startscript.sh stop"
	;;
	
	#------------------------------#
	# UNINSTALL
	#------------------------------#
	uninstall)
		serverID=$2;
		su teamspeak -c "cd /home/teamspeak/server$serverID/;./ts3server_startscript.sh stop"
		su teamspeak -c "rm -R /home/teamspeak/server$serverID/;"
	;;
esac		
