###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Get-GPOEmpty.ps1
# Autor        :  Julien Mazoyer
# Description  :  Get Empty GPO
###############################################################################################################

<#
    .SYNOPSIS
    Get Empty GPO

    .DESCRIPTION
    Get Empty GPO Settings

    .EXAMPLE
    PS C:\>Get-GPOEmpty GPO
#>
function Get-GPOEmpty
{

    [cmdletbinding()]
    param (
    )
    try
    {
        Write-Verbose -Message "Importing GroupPolicy module"
        Import-Module GroupPolicy -ErrorAction Stop
    }
    catch
    {
        Write-Error -Message "GroupPolicy Module not found. Make sure RSAT (Remote Server Admin Tools) is installed"
        exit
    }
    $EmptyGPO = New-Object System.Collections.ArrayList
    try
    {
        Write-Verbose -Message "Importing GroupPolicy Policies"  
        $GPOs = Get-GPO -All  
        Write-Verbose -Message "Found '$($GPOs.Count)' policies to check"
    }
    catch
    {
        Write-Error -Message "Can't Load GPO's Please make sure you have connection to the Domain Controllers"
        exit
    }
    ForEach ($gpo  in $GPOs)
    { 
        Write-Verbose -Message "Checking '$($gpo.DisplayName)' status"
        [xml]$GPOXMLReport = $gpo | Get-GPOReport -ReportType xml
        if ($null -eq $GPOXMLReport.gpo.User.ExtensionData -and $null -eq $GPOXMLReport.gpo.Computer.ExtensionData)
        {
            $EmptyGPO += $gpo
        }
    }

    return $EmptyGPO.DisplayName
}