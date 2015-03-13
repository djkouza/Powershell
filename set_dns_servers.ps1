    ########################################################################
    ####        Written By:  Shaun (DJKouza)                           	####
    ####        Date:        2015/02/04                              	####
    ####        Version: 1.0                                           	####
    ####               	set_dns_servers.ps1				  			   	####
    ####            	Description: 	Used for testing different 		####
	####								DNS Settings				   	####
	####				Functions: 										####
	####				ToDo: Clean Up, more flexibility				####
	####															   	####
    ########################################################################

###  Set Statip DNS
$wmi=Get-WmiObject win32_networkadapterconfiguration -filter 'IPEnabled=True'
$wmi.GetRelated('Win32_NetworkAdapter') | select *
$wmi = Get-WmiObject win32_networkadapterconfiguration -filter "ipenabled = 'true'"
Write-Host " 
1.	All DHCP
2.  Static Domain DNS
3.  Static Google DNS
"
$SetNetworkConfig = Read-Host 'Please choose one of the above Settings:'

### using if statements because I may want to add allot of staic options for DNS and keep the same static IP, so could work better than Switch
if($SetNetworkConfig -eq 1)
{
#enable DHCP
Write-Host "DHCP"
}
else
{
$wmi.EnableStatic("192.168.1.2", "255.255.255.0") #static IP and netmask
$wmi.SetGateways("192.168.1.1", 1) #set gateway
	if($SetNetworkConfig -eq 2)
	{
	$wmi.SetDNSServerSearchOrder("192.168.1.1") #set a local DNS server
	Write-Host "Domain"
	}
	elseif($SetNetworkConfig -eq 3)
	{
	$wmi.SetDNSServerSearchOrder("8.8.8.8") #use Googles DNS
	Write-Host "Google"
	}
	else
	{
	Write-Host "Invalid Entry"
	}
}
ipconfig /all | findstr 'DNS Servers'

$SetNetworkConfig

