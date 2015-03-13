    ########################################################################
    ####        Written By:  Shaun (DJKouza)                           	####
    ####        Date:        2015/03/11                              	####
    ####                                                              	####
    ####               	lock_account.ps1				  			   	####
    ####            													####
	####				Functions: 										####
	####															   	####
    ########################################################################
# Import the AD Powershell module
ipmo ActiveDirectory
Function Do-ADAuthentication {
    param($username,$password)
    (new-object directoryservices.directoryentry "",$username,$password).psbase.name -ne $null
}
##Lockout Account domain\testuser
$attempt=0
$lockoutThreshhold=10  ## set the number of failed logins before an account locks
While($attempt -lt $lockoutThreshhold)
	{
	Do-ADAuthentication "domain\testuser" "badpassword"
		$a++
	}
Unlock-ADAccount testuser #we can unlock it now
