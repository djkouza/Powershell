    ########################################################################
    ####        Written By:  Shaun (DJKouza)                           	####
    ####        Date:        2015/03/11                              	####
    ####        Version: 1.0                                           	####
    ####               	get_ad_locked_account.ps1		  			   	####
    ####            													####
	####				Functions: 										####
	####															   	####
    ########################################################################
# Import the AD Powershell module
ipmo ActiveDirectory
###############################
#Get logs (you can't filter on the get-eventlog so I grab 500 to be safe 500 is quick and ensures we get what we need, then select what we want)
###############################
$EventLogs = Get-EventLog "Security" -Newest 500 | Where-Object {$_.EventID -eq 4740}  #event 4740 is the account locked out event
$NewestLog = $EventLogs[0] ##if there is more than one it creates an array...
$LogText = $NewestLog.Message #all we want is the test of the log
###############################
#Send Mail
###############################
$MailFrom = "domaincontroller@my.domain.com"
$MailServer = "smtp.mydomain.com"
$hostname = hostname
$MailTo = "admin-alert@mydomain.com"
$MailSubject = "An account has been locked out on Domain Controller $hostname"
$Body = "`<BR>" +`
            " <b> Dear SysAdmin, </b>" +`
            " <H2> <BR> The following account lockout event has occoured: </H2>" +`
			"  <BR> "+`
			"####################Begin Log####################"+`
			"  <BR><BR> "+`
			"$LogText"+`
			" <BR><BR>  "+`
			"   "
Send-MailMessage -To $MailTo -Subject $MailSubject -From $MailFrom -SmtpServer $MailServer -Body $Body -BodyAsHtml:$True