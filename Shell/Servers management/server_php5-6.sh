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
		packageAPT="php5 php5-dev php5-gd php5-mysql libssh2-php"	
		InstallPackageAPT
		
		# Mise à jour vers php 5.6
		echo 'deb http://packages.dotdeb.org wheezy-php56 all' >> /etc/apt/sources.list.d/dotdeb.list
		echo 'deb-src http://packages.dotdeb.org wheezy-php56 all' >> /etc/apt/sources.list.d/dotdeb.list
		wget http://www.dotdeb.org/dotdeb.gpg
		apt-key add dotdeb.gpg
		apt-get update
		apt-get upgrade -y
		apt-get dist-upgrade -y
		service apache2 restart
		rm dotdeb.gpg		
	;;
	
	#------------------------------#
	# UNINSTALL
	#------------------------------#
	uninstall)
		packageAPT="php5 php5-dev php5-gd php5-mysql libssh2-php"	
		UninstallPackageAPT
	;;
	
esac