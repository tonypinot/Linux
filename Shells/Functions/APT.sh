# Parameter: "sourcePackageAPT"
function CheckPackageAPTSource()
{
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

# Parameter: "packageAPT"
function InstallPackageAPT()
{
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

# Parameter: "packageAPT"
function UninstallPackageAPT()
{
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