function createUser()
{
	if grep "^$userName:" /etc/passwd > /dev/null
	then
		echo "$userName already exists"
	else
		useradd -d /home/$userFolder/ $userParameters $userName
	fi
}