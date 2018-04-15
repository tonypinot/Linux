#!/bin/sh

#------------------------------------------------------------#
# FILE FUNCTIONS
#------------------------------------------------------------#
function RemplaceFileText()
{
	if IsEmpty "$1" "[Function RemplaceFileText] oldText"; then exit; fi
	if IsEmpty "$2" "[Function RemplaceFileText] newText"; then exit; fi
	if IsEmpty "$3" "[Function RemplaceFileText] filePath"; then exit; fi

	oldText=$1
	newText=$2
	filePath=$3
	
	sed -i 's/$1/$2/g' $3
}

#------------------------------------------------------------#
# APT FUNCTIONS
#------------------------------------------------------------#
function CheckPackageAPTSource()
{
	sourcePackageAPT=$1

	echo -e "Verifying the source in the /etc/apt/sources.list file: $sourcePackageAPT"
	
	if grep "$sourcePackageAPT" /etc/apt/sources.list
		then
			echo -e "Source already exists in the file.\n"
		else
			echo -e "Source doesn't exists in the file\n"
			echo -e "Adding the source to the file"
			echo $sourcePackageAPT >> /etc/apt/sources.list
			
			if grep "$sourcePackageAPT" /etc/apt/sources.list
				then
					echo -e "The source has been added\n"
				else
					echo -e "FAIL: The source could not be added\n"
			fi
	fi
}
function InstallPackageAPT()
{
	packageAPT=$1

	echo "Check package $packageAPT..."
	
	if which $packageAPT
		then
			echo "Package $packageAPT already exists!"
		else
			echo "Package $packageAPT doesn't exists"
			echo "Installation of the $packageAPT package in progress..."
			apt-get install -y $packageAPT
			apt-get -f install
	fi
}
function UninstallPackageAPT()
{
	packageAPT=$1

	echo "Check package $packageAPT..."
	
	if which $packageAPT
		then
			echo "Package $packageAPT exists"
			echo "Uninstalling of the $packageAPT package in progress..."
			apt-get autoremove -y $packageAPT
		else
			echo "Package $packageAPT doesn't exists!"
	fi
}

#------------------------------------------------------------#
# USER FUNCTIONS
#------------------------------------------------------------#
function HasUser()
{
	userName=$1

	if grep "^$userName:" /etc/passwd > /dev/null
	then
		true
	else
		false
	fi
}
function CreateUser()
{
	if IsEmpty "$1" "[Function CreateUser] userName"; then exit; fi
	if IsEmpty "$2" "[Function CreateUser] userParameters"; then exit; fi
	if IsEmpty "$3" "[Function CreateUser] userFolder"; then exit; fi
	if IsEmpty "$4" "[Function CreateUser] displayAlert (true/false)"; then exit; fi
	
	userName=$1
	userParameters=$2
	userFolder=$3
	displayAlert=$4
	
	if HasUser $userName
	then
		if [ "$displayAlert" = "true" ]; then echo "[Function CreateUser] The user '$userName' already exists!"; fi
	else
		useradd -d /home/$userFolder/ $userParameters $userName		
	fi
}
function DeleteUser()
{
	if IsEmpty "$1" "[Function DeleteUser] userName"; then exit; fi
	if IsEmpty "$2" "[Function DeleteUser] displayAlert (true/false)"; then exit; fi
	
	userName=$1
	displayAlert=$2
	
	if HasUser $userName
	then
		userdel $userName -r
	else
		if [ "$displayAlert" = "true" ]; then echo "[Function DeleteUser] The user '$userName' does not exists!"; fi	
	fi
}

#------------------------------------------------------------#
# SCREEN FUNCTIONS
#------------------------------------------------------------#
function HasScreen()
{
	screenName=$1
	
	if screen -list | grep -q $screenName
	then
		true
	else
		false
	fi
}
function DeleteScreen()
{
	if IsEmpty "$1" "[Function DeleteScreen] screenName"; then exit; fi
	if IsEmpty "$2" "[Function DeleteScreen] displayAlert (true/false)"; then exit; fi

	screenName=$1
	displayAlert=$2
	
	if HasScreen $screenName
	then
		screen -S $screenName -X quit
	else
		if [ "$displayAlert" = "true" ]; then echo "[Function DeleteScreen] The screen '$screenName' does not exists!"; fi	
	fi
}

#------------------------------------------------------------#
# VARIABLE FUNCTIONS
#------------------------------------------------------------#
function IsEmpty()
{
	value=$1
	label=$2

	if [[ -z $value ]]; then
		if [[ ! -z $label ]]; then echo "$label: NOK (Is empty!)"; fi
		true
	else		
		if [[ ! -z $label ]]; then echo "$label: OK ($value)"; fi
		false
	fi
}