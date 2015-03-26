    ########################################################################
    ####        Written By:  Shaun (DJKouza)                           	####
    ####        Date:        2015/03/26                              	####
    ####        Version: 1.5                                           	####
    ####               	get_ad_locked_account.ps1		  			   	####
    ####            													####
	####				Functions: 	setSMTP								####
	####															   	####
    ########################################################################
# Import the AD Powershell module
ipmo ActiveDirectory
###############################
#Function to set SMTP based on local subnets
###############################
function setSMTP()
{
$SMTPServer = ""
$Computer = hostname
$Networks = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $Computer | ? {$_.IPEnabled}
foreach ($Network in $Networks) 
    {
    [STRING]$IPAddress  = $Network.IpAddress[0]
    $DefaultGateway = $Network.DefaultIPGateway
    $NetLoc = $IPAddress.LastIndexOf(".")
    $Net = $IPAddress.Substring(0,$NetLoc)
    Switch($Net)
        {
        10.1.2 {$SMTP="smtp.location1.com"} #location1
        10.1.1 {$SMTP="smtp.location2.com"} #location2
        default {}
        }
    }
return $SMTP
}
###############################
#Get logs (you can't filter on the get-eventlog so I grab 500 to be safe 500 is quick and ensures we get what we need, then select what we want)
###############################
$EventLogs = Get-EventLog "Security" -Newest 500 | Where-Object {$_.EventID -eq 4740}  #event 4740 is the account locked out event
$EventLogsFailedLogin = Get-EventLog "Security" -Newest 500 | Where-Object {$_.EventID -eq 4625}  #event 4625 is the login failed event
$failCount = $EventLogsFailedLogin.count
##$EventLogs.count
$NewestLog = $EventLogs[0] ##if there is more than one it creates an array...
$LogText = $NewestLog.Message #we just want the text for now
$LogTime = $NewestLog.TimeGenerated
$tmpFile = "c:\powershell\failed_events.txt"
for ($i =0; $i -lt $failCount; $i++)
	{
	$EventLogsFailedLogin[$i].Message | out-file $tmpFile -Append #let's also dumpt the failed logins to a file to attach to help troubleshoot
	}
###############################
# Get more user info
###############################
$strStart = $LogText.LastIndexOf("Account Name:")
$cutFront = $LogText.Substring($strStart)
$strEnd = $cutFront.IndexOf("Additional")
$AccountName = $cutFront.SubString(0,$strEnd)
$AccountNameStart = $AccountName.IndexOf(":")
$final = $AccountName.SubString($AccountNameStart+1)
$finalUser = $final.trim()
$userInfo = Get-AdUser $finalUser -Properties mail,cn,samaccountname,displayname
if($userInfo)
	{
	$UserDN = $userInfo.DistinguishedName
	$UserMail = $userInfo.mail
	$UserDisplayName = $userInfo.displayname
	}

###############################
#Send Mail
###############################
$MailFrom = "domaincontroller@my.domain.com"
$MailServer = setSMTP  #use function to pull SMTP based on subnet
$hostname = hostname
$MailTo = "admin-alert@mydomain.com"
$MailSubject = "An account has been locked out on Domain Controller $hostname"
$Body = "`<BR>" +`
            " <b> Dear SysAdmin, </b>" +`
            " <H2> <BR> We have detected an account lockout event for account  $finalUser with E-Mail $UserMail </H2>" +`
			"  <BR> $UserDN  $UserMail <BR><BR>"+`
			"  <BR> "+`
			"####################Begin Log####################"+`
			" <BR> <BR>$LogTime<BR> "+`
			"$LogText"+`
			" <BR><BR>  "+`
			"   "
Send-MailMessage -To $MailTo -Subject $MailSubject -From $MailFrom -SmtpServer $MailServer -Attachments $tmpFile -Body $Body -BodyAsHtml:$True

if($userInfo -and $UserMail)
	{
	$UserMailSubject = "Your Active Directory Account $finalUser has been locked"
	$UserBody = "`<BR>" +`
            " <b> Dear $UserDisplayName, </b>" +`
            " <H2> <BR> We have detected an account lockout event for your account $finalUser </H2>" +`
			" <BR> Please contact your Systems Administrator or helpdesk for further assistance.<BR>  "+`
			"   "
	Send-MailMessage -To $UserMail -Subject $UserMailSubject -From $MailFrom -SmtpServer $MailServer -Body $UserBody -BodyAsHtml:$True			
	}
	

if(Test-Path $tmpFile)
{
Remove-Item $tmpFile #delete the temp file as we append it we want it to recreate every time
}