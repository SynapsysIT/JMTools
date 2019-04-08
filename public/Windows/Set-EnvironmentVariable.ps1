###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Set-EnvironmentVariable.ps1
# Autor        :  Julien Mazoyer
# Description  :  Set Environment Variable
###############################################################################################################

<#
      .SYNOPSIS
      Set Environment Variable

      .DESCRIPTION
      Set Environment Variable

      .EXAMPLE
      Set Environment Variable -Name "VARIABLE" -Value "VALUE" -Target User
#>
function Set-EnvironmentVariable
{
    param
    (
        [string]
        [Parameter(Mandatory)]
        $Name,
 
        [string]
        [AllowEmptyString()]
        [Parameter(Mandatory)]
        $Value,
 
        [System.EnvironmentVariableTarget]
        [Parameter(Mandatory)]
        [string]$Target
    )
 
    [Environment]::SetEnvironmentVariable($Name, $Value, $Target)
}