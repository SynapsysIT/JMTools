function Get-RegistryKeyEntries
{
	<#
		.SYNOPSIS
			Gets all of the properties and their values associated with a registry key.

		.DESCRIPTION
			The Get-RegistryKeyEntries cmdlet gets each entry and its value for a specified registry key.

		.PARAMETER Path
			The registry key path in the format that PowerShell can process, such as HKLM:\Software\Microsoft or Registry::HKEY_LOCAL_MACHINE\Software\Microsoft

		.INPUTS
			System.String

				You can pipe a registry path to Get-RegistryKeyEntries.

		.OUTPUTS
			System.Management.Automation.PSCustomObject[]

		.EXAMPLE
			Get-RegistryEntries -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall

			Gets all of the entries associated with the registry key. It does not get any information about subkeys.

		.NOTES
			AUTHOR: Michael Haken	
			LAST UPDATE: 2/27/2016

		.FUNCTIONALITY
			The intended use of this cmdlet is to supplement the Get-ItemProperty cmdlet to get the values for every entry in a registry key.
	#>
	[CmdletBinding()]
	[OutputType([System.Management.Automation.PSCustomObject[]])]
	Param(
		[Parameter(Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateScript({
			Test-Path -Path $_
		})]
		[ValidateNotNullOrEmpty()]
		[System.String]$Path
	)

	Begin {}

	Process
	{
		Get-Item -Path $Path | Select-Object -ExpandProperty Property | ForEach-Object {
			Write-Output -InputObject ([PSCustomObject]@{"Path"=$Path;"Property"="$_";"Value"=(Get-ItemProperty -Path $Path -Name $_ | Select-Object -ExpandProperty $_)})
		}
	}

    End {}
}

