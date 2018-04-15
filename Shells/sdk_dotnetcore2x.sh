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

	install)
		apt-get update
		
		InstallPackageAPT "curl libunwind8 gettext apt-transport-https"
		
		curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
		mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
		sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/dotnetdev.list'
		
		apt-get update
		
		InstallPackageAPT "dotnet-sdk-2.0.0"
		
		export PATH=$PATH:$HOME/dotnet
		
		dotnet --version
		
		# Create dotnet user if not exist
		if ! HasUser dotnet
		then
			CreateUser dotnet "-m" "dotnet" true
			passwd dotnet
		fi
	;;

esac