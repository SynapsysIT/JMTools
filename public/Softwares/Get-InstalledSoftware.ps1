###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Get-InstalledSoftware.ps1
# Autor        :  Julien Mazoyer
# Description  :  Get all installed software with DisplayName, Publisher and UninstallString
###############################################################################################################

<#
    .SYNOPSIS
    Get all installed software with DisplayName, Publisher and UninstallString
                 
    .DESCRIPTION         
    Get all installed software with DisplayName, Publisher and UninstallString from a local or remote computer. (Remote Powershell must be enabled)
                                 
    .EXAMPLE
    Get-InstalledSoftware
       
    .EXAMPLE
    Get-InstalledSoftware -Search "*chrome*"

	DisplayName     : Google Chrome
	Publisher       : Google Inc.
	UninstallString : "C:\Program Files (x86)\Google\Chrome\Application\51.0.2704.103\Installer\setup.exe" --uninstall --multi-install --chrome --system-level
	InstallLocation : C:\Program Files (x86)\Google\Chrome\Application
	InstallDate     : 20160506

    .EXAMPLE
    Get-InstalledSoftware -Search "*firefox*" -ComputerName PC01  
	
    DisplayName     : Mozilla Firefox 47.0.1 (x86 de)
    Publisher       : Mozilla
    UninstallString : "C:\Program Files (x86)\Mozilla Firefox\uninstall\helper.exe"
    InstallLocation : C:\Program Files (x86)\Mozilla Firefox
    InstallDate     :
#>

function Get-InstalledSoftware
	{
	[CmdletBinding()]
	param(
		[Parameter(
			Position=0,
			HelpMessage='Search for product name (You can use wildcards like "*ProductName*')]
		[String]$Search,

		[Parameter(
			Position=1,
			HelpMessage='ComputerName or IPv4-Address of the remote computer')]
		[String]$ComputerName = $env:COMPUTERNAME,

		[Parameter(
			Position=2,
			HelpMessage='Credentials to authenticate agains a remote computer')]
		[System.Management.Automation.PSCredential]
		[System.Management.Automation.CredentialAttribute()]
		$Credential
	)

	Begin{
		$LocalAddress = @("127.0.0.1","localhost",".","$($env:COMPUTERNAME)")

		[System.Management.Automation.ScriptBlock]$Scriptblock = {
			# Location where all entrys for installed software should be stored
			return Get-ChildItem -Path  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall", "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | Get-ItemProperty | Select-Object -Property DisplayName, Publisher, UninstallString, InstallLocation, InstallDate
		}
	}

	Process{
		if($LocalAddress -contains $ComputerName)
		{			
			$Strings = Invoke-Command -ScriptBlock $Scriptblock -ArgumentList $Search            
		}
		else
		{
			if(Test-Connection -ComputerName $ComputerName -Count 2 -Quiet)
			{
				try {
					if($PSBoundParameters.ContainsKey('Credential'))
					{
						$Strings = Invoke-Command -ScriptBlock $Scriptblock -ComputerName $ComputerName -ArgumentList $Search -Credential $Credential -ErrorAction Stop
					}
					else
					{					    
						$Strings = Invoke-Command -ScriptBlock $Scriptblock -ComputerName $ComputerName -ArgumentList $Search -ErrorAction Stop
					}
				}
				catch {
					throw 
				}
			}
			else 
			{				
				throw """$ComputerName"" is not reachable via ICMP!"
			}
		}

		foreach($String in $Strings)
		{
			# Check for each entry if data exists
			if((-not([String]::IsNullOrEmpty($String.DisplayName))) -and (-not([String]::IsNullOrEmpty($String.UninstallString))))
			{
				# Search (only if parameter is used)
				if((-not($PSBoundParameters.ContainsKey('Search'))) -or (($PSBoundParameters.ContainsKey('Search') -and ($String.DisplayName -like $Search))))
				{                   
					[pscustomobject] @{
						DisplayName = $String.DisplayName
						Publisher = $String.Publisher
						UninstallString = $String.UninstallString
						InstallLocation = $String.InstallLocation
						InstallDate = $String.InstallDate
					}
				}   
			}
		}
	}

	End{
		
	}
}
