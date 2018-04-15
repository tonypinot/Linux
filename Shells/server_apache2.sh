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
		InstallPackageAPT "apache2 apache2-utils"		
	;;

	uninstall)
		UninstallPackageAPT "apache2 apache2-utils"
	;;
	
	configuration)
		echo 'AddDefaultCharset UTF-8' >> /etc/apache2/conf.d/charset
		echo 'DirectoryIndex index.html index.htm index.xhtml index.php' >> /etc/apache2/apache2.conf
		a2enmod rewrite
	;;
	
	restart)
		/etc/init.d/apache2 restart
	;;
	
esac