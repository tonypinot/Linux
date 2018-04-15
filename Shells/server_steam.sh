#!/bin/sh

#------------------------------------------------------------#
# REQUIRED FILES
#------------------------------------------------------------#
source /home/scripts/voidCore.sh

#------------------------------------------------------------#
# FUNCTIONS
#------------------------------------------------------------#

	#------------------------------#
	# STEAMCMD
	#------------------------------#
	function SteamInstall()
	{
		# 32bits libraries
		dpkg --add-architecture i386
		apt-get update
		apt-get upgrade
		InstallPackageAPT "libc6-i386 lib32gcc1 lib32stdc++6"	
		apt-get install -f
		
		# Create steam user if not exist
		if ! HasUser steam
		then
			CreateUser steam "-m" "steam" true
			passwd steam
		fi
		
		# Download steam files
		su steam -c "mkdir /home/steam/steamcmd/"
		su steam -c "cd /home/steam/steamcmd/;wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz"
		su steam -c "cd /home/steam/steamcmd/;tar -xvzf steamcmd_linux.tar.gz;rm steamcmd_linux.tar.gz"
	}
	function SteamRemove()
	{
		DeleteUser steam true
	}

	#------------------------------#
	# CSGO
	#------------------------------#	
	function CSGOStart()
	{
		serverID=${1}; if IsEmpty "$serverID" "[server_steam.sh] csgo parameter serverID"; then exit; fi
		steamToken=${2}; if IsEmpty "$steamToken" "[server_steam.sh] csgo parameter steamToken"; then exit; fi
		serverIp=${3}; if IsEmpty "$serverIp" "[server_steam.sh] csgo parameter serverIp"; then exit; fi
		serverPort=${4}; if IsEmpty "$serverPort" "[server_steam.sh] csgo parameter serverPort"; then exit; fi
		serverGameType=${5}; if IsEmpty "$serverGameType" "[server_steam.sh] csgo parameter serverGameType"; then exit; fi
		serverGameMode=${6}; if IsEmpty "$serverGameMode" "[server_steam.sh] csgo parameter serverGameMode"; then exit; fi
		mapgroup=${7}; if IsEmpty "$mapgroup" "[server_steam.sh] csgo parameter mapgroup"; then exit; fi
		map=${8}; if IsEmpty "$map" "[server_steam.sh] csgo parameter map"; then exit; fi

		customParameters="+sv_setsteamaccount $steamToken +ip $serverIp -port $serverPort +game_type $serverGameType +game_mode $serverGameMode +mapgroup $mapgroup +map $map"
		serverStartCommand="./srcds_run -game csgo -console -usercon -secure -net_port_try 1 -tickrate 128 -stringtables $customParameters"
		
		workshopAuthkey=${9}; if ! IsEmpty "$workshopAuthkey" "[server_steam.sh] csgo parameter workshopAuthkey"; then serverStartCommand+=" -authkey $workshopAuthkey" ; fi
		workshopCollection=${10}; if ! IsEmpty "$workshopCollection" "[server_steam.sh] csgo parameter workshopCollection"; then serverStartCommand+=" +host_workshop_collection $workshopCollection" ; fi
		workshopMap=${11}; if ! IsEmpty "$workshopMap" "[server_steam.sh] csgo parameter workshopMap"; then serverStartCommand+=" +host_workshop_map $workshopMap" ; fi

		su steam -c "cd /home/steam/games/csgo/server$serverID/;screen -AdmS csgoServer$serverID $serverStartCommand"
	}
	function CSGOStop()
	{
		serverID=${1}; if IsEmpty "$serverID" "[server_steam.sh] csgo parameter serverID"; then exit; fi
		screenName="csgoServer$serverID"
		
		if ls -laR /var/run/screen/ | grep -q $screenName
		then
			su steam -c "screen -S $screenName -X quit"
		fi
	}
	function CSGOUpdate()
	{
		serverID=${1}; if IsEmpty "$serverID" "[server_steam.sh] csgo parameter serverID"; then exit; fi		
		su steam -c "cd /home/steam/steamcmd/;./steamcmd.sh +login anonymous +force_install_dir /home/steam/games/csgo/server$serverID/ +app_update 740 validate +quit"
	}
	function CSGOUninstall()
	{
		serverID=${1}; if IsEmpty "$serverID" "[server_steam.sh] csgo parameter serverID"; then exit; fi
		CSGOStop $serverID
		
		rm -R "/home/steam/games/csgo/server$serverID/"
	}

	#------------------------------#
	# ARK
	#------------------------------#
	function ARKInstallPrerequisites()
	{
		echo 'fs.file-max=100000' > /etc/sysctl.conf;
		sysctl -p /etc/sysctl.conf
		
		echo 'fs.file-max=100000' > /etc/sysctl.conf;
		echo 'soft nofile 1000000' > /etc/security/limits.conf;
		echo 'hard nofile 1000000' > /etc/security/limits.conf;
		echo 'session required pam_limits.so' > /etc/pam.d/common-session;
	}
	function ARKStart()
	{
		serverID=${1}; if IsEmpty "$serverID" "[server_steam.sh] ARK parameter serverID"; then exit; fi		
		sessionName=${2}; if IsEmpty "$sessionName" "[server_steam.sh] ARK parameter sessionName"; then exit; fi
		serverPassword=${3}; if IsEmpty "$serverPassword" "[server_steam.sh] ARK parameter serverPassword"; then exit; fi
		serverAdminPassword=${4}; if IsEmpty "$serverAdminPassword" "[server_steam.sh] ARK parameter serverAdminPassword"; then exit; fi
	
		customParameters="SessionName=$sessionName?ServerPassword=$serverPassword?ServerAdminPassword=$serverAdminPassword"
		serverStartCommand="./ShooterGameServer TheIsland?listen?$customParameters -server -log"		
		
		su steam -c "cd /home/steam/games/ark/server$serverID/ShooterGame/Binaries/Linux/;screen -AdmS arkServer$serverID $serverStartCommand"
	}
	function ARKStop()
	{
		serverID=${1}; if IsEmpty "$serverID" "[server_steam.sh] ARK parameter serverID"; then exit; fi
		screenName="arkServer$serverID"
		
		if ls -laR /var/run/screen/ | grep -q $screenName
		then
			su steam -c "screen -S $screenName -X quit"
		fi
	}
	function ARKUpdate()
	{
		serverID=${1}; if IsEmpty "$serverID" "[server_steam.sh] ARK parameter serverID"; then exit; fi
		su steam -c "cd /home/steam/steamcmd/;./steamcmd.sh +login anonymous +force_install_dir /home/steam/games/ark/server$serverID/ +app_update 376030 validate +quit"
	}
	function ARKUninstall()
	{
		serverID=${1}; if IsEmpty "$serverID" "[server_steam.sh] csgo parameter serverID"; then exit; fi
		ARKStop $serverID
		
		rm -R "/home/steam/games/ark/server$serverID/"
	}

	
#------------------------------------------------------------#
# SCRIPT
#------------------------------------------------------------#
clear

target=${1}; if IsEmpty "$target" "[server_steam.sh] parameter target"; then exit; fi
action=${2}; if IsEmpty "$action" "[server_steam.sh] parameter action"; then exit; fi

case $target in

	#------------------------------#
	# STEAMCMD
	#------------------------------#
	"steam")	
		case $action in
			"install")
				SteamInstall
			;;
			"remove")
				SteamRemove
			;;			
		esac
	;;
	
	#------------------------------#
	# CSGO
	#------------------------------#
	"csgo")
		case $action in
			"start")
				CSGOStart ${3} ${4} ${5} ${6} ${7} ${8} ${9} ${10} ${11} ${12} ${13}
			;;
			"update")
				CSGOUpdate ${3}
			;;
			"stop")
				CSGOStop ${3}
			;;
		esac
	;;
	
	#------------------------------#
	# ARK
	#------------------------------#
	"ark")
		case $action in
			"installPrerequisites")
				ARKInstallPrerequisites
			;;
			"start")
				ARKStart ${3} ${4} ${5} ${6}
			;;
			"update")
				ARKUpdate ${3}
			;;
			"stop")
				ARKStop ${3}
			;;
		esac
	;;
	
esac