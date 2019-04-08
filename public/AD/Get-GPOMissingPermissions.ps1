###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Get-GPOMissingPermissions.ps1
# Autor        :  Julien Mazoyer
# Description  :  Get GPO where "Authentificated Users" & "Domain Computers" have no permissions. These GPO are not applied to any Users / Computers.
###############################################################################################################

<#
    .SYNOPSIS
    Get-GPO Missing Permissions

    .DESCRIPTION
    Get GPO where "Authentificated Users" & "Domain Computers" have no permissions. These GPO are not applied to any Users / Computers.

    .EXAMPLE
    PS C:\>Get-GPOMissingPermissions
#>
function Get-GPOMissingPermissions
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
    $MissingPermissionsGPOArray = New-Object System.Collections.ArrayList
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
        If ($GPO.User.Enabled)
        {
            $GPOPermissionForAuthUsers = Get-GPPermission -Guid $GPO.Id -All | Select-Object -ExpandProperty Trustee | Where-Object { $_.Name -eq "Authenticated Users" }
            $GPOPermissionForDomainComputers = Get-GPPermission -Guid $GPO.Id -All | Select-Object -ExpandProperty Trustee | Where-Object { $_.Name -eq "Domain Computers" }
            If (!$GPOPermissionForAuthUsers -and !$GPOPermissionForDomainComputers)
            {
                $MissingPermissionsGPOArray += $gpo
            }
        }
    }

    return $MissingPermissionsGPOArray.DisplayName

}