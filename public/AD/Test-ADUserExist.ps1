###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Test-ADUserExist.ps1
# Autor        :  Julien Mazoyer
# Description  :  Test if a AD User exist in the AD Domain
###############################################################################################################

<#
    .SYNOPSIS
    Test if a AD User exist in the AD Domain

    .DESCRIPTION
    Test if a AD User exist in the AD Domain

    .EXAMPLE
	PS C:\> Test-ADUserExists j.mazoyer
	True
#>
function Test-ADUserExists
{

    param(
        [Parameter(Mandatory)]
        [string]$SAMAccountName
    )
    @(Get-ADUser -LDAPFilter "(samaccountname=$SAMAccountName)").Count -ne 0
}
