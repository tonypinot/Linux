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
		packageAPT="mysql-server"	
		InstallPackageAPT
	;;

	#------------------------------#
	# SECURE
	#------------------------------#
	secure)
		echo 'Enter the mysql root password for execute the mysql securation process:'
		read mysqlPassword
	
		mysql -uroot -p$mysqlPassword -e "DELETE FROM mysql.user WHERE User='';"
		mysql -uroot -p$mysqlPassword -e "DELETE FROM mysql.user WHERE User='root' AND Host!='localhost'"
		mysql -uroot -p$mysqlPassword -e "DROP DATABASE IF EXISTS test;"
		mysql -uroot -p$mysqlPassword -e "DELETE FROM mysql.db WHERE Db=’test’ OR Db=’test_%’"
		mysql -uroot -p$mysqlPassword -e "FLUSH PRIVILEGES"
	;;
	
	#------------------------------#
	# UNINSTALL
	#------------------------------#
	uninstall)
		packageAPT="mysql-server"	
		UninstallPackageAPT
	;;
	
esac