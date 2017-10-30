#!/bin/sh

#------------------------------------------------------------#
# REQUIRED FILES
#------------------------------------------------------------#
source /home/scripts/functions/APT.sh

#------------------------------------------------------------#
# ACTIONS
#------------------------------------------------------------#
action=$1

case $action in

	#------------------------------#
	# INSTALL
	#------------------------------#
	install)	
		echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list
		wget -O- https://www.dotdeb.org/dotdeb.gpg | apt-key add -
		apt update

		packageAPT="php7.0 php7.0-fpm libapache2-mod-php7.0"	
		InstallPackageAPT
	;;
	
	#------------------------------#
	# UNINSTALL
	#------------------------------#
	uninstall)
		packageAPT="php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-curl php7.0-json php7.0-gd php7.0-mcrypt php7.0-msgpack php7.0-memcached php7.0-intl php7.0-sqlite3 php7.0-gmp php7.0-geoip php7.0-mbstring php7.0-xml php7.0-zip"	
		UninstallPackageAPT
	;;
	
esac