#!/bin/sh

#------------------------------------------------------------#
# REQUIRED FILES
#------------------------------------------------------------#
source /home/scripts/voidCore.sh

#------------------------------------------------------------#
# FUNCTIONS
#------------------------------------------------------------#
function Update()
{
	# Update to php 5.6
	echo 'deb http://packages.dotdeb.org wheezy-php56 all' >> /etc/apt/sources.list.d/dotdeb.list
	echo 'deb-src http://packages.dotdeb.org wheezy-php56 all' >> /etc/apt/sources.list.d/dotdeb.list
	wget http://www.dotdeb.org/dotdeb.gpg
	apt-key add dotdeb.gpg
	apt-get update
	apt-get upgrade -y
	apt-get dist-upgrade -y
	service apache2 restart
	rm dotdeb.gpg	
}

#------------------------------------------------------------#
# ACTIONS
#------------------------------------------------------------#
action=$1

case $action in

	install)
		InstallPackageAPT "php5 php5-dev php5-gd php5-mysql libssh2-php"
		Update
	;;
	
	uninstall)
		UninstallPackageAPT "php5 php5-dev php5-gd php5-mysql libssh2-php"
	;;
	
esac