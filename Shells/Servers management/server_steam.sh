#!/bin/sh

#------------------------------------------------------------#
# REQUIRED FILES
#------------------------------------------------------------#
source /home/scripts/functions/tryCatch.sh
source /home/scripts/functions/createUser.sh
source /home/scripts/functions/basicCore.sh
source /home/scripts/functions/APT.sh

#------------------------------------------------------------#
# FUNCTIONS
#------------------------------------------------------------#

	#------------------------------#
	# STEAMCMD
	#------------------------------#
	SteamInstall()
	{
		# 32bits libraries
		dpkg --add-architecture i386
		apt-get update
		apt-get upgrade
		apt-get install -y lib32gcc1
		apt-get install -f
		
		# Create steam user if not exist
		if [ -z "$(getent passwd steam)" ]; then
			userName="steam"
			userParameters="-m"
			userFolder="steam"
			createUser
			passwd steam	
		fi
		
		# Download steam files
		su steam -c "mkdir /home/steam/steamcmd/"
		su steam -c "cd /home/steam/steamcmd/;wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz"
		su steam -c "cd /home/steam/steamcmd/;tar -xvzf steamcmd_linux.tar.gz;rm steamcmd_linux.tar.gz"
	}
	
	#------------------------------#
	# GLOBAL
	#------------------------------#
	ServerInstall()
	{
		serverType=$1
	
		echo "Checking the server type parameter"
		if [[ -z $serverType ]]; then
			echo "Wrong parameters - Server type is empty"
			exit
		fi
		
		case $serverType in
			csgo)
				ServerCSGOInstall $2
			;;
		esac
	}
	ServerStart()
	{
		serverType=$1
	
		echo "Checking the server type parameter"
		if [[ -z $serverType ]]; then
			echo "Wrong parameters - Server type is empty"
			exit
		fi
		
		case $serverType in
			csgo)
				ServerCSGOStart $2 $3 $4 $5 $6 $7 $8
			;;
		esac
	}
	
	#------------------------------#
	# CSGO
	#------------------------------#
	ServerCSGOInstall()
	{
		serverID=$1
		
		echo "Checking the server id parameter"
		if [[ -z $serverID ]]; then
			echo "Wrong parameters - Server id is empty"
			exit
		else
			serverFolder="/home/steam/server$serverID/"
			if [ -d "$serverFolder" ]; then
				su steam -c "rmdir $serverFolder"	
			fi	
		fi
		
		su steam -c "cd /home/steam/steamcmd/;./steamcmd.sh +login anonymous +force_install_dir /home/steam/server$serverID/ +app_update 740 validate +quit"
	}
	ServerCSGOStart()
	{
		serverID=$1	
		steamToken=$2		
		serverPort=$3
		serverGameType=$4
		serverGameMode=$5
		mapgroup=$6
		map=$7

		clear
		if IsEmpty "$serverID" "[CSGO Parameter] serverID"; then return; fi
		if IsEmpty "$steamToken" "[CSGO Parameter] steamToken"; then return; fi
		if IsEmpty "$serverPort" "[CSGO Parameter] serverPort"; then return; fi
		if IsEmpty "$serverGameType" "[CSGO Parameter] serverGameType"; then return; fi
		if IsEmpty "$serverGameMode" "[CSGO Parameter] serverGameMode"; then return; fi
		if IsEmpty "$mapgroup" "[CSGO Parameter] mapgroup"; then return; fi
		if IsEmpty "$map" "[CSGO Parameter] map"; then return; fi
		
		serverCustomParameters="+sv_setsteamaccount $steamToken -port $serverPort +game_type $serverGameType +game_mode $serverGameMode +mapgroup $mapgroup +map $map"
		serverParameters="./srcds_run -game csgo -console -usercon -secure -net_port_try 1 $serverCustomParameters"
		
		su steam -c "cd /home/steam/server$serverID/;screen -AdmS csgoServer$serverID $serverParameters"
		
		true
	}

#------------------------------------------------------------#
# SCRIPT
#------------------------------------------------------------#
action=$1

case $action in

	SteamInstall)
		SteamInstall
	;;
	ServerInstall)
		ServerInstall $2 $3
	;;
	ServerUninstall)
		ServerUninstall $2 $3
	;;
	ServerStart)
		ServerStart $2 $3 $4 $5 $6 $7 $8 $9
	;;
	ServerStop)
		ServerStop $2 $3
	;;
	
esac