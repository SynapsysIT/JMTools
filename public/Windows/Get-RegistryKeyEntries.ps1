###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Get-RegistryKeyEntries.ps1
# Autor        :  Julien Mazoyer
# Description  :  Gets all of the properties and their values in a registry key.
###############################################################################################################

<#
		.SYNOPSIS
			Gets all of the properties and their values in a registry key.

		.DESCRIPTION
			Gets all of the properties and their values in a registry key.

		.EXAMPLE
			Get-RegistryEntries -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall

#>
function Get-RegistryKeyEntries
{

    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject[]])]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [ValidateScript( {
                Test-Path -Path $_
            })]
        [ValidateNotNullOrEmpty()]
        [System.String]$Path
    )

    Begin { }

    Process
    {
        Get-Item -Path $Path | Select-Object -ExpandProperty Property | ForEach-Object {
            Write-Output -InputObject ([PSCustomObject]@{"Path" = $Path; "Property" = "$_"; "Value" = (Get-ItemProperty -Path $Path -Name $_ | Select-Object -ExpandProperty $_) })
        }
    }

    End { }
}

