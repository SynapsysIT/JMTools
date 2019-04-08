###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Start-PortScan.ps1
# Autor        :  Julien Mazoyer
# Description  :  Start a port scan on the selected computer.
###############################################################################################################

<#
    .SYNOPSIS
    Start a port scan on the selected computer.

    .DESCRIPTION
    Start a port scan on the selected computer on common TCP Ports

    .EXAMPLE
    PS C:\> Start-PortScan

	Service : FTP Data
	Port    : 20
	Status  : Closed

	Service : FTP Command
	Port    : 21
	Status  : Closed

	Service : SSH
	Port    : 22
	Status  : Closed

	Service : TelNet
	Port    : 23
	Status  : Closed

	...
#>
function Start-PortScan
{
	

	[CmdletBinding()]
	[OutputType([System.Management.Automation.PSCustomObject[]])]
	Param(
		[Parameter(Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[System.String]$ComputerName = "localhost"
	)

	Begin
	{
	$script:Ports = @(
		[PSCustomObject]@{"Service"="FTP Data";"Port"=20},
		[PSCustomObject]@{"Service"="FTP Command";"Port"=21},
		[PSCustomObject]@{"Service"="SSH";"Port"=22},
		[PSCustomObject]@{"Service"="TelNet";"Port"=23},
		[PSCustomObject]@{"Service"="SMTP";"Port"=25},
		[PSCustomObject]@{"Service"="WINS";"Port"=42},
		[PSCustomObject]@{"Service"="DNS";"Port"=53},
		[PSCustomObject]@{"Service"="DHCP Server";"Port"=67},
		[PSCustomObject]@{"Service"="DHCP Client";"Port"=68},
		[PSCustomObject]@{"Service"="TFTP";"Port"=69},
		[PSCustomObject]@{"Service"="HTTP";"Port"=80},
		[PSCustomObject]@{"Service"="Kerberos";"Port"=88},
		[PSCustomObject]@{"Service"="POP3";"Port"=110},
		[PSCustomObject]@{"Service"="SFTP";"Port"=115},
		[PSCustomObject]@{"Service"="NetBIOS Name Service";"Port"=137},
		[PSCustomObject]@{"Service"="NetBIOS Datagram Service";"Port"=138},
		[PSCustomObject]@{"Service"="NetBIOS Session Service";"Port"=139},
		[PSCustomObject]@{"Service"="SNMP";"Port"=161},
		[PSCustomObject]@{"Service"="LDAP";"Port"=389},
		[PSCustomObject]@{"Service"="SSL";"Port"=443},
		[PSCustomObject]@{"Service"="SMB";"Port"=445},
		[PSCustomObject]@{"Service"="Syslog";"Port"=514},
		[PSCustomObject]@{"Service"="RPC";"Port"=135},
		[PSCustomObject]@{"Service"="LDAPS";"Port"=636},
		[PSCustomObject]@{"Service"="SOCKS";"Port"=1080},
		[PSCustomObject]@{"Service"="MSSQL";"Port"=1433},
		[PSCustomObject]@{"Service"="SQL Browser";"Port"=1434},
		[PSCustomObject]@{"Service"="Oracle DB";"Port"=1521},
		[PSCustomObject]@{"Service"="NFS";"Port"=2049},
		[PSCustomObject]@{"Service"="RDP";"Port"=3389},
		[PSCustomObject]@{"Service"="XMPP";"Port"=5222},
		[PSCustomObject]@{"Service"="HTTP Proxy";"Port"=8080},
		[PSCustomObject]@{"Service"="Global Catalog";"Port"=3268},
		[PSCustomObject]@{"Service"="Global Catalog/SSL";"Port"=3269},
		[PSCustomObject]@{"Service"="POP3/SSL";"Port"=995},
		[PSCustomObject]@{"Service"="IMAP/SSL";"Port"=993},
		[PSCustomObject]@{"Service"="IMAP";"Port"=143}
	)
	}

	Process
	{
		$Jobs = @()

		$i = 1

		foreach ($Item in $Ports)
		{
			Write-Progress -Activity "Running Port Scan" -Status "Scanning Port $($Item.Port) $($Item.Service)" -PercentComplete (($i++ / $Ports.Count) * 100)

			$Jobs += Start-Job -ArgumentList @($ComputerName,$Item) -ScriptBlock {
				$ComputerName = $args[0]
				$Service = $args[1].Service
				$Port = $args[1].Port

				$Socket = New-Object Net.Sockets.TcpClient
				$ErrorActionPreference = 'SilentlyContinue'
				$Socket.Connect($ComputerName, $Port)
				$ErrorActionPreference = 'Continue'

				if ($Socket.Connected)
				{
					$Socket.Close()
					return [PSCustomObject]@{"Service"="$Service";"Port"=$Port;"Status"="Open"}
				}
				else
				{
					return [PSCustomObject]@{"Service"="$Service";"Port"=$Port;"Status"="Closed"}
				}
			}
		}

		Write-Progress -Completed -Activity "Running Port Scan"

		$RunningJobs = @()

		$RunningJobs = Get-Job | Where-Object {$_.Id -in ($Jobs | Select-Object -ExpandProperty Id)}

		while (($RunningJobs | Where {$_.State -eq "Running"}).Length -gt 0) {
			$Completed = ($RunningJobs | Where {$_.State -eq "Completed"}).Length

			Write-Progress -Activity "Completing Jobs" -Status ("Waiting for connections to complete: " + (($Completed / $RunningJobs.Length) * 100) + "% Complete") -PercentComplete (($Completed / $RunningJobs.Length) * 100)
			Start-Sleep -Milliseconds 500
		}

		Write-Progress -Activity "Completing Jobs" -Completed

		Wait-Job -Job $Jobs | Out-Null
		$Data = @()
		Receive-Job -Job $Jobs | ForEach-Object {
			$Data += $_
		}

		Remove-Job -Job $Jobs

		return $($Data | Select-Object -Property * -ExcludeProperty RunspaceId)
	}

	End
	{
	}
}
