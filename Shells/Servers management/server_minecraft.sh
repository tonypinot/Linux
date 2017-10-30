#!/bin/sh

#------------------------------------------------------------#
# REQUIRED FILES
#------------------------------------------------------------#
source /home/scripts/functions/createUser.sh
source /home/scripts/functions/APT.sh

#------------------------------------------------------------#
# ACTIONS
#------------------------------------------------------------#
action=$1

case $action in

	#------------------------------#
	# JAVA_INSTALL
	#------------------------------#
	java_install)
		echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list
		echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
		apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
		apt-get update
		apt-get install -y oracle-java8-installer
	;;
	
	#------------------------------#
	# OVERVIEWER_INSTALL
	#------------------------------#		
	overviewer_install)
		packageAPT="apt-transport-https"
		InstallPackageAPT
	
		sourcePackageAPT="deb https://overviewer.org/debian ./"
		CheckPackageAPTSource		
		
		wget -O - https://overviewer.org/debian/overviewer.gpg.asc | apt-key add -
		apt-get update
		
		packageAPT="minecraft-overviewer"
		InstallPackageAPT
		
		echo 'Overviewer texture pack version (ex: 1.12.2):'
		read version
		
		su minecraft -c "wget http://s3.amazonaws.com/Minecraft.Download/versions/$version/$version.jar -P ~/.minecraft/versions/$version/"
		
		mkdir /var/www/minecraft/
		chown minecraft:minecraft /var/www/minecraft/
	;;
	
	#------------------------------#
	# OVERVIEWER_RENDER_MAP
	#------------------------------#
	overviewer_render_map)
		serverID=$2
		serverMap=$3
	
		su minecraft -c "mkdir /var/www/minecraft/$serverID/"
		su minecraft -c "cd /home/minecraft/server$serverID/;overviewer.py "$serverMap" /var/www/minecraft/$serverID/"
	;;	
	
	#------------------------------#
	# INSTALL
	#------------------------------#
	install)
	
		serverID=$2

		# Create minecraft user
		userName="minecraft"
		userParameters="-m"
		userFolder="minecraft"
		createUser
		passwd minecraft
		
		# Select server version
		echo 'Choose server version (ex: 1.12.2):'
		read version		
		
		# Select server type		
		echo 'Choose server type (Minecraft by default):'
		echo 'Type 0 for classic server'
		echo 'Type 1 for Craftbukkit server'
		echo 'Type 2 for Spigot server'
		read serverType
		
		# Select download url
		case "$serverType" in
			1)
				url="http://cdn.getbukkit.org/craftbukkit/craftbukkit-$version.jar"
			;;
			2)
				url="http://cdn.getbukkit.org/spigot/spigot-$version.jar"
			;;
			*)
				url="http://s3.amazonaws.com/Minecraft.Download/versions/$version/minecraft_server.$version.jar"
			;;
		esac
		
		# Download minecraft server files
		su minecraft -c "mkdir /home/minecraft/server$serverID/"
		su minecraft -c "cd /home/minecraft/server$serverID/;wget $url -O minecraftServer.jar"
		su minecraft -c "cd /home/minecraft/server$serverID/;echo 'eula=true' > eula.txt"
		
		cd /home/scripts/
		./server_minecraft.sh start $serverID
	;;	
	
	#------------------------------#
	# START
	#------------------------------#
	start)
		serverID=$2
		su minecraft -c "cd /home/minecraft/server$serverID/;screen -dmS minecraftServer$serverID java -Xms2G -Xmx2G -jar minecraftServer.jar nogui"
	;;
	
	#------------------------------#
	# STOP
	#------------------------------#
	stop)
		serverID=$2
		su minecraft -c "script /dev/null/;cd /home/minecraft/server$serverID/;screen -S minecraftServer$serverID -X quit"
	;;
	
	#------------------------------#
	# UNINSTALL
	#------------------------------#
	uninstall)
		serverID=$2
	;;
esac
