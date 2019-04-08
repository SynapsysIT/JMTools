###############################################################################################################
# Language     :  PowerShell 5.0
# Filename     :  Invoke-Sudo.ps1
# Autor        :  Julien Mazoyer
# Description  :  
###############################################################################################################

<#
    .SYNOPSIS
    Open Elevated Powershell Console
#>
Function Invoke-Sudo
{

    [Alias("sudo")]
    param()
    If ($null -eq $args[0])
    {
        if ($env:ConEmuANSI)
        {
            ConEmuc -c powershell -new_console:a
        }
        else
        {
            Start-Process powershell -Verb RunAs -ArgumentList "-noexit `"$($pwd.Path)`""
        }
    }
    Else
    {
        $file, [string]$arguments = $args
        $psi = New-Object System.Diagnostics.ProcessStartInfo $file
        $psi.Arguments = $arguments
        $psi.Verb = "runas"
        $psi.WorkingDirectory = Get-Location
        [System.Diagnostics.Process]::Start($psi)
    }
}