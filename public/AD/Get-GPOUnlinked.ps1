###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Get-GPOUnlinked.ps1
# Autor        :  Julien Mazoyer
# Description  :  Get GPO with no OU Link.
###############################################################################################################

<#
    .SYNOPSIS
    Get GPO with no OU Link.

    .DESCRIPTION
    Get GPO with no OU Link.

    .EXAMPLE
    PS C:\>Get-GPOUnlinked
#>
function Get-GPOUnlinked
{

    [cmdletbinding()]
    param ()
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
    $UnlinkedGPO = New-Object System.Collections.ArrayList
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
        Write-Verbose -Message "Checking '$($gpo.DisplayName)' link"
        [xml]$GPOXMLReport = $gpo | Get-GPOReport -ReportType xml
        if ($null -eq $GPOXMLReport.GPO.LinksTo)
        { 
            $UnlinkedGPO += $gpo
        }
    }
    return $UnlinkedGPO.DisplayName
}