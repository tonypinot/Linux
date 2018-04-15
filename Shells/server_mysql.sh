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
		InstallPackageAPT mysql-server
	;;

	uninstall)
		UninstallPackageAPT mysql-server
	;;

	secure)
		echo 'Enter the mysql root password for execute the mysql securation process:'
		read mysqlPassword
	
		mysql -uroot -p$mysqlPassword -e "DELETE FROM mysql.user WHERE User='';"
		mysql -uroot -p$mysqlPassword -e "DELETE FROM mysql.user WHERE User='root' AND Host!='localhost'"
		mysql -uroot -p$mysqlPassword -e "DROP DATABASE IF EXISTS test;"
		mysql -uroot -p$mysqlPassword -e "DELETE FROM mysql.db WHERE Db=’test’ OR Db=’test_%’"
		mysql -uroot -p$mysqlPassword -e "FLUSH PRIVILEGES"
	;;

esac