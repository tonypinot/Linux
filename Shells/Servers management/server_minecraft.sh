#!/bin/sh

#------------------------------------------------------------#
# REQUIRED FILES
#------------------------------------------------------------#
source /home/scripts/functions/tryCatch.sh
source /home/scripts/functions/createUser.sh
source /home/scripts/functions/APT.sh

#------------------------------------------------------------#
# FUNCTIONS
#------------------------------------------------------------#

	#------------------------------#
	# JAVA
	#------------------------------#
	JavaInstall()
	{
		echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list
		echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
		apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
		apt-get update
		apt-get install -y oracle-java8-installer	
	}

	#------------------------------#
	# OVERVIEWER
	#------------------------------#
	OverviewerInstall()
	{
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
	}
	OverviewerRenderMap()
	{
		try
		(
			serverID=$1
			serverMap=$2
			
			# Check $serverID and his folder
			echo "-----------------------------------------------"
			echo "	Check serverID and his folder"
			echo "-----------------------------------------------"
			if [[ -z $serverID ]]; then
				echo "Wrong parameters - Server id is empty"
				exit
			else
				serverFolder="/home/minecraft/server$serverID/"
				if [ ! -d "$serverFolder" ]; then
					echo "$serverFolder does not exist"
					exit
				fi
			fi

			# Check $serverMap and his folder
			echo "-----------------------------------------------"
			echo "	Check serverMap and his folder"
			echo "-----------------------------------------------"
			if [[ -z $serverMap ]]; then
				serverMap="world"
			fi
			serverMapFolder="$serverFolder$serverMap/"
			if [ ! -d "$serverMapFolder" ]; then
				echo "$serverMapFolder does not exist"
				exit
			fi

			# Check web folders
			echo "-----------------------------------------------"
			echo "	Check web folders"
			echo "-----------------------------------------------"
			if [ ! -d "/var/www/minecraft/" ]; then
				su minecraft -c "mkdir /var/www/minecraft/"			
			fi

			if [ ! -d "/var/www/minecraft/server$serverID/" ]; then
				su minecraft -c "mkdir /var/www/minecraft/server$serverID/"			
			fi
			
			if [ ! -d "/var/www/minecraft/server$serverID/$serverMap/" ]; then
				su minecraft -c "mkdir /var/www/minecraft/server$serverID/$serverMap/"			
			fi			
			
			# Start rendering
			echo "-----------------------------------------------"
			echo "	Start rendering"
			echo "-----------------------------------------------"
			su minecraft -c "cd /home/minecraft/server$serverID/;overviewer.py "$serverMap" /var/www/minecraft/server$serverID/$serverMap/"
			echo "-----------------------------------------------"
			echo "	End rendering"
			echo "-----------------------------------------------"
		)
		catch || {
			echo $ex_code
		}
	}

	#------------------------------#
	# MINECRAFT
	#------------------------------#	
	ServerInstall()
	{
		serverID=$1
		
		# Check $serverID and his folder
		echo "-----------------------------------------------"
		echo "	Check serverID and his folder"
		echo "-----------------------------------------------"
		if [[ -z $serverID ]]; then
			echo "Wrong parameters - Server id is empty"
			exit
		else
			serverFolder="/home/minecraft/server$serverID/"
			if [ -d "$serverFolder" ]; then
				su minecraft -c "rmdir $serverFolder"	
			fi
		fi
		
		# Create minecraft user if not exist
		if [ -z "$(getent passwd minecraft)" ]; then
			userName="minecraft"
			userParameters="-m"
			userFolder="minecraft"
			createUser
			passwd minecraft		
		fi
		
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
		su minecraft -c "mkdir $serverFolder"
		su minecraft -c "cd $serverFolder;wget $url -O minecraftServer.jar"
		su minecraft -c "cd $serverFolder;echo 'eula=true' > eula.txt"		
	}
	ServerUninstall()
	{
		serverID=$1		
		ServerStop $1
		
		su minecraft -c "rm -rf /home/minecraft/server$serverID/"
	}
	ServerStart()
	{
		serverID=$1
		
		su minecraft -c "cd /home/minecraft/server$serverID/;screen -dmS minecraftServer$serverID java -Xms2G -Xmx2G -jar minecraftServer.jar nogui"
	}
	ServerStop()
	{
		serverID=$1	
		
		# Check $serverID and his folder
		if [[ -z $serverID ]]; then
			echo "Wrong parameters - Server id is empty"
			exit
		else
			serverFolder="/home/minecraft/server$serverID/"
			if [ ! -d "$serverFolder" ]; then
				echo "$serverFolder does not exist"
				exit
			fi
		fi
		
		# Shutdown the minecraft server		
		su minecraft -c 'screen -S minecraftServer$serverID -X stuff "save-all\015"'
		su minecraft -c 'screen -S minecraftServer$serverID -X stuff "say The server will shut down in 10 seconds\015"'	
		sleep 1
		su minecraft -c 'screen -S minecraftServer$serverID -X stuff "say The server will shut down in 9 seconds\015"'
		sleep 1
		su minecraft -c 'screen -S minecraftServer$serverID -X stuff "say The server will shut down in 8 seconds\015"'
		sleep 1
		su minecraft -c 'screen -S minecraftServer$serverID -X stuff "say The server will shut down in 7 seconds\015"'
		sleep 1
		su minecraft -c 'screen -S minecraftServer$serverID -X stuff "say The server will shut down in 6 seconds\015"'
		sleep 1
		su minecraft -c 'screen -S minecraftServer$serverID -X stuff "say The server will shut down in 5 seconds\015"'
		sleep 1
		su minecraft -c 'screen -S minecraftServer$serverID -X stuff "say The server will shut down in 4 seconds\015"'
		sleep 1
		su minecraft -c 'screen -S minecraftServer$serverID -X stuff "say The server will shut down in 3 seconds\015"'
		sleep 1
		su minecraft -c 'screen -S minecraftServer$serverID -X stuff "say The server will shut down in 2 seconds\015"'
		sleep 1
		su minecraft -c 'screen -S minecraftServer$serverID -X stuff "say The server will shut down in 1 seconds\015"'
		sleep 1
		su minecraft -c 'screen -S minecraftServer$serverID -X stuff "stop\015"'
	}

#------------------------------------------------------------#
# SCRIPT
#------------------------------------------------------------#
action=$1

case $action in

	JavaInstall)
		JavaInstall
	;;
	OverviewerInstall)
		OverviewerInstall 
	;;
	OverviewerRenderMap)
		OverviewerRenderMap $2 $3
	;;
	ServerInstall)
		ServerInstall $2
	;;
	ServerUninstall)
		ServerUninstall $2
	;;
	ServerStart)
		ServerStart $2
	;;
	ServerStop)
		ServerStop $2
	;;
	
esac