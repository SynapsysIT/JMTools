###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Get-GpResult.ps1
# Autor        :  Julien Mazoyer
# Description  :  Custom Powershell Gpresult
###############################################################################################################

<#
    .SYNOPSIS
    Get GPO Result

    .DESCRIPTION
    Custom Powershell Gpresult

    .EXAMPLE
    PS C:\>Get-GPResult
#>
function Get-GpResult
{

    [CmdletBinding()]
    param ()


    Write-Verbose "[+] Gùnùration des RSoP ..."
    $TempFile = "C:\Users\$env:USERNAME\AppData\Local\Temp\{0}.xml" -f $(New-Guid).Guid
    Get-GPResultantSetOfPolicy -ReportType Xml -Path $TempFile | Out-Null


    [xml]$XML = Get-Content $TempFile

    $GPOComputers = $XML.DocumentElement.ComputerResults.GPO
    $GPOUsers = $XML.DocumentElement.UserResults.GPO

    $Report = [System.Collections.ArrayList]::new()

    foreach ($GPO in $GPOComputers)
    {
        if (($GPO.FilterAllowed -eq "true") `
                -AND ($GPO.IsValid -eq "true") `
                -AND ($GPO.AccessDenied -eq "false") `
                -AND ($GPO.Enabled -eq "true")) { $Applied = "YES" } else { $Applied = "NO" }

        $Temp = [PSCustomObject]@{
            Target     = "Computer"
            Name       = $GPO.Name
            WMIFilter  = $GPO.FilterName
            "Applied?" = $Applied

        }

        $null = $Report.Add($temp)
    }

    foreach ($GPO in $GPOUsers)
    {
        if (($GPO.FilterAllowed -eq "true") `
                -AND ($GPO.IsValid -eq "true") `
                -AND ($GPO.AccessDenied -eq "false") `
                -AND ($GPO.Enabled -eq "true")) { $Applied = $true } else { $Applied = $false }

        $Temp = [PSCustomObject]@{
            Target     = "Computer"
            Name       = $GPO.Name
            WMIFilter  = $GPO.FilterName
            "Applied?" = $Applied

        }

        $null = $Report.Add($temp)
    }

    return $Report
}