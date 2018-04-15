#!/bin/sh

#------------------------------------------------------------#
# REQUIRED FILES
#------------------------------------------------------------#
source /home/scripts/voidCore.sh

#------------------------------------------------------------#
# SCRIPT
#------------------------------------------------------------#
clear

action=$1

case $action in
	
	"install")
		InstallPackageAPT proftpd
	;;
	
	"reload")
		/etc/init.d/proftpd reload
	;;
	
	"enableDefaultDirectory")
		sed -i 's/# DefaultRoot/DefaultRoot/g' /etc/proftpd/proftpd.conf
		#RemplaceFileText "# DefaultRoot" "DefaultRoot" /etc/proftpd/proftpd.conf
	;;
	
	"disableDefaultDirectory")
		sed -i 's/DefaultRoot/# DefaultRoot/g' /etc/proftpd/proftpd.conf
		#RemplaceFileText "DefaultRoot" "# DefaultRoot" /etc/proftpd/proftpd.conf
	;;

esac