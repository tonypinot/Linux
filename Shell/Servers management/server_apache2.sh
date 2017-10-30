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
		packageAPT="apache2 apache2-utils"
		InstallPackageAPT
		echo 'AddDefaultCharset UTF-8' >> /etc/apache2/conf.d/charset
		echo 'DirectoryIndex index.html index.htm index.xhtml index.php' >> /etc/apache2/apache2.conf
		a2enmod rewrite
		/etc/init.d/apache2 restart
	;;

	#------------------------------#
	# UNINSTALL
	#------------------------------#
	uninstall)
		packageAPT="apache2 apache2-utils"	
		UninstallPackageAPT
	;;
	
esac